# REQUIRES: x86
# RUN: rm -rf %t; split-file %s %t
# RUN: llvm-mc -filetype=obj -triple=x86_64-apple-darwin %t/test.s -o %t/test.o
# RUN: llvm-mc -filetype=obj -triple=x86_64-apple-darwin %t/suffixed.s -o %t/suffixed.o
# RUN: llvm-mc -filetype=obj -triple=x86_64-apple-darwin %t/plain.s -o %t/plain.o

# NORMAL-ORDER: <_func1.__uniq.123>:
# NORMAL-ORDER: <_func2.llvm.456>:
# NORMAL-ORDER: <_func3.Tgm>:
# NORMAL-ORDER: <_main>:

# ORDERED: <_func2.llvm.456>:
# ORDERED: <_func3.Tgm>:
# ORDERED: <_func1.__uniq.123>:
# ORDERED: <_main>:

# PLAIN-NORMAL: <_plain1>:
# PLAIN-NORMAL: <_plain2>:
# PLAIN-NORMAL: <_plain3>:
# PLAIN-NORMAL: <_main2>:

# PLAIN-ORDERED: <_plain2>:
# PLAIN-ORDERED: <_plain3>:
# PLAIN-ORDERED: <_plain1>:
# PLAIN-ORDERED: <_main2>:

# Test 1: Symbols in binary have suffixes, order file has plain names
# RUN: %lld -lSystem -o %t/test-normal %t/test.o %t/suffixed.o
# RUN: llvm-objdump -d %t/test-normal | FileCheck %s --check-prefix=NORMAL-ORDER

# RUN: %lld -lSystem -o %t/test-ordered %t/test.o %t/suffixed.o -order_file %t/order
# RUN: llvm-objdump -d %t/test-ordered | FileCheck %s --check-prefix=ORDERED

# Test 2: Symbols in binary are plain, order file has suffixed names
# RUN: %lld -lSystem -o %t/plain-normal %t/plain.o
# RUN: llvm-objdump -d %t/plain-normal | FileCheck %s --check-prefix=PLAIN-NORMAL

# RUN: %lld -lSystem -o %t/plain-ordered %t/plain.o -order_file %t/order-suffixed
# RUN: llvm-objdump -d %t/plain-ordered | FileCheck %s --check-prefix=PLAIN-ORDERED

#--- order
# Order file with symbols without suffixes
_func2
_func3
_func1
_main

#--- order-suffixed
# Order file with suffixed symbols
_plain2.__uniq.abc
_plain3.llvm.def
_plain1.Tgm
_main2

#--- test.s
.globl _main

_main:
  callq _func1.__uniq.123
  callq _func2.llvm.456
  callq _func3.Tgm
  ret

#--- suffixed.s
.globl _func1.__uniq.123
_func1.__uniq.123:
  ret

.globl _func2.llvm.456
_func2.llvm.456:
  ret

.globl _func3.Tgm
_func3.Tgm:
  ret

#--- plain.s
.globl _plain1
_plain1:
  ret

.globl _plain2
_plain2:
  ret

.globl _plain3
_plain3:
  ret

.globl _main2
_main2:
  callq _plain1
  callq _plain2
  callq _plain3
  ret
