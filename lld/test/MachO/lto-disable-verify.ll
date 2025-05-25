; REQUIRES: x86
; RUN: llvm-as %s -o %t.bc
; RUN: %lld -arch x86_64 -dylib %t.bc -o %t.dylib
; RUN: %lld -arch x86_64 -dylib --disable-verify %t.bc -o %t2.dylib
; RUN: llvm-nm %t.dylib | FileCheck %s
; RUN: llvm-nm %t2.dylib | FileCheck %s

; CHECK: T _foo

target triple = "x86_64-apple-macosx10.15.0"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

define void @foo() {
  ret void
}
