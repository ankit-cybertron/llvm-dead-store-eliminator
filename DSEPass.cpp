#include "llvm/IR/Function.h"
#include "llvm/IR/InstIterator.h"
#include "llvm/IR/Instructions.h"
#include "llvm/Passes/PassBuilder.h"
#include "llvm/Plugins/PassPlugin.h"  // LLVM 22+: moved from llvm/Passes/
#include "llvm/Support/raw_ostream.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/SmallVector.h"

using namespace llvm;

namespace {

// Local (intra-block) dead store elimination.
//
// For each basic block, track the most recent store to each pointer.
// A store is dead when another store to the same pointer follows with no
// intervening load, call, or branch. Tracking resets at block boundaries;
// cross-block cases require MemorySSA and are left for v2.
//
// Pointers are canonicalized with stripPointerCasts() before use as map
// keys: this catches bitcast and zero-index GEP aliases while keeping
// distinct struct field GEPs separate (preserving soundness).
class DSEPass : public PassInfoMixin<DSEPass> {
public:
  PreservedAnalyses run(Function &F, FunctionAnalysisManager &AM) {
    unsigned eliminated = 0;

    for (BasicBlock &BB : F) {
      DenseMap<Value *, StoreInst *> lastStore;
      SmallVector<StoreInst *, 8> deadStores;

      for (Instruction &I : BB) {
        if (auto *SI = dyn_cast<StoreInst>(&I)) {
          // Skip volatile/atomic stores; invalidate their slot conservatively.
          if (SI->isVolatile() || !SI->isSimple()) {
            lastStore.erase(SI->getPointerOperand()->stripPointerCasts());
            continue;
          }

          Value *ptr = SI->getPointerOperand()->stripPointerCasts();
          auto it = lastStore.find(ptr);
          if (it != lastStore.end()) {
            deadStores.push_back(it->second);
            ++eliminated;
          }
          lastStore[ptr] = SI;
          continue;
        }

        if (auto *LI = dyn_cast<LoadInst>(&I)) {
          // A load reads the current value — the prior store is now live.
          lastStore.erase(LI->getPointerOperand()->stripPointerCasts());
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
