# LLVM Dead Store Eliminator

An out-of-tree LLVM pass (new Pass Manager, LLVM 22.1.1) that eliminates
redundant local stores — a store to a pointer that's immediately overwritten
with no intervening load, call, or branch.

## Build

```bash
rm -rf build && mkdir build && cd build
cmake -G Ninja .. \
  -DLLVM_DIR="$(brew --prefix llvm)/lib/cmake/llvm" \
  -DCMAKE_C_COMPILER="$(brew --prefix llvm)/bin/clang" \
  -DCMAKE_CXX_COMPILER="$(brew --prefix llvm)/bin/clang++"
ninja
```

> On macOS, always pass the Homebrew clang explicitly. The system `/usr/bin/c++`
> lacks LLVM's own development headers.

## Run

```bash
opt -load-pass-plugin=./build/libDSEPass.dylib -passes=my-dse -S input.ll
```

## Test

```bash
lit -Ddse_lib="$(pwd)/build/libDSEPass.dylib" test/ -v
```

## How it works

For each basic block, track the last store to each pointer:

| Instruction seen | Action |
|---|---|
| Store to pointer `P` | If `P` was already stored to → prior store is dead |
| Load from `P` | Clear `P` from tracking (value is now used) |
| Any call | Clear all tracking (conservative — may alias anything) |
| Branch / return | Clear all tracking (end of local scope) |

Pointers are normalized with `stripPointerCasts()` before use as map keys,
catching bitcast and zero-index GEP aliases while keeping distinct struct
fields independent.

## Results

6 dead stores eliminated, 5.7% IR instruction reduction across 7 functions.
See [`real-world/results.md`](real-world/results.md) for the full breakdown.

## Status

- [x] v1 algorithm — local, intra-block DSE
- [x] Positive + negative lit/FileCheck test suite (3 PASS, 1 XFAIL)
- [x] Real-world validation — `real-world/results.md`
- [ ] MemorySSA cross-block v2 (stretch)
