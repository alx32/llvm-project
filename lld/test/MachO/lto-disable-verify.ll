; REQUIRES: x86
; RUN: llvm-as %s -o %t.bc
; RUN: %lld -arch x86_64 -dylib --lto-debug-pass-manager %t.bc -o %t.dylib 2>&1 | FileCheck --check-prefix=VERIFY %s
; RUN: %lld -arch x86_64 -dylib --lto-debug-pass-manager --disable-verify %t.bc -o %t2.dylib 2>&1 | FileCheck --check-prefix=NOVERIFY %s

; VERIFY: Running pass: VerifierPass
; NOVERIFY-NOT: Running pass: VerifierPass

target triple = "x86_64-apple-macosx10.15.0"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

define void @foo() {
  ret void
}
