#include "llvm/IR/Function.h"
#include "llvm/IR/InstIterator.h"
#include "llvm/IR/Instructions.h"
#include "llvm/Passes/PassBuilder.h"
#include "llvm/Plugins/PassPlugin.h"  // LLVM 22+: moved from llvm/Passes/
#include "llvm/Support/raw_ostream.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/Hashing.h"
#include "llvm/ADT/SmallVector.h"

using namespace llvm;

// ---------------------------------------------------------------------------
// MemLocKey — canonical memory location: (base pointer, constant byte offset)
//
// Two GEPs addressing the same struct field produce different Value* pointers
// in unoptimised IR.  By resolving each pointer to its base alloca + constant
// byte offset via stripAndAccumulateConstantOffsets(), both GEPs map to the
// same key and are correctly tracked together.
// ---------------------------------------------------------------------------
struct MemLocKey {
  Value *Base;
  int64_t Offset;
};

namespace llvm {
template <> struct DenseMapInfo<MemLocKey> {
  static MemLocKey getEmptyKey() {
    return {DenseMapInfo<Value *>::getEmptyKey(), 0};
  }
  static MemLocKey getTombstoneKey() {
    return {DenseMapInfo<Value *>::getTombstoneKey(), 0};
  }
  static unsigned getHashValue(const MemLocKey &K) {
    return hash_combine(K.Base, K.Offset);
  }
  static bool isEqual(const MemLocKey &A, const MemLocKey &B) {
    return A.Base == B.Base && A.Offset == B.Offset;
  }
};
} // namespace llvm

// Resolve a pointer to its canonical {base, byte_offset} key.
// Non-constant offsets (variable-index GEPs) fall back to {ptr, 0}, which is
// conservative: the GEP itself becomes the base and no aliasing is inferred.
static MemLocKey toKey(Value *ptr, const DataLayout &DL) {
  APInt offset(DL.getPointerSizeInBits(), 0);
  Value *base = ptr->stripAndAccumulateConstantOffsets(
      DL, offset, /*AllowNonInbounds=*/false);
  return {base, offset.getSExtValue()};
}

namespace {

// Local (intra-block) dead store elimination.
//
// For each basic block, track the most recent store to each memory location.
// A store is dead when another store of the same type to the same location
// follows with no intervening load, call, or branch. Tracking resets at
// block boundaries; cross-block cases require MemorySSA (v2 stretch goal).
class DSEPass : public PassInfoMixin<DSEPass> {
public:
  PreservedAnalyses run(Function &F, FunctionAnalysisManager &AM) {
    unsigned eliminated = 0;
    const DataLayout &DL = F.getDataLayout();

    for (BasicBlock &BB : F) {
      DenseMap<MemLocKey, StoreInst *> lastStore;
      SmallVector<StoreInst *, 8> deadStores;

      for (Instruction &I : BB) {
        if (auto *SI = dyn_cast<StoreInst>(&I)) {
          // Skip volatile/atomic stores; invalidate their slot conservatively.
          if (SI->isVolatile() || !SI->isSimple()) {
            lastStore.erase(toKey(SI->getPointerOperand(), DL));
            continue;
          }

          MemLocKey key = toKey(SI->getPointerOperand(), DL);
          auto it = lastStore.find(key);
          if (it != lastStore.end()) {
            // Only kill if the new store fully covers the old one
            // (same value type → same byte width).  A narrow store
            // partially overlapping a wider one is not a full kill.
            if (it->second->getValueOperand()->getType() ==
                SI->getValueOperand()->getType()) {
              deadStores.push_back(it->second);
              ++eliminated;
            }
          }
          lastStore[key] = SI;
          continue;
        }

        if (auto *LI = dyn_cast<LoadInst>(&I)) {
          // A load reads the current value — the prior store is now live.
          lastStore.erase(toKey(LI->getPointerOperand(), DL));
          continue;
        }

        if (isa<CallBase>(I)) {
          // Any call may read or alias a tracked pointer — clear all.
          lastStore.clear();
          continue;
        }

        if (I.isTerminator()) {
          // Branch/return ends local tracking scope.
          lastStore.clear();
          continue;
        }
      }

      for (StoreInst *dead : deadStores)
        dead->eraseFromParent();
    }

    if (eliminated > 0) {
      errs() << "[dse-pass] " << F.getName() << ": eliminated " << eliminated
             << " redundant store(s)\n";
      return PreservedAnalyses::none();
    }

    return PreservedAnalyses::all();
  }
};

} // namespace

llvm::PassPluginLibraryInfo getDSEPassPluginInfo() {
  return {LLVM_PLUGIN_API_VERSION, "LLVM Dead Store Eliminator", LLVM_VERSION_STRING,
          [](PassBuilder &PB) {
            PB.registerPipelineParsingCallback(
                [](StringRef Name, FunctionPassManager &FPM,
                   ArrayRef<PassBuilder::PipelineElement>) {
                  if (Name == "my-dse") {
                    FPM.addPass(DSEPass());
                    return true;
                  }
                  return false;
                });
          }};
}

extern "C" LLVM_ATTRIBUTE_WEAK ::llvm::PassPluginLibraryInfo
llvmGetPassPluginInfo() {
  return getDSEPassPluginInfo();
}
