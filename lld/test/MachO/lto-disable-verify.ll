; REQUIRES: x86
; RUN: llvm-as %s -o %t.bc
; RUN: %lld -arch x86_64 -lto_library /usr/lib/libLTO.dylib \
; RUN:     -dylib %t.bc -o %t.dylib 2>&1 | FileCheck --check-prefix=VERIFY %s
; RUN: %lld -arch x86_64 -lto_library /usr/lib/libLTO.dylib \
; RUN:     -dylib --disable-verify %t.bc -o %t.dylib 2>&1 | FileCheck --check-prefix=NOVERIFY %s

; VERIFY-NOT: --disable-verify
; NOVERIFY-NOT: error

target triple = "x86_64-apple-macosx10.15.0"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

define void @foo() {
  ret void
}
