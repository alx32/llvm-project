; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=aarch64-linux-gnu -mattr=+sve < %s | FileCheck %s
; RUN: llc -mtriple=aarch64-linux-gnu -mattr=+sme -force-streaming < %s | FileCheck %s

;
; Testing prfop encodings
;
define void @test_svprf_pldl1strm(<vscale x 16 x i1> %pg, ptr %base) {
; CHECK-LABEL: test_svprf_pldl1strm:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    prfb pldl1strm, p0, [x0]
; CHECK-NEXT:    ret
entry:
  tail call void @llvm.aarch64.sve.prf.nxv16i1(<vscale x 16 x i1> %pg, ptr %base, i32 1)
  ret void
}

define void @test_svprf_pldl2keep(<vscale x 16 x i1> %pg, ptr %base) {
; CHECK-LABEL: test_svprf_pldl2keep:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    prfb pldl2keep, p0, [x0]
; CHECK-NEXT:    ret
entry:
  tail call void @llvm.aarch64.sve.prf.nxv16i1(<vscale x 16 x i1> %pg, ptr %base, i32 2)
  ret void
}

define void @test_svprf_pldl2strm(<vscale x 16 x i1> %pg, ptr %base) {
; CHECK-LABEL: test_svprf_pldl2strm:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    prfb pldl2strm, p0, [x0]
; CHECK-NEXT:    ret
entry:
  tail call void @llvm.aarch64.sve.prf.nxv16i1(<vscale x 16 x i1> %pg, ptr %base, i32 3)
  ret void
}

define void @test_svprf_pldl3keep(<vscale x 16 x i1> %pg, ptr %base) {
; CHECK-LABEL: test_svprf_pldl3keep:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    prfb pldl3keep, p0, [x0]
; CHECK-NEXT:    ret
entry:
  tail call void @llvm.aarch64.sve.prf.nxv16i1(<vscale x 16 x i1> %pg, ptr %base, i32 4)
  ret void
}

define void @test_svprf_pldl3strm(<vscale x 16 x i1> %pg, ptr %base) {
; CHECK-LABEL: test_svprf_pldl3strm:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    prfb pldl3strm, p0, [x0]
; CHECK-NEXT:    ret
entry:
  tail call void @llvm.aarch64.sve.prf.nxv16i1(<vscale x 16 x i1> %pg, ptr %base, i32 5)
  ret void
}

define void @test_svprf_pstl1keep(<vscale x 16 x i1> %pg, ptr %base) {
; CHECK-LABEL: test_svprf_pstl1keep:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    prfb pstl1keep, p0, [x0]
; CHECK-NEXT:    ret
entry:
  tail call void @llvm.aarch64.sve.prf.nxv16i1(<vscale x 16 x i1> %pg, ptr %base, i32 8)
  ret void
}

define void @test_svprf_pstl1strm(<vscale x 16 x i1> %pg, ptr %base) {
; CHECK-LABEL: test_svprf_pstl1strm:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    prfb pstl1strm, p0, [x0]
; CHECK-NEXT:    ret
entry:
  tail call void @llvm.aarch64.sve.prf.nxv16i1(<vscale x 16 x i1> %pg, ptr %base, i32 9)
  ret void
}

define void @test_svprf_pstl2keep(<vscale x 16 x i1> %pg, ptr %base) {
; CHECK-LABEL: test_svprf_pstl2keep:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    prfb pstl2keep, p0, [x0]
; CHECK-NEXT:    ret
entry:
  tail call void @llvm.aarch64.sve.prf.nxv16i1(<vscale x 16 x i1> %pg, ptr %base, i32 10)
  ret void
}

define void @test_svprf_pstl2strm(<vscale x 16 x i1> %pg, ptr %base) {
; CHECK-LABEL: test_svprf_pstl2strm:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    prfb pstl2strm, p0, [x0]
; CHECK-NEXT:    ret
entry:
  tail call void @llvm.aarch64.sve.prf.nxv16i1(<vscale x 16 x i1> %pg, ptr %base, i32 11)
  ret void
}

define void @test_svprf_pstl3keep(<vscale x 16 x i1> %pg, ptr %base) {
; CHECK-LABEL: test_svprf_pstl3keep:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    prfb pstl3keep, p0, [x0]
; CHECK-NEXT:    ret
entry:
  tail call void @llvm.aarch64.sve.prf.nxv16i1(<vscale x 16 x i1> %pg, ptr %base, i32 12)
  ret void
}

define void @test_svprf_pstl3strm(<vscale x 16 x i1> %pg, ptr %base) {
; CHECK-LABEL: test_svprf_pstl3strm:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    prfb pstl3strm, p0, [x0]
; CHECK-NEXT:    ret
entry:
  tail call void @llvm.aarch64.sve.prf.nxv16i1(<vscale x 16 x i1> %pg, ptr %base, i32 13)
  ret void
}

;
; Testing imm limits of SI form
;

define void @test_svprf_vnum_under(<vscale x 16 x i1> %pg, ptr %base) {
; CHECK-LABEL: test_svprf_vnum_under:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    rdvl x8, #1
; CHECK-NEXT:    mov x9, #-528
; CHECK-NEXT:    lsr x8, x8, #4
; CHECK-NEXT:    mul x8, x8, x9
; CHECK-NEXT:    prfb pstl3strm, p0, [x0, x8]
; CHECK-NEXT:    ret
entry:
  %gep = getelementptr inbounds <vscale x 16 x i8>, ptr %base, i64 -33, i64 0
  tail call void @llvm.aarch64.sve.prf.nxv16i1(<vscale x 16 x i1> %pg, ptr %gep, i32 13)
  ret void
}

define void @test_svprf_vnum_min(<vscale x 16 x i1> %pg, ptr %base) {
; CHECK-LABEL: test_svprf_vnum_min:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    prfb pstl3strm, p0, [x0, #-32, mul vl]
; CHECK-NEXT:    ret
entry:
  %gep = getelementptr inbounds <vscale x 16 x i8>, ptr %base, i64 -32, i64 0
  tail call void @llvm.aarch64.sve.prf.nxv16i1(<vscale x 16 x i1> %pg, ptr %gep, i32 13)
  ret void
}

define void @test_svprf_vnum_over(<vscale x 16 x i1> %pg, ptr %base) {
; CHECK-LABEL: test_svprf_vnum_over:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    rdvl x8, #1
; CHECK-NEXT:    mov w9, #512
; CHECK-NEXT:    lsr x8, x8, #4
; CHECK-NEXT:    mul x8, x8, x9
; CHECK-NEXT:    prfb pstl3strm, p0, [x0, x8]
; CHECK-NEXT:    ret
entry:
  %gep = getelementptr inbounds <vscale x 16 x i8>, ptr %base, i64 32, i64 0
  tail call void @llvm.aarch64.sve.prf.nxv16i1(<vscale x 16 x i1> %pg, ptr %gep, i32 13)
  ret void
}

define void @test_svprf_vnum_max(<vscale x 16 x i1> %pg, ptr %base) {
; CHECK-LABEL: test_svprf_vnum_max:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    prfb pstl3strm, p0, [x0, #31, mul vl]
; CHECK-NEXT:    ret
entry:
  %gep = getelementptr inbounds <vscale x 16 x i8>, ptr %base, i64 31, i64 0
  tail call void @llvm.aarch64.sve.prf.nxv16i1(<vscale x 16 x i1> %pg, ptr %gep, i32 13)
  ret void
}

;
; scalar contiguous
;

define void @test_svprfb(<vscale x 16 x i1> %pg, ptr %base) {
; CHECK-LABEL: test_svprfb:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    prfb pldl1keep, p0, [x0]
; CHECK-NEXT:    ret
entry:
  tail call void @llvm.aarch64.sve.prf.nxv16i1(<vscale x 16 x i1> %pg, ptr %base, i32 0)
  ret void
}

define void @test_svprfh(<vscale x 8 x i1> %pg, ptr %base) {
; CHECK-LABEL: test_svprfh:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    prfh pldl1keep, p0, [x0]
; CHECK-NEXT:    ret
entry:
  tail call void @llvm.aarch64.sve.prf.nxv8i1(<vscale x 8 x i1> %pg, ptr %base, i32 0)
  ret void
}

define void @test_svprfw(<vscale x 4 x i1> %pg, ptr %base) {
; CHECK-LABEL: test_svprfw:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    prfw pldl1keep, p0, [x0]
; CHECK-NEXT:    ret
entry:
  tail call void @llvm.aarch64.sve.prf.nxv4i1(<vscale x 4 x i1> %pg, ptr %base, i32 0)
  ret void
}

define void @test_svprfd(<vscale x 2 x i1> %pg, ptr %base) {
; CHECK-LABEL: test_svprfd:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    prfd pldl1keep, p0, [x0]
; CHECK-NEXT:    ret
entry:
  tail call void @llvm.aarch64.sve.prf.nxv2i1(<vscale x 2 x i1> %pg, ptr %base, i32 0)
  ret void
}

;
; scalar + imm contiguous
;
; imm form of prfb is tested above

define void @test_svprfh_vnum(<vscale x 8 x i1> %pg, ptr %base) {
; CHECK-LABEL: test_svprfh_vnum:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    prfh pstl3strm, p0, [x0, #31, mul vl]
; CHECK-NEXT:    ret
entry:
  %gep = getelementptr <vscale x 8 x i16>, ptr %base, i64 31
  %addr = bitcast ptr %gep to ptr
  tail call void @llvm.aarch64.sve.prf.nxv8i1(<vscale x 8 x i1> %pg, ptr %addr, i32 13)
  ret void
}

define void @test_svprfw_vnum(<vscale x 4 x i1> %pg, ptr %base) {
; CHECK-LABEL: test_svprfw_vnum:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    prfw pstl3strm, p0, [x0, #31, mul vl]
; CHECK-NEXT:    ret
entry:
  %gep = getelementptr <vscale x 4 x i32>, ptr %base, i64 31
  %addr = bitcast ptr %gep to ptr
  tail call void @llvm.aarch64.sve.prf.nxv4i1(<vscale x 4 x i1> %pg, ptr %addr, i32 13)
  ret void
}

define void @test_svprfd_vnum(<vscale x 2 x i1> %pg, ptr %base) {
; CHECK-LABEL: test_svprfd_vnum:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    prfd pstl3strm, p0, [x0, #31, mul vl]
; CHECK-NEXT:    ret
entry:
  %gep = getelementptr <vscale x 2 x i64>, ptr %base, i64 31
  %addr = bitcast ptr %gep to ptr
  tail call void @llvm.aarch64.sve.prf.nxv2i1(<vscale x 2 x i1> %pg, ptr %addr, i32 13)
  ret void
}

;
; scalar + scaled scalar contiguous
;

define void @test_svprfb_ss(<vscale x 16 x i1> %pg, ptr %base, i64 %offset) {
; CHECK-LABEL: test_svprfb_ss:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    prfb pstl3strm, p0, [x0, x1]
; CHECK-NEXT:    ret
entry:
  %addr = getelementptr i8, ptr %base, i64 %offset
  tail call void @llvm.aarch64.sve.prf.nxv16i1(<vscale x 16 x i1> %pg, ptr %addr, i32 13)
  ret void
}

define void @test_svprfh_ss(<vscale x 8 x i1> %pg, ptr %base, i64 %offset) {
; CHECK-LABEL: test_svprfh_ss:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    prfh pstl3strm, p0, [x0, x1, lsl #1]
; CHECK-NEXT:    ret
entry:
  %gep = getelementptr i16, ptr %base, i64 %offset
  tail call void @llvm.aarch64.sve.prf.nxv8i1(<vscale x 8 x i1> %pg, ptr %gep, i32 13)
  ret void
}

define void @test_svprfw_ss(<vscale x 4 x i1> %pg, ptr %base, i64 %offset) {
; CHECK-LABEL: test_svprfw_ss:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    prfw pstl3strm, p0, [x0, x1, lsl #2]
; CHECK-NEXT:    ret
entry:
  %gep = getelementptr i32, ptr %base, i64 %offset
  tail call void @llvm.aarch64.sve.prf.nxv4i1(<vscale x 4 x i1> %pg, ptr %gep, i32 13)
  ret void
}

define void @test_svprfd_ss(<vscale x 2 x i1> %pg, ptr %base, i64 %offset) {
; CHECK-LABEL: test_svprfd_ss:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    prfd pstl3strm, p0, [x0, x1, lsl #3]
; CHECK-NEXT:    ret
entry:
  %gep = getelementptr i64, ptr %base, i64 %offset
  tail call void @llvm.aarch64.sve.prf.nxv2i1(<vscale x 2 x i1> %pg, ptr %gep, i32 13)
  ret void
}


declare void @llvm.aarch64.sve.prf.nxv16i1(<vscale x 16 x i1>, ptr, i32)
declare void @llvm.aarch64.sve.prf.nxv8i1(<vscale x 8 x i1>,  ptr, i32)
declare void @llvm.aarch64.sve.prf.nxv4i1(<vscale x 4 x i1>,  ptr, i32)
declare void @llvm.aarch64.sve.prf.nxv2i1(<vscale x 2 x i1>,  ptr, i32)
