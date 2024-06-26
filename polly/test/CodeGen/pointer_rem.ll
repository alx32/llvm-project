; RUN: opt %loadNPMPolly -polly-process-unprofitable '-passes=print<polly-function-scops>,scop(print<polly-ast>)' -disable-output -S < %s | FileCheck %s --check-prefix=AST
; RUN: opt %loadNPMPolly -polly-process-unprofitable '-passes=print<polly-function-scops>,scop(polly-codegen)' -S < %s | FileCheck %s --check-prefix=CODEGEN

target datalayout = "e-m:e-i64:64-i128:128-n8:16:32:64-S128"
target triple = "aarch64--linux-gnu"

; This test is to ensure that for we generate signed remainder for
; the polly.cond check.

; AST: isl ast :: foo1
; AST: if ((a1 - b1) % 24 == 0)

; CODEGEN: define void @foo1
; CODEGEN: polly.cond:
; CODEGEN: %pexp.zdiv_r = srem {{.*}}, 24

%struct.A = type { i32, i64, i8 }

; Function Attrs: norecurse nounwind
define void @foo1(ptr %a1, ptr readnone %b1) #0 {
entry:
  br label %entry.split

entry.split:                                      ; preds = %entry
  %cmp4 = icmp eq ptr %a1, %b1
  br i1 %cmp4, label %for.cond.cleanup, label %for.body.preheader

for.body.preheader:                               ; preds = %entry.split
  br label %for.body

for.cond.cleanup.loopexit:                        ; preds = %for.body
  br label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.cond.cleanup.loopexit, %entry.split
  ret void

for.body:                                         ; preds = %for.body.preheader, %for.body
  %start.05 = phi ptr [ %incdec.ptr, %for.body ], [ %a1, %for.body.preheader ]
  %0 = load i32, ptr %start.05, align 8
  %add = add nsw i32 %0, 1
  store i32 %add, ptr %start.05, align 8
  %incdec.ptr = getelementptr inbounds %struct.A, ptr %start.05, i64 1
  %cmp = icmp eq ptr %incdec.ptr, %b1
  br i1 %cmp, label %for.cond.cleanup.loopexit, label %for.body
}


