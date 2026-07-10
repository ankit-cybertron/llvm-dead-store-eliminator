; RUN: opt -load-pass-plugin=%dse_lib -passes=my-dse -S %s | FileCheck %s

declare void @unknown_fn(ptr)

define void @store_across_call(i32 %v1, i32 %v2) {
entry:
  %p = alloca i32
  store i32 %v1, ptr %p
  call void @unknown_fn(ptr %p)
  store i32 %v2, ptr %p
  ret void
}

; v1 has no readnone/readonly reasoning: any unknown call clears tracking,
; so the first store must survive even though @unknown_fn happens to only
; take %p as an argument here.
; CHECK: store i32 %v1, ptr %p
; CHECK: call void @unknown_fn(ptr %p)
; CHECK: store i32 %v2, ptr %p
