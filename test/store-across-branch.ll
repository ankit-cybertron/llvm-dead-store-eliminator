; XFAIL: *
; This case requires cross-block (MemorySSA-based) DSE -- Phase 6 / v2.
; Remove the XFAIL line once v2 is implemented and this passes for real.
; RUN: opt -load-pass-plugin=%dse_lib -passes=my-dse -S %s | FileCheck %s

define void @store_across_branch(i1 %cond, i32 %v1, i32 %v2, i32 %v3) {
entry:
  %p = alloca i32
  store i32 %v1, ptr %p
  br i1 %cond, label %a, label %b

a:
  store i32 %v2, ptr %p
  ret void

b:
  store i32 %v3, ptr %p
  ret void
}

; %v1's store is dead: both successors overwrite %p before any load.
; v1 (intra-block only) cannot see this -- it requires v2/MemorySSA.
; CHECK-NOT: store i32 %v1, ptr %p
