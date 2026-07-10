; RUN: opt -load-pass-plugin=%dse_lib -passes=my-dse -S %s | FileCheck %s
;
; Tests that the (base, byte_offset) MemLocKey canonicalization catches dead
; stores to struct fields even when clang emits a fresh GEP instruction for
; each access (which produces different Value* pointers at -O0).

%Point = type { i32, i32 }

define i32 @struct_field_dse(i32 %px, i32 %py) {
; CHECK-LABEL: @struct_field_dse(
entry:
  %pt = alloca %Point, align 4

  ; pt.x = 0  →  dead: immediately overwritten by pt.x = %px
  ; Two distinct GEP instructions, same (base=%pt, offset=0) key.
; CHECK-NOT:   store i32 0, ptr %pt
  store i32 0,   ptr %pt, align 4

  ; pt.x = px  →  live
; CHECK:       store i32 %px, ptr %pt
  store i32 %px, ptr %pt, align 4

  %y_ptr1 = getelementptr inbounds %Point, ptr %pt, i32 0, i32 1
  %y_ptr2 = getelementptr inbounds %Point, ptr %pt, i32 0, i32 1

  ; pt.y = 0  →  dead: immediately overwritten by pt.y = %py
  ; y_ptr1 and y_ptr2 are different Value*s but same (base=%pt, offset=4).
; CHECK-NOT:   store i32 0, ptr %y_ptr1
  store i32 0,   ptr %y_ptr1, align 4

  ; pt.y = py  →  live
; CHECK:       store i32 %py, ptr %y_ptr2
  store i32 %py, ptr %y_ptr2, align 4

  %x = load i32, ptr %pt, align 4
  %y = load i32, ptr %y_ptr2, align 4
  %sum = add nsw i32 %x, %y
  ret i32 %sum
}
