/*
 * setjmp() & longjmp() implementation for x86_64.
 * Replaces a buggy C implementation.
 */

#include <setjmp.h>
#include <stdlib.h>

asm (".global __longjmp\n\t"
     ".global _longjmp\n\t"
     ".global longjmp\n\t"
     ".type __longjmp, %function\n\t"
     ".type _longjmp,  %function\n\t"
     ".type longjmp,   %function\n\t"
     "__longjmp:\n\t"
     "_longjmp:\n\t"
     "longjmp:\n\t"

     /* ensure return value is non-zero */
     "mov    %rsi,     %rax\n\t"
     "test   %rax,     %rax\n\t"
     "sete   %bl\n\t"
     "movsbq %bl,      %rbx\n\t"
     "add    %rbx,     %rax\n\t"

     "movq 0x00(%rdi), %rbp\n\t" /* rbp = env->__bp */
     "movq 0x10(%rdi), %rsp\n\t" /* rsp = env->__sp */
     "movq 0x08(%rdi), %rbx\n\t" /* rbx = env->__pc */
     "jmp  *%rbx\n\t"
);

asm (".global __setjmp\n\t"
     ".global _setjmp \n\t"
     ".global setjmp\n\t"
     ".type __setjmp, %function\n\t"
     ".type _setjmp,  %function\n\t"
     ".type setjmp,   %function\n\t"
     "__setjmp:\n\t"
     "_setjmp:\n\t"
     "setjmp:\n\t"
     "movq %rbp,   0x00(%rdi)\n\t" /* env->__bp = base pointer from caller */
     "movq (%rsp), %rax\n\t"       /* rax = return address to caller */
     "movq %rax,   0x08(%rdi)\n\t" /* env->__pc = retaddr */
     "movq %rsp,   %rax\n\t"       /* rax = stack pointer */
     "add  $8,     %rax\n\t"       /* offset sp to skip return addr */
     "movq %rax,   0x10(%rdi)\n\t" /* env->__sp = sp before call */
     "movq $0,     %rax\n\t"
     "ret\n\t");
