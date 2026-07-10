; ModuleID = 'real-world/input2.ll'
source_filename = "real-world/input2.c"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx26.0.0"

%struct.Entity = type { %struct.Vec2, %struct.Vec2 }
%struct.Vec2 = type { i32, i32 }
%struct.Stats = type { float, float, float, i32 }

; Function Attrs: noinline nounwind ssp uwtable(sync)
define void @entity_reset(ptr noundef %0, i32 noundef %1, i32 noundef %2, i32 noundef %3, i32 noundef %4) #0 {
  %6 = alloca ptr, align 8
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  store ptr %0, ptr %6, align 8
  store i32 %1, ptr %7, align 4
  store i32 %2, ptr %8, align 4
  store i32 %3, ptr %9, align 4
  store i32 %4, ptr %10, align 4
  %11 = load ptr, ptr %6, align 8
  %12 = getelementptr inbounds nuw %struct.Entity, ptr %11, i32 0, i32 0
  %13 = getelementptr inbounds nuw %struct.Vec2, ptr %12, i32 0, i32 0
  store i32 -1, ptr %13, align 4
  %14 = load i32, ptr %7, align 4
  %15 = load ptr, ptr %6, align 8
  %16 = getelementptr inbounds nuw %struct.Entity, ptr %15, i32 0, i32 0
  %17 = getelementptr inbounds nuw %struct.Vec2, ptr %16, i32 0, i32 0
  store i32 %14, ptr %17, align 4
  %18 = load ptr, ptr %6, align 8
  %19 = getelementptr inbounds nuw %struct.Entity, ptr %18, i32 0, i32 0
  %20 = getelementptr inbounds nuw %struct.Vec2, ptr %19, i32 0, i32 1
  store i32 -1, ptr %20, align 4
  %21 = load i32, ptr %8, align 4
  %22 = load ptr, ptr %6, align 8
  %23 = getelementptr inbounds nuw %struct.Entity, ptr %22, i32 0, i32 0
  %24 = getelementptr inbounds nuw %struct.Vec2, ptr %23, i32 0, i32 1
  store i32 %21, ptr %24, align 4
  %25 = load ptr, ptr %6, align 8
  %26 = getelementptr inbounds nuw %struct.Entity, ptr %25, i32 0, i32 1
  %27 = getelementptr inbounds nuw %struct.Vec2, ptr %26, i32 0, i32 0
  store i32 -1, ptr %27, align 4
  %28 = load i32, ptr %9, align 4
  %29 = load ptr, ptr %6, align 8
  %30 = getelementptr inbounds nuw %struct.Entity, ptr %29, i32 0, i32 1
  %31 = getelementptr inbounds nuw %struct.Vec2, ptr %30, i32 0, i32 0
  store i32 %28, ptr %31, align 4
  %32 = load ptr, ptr %6, align 8
  %33 = getelementptr inbounds nuw %struct.Entity, ptr %32, i32 0, i32 1
  %34 = getelementptr inbounds nuw %struct.Vec2, ptr %33, i32 0, i32 1
  store i32 -1, ptr %34, align 4
  %35 = load i32, ptr %10, align 4
  %36 = load ptr, ptr %6, align 8
  %37 = getelementptr inbounds nuw %struct.Entity, ptr %36, i32 0, i32 1
  %38 = getelementptr inbounds nuw %struct.Vec2, ptr %37, i32 0, i32 1
  store i32 %35, ptr %38, align 4
  ret void
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define i32 @array_const_idx() #0 {
  %1 = alloca [4 x i32], align 4
  %2 = getelementptr inbounds [4 x i32], ptr %1, i64 0, i64 0
  %3 = getelementptr inbounds [4 x i32], ptr %1, i64 0, i64 1
  %4 = getelementptr inbounds [4 x i32], ptr %1, i64 0, i64 2
  %5 = getelementptr inbounds [4 x i32], ptr %1, i64 0, i64 3
  %6 = getelementptr inbounds [4 x i32], ptr %1, i64 0, i64 0
  store i32 10, ptr %6, align 4
  %7 = getelementptr inbounds [4 x i32], ptr %1, i64 0, i64 1
  store i32 20, ptr %7, align 4
  %8 = getelementptr inbounds [4 x i32], ptr %1, i64 0, i64 2
  store i32 30, ptr %8, align 4
  %9 = getelementptr inbounds [4 x i32], ptr %1, i64 0, i64 3
  store i32 40, ptr %9, align 4
  %10 = getelementptr inbounds [4 x i32], ptr %1, i64 0, i64 0
  %11 = load i32, ptr %10, align 4
  %12 = getelementptr inbounds [4 x i32], ptr %1, i64 0, i64 1
  %13 = load i32, ptr %12, align 4
  %14 = add nsw i32 %11, %13
  %15 = getelementptr inbounds [4 x i32], ptr %1, i64 0, i64 2
  %16 = load i32, ptr %15, align 4
  %17 = add nsw i32 %14, %16
  %18 = getelementptr inbounds [4 x i32], ptr %1, i64 0, i64 3
  %19 = load i32, ptr %18, align 4
  %20 = add nsw i32 %17, %19
  ret i32 %20
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define void @fill_coords(ptr noundef %0, ptr noundef %1, i32 noundef %2, i32 noundef %3) #0 {
  %5 = alloca ptr, align 8
  %6 = alloca ptr, align 8
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  store ptr %0, ptr %5, align 8
  store ptr %1, ptr %6, align 8
  store i32 %2, ptr %7, align 4
  store i32 %3, ptr %8, align 4
  %9 = load ptr, ptr %5, align 8
  store i32 -1, ptr %9, align 4
  %10 = load ptr, ptr %6, align 8
  store i32 -1, ptr %10, align 4
  %11 = load i32, ptr %7, align 4
  %12 = load ptr, ptr %5, align 8
  store i32 %11, ptr %12, align 4
  %13 = load i32, ptr %8, align 4
  %14 = load ptr, ptr %6, align 8
  store i32 %13, ptr %14, align 4
  ret void
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define i32 @chained(i32 noundef %0, i32 noundef %1) #0 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  store i32 %0, ptr %3, align 4
  store i32 %1, ptr %4, align 4
  %6 = load i32, ptr %3, align 4
  %7 = load i32, ptr %4, align 4
  %8 = add nsw i32 %6, %7
  store i32 %8, ptr %5, align 4
  %9 = load i32, ptr %5, align 4
  ret i32 %9
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define void @stats_reset(ptr noundef %0, float noundef %1, float noundef %2, float noundef %3, i32 noundef %4) #0 {
  %6 = alloca ptr, align 8
  %7 = alloca float, align 4
  %8 = alloca float, align 4
  %9 = alloca float, align 4
  %10 = alloca i32, align 4
  store ptr %0, ptr %6, align 8
  store float %1, ptr %7, align 4
  store float %2, ptr %8, align 4
  store float %3, ptr %9, align 4
  store i32 %4, ptr %10, align 4
  %11 = load ptr, ptr %6, align 8
  %12 = getelementptr inbounds nuw %struct.Stats, ptr %11, i32 0, i32 0
  store float 0.000000e+00, ptr %12, align 4
  %13 = load float, ptr %7, align 4
  %14 = load ptr, ptr %6, align 8
  %15 = getelementptr inbounds nuw %struct.Stats, ptr %14, i32 0, i32 0
  store float %13, ptr %15, align 4
  %16 = load ptr, ptr %6, align 8
  %17 = getelementptr inbounds nuw %struct.Stats, ptr %16, i32 0, i32 1
  store float 0.000000e+00, ptr %17, align 4
  %18 = load float, ptr %8, align 4
  %19 = load ptr, ptr %6, align 8
  %20 = getelementptr inbounds nuw %struct.Stats, ptr %19, i32 0, i32 1
  store float %18, ptr %20, align 4
  %21 = load ptr, ptr %6, align 8
  %22 = getelementptr inbounds nuw %struct.Stats, ptr %21, i32 0, i32 2
  store float 0.000000e+00, ptr %22, align 4
  %23 = load float, ptr %9, align 4
  %24 = load ptr, ptr %6, align 8
  %25 = getelementptr inbounds nuw %struct.Stats, ptr %24, i32 0, i32 2
  store float %23, ptr %25, align 4
  %26 = load ptr, ptr %6, align 8
  %27 = getelementptr inbounds nuw %struct.Stats, ptr %26, i32 0, i32 3
  store i32 0, ptr %27, align 4
  %28 = load i32, ptr %10, align 4
  %29 = load ptr, ptr %6, align 8
  %30 = getelementptr inbounds nuw %struct.Stats, ptr %29, i32 0, i32 3
  store i32 %28, ptr %30, align 4
  ret void
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define i32 @safe_divide(i32 noundef %0, i32 noundef %1) #0 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store i32 %0, ptr %4, align 4
  store i32 %1, ptr %5, align 4
  store i32 0, ptr %6, align 4
  %7 = load i32, ptr %5, align 4
  %8 = icmp eq i32 %7, 0
  br i1 %8, label %9, label %10

9:                                                ; preds = %2
  store i32 -1, ptr %3, align 4
  br label %15

10:                                               ; preds = %2
  %11 = load i32, ptr %4, align 4
  %12 = load i32, ptr %5, align 4
  %13 = sdiv i32 %11, %12
  store i32 %13, ptr %6, align 4
  %14 = load i32, ptr %6, align 4
  store i32 %14, ptr %3, align 4
  br label %15

15:                                               ; preds = %10, %9
  %16 = load i32, ptr %3, align 4
  ret i32 %16
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define void @write_hw_reg(ptr noundef %0, i32 noundef %1) #0 {
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
  store i32 %1, ptr %4, align 4
  %5 = load ptr, ptr %3, align 8
  store volatile i32 57005, ptr %5, align 4
  %6 = load i32, ptr %4, align 4
  %7 = load ptr, ptr %3, align 8
  store volatile i32 %6, ptr %7, align 4
  ret void
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define void @init_array(ptr noundef %0, i32 noundef %1) #0 {
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
  store i32 %1, ptr %4, align 4
  store i32 0, ptr %5, align 4
  br label %6

6:                                                ; preds = %20, %2
  %7 = load i32, ptr %5, align 4
  %8 = load i32, ptr %4, align 4
  %9 = icmp slt i32 %7, %8
  br i1 %9, label %10, label %23

10:                                               ; preds = %6
  %11 = load ptr, ptr %3, align 8
  %12 = load i32, ptr %5, align 4
  %13 = sext i32 %12 to i64
  %14 = getelementptr inbounds i32, ptr %11, i64 %13
  store i32 0, ptr %14, align 4
  %15 = load i32, ptr %5, align 4
  %16 = load ptr, ptr %3, align 8
  %17 = load i32, ptr %5, align 4
  %18 = sext i32 %17 to i64
  %19 = getelementptr inbounds i32, ptr %16, i64 %18
  store i32 %15, ptr %19, align 4
  br label %20

20:                                               ; preds = %10
  %21 = load i32, ptr %5, align 4
  %22 = add nsw i32 %21, 1
  store i32 %22, ptr %5, align 4
  br label %6, !llvm.loop !6

23:                                               ; preds = %6
  ret void
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define i32 @compute_all(i32 noundef %0, i32 noundef %1, i32 noundef %2, i32 noundef %3) #0 {
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  %11 = alloca i32, align 4
  %12 = alloca i32, align 4
  store i32 %0, ptr %5, align 4
  store i32 %1, ptr %6, align 4
  store i32 %2, ptr %7, align 4
  store i32 %3, ptr %8, align 4
  %13 = load i32, ptr %5, align 4
  %14 = mul nsw i32 %13, 2
  store i32 %14, ptr %9, align 4
  %15 = load i32, ptr %6, align 4
  %16 = mul nsw i32 %15, 3
  store i32 %16, ptr %10, align 4
  %17 = load i32, ptr %9, align 4
  %18 = load i32, ptr %10, align 4
  %19 = add nsw i32 %17, %18
  store i32 %19, ptr %11, align 4
  %20 = load i32, ptr %11, align 4
  %21 = load i32, ptr %7, align 4
  %22 = load i32, ptr %8, align 4
  %23 = mul nsw i32 %21, %22
  %24 = sub nsw i32 %20, %23
  store i32 %24, ptr %12, align 4
  %25 = load i32, ptr %12, align 4
  ret i32 %25
}

; Function Attrs: noinline nounwind ssp uwtable(sync)
define i32 @store_load_store(i32 noundef %0, i32 noundef %1) #0 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store i32 %0, ptr %3, align 4
  store i32 %1, ptr %4, align 4
  %7 = load i32, ptr %3, align 4
  store i32 %7, ptr %5, align 4
  %8 = load i32, ptr %5, align 4
  %9 = add nsw i32 %8, 1
  store i32 %9, ptr %6, align 4
  %10 = load i32, ptr %4, align 4
  store i32 %10, ptr %5, align 4
  %11 = load i32, ptr %5, align 4
  %12 = load i32, ptr %6, align 4
  %13 = add nsw i32 %11, %12
  ret i32 %13
}

attributes #0 = { noinline nounwind ssp uwtable(sync) "frame-pointer"="non-leaf-no-reserve" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a" }

!llvm.module.flags = !{!0, !1, !2, !3, !4}
!llvm.ident = !{!5}

!0 = !{i32 2, !"SDK Version", [2 x i32] [i32 26, i32 5]}
!1 = !{i32 1, !"wchar_size", i32 4}
!2 = !{i32 8, !"PIC Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 1}
!4 = !{i32 7, !"frame-pointer", i32 4}
!5 = !{!"Homebrew clang version 22.1.1"}
!6 = distinct !{!6, !7}
!7 = !{!"llvm.loop.mustprogress"}
