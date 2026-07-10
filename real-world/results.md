# LLVM Dead Store Eliminator — Real-World Validation

**Source:** `real-world/input.c` · **LLVM:** 22.1.1 (Apple M2) · **Pass:** `my-dse` v1

## Results

| Metric | Value |
|---|---|
| Functions processed | 7 |
| Total stores before | 14 |
| Dead stores eliminated | 7 |
| IR instruction count before | 106 |
| IR instruction count after | 99 |
| Reduction | **6.6%** |

## Per-Function Breakdown

| Function | Eliminated | Notes |
|---|---|---|
| `compute_with_dead_init` | **1** | `result = 0` dead ✅ |
| `overwrite_twice` | **2** | Both inits dead ✅ |
| `store_load_store` | **0** | Load between stores — correctly kept ✅ |
| `store_then_call` | **0** | Call invalidates tracking — correctly kept ✅ |
| `cross_block_dead` | **0** | Cross-block — needs v2/MemorySSA ✅ |
| `multi_local` | **2** | Dead inits for `a` and `b` ✅ |
| `struct_dead_store` | **2** | Both `pt.x=0` and `pt.y=0` eliminated ✅ |

## Before / After

```llvm
; BEFORE — compute_with_dead_init
  %result = alloca i32, align 4
  store i32 0,   ptr %result, align 4   ; ← dead, eliminated
  %add = add nsw i32 %a, %b
  store i32 %add, ptr %result, align 4
  %ret = load i32, ptr %result, align 4
  ret i32 %ret

; AFTER
  %result = alloca i32, align 4
  %add = add nsw i32 %a, %b
  store i32 %add, ptr %result, align 4
  %ret = load i32, ptr %result, align 4
  ret i32 %ret
```

## Correctness

All 3 negative-case functions produced 0 eliminations. All 4 lit/FileCheck
tests pass (3 PASS + 1 XFAIL for the cross-block v2 case).
