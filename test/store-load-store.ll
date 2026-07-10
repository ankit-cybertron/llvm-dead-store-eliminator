; Test: store → load → store — negative case.
;
; The load between the two stores observes %v1, making the first store live.
; The pass must NOT eliminate it.
;
; RUN: opt -load-pass-plugin=%dse_lib -passes=my-dse -S %s | FileCheck %s

define i32 @store_load_store(i32 %v1, i32 %v2) {
entry:
  %p = alloca i32, align 4
  store i32 %v1, ptr %p, align 4
  %loaded = load i32, ptr %p, align 4
  store i32 %v2, ptr %p, align 4
  ret i32 %loaded
}

; Both stores must survive; the load clears tracking of %p.
; CHECK-LABEL: @store_load_store(
; CHECK:       store i32 %v1, ptr %p
; CHECK:       load i32, ptr %p
; CHECK:       store i32 %v2, ptr %p
; CHECK:       ret i32 %loaded
