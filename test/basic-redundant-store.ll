; RUN: opt -load-pass-plugin=%dse_lib -passes=my-dse -S %s | FileCheck %s

; --- Test 1: two direct stores, no load/call between them ----------------
; The first store is provably dead; only the second should survive.
define void @basic(i32 %v1, i32 %v2) {
; CHECK-LABEL: @basic(
entry:
  %p = alloca i32
; CHECK-NOT:   store i32 %v1
  store i32 %v1, ptr %p
; CHECK:       store i32 %v2, ptr %p
  store i32 %v2, ptr %p
  ret void
}

; --- Test 2: store via alloca base, then store via GEP-0 alias -----------
; getUnderlyingObject() must canonicalize both to %q, so the first store
; is still recognised as dead and eliminated.
define void @gep_alias(i32 %v1, i32 %v2) {
; CHECK-LABEL: @gep_alias(
entry:
  %q    = alloca i32
  %gep0 = getelementptr inbounds i32, ptr %q, i64 0
; CHECK-NOT:   store i32 %v1
  store i32 %v1, ptr %q
; CHECK:       store i32 %v2, ptr %gep0
  store i32 %v2, ptr %gep0
  ret void
}
