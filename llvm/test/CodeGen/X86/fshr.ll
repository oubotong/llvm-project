; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown-unknown | FileCheck %s --check-prefixes=CHECK,X86,X86-FAST
; RUN: llc < %s -mtriple=i686-unknown-unknown -mattr=+slow-shld | FileCheck %s --check-prefixes=CHECK,X86,X86-SLOW
; RUN: llc < %s -mtriple=x86_64-unknown-unknown | FileCheck %s --check-prefixes=CHECK,X64,X64-FAST
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+slow-shld | FileCheck %s --check-prefixes=CHECK,X64,X64-SLOW

declare i8 @llvm.fshr.i8(i8, i8, i8) nounwind readnone
declare i16 @llvm.fshr.i16(i16, i16, i16) nounwind readnone
declare i32 @llvm.fshr.i32(i32, i32, i32) nounwind readnone
declare i64 @llvm.fshr.i64(i64, i64, i64) nounwind readnone

;
; Variable Funnel Shift
;

define i8 @var_shift_i8(i8 %x, i8 %y, i8 %z) nounwind {
; X86-LABEL: var_shift_i8:
; X86:       # %bb.0:
; X86-NEXT:    movb {{[0-9]+}}(%esp), %ah
; X86-NEXT:    movb {{[0-9]+}}(%esp), %al
; X86-NEXT:    movb {{[0-9]+}}(%esp), %dl
; X86-NEXT:    andb $7, %dl
; X86-NEXT:    movb %al, %ch
; X86-NEXT:    movb %dl, %cl
; X86-NEXT:    shrb %cl, %ch
; X86-NEXT:    movb $8, %cl
; X86-NEXT:    subb %dl, %cl
; X86-NEXT:    shlb %cl, %ah
; X86-NEXT:    testb %dl, %dl
; X86-NEXT:    je .LBB0_2
; X86-NEXT:  # %bb.1:
; X86-NEXT:    orb %ch, %ah
; X86-NEXT:    movb %ah, %al
; X86-NEXT:  .LBB0_2:
; X86-NEXT:    retl
;
; X64-LABEL: var_shift_i8:
; X64:       # %bb.0:
; X64-NEXT:    andb $7, %dl
; X64-NEXT:    movl %esi, %eax
; X64-NEXT:    movl %edx, %ecx
; X64-NEXT:    shrb %cl, %al
; X64-NEXT:    movb $8, %cl
; X64-NEXT:    subb %dl, %cl
; X64-NEXT:    shlb %cl, %dil
; X64-NEXT:    orb %al, %dil
; X64-NEXT:    movzbl %dil, %eax
; X64-NEXT:    testb %dl, %dl
; X64-NEXT:    cmovel %esi, %eax
; X64-NEXT:    # kill: def $al killed $al killed $eax
; X64-NEXT:    retq
  %tmp = tail call i8 @llvm.fshr.i8(i8 %x, i8 %y, i8 %z)
  ret i8 %tmp
}

define i16 @var_shift_i16(i16 %x, i16 %y, i16 %z) nounwind {
; X86-FAST-LABEL: var_shift_i16:
; X86-FAST:       # %bb.0:
; X86-FAST-NEXT:    movzwl {{[0-9]+}}(%esp), %edx
; X86-FAST-NEXT:    movzwl {{[0-9]+}}(%esp), %eax
; X86-FAST-NEXT:    movb {{[0-9]+}}(%esp), %cl
; X86-FAST-NEXT:    andb $15, %cl
; X86-FAST-NEXT:    shrdw %cl, %dx, %ax
; X86-FAST-NEXT:    retl
;
; X86-SLOW-LABEL: var_shift_i16:
; X86-SLOW:       # %bb.0:
; X86-SLOW-NEXT:    pushl %edi
; X86-SLOW-NEXT:    pushl %esi
; X86-SLOW-NEXT:    movl {{[0-9]+}}(%esp), %esi
; X86-SLOW-NEXT:    movb {{[0-9]+}}(%esp), %dl
; X86-SLOW-NEXT:    andb $15, %dl
; X86-SLOW-NEXT:    movzwl {{[0-9]+}}(%esp), %eax
; X86-SLOW-NEXT:    movl %eax, %edi
; X86-SLOW-NEXT:    movl %edx, %ecx
; X86-SLOW-NEXT:    shrl %cl, %edi
; X86-SLOW-NEXT:    movb $16, %cl
; X86-SLOW-NEXT:    subb %dl, %cl
; X86-SLOW-NEXT:    shll %cl, %esi
; X86-SLOW-NEXT:    testb %dl, %dl
; X86-SLOW-NEXT:    je .LBB1_2
; X86-SLOW-NEXT:  # %bb.1:
; X86-SLOW-NEXT:    orl %edi, %esi
; X86-SLOW-NEXT:    movl %esi, %eax
; X86-SLOW-NEXT:  .LBB1_2:
; X86-SLOW-NEXT:    # kill: def $ax killed $ax killed $eax
; X86-SLOW-NEXT:    popl %esi
; X86-SLOW-NEXT:    popl %edi
; X86-SLOW-NEXT:    retl
;
; X64-FAST-LABEL: var_shift_i16:
; X64-FAST:       # %bb.0:
; X64-FAST-NEXT:    movl %edx, %ecx
; X64-FAST-NEXT:    movl %esi, %eax
; X64-FAST-NEXT:    andb $15, %cl
; X64-FAST-NEXT:    # kill: def $cl killed $cl killed $ecx
; X64-FAST-NEXT:    shrdw %cl, %di, %ax
; X64-FAST-NEXT:    # kill: def $ax killed $ax killed $eax
; X64-FAST-NEXT:    retq
;
; X64-SLOW-LABEL: var_shift_i16:
; X64-SLOW:       # %bb.0:
; X64-SLOW-NEXT:    movzwl %si, %eax
; X64-SLOW-NEXT:    andb $15, %dl
; X64-SLOW-NEXT:    movl %edx, %ecx
; X64-SLOW-NEXT:    shrl %cl, %eax
; X64-SLOW-NEXT:    movb $16, %cl
; X64-SLOW-NEXT:    subb %dl, %cl
; X64-SLOW-NEXT:    shll %cl, %edi
; X64-SLOW-NEXT:    orl %edi, %eax
; X64-SLOW-NEXT:    testb %dl, %dl
; X64-SLOW-NEXT:    cmovel %esi, %eax
; X64-SLOW-NEXT:    # kill: def $ax killed $ax killed $eax
; X64-SLOW-NEXT:    retq
  %tmp = tail call i16 @llvm.fshr.i16(i16 %x, i16 %y, i16 %z)
  ret i16 %tmp
}

define i32 @var_shift_i32(i32 %x, i32 %y, i32 %z) nounwind {
; X86-FAST-LABEL: var_shift_i32:
; X86-FAST:       # %bb.0:
; X86-FAST-NEXT:    movb {{[0-9]+}}(%esp), %cl
; X86-FAST-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-FAST-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-FAST-NEXT:    shrdl %cl, %edx, %eax
; X86-FAST-NEXT:    retl
;
; X86-SLOW-LABEL: var_shift_i32:
; X86-SLOW:       # %bb.0:
; X86-SLOW-NEXT:    pushl %edi
; X86-SLOW-NEXT:    pushl %esi
; X86-SLOW-NEXT:    movl {{[0-9]+}}(%esp), %esi
; X86-SLOW-NEXT:    movb {{[0-9]+}}(%esp), %dl
; X86-SLOW-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-SLOW-NEXT:    movl %eax, %edi
; X86-SLOW-NEXT:    movl %edx, %ecx
; X86-SLOW-NEXT:    shrl %cl, %edi
; X86-SLOW-NEXT:    andb $31, %dl
; X86-SLOW-NEXT:    movl %edx, %ecx
; X86-SLOW-NEXT:    negb %cl
; X86-SLOW-NEXT:    shll %cl, %esi
; X86-SLOW-NEXT:    testb %dl, %dl
; X86-SLOW-NEXT:    je .LBB2_2
; X86-SLOW-NEXT:  # %bb.1:
; X86-SLOW-NEXT:    orl %edi, %esi
; X86-SLOW-NEXT:    movl %esi, %eax
; X86-SLOW-NEXT:  .LBB2_2:
; X86-SLOW-NEXT:    popl %esi
; X86-SLOW-NEXT:    popl %edi
; X86-SLOW-NEXT:    retl
;
; X64-FAST-LABEL: var_shift_i32:
; X64-FAST:       # %bb.0:
; X64-FAST-NEXT:    movl %edx, %ecx
; X64-FAST-NEXT:    movl %esi, %eax
; X64-FAST-NEXT:    # kill: def $cl killed $cl killed $ecx
; X64-FAST-NEXT:    shrdl %cl, %edi, %eax
; X64-FAST-NEXT:    retq
;
; X64-SLOW-LABEL: var_shift_i32:
; X64-SLOW:       # %bb.0:
; X64-SLOW-NEXT:    movl %edi, %eax
; X64-SLOW-NEXT:    movl %esi, %edi
; X64-SLOW-NEXT:    movl %edx, %ecx
; X64-SLOW-NEXT:    shrl %cl, %edi
; X64-SLOW-NEXT:    andb $31, %dl
; X64-SLOW-NEXT:    movl %edx, %ecx
; X64-SLOW-NEXT:    negb %cl
; X64-SLOW-NEXT:    shll %cl, %eax
; X64-SLOW-NEXT:    orl %edi, %eax
; X64-SLOW-NEXT:    testb %dl, %dl
; X64-SLOW-NEXT:    cmovel %esi, %eax
; X64-SLOW-NEXT:    retq
  %tmp = tail call i32 @llvm.fshr.i32(i32 %x, i32 %y, i32 %z)
  ret i32 %tmp
}

define i32 @var_shift_i32_optsize(i32 %x, i32 %y, i32 %z) nounwind optsize {
; X86-LABEL: var_shift_i32_optsize:
; X86:       # %bb.0:
; X86-NEXT:    movb {{[0-9]+}}(%esp), %cl
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    shrdl %cl, %edx, %eax
; X86-NEXT:    retl
;
; X64-LABEL: var_shift_i32_optsize:
; X64:       # %bb.0:
; X64-NEXT:    movl %edx, %ecx
; X64-NEXT:    movl %esi, %eax
; X64-NEXT:    # kill: def $cl killed $cl killed $ecx
; X64-NEXT:    shrdl %cl, %edi, %eax
; X64-NEXT:    retq
  %tmp = tail call i32 @llvm.fshr.i32(i32 %x, i32 %y, i32 %z)
  ret i32 %tmp
}

define i32 @var_shift_i32_pgso(i32 %x, i32 %y, i32 %z) nounwind !prof !14 {
; X86-LABEL: var_shift_i32_pgso:
; X86:       # %bb.0:
; X86-NEXT:    movb {{[0-9]+}}(%esp), %cl
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    shrdl %cl, %edx, %eax
; X86-NEXT:    retl
;
; X64-LABEL: var_shift_i32_pgso:
; X64:       # %bb.0:
; X64-NEXT:    movl %edx, %ecx
; X64-NEXT:    movl %esi, %eax
; X64-NEXT:    # kill: def $cl killed $cl killed $ecx
; X64-NEXT:    shrdl %cl, %edi, %eax
; X64-NEXT:    retq
  %tmp = tail call i32 @llvm.fshr.i32(i32 %x, i32 %y, i32 %z)
  ret i32 %tmp
}

define i64 @var_shift_i64(i64 %x, i64 %y, i64 %z) nounwind {
; X86-FAST-LABEL: var_shift_i64:
; X86-FAST:       # %bb.0:
; X86-FAST-NEXT:    pushl %ebp
; X86-FAST-NEXT:    pushl %ebx
; X86-FAST-NEXT:    pushl %edi
; X86-FAST-NEXT:    pushl %esi
; X86-FAST-NEXT:    pushl %eax
; X86-FAST-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-FAST-NEXT:    movl %eax, (%esp) # 4-byte Spill
; X86-FAST-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-FAST-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-FAST-NEXT:    movl {{[0-9]+}}(%esp), %esi
; X86-FAST-NEXT:    movl {{[0-9]+}}(%esp), %ebx
; X86-FAST-NEXT:    andl $63, %ebx
; X86-FAST-NEXT:    movb $64, %cl
; X86-FAST-NEXT:    subb %bl, %cl
; X86-FAST-NEXT:    movl %eax, %edi
; X86-FAST-NEXT:    shll %cl, %edi
; X86-FAST-NEXT:    shldl %cl, %eax, %esi
; X86-FAST-NEXT:    testb $32, %cl
; X86-FAST-NEXT:    je .LBB5_2
; X86-FAST-NEXT:  # %bb.1:
; X86-FAST-NEXT:    movl %edi, %esi
; X86-FAST-NEXT:    xorl %edi, %edi
; X86-FAST-NEXT:  .LBB5_2:
; X86-FAST-NEXT:    movl %edx, %ebp
; X86-FAST-NEXT:    movl %ebx, %ecx
; X86-FAST-NEXT:    shrl %cl, %ebp
; X86-FAST-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-FAST-NEXT:    shrdl %cl, %edx, %eax
; X86-FAST-NEXT:    testb $32, %bl
; X86-FAST-NEXT:    je .LBB5_4
; X86-FAST-NEXT:  # %bb.3:
; X86-FAST-NEXT:    movl %ebp, %eax
; X86-FAST-NEXT:    xorl %ebp, %ebp
; X86-FAST-NEXT:  .LBB5_4:
; X86-FAST-NEXT:    testl %ebx, %ebx
; X86-FAST-NEXT:    je .LBB5_6
; X86-FAST-NEXT:  # %bb.5:
; X86-FAST-NEXT:    orl %ebp, %esi
; X86-FAST-NEXT:    orl %eax, %edi
; X86-FAST-NEXT:    movl %edi, (%esp) # 4-byte Spill
; X86-FAST-NEXT:    movl %esi, %edx
; X86-FAST-NEXT:  .LBB5_6:
; X86-FAST-NEXT:    movl (%esp), %eax # 4-byte Reload
; X86-FAST-NEXT:    addl $4, %esp
; X86-FAST-NEXT:    popl %esi
; X86-FAST-NEXT:    popl %edi
; X86-FAST-NEXT:    popl %ebx
; X86-FAST-NEXT:    popl %ebp
; X86-FAST-NEXT:    retl
;
; X86-SLOW-LABEL: var_shift_i64:
; X86-SLOW:       # %bb.0:
; X86-SLOW-NEXT:    pushl %ebp
; X86-SLOW-NEXT:    pushl %ebx
; X86-SLOW-NEXT:    pushl %edi
; X86-SLOW-NEXT:    pushl %esi
; X86-SLOW-NEXT:    subl $8, %esp
; X86-SLOW-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-SLOW-NEXT:    movl %eax, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; X86-SLOW-NEXT:    movl {{[0-9]+}}(%esp), %esi
; X86-SLOW-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-SLOW-NEXT:    movl {{[0-9]+}}(%esp), %ebx
; X86-SLOW-NEXT:    andl $63, %ebx
; X86-SLOW-NEXT:    movb $64, %al
; X86-SLOW-NEXT:    subb %bl, %al
; X86-SLOW-NEXT:    movl %edx, (%esp) # 4-byte Spill
; X86-SLOW-NEXT:    movl %eax, %ecx
; X86-SLOW-NEXT:    shll %cl, %edx
; X86-SLOW-NEXT:    movb %al, %ch
; X86-SLOW-NEXT:    andb $31, %ch
; X86-SLOW-NEXT:    movb %ch, %cl
; X86-SLOW-NEXT:    negb %cl
; X86-SLOW-NEXT:    movl %esi, %edi
; X86-SLOW-NEXT:    shrl %cl, %edi
; X86-SLOW-NEXT:    testb %ch, %ch
; X86-SLOW-NEXT:    movl {{[0-9]+}}(%esp), %ebp
; X86-SLOW-NEXT:    je .LBB5_2
; X86-SLOW-NEXT:  # %bb.1:
; X86-SLOW-NEXT:    orl %edi, %edx
; X86-SLOW-NEXT:    movl %edx, (%esp) # 4-byte Spill
; X86-SLOW-NEXT:  .LBB5_2:
; X86-SLOW-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-SLOW-NEXT:    movl %ebx, %ecx
; X86-SLOW-NEXT:    shrl %cl, %edx
; X86-SLOW-NEXT:    movb %bl, %ah
; X86-SLOW-NEXT:    andb $31, %ah
; X86-SLOW-NEXT:    movb %ah, %cl
; X86-SLOW-NEXT:    negb %cl
; X86-SLOW-NEXT:    movl %ebp, %edi
; X86-SLOW-NEXT:    shll %cl, %edi
; X86-SLOW-NEXT:    testb %ah, %ah
; X86-SLOW-NEXT:    movl {{[0-9]+}}(%esp), %ebp
; X86-SLOW-NEXT:    je .LBB5_4
; X86-SLOW-NEXT:  # %bb.3:
; X86-SLOW-NEXT:    orl %edx, %edi
; X86-SLOW-NEXT:    movl %edi, %ebp
; X86-SLOW-NEXT:  .LBB5_4:
; X86-SLOW-NEXT:    movl {{[0-9]+}}(%esp), %edi
; X86-SLOW-NEXT:    movl %ebx, %ecx
; X86-SLOW-NEXT:    shrl %cl, %edi
; X86-SLOW-NEXT:    testb $32, %bl
; X86-SLOW-NEXT:    je .LBB5_6
; X86-SLOW-NEXT:  # %bb.5:
; X86-SLOW-NEXT:    movl %edi, %ebp
; X86-SLOW-NEXT:    xorl %edi, %edi
; X86-SLOW-NEXT:  .LBB5_6:
; X86-SLOW-NEXT:    movl %eax, %ecx
; X86-SLOW-NEXT:    shll %cl, %esi
; X86-SLOW-NEXT:    testb $32, %al
; X86-SLOW-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-SLOW-NEXT:    jne .LBB5_7
; X86-SLOW-NEXT:  # %bb.8:
; X86-SLOW-NEXT:    movl (%esp), %eax # 4-byte Reload
; X86-SLOW-NEXT:    testl %ebx, %ebx
; X86-SLOW-NEXT:    jne .LBB5_10
; X86-SLOW-NEXT:    jmp .LBB5_11
; X86-SLOW-NEXT:  .LBB5_7:
; X86-SLOW-NEXT:    movl %esi, %eax
; X86-SLOW-NEXT:    xorl %esi, %esi
; X86-SLOW-NEXT:    testl %ebx, %ebx
; X86-SLOW-NEXT:    je .LBB5_11
; X86-SLOW-NEXT:  .LBB5_10:
; X86-SLOW-NEXT:    orl %ebp, %esi
; X86-SLOW-NEXT:    orl %edi, %eax
; X86-SLOW-NEXT:    movl %esi, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; X86-SLOW-NEXT:    movl %eax, %edx
; X86-SLOW-NEXT:  .LBB5_11:
; X86-SLOW-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %eax # 4-byte Reload
; X86-SLOW-NEXT:    addl $8, %esp
; X86-SLOW-NEXT:    popl %esi
; X86-SLOW-NEXT:    popl %edi
; X86-SLOW-NEXT:    popl %ebx
; X86-SLOW-NEXT:    popl %ebp
; X86-SLOW-NEXT:    retl
;
; X64-FAST-LABEL: var_shift_i64:
; X64-FAST:       # %bb.0:
; X64-FAST-NEXT:    movq %rdx, %rcx
; X64-FAST-NEXT:    movq %rsi, %rax
; X64-FAST-NEXT:    # kill: def $cl killed $cl killed $rcx
; X64-FAST-NEXT:    shrdq %cl, %rdi, %rax
; X64-FAST-NEXT:    retq
;
; X64-SLOW-LABEL: var_shift_i64:
; X64-SLOW:       # %bb.0:
; X64-SLOW-NEXT:    movq %rdi, %rax
; X64-SLOW-NEXT:    movq %rsi, %rdi
; X64-SLOW-NEXT:    movl %edx, %ecx
; X64-SLOW-NEXT:    shrq %cl, %rdi
; X64-SLOW-NEXT:    andb $63, %dl
; X64-SLOW-NEXT:    movl %edx, %ecx
; X64-SLOW-NEXT:    negb %cl
; X64-SLOW-NEXT:    shlq %cl, %rax
; X64-SLOW-NEXT:    orq %rdi, %rax
; X64-SLOW-NEXT:    testb %dl, %dl
; X64-SLOW-NEXT:    cmoveq %rsi, %rax
; X64-SLOW-NEXT:    retq
  %tmp = tail call i64 @llvm.fshr.i64(i64 %x, i64 %y, i64 %z)
  ret i64 %tmp
}

;
; Const Funnel Shift
;

define i8 @const_shift_i8(i8 %x, i8 %y) nounwind {
; X86-LABEL: const_shift_i8:
; X86:       # %bb.0:
; X86-NEXT:    movb {{[0-9]+}}(%esp), %al
; X86-NEXT:    movb {{[0-9]+}}(%esp), %cl
; X86-NEXT:    shrb $7, %cl
; X86-NEXT:    addb %al, %al
; X86-NEXT:    orb %cl, %al
; X86-NEXT:    retl
;
; X64-LABEL: const_shift_i8:
; X64:       # %bb.0:
; X64-NEXT:    # kill: def $edi killed $edi def $rdi
; X64-NEXT:    shrb $7, %sil
; X64-NEXT:    leal (%rdi,%rdi), %eax
; X64-NEXT:    orb %sil, %al
; X64-NEXT:    # kill: def $al killed $al killed $eax
; X64-NEXT:    retq
  %tmp = tail call i8 @llvm.fshr.i8(i8 %x, i8 %y, i8 7)
  ret i8 %tmp
}

define i16 @const_shift_i16(i16 %x, i16 %y) nounwind {
; X86-FAST-LABEL: const_shift_i16:
; X86-FAST:       # %bb.0:
; X86-FAST-NEXT:    movzwl {{[0-9]+}}(%esp), %ecx
; X86-FAST-NEXT:    movzwl {{[0-9]+}}(%esp), %eax
; X86-FAST-NEXT:    shrdw $7, %cx, %ax
; X86-FAST-NEXT:    retl
;
; X86-SLOW-LABEL: const_shift_i16:
; X86-SLOW:       # %bb.0:
; X86-SLOW-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-SLOW-NEXT:    movzwl {{[0-9]+}}(%esp), %ecx
; X86-SLOW-NEXT:    shrl $7, %ecx
; X86-SLOW-NEXT:    shll $9, %eax
; X86-SLOW-NEXT:    orl %ecx, %eax
; X86-SLOW-NEXT:    # kill: def $ax killed $ax killed $eax
; X86-SLOW-NEXT:    retl
;
; X64-FAST-LABEL: const_shift_i16:
; X64-FAST:       # %bb.0:
; X64-FAST-NEXT:    movl %esi, %eax
; X64-FAST-NEXT:    shrdw $7, %di, %ax
; X64-FAST-NEXT:    # kill: def $ax killed $ax killed $eax
; X64-FAST-NEXT:    retq
;
; X64-SLOW-LABEL: const_shift_i16:
; X64-SLOW:       # %bb.0:
; X64-SLOW-NEXT:    movzwl %si, %eax
; X64-SLOW-NEXT:    shll $9, %edi
; X64-SLOW-NEXT:    shrl $7, %eax
; X64-SLOW-NEXT:    orl %edi, %eax
; X64-SLOW-NEXT:    # kill: def $ax killed $ax killed $eax
; X64-SLOW-NEXT:    retq
  %tmp = tail call i16 @llvm.fshr.i16(i16 %x, i16 %y, i16 7)
  ret i16 %tmp
}

define i32 @const_shift_i32(i32 %x, i32 %y) nounwind {
; X86-FAST-LABEL: const_shift_i32:
; X86-FAST:       # %bb.0:
; X86-FAST-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-FAST-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-FAST-NEXT:    shrdl $7, %ecx, %eax
; X86-FAST-NEXT:    retl
;
; X86-SLOW-LABEL: const_shift_i32:
; X86-SLOW:       # %bb.0:
; X86-SLOW-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-SLOW-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-SLOW-NEXT:    shrl $7, %ecx
; X86-SLOW-NEXT:    shll $25, %eax
; X86-SLOW-NEXT:    orl %ecx, %eax
; X86-SLOW-NEXT:    retl
;
; X64-FAST-LABEL: const_shift_i32:
; X64-FAST:       # %bb.0:
; X64-FAST-NEXT:    movl %edi, %eax
; X64-FAST-NEXT:    shldl $25, %esi, %eax
; X64-FAST-NEXT:    retq
;
; X64-SLOW-LABEL: const_shift_i32:
; X64-SLOW:       # %bb.0:
; X64-SLOW-NEXT:    # kill: def $esi killed $esi def $rsi
; X64-SLOW-NEXT:    # kill: def $edi killed $edi def $rdi
; X64-SLOW-NEXT:    shrl $7, %esi
; X64-SLOW-NEXT:    shll $25, %edi
; X64-SLOW-NEXT:    leal (%rdi,%rsi), %eax
; X64-SLOW-NEXT:    retq
  %tmp = tail call i32 @llvm.fshr.i32(i32 %x, i32 %y, i32 7)
  ret i32 %tmp
}

define i64 @const_shift_i64(i64 %x, i64 %y) nounwind {
; X86-FAST-LABEL: const_shift_i64:
; X86-FAST:       # %bb.0:
; X86-FAST-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-FAST-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-FAST-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-FAST-NEXT:    shldl $25, %ecx, %edx
; X86-FAST-NEXT:    shrdl $7, %ecx, %eax
; X86-FAST-NEXT:    retl
;
; X86-SLOW-LABEL: const_shift_i64:
; X86-SLOW:       # %bb.0:
; X86-SLOW-NEXT:    pushl %esi
; X86-SLOW-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-SLOW-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-SLOW-NEXT:    movl {{[0-9]+}}(%esp), %esi
; X86-SLOW-NEXT:    shrl $7, %ecx
; X86-SLOW-NEXT:    movl %esi, %eax
; X86-SLOW-NEXT:    shll $25, %eax
; X86-SLOW-NEXT:    orl %ecx, %eax
; X86-SLOW-NEXT:    shrl $7, %esi
; X86-SLOW-NEXT:    shll $25, %edx
; X86-SLOW-NEXT:    orl %esi, %edx
; X86-SLOW-NEXT:    popl %esi
; X86-SLOW-NEXT:    retl
;
; X64-FAST-LABEL: const_shift_i64:
; X64-FAST:       # %bb.0:
; X64-FAST-NEXT:    movq %rdi, %rax
; X64-FAST-NEXT:    shldq $57, %rsi, %rax
; X64-FAST-NEXT:    retq
;
; X64-SLOW-LABEL: const_shift_i64:
; X64-SLOW:       # %bb.0:
; X64-SLOW-NEXT:    shrq $7, %rsi
; X64-SLOW-NEXT:    shlq $57, %rdi
; X64-SLOW-NEXT:    leaq (%rdi,%rsi), %rax
; X64-SLOW-NEXT:    retq
  %tmp = tail call i64 @llvm.fshr.i64(i64 %x, i64 %y, i64 7)
  ret i64 %tmp
}

;
; Combine Consecutive Loads
;

define i8 @combine_fshr_load_i8(i8* %p) nounwind {
; X86-LABEL: combine_fshr_load_i8:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movb (%eax), %al
; X86-NEXT:    retl
;
; X64-LABEL: combine_fshr_load_i8:
; X64:       # %bb.0:
; X64-NEXT:    movb (%rdi), %al
; X64-NEXT:    retq
  %p1 = getelementptr i8, i8* %p, i32 1
  %ld0 = load i8, i8 *%p
  %ld1 = load i8, i8 *%p1
  %res = call i8 @llvm.fshr.i8(i8 %ld1, i8 %ld0, i8 8)
  ret i8 %res
}

define i16 @combine_fshr_load_i16(i16* %p) nounwind {
; X86-LABEL: combine_fshr_load_i16:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movzwl 1(%eax), %eax
; X86-NEXT:    retl
;
; X64-LABEL: combine_fshr_load_i16:
; X64:       # %bb.0:
; X64-NEXT:    movzwl 1(%rdi), %eax
; X64-NEXT:    retq
  %p0 = getelementptr i16, i16* %p, i32 0
  %p1 = getelementptr i16, i16* %p, i32 1
  %ld0 = load i16, i16 *%p0
  %ld1 = load i16, i16 *%p1
  %res = call i16 @llvm.fshr.i16(i16 %ld1, i16 %ld0, i16 8)
  ret i16 %res
}

define i32 @combine_fshr_load_i32(i32* %p) nounwind {
; X86-LABEL: combine_fshr_load_i32:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl 9(%eax), %eax
; X86-NEXT:    retl
;
; X64-LABEL: combine_fshr_load_i32:
; X64:       # %bb.0:
; X64-NEXT:    movl 9(%rdi), %eax
; X64-NEXT:    retq
  %p0 = getelementptr i32, i32* %p, i32 2
  %p1 = getelementptr i32, i32* %p, i32 3
  %ld0 = load i32, i32 *%p0
  %ld1 = load i32, i32 *%p1
  %res = call i32 @llvm.fshr.i32(i32 %ld1, i32 %ld0, i32 8)
  ret i32 %res
}

define i64 @combine_fshr_load_i64(i64* %p) nounwind {
; X86-LABEL: combine_fshr_load_i64:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movl 11(%ecx), %eax
; X86-NEXT:    movl 15(%ecx), %edx
; X86-NEXT:    retl
;
; X64-LABEL: combine_fshr_load_i64:
; X64:       # %bb.0:
; X64-NEXT:    movq 11(%rdi), %rax
; X64-NEXT:    retq
  %p0 = getelementptr i64, i64* %p, i64 1
  %p1 = getelementptr i64, i64* %p, i64 2
  %ld0 = load i64, i64 *%p0
  %ld1 = load i64, i64 *%p1
  %res = call i64 @llvm.fshr.i64(i64 %ld1, i64 %ld0, i64 24)
  ret i64 %res
}

!llvm.module.flags = !{!0}
!0 = !{i32 1, !"ProfileSummary", !1}
!1 = !{!2, !3, !4, !5, !6, !7, !8, !9}
!2 = !{!"ProfileFormat", !"InstrProf"}
!3 = !{!"TotalCount", i64 10000}
!4 = !{!"MaxCount", i64 10}
!5 = !{!"MaxInternalCount", i64 1}
!6 = !{!"MaxFunctionCount", i64 1000}
!7 = !{!"NumCounts", i64 3}
!8 = !{!"NumFunctions", i64 3}
!9 = !{!"DetailedSummary", !10}
!10 = !{!11, !12, !13}
!11 = !{i32 10000, i64 100, i32 1}
!12 = !{i32 999000, i64 100, i32 1}
!13 = !{i32 999999, i64 1, i32 2}
!14 = !{!"function_entry_count", i64 0}
