# REQUIRES: x86
# RUN: rm -rf %t; split-file %s %t
# RUN: llvm-mc -filetype=obj -triple=x86_64-apple-darwin %t/test.s -o %t/test.o
# RUN: echo "2090499946" > %t/order.txt
# RUN: echo "# This is a comment" >> %t/order.txt
# RUN: echo "1164077866" >> %t/order.txt
# RUN: echo "" >> %t/order.txt
# RUN: echo "3916589616" >> %t/order.txt

# RUN: %lld -lSystem -o %t/test-no-order %t/test.o
# RUN: llvm-objdump --section="__TEXT,__cstring" --full-contents %t/test-no-order | FileCheck %s --check-prefix=NO-ORDER

# RUN: %lld -lSystem -o %t/test-order %t/test.o -order_file_cstring %t/order.txt
# RUN: llvm-objdump --section="__TEXT,__cstring" --full-contents %t/test-order | FileCheck %s --check-prefix=ORDER

# NO-ORDER: Contents of section __TEXT,__cstring:
# NO-ORDER-NEXT: {{.*}} 48656c6c 6f20576f 726c6400 476f6f64  Hello World.Good
# NO-ORDER-NEXT: {{.*}} 62796500 54657374 696e6700           bye.Testing.

# ORDER: Contents of section __TEXT,__cstring:
# ORDER-NEXT: {{.*}} 476f6f64 62796500 54657374 696e6700  Goodbye.Testing.
# ORDER-NEXT: {{.*}} 48656c6c 6f20576f 726c6400           Hello World.

#--- test.s
.section __TEXT,__cstring
.globl _hello_str
_hello_str:
  .asciz "Hello World"

.globl _goodbye_str
_goodbye_str:
  .asciz "Goodbye"

.globl _testing_str
_testing_str:
  .asciz "Testing"

.text
.globl _main
_main:
  leaq _hello_str(%rip), %rdi
  callq _puts
  leaq _goodbye_str(%rip), %rdi
  callq _puts
  leaq _testing_str(%rip), %rdi
  callq _puts
  xorl %eax, %eax
  ret
