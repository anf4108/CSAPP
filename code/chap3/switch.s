	.file	"switch.c"
	.text
	.globl	switch_eg
	.type	switch_eg, @function
switch_eg:
.LFB0:
	.cfi_startproc
	endbr64
	movq	%rdx, %rcx
	cmpq	$3, %rdi
	je	.L8
	jg	.L3
	cmpq	$1, %rdi
	je	.L4
	cmpq	$2, %rdi
	jne	.L11
	movq	%rsi, %rax
	cqto
	idivq	%rcx
	jmp	.L2
.L11:
	movl	$2, %eax
	ret
.L3:
	subq	$5, %rdi
	cmpq	$1, %rdi
	ja	.L12
	movl	$1, %eax
	subq	%rdx, %rax
	ret
.L4:
	movq	%rdx, %rax
	imulq	%rsi, %rax
	ret
.L8:
	movl	$1, %eax
.L2:
	addq	%rcx, %rax
	ret
.L12:
	movl	$2, %eax
	ret
	.cfi_endproc
.LFE0:
	.size	switch_eg, .-switch_eg
	.ident	"GCC: (Ubuntu 9.4.0-1ubuntu1~20.04.1) 9.4.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	 1f - 0f
	.long	 4f - 1f
	.long	 5
0:
	.string	 "GNU"
1:
	.align 8
	.long	 0xc0000002
	.long	 3f - 2f
2:
	.long	 0x3
3:
	.align 8
4:
