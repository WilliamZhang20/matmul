	.file	"matmul_kernel_optim.c"
	.text
	.p2align 4
	.def	printf;	.scl	3;	.type	32;	.endef
	.seh_proc	printf
printf:
	pushq	%rsi
	.seh_pushreg	%rsi
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$56, %rsp
	.seh_stackalloc	56
	.seh_endprologue
	leaq	88(%rsp), %rsi
	movq	%rdx, 88(%rsp)
	movq	%rcx, %rbx
	movl	$1, %ecx
	movq	%r8, 96(%rsp)
	movq	%r9, 104(%rsp)
	movq	%rsi, 40(%rsp)
	call	*__imp___acrt_iob_func(%rip)
	movq	%rsi, %r8
	movq	%rbx, %rdx
	movq	%rax, %rcx
	call	__mingw_vfprintf
	addq	$56, %rsp
	popq	%rbx
	popq	%rsi
	ret
	.seh_endproc
	.p2align 4
	.def	kernel_16x6.constprop.0;	.scl	3;	.type	32;	.endef
	.seh_proc	kernel_16x6.constprop.0
kernel_16x6.constprop.0:
	subq	$152, %rsp
	.seh_stackalloc	152
	vmovups	%xmm6, (%rsp)
	.seh_savexmm	%xmm6, 0
	vmovups	%xmm7, 16(%rsp)
	.seh_savexmm	%xmm7, 16
	vmovups	%xmm8, 32(%rsp)
	.seh_savexmm	%xmm8, 32
	vmovups	%xmm9, 48(%rsp)
	.seh_savexmm	%xmm9, 48
	vmovups	%xmm10, 64(%rsp)
	.seh_savexmm	%xmm10, 64
	vmovups	%xmm11, 80(%rsp)
	.seh_savexmm	%xmm11, 80
	vmovups	%xmm12, 96(%rsp)
	.seh_savexmm	%xmm12, 96
	vmovups	%xmm13, 112(%rsp)
	.seh_savexmm	%xmm13, 112
	vmovups	%xmm14, 128(%rsp)
	.seh_savexmm	%xmm14, 128
	.seh_endprologue
	vmovups	(%r8), %ymm14
	vmovups	32(%r8), %ymm13
	vmovups	3968(%r8), %ymm12
	vmovups	4000(%r8), %ymm11
	vmovups	7936(%r8), %ymm10
	vmovups	7968(%r8), %ymm9
	vmovups	11904(%r8), %ymm8
	vmovups	11936(%r8), %ymm7
	vmovups	15872(%r8), %ymm6
	leaq	4000(%rdx), %rax
	vmovups	15904(%r8), %ymm5
	vmovups	19840(%r8), %ymm4
	movq	%rax, %r9
	vmovups	19872(%r8), %ymm3
	jmp	.L4
	.p2align 4,,10
	.p2align 3
.L7:
	leaq	4000(%rdx), %rax
.L4:
	vmovups	(%rcx), %ymm1
	vmovups	32(%rcx), %ymm0
	addq	$4, %rdx
	addq	$3968, %rcx
	vbroadcastss	-4(%rdx), %ymm2
	vfmadd231ps	%ymm2, %ymm1, %ymm14
	vfmadd231ps	%ymm2, %ymm0, %ymm13
	vbroadcastss	(%rax), %ymm2
	vfmadd231ps	%ymm2, %ymm1, %ymm12
	vfmadd231ps	%ymm2, %ymm0, %ymm11
	vbroadcastss	7996(%rdx), %ymm2
	vfmadd231ps	%ymm2, %ymm1, %ymm10
	vfmadd231ps	%ymm2, %ymm0, %ymm9
	vbroadcastss	11996(%rdx), %ymm2
	vfmadd231ps	%ymm2, %ymm1, %ymm8
	vfmadd231ps	%ymm2, %ymm0, %ymm7
	vbroadcastss	15996(%rdx), %ymm2
	vfmadd231ps	%ymm2, %ymm1, %ymm6
	vfmadd231ps	%ymm2, %ymm0, %ymm5
	vbroadcastss	19996(%rdx), %ymm2
	vfmadd231ps	%ymm2, %ymm1, %ymm4
	vfmadd231ps	%ymm2, %ymm0, %ymm3
	cmpq	%rdx, %r9
	jne	.L7
	vmovups	%ymm14, (%r8)
	vmovups	%ymm13, 32(%r8)
	vmovups	%ymm12, 3968(%r8)
	vmovups	%ymm11, 4000(%r8)
	vmovups	%ymm10, 7936(%r8)
	vmovups	%ymm9, 7968(%r8)
	vmovups	%ymm8, 11904(%r8)
	vmovups	%ymm7, 11936(%r8)
	vmovups	%ymm6, 15872(%r8)
	vmovups	%ymm5, 15904(%r8)
	vmovups	%ymm4, 19840(%r8)
	vmovups	%ymm3, 19872(%r8)
	vzeroupper
	vmovups	(%rsp), %xmm6
	vmovups	16(%rsp), %xmm7
	vmovups	32(%rsp), %xmm8
	vmovups	48(%rsp), %xmm9
	vmovups	64(%rsp), %xmm10
	vmovups	80(%rsp), %xmm11
	vmovups	96(%rsp), %xmm12
	vmovups	112(%rsp), %xmm13
	vmovups	128(%rsp), %xmm14
	addq	$152, %rsp
	ret
	.seh_endproc
	.p2align 4
	.def	kernel_16x6.constprop.1;	.scl	3;	.type	32;	.endef
	.seh_proc	kernel_16x6.constprop.1
kernel_16x6.constprop.1:
	pushq	%r15
	.seh_pushreg	%r15
	pushq	%r14
	.seh_pushreg	%r14
	pushq	%r13
	.seh_pushreg	%r13
	pushq	%r12
	.seh_pushreg	%r12
	pushq	%rbp
	.seh_pushreg	%rbp
	pushq	%rdi
	.seh_pushreg	%rdi
	pushq	%rsi
	.seh_pushreg	%rsi
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$584, %rsp
	.seh_stackalloc	584
	vmovups	%xmm6, 432(%rsp)
	.seh_savexmm	%xmm6, 432
	vmovups	%xmm7, 448(%rsp)
	.seh_savexmm	%xmm7, 448
	vmovups	%xmm8, 464(%rsp)
	.seh_savexmm	%xmm8, 464
	vmovups	%xmm9, 480(%rsp)
	.seh_savexmm	%xmm9, 480
	vmovups	%xmm10, 496(%rsp)
	.seh_savexmm	%xmm10, 496
	vmovups	%xmm11, 512(%rsp)
	.seh_savexmm	%xmm11, 512
	vmovups	%xmm12, 528(%rsp)
	.seh_savexmm	%xmm12, 528
	vmovups	%xmm13, 544(%rsp)
	.seh_savexmm	%xmm13, 544
	vmovups	%xmm14, 560(%rsp)
	.seh_savexmm	%xmm14, 560
	.seh_endprologue
	vmovups	(%r8), %ymm2
	vmovups	32(%r8), %ymm3
	movl	688(%rsp), %r15d
	movq	%rcx, %r10
	leal	(%r9,%r9), %ebp
	leaq	63(%rsp), %rax
	movq	%rdx, %rcx
	movslq	%r9d, %rdx
	movslq	%ebp, %rdi
	addl	%r9d, %ebp
	andq	$-32, %rax
	leaq	0(,%rdx,4), %r11
	leaq	32(%r8,%rdi,4), %rdi
	movslq	%ebp, %rbp
	salq	$4, %rdx
	leaq	32(%r8,%r11), %rsi
	leaq	(%r8,%r11), %rbx
	vmovups	(%rdi), %ymm7
	movq	%rdi, 24(%rsp)
	vmovups	(%rsi), %ymm5
	movq	%rsi, 16(%rsp)
	leaq	(%rbx,%r11), %rsi
	leaq	32(%r8,%rbp,4), %r13
	leaq	(%rsi,%r11), %rdi
	vmovups	(%rbx), %ymm4
	vmovups	(%rsi), %ymm6
	vmovups	%ymm2, (%rax)
	leaq	(%rdi,%r11), %rbp
	leaq	32(%r8,%rdx), %r14
	vmovups	(%rdi), %ymm8
	vmovups	0(%r13), %ymm9
	leaq	0(%rbp,%r11), %rdx
	vmovups	0(%rbp), %ymm10
	vmovups	(%r14), %ymm11
	vmovups	%ymm3, 32(%rax)
	vmovups	(%rdx), %ymm12
	movq	%rdx, 8(%rsp)
	leal	(%r9,%r9,4), %edx
	movslq	%edx, %rdx
	vmovups	%ymm4, 64(%rax)
	leaq	32(%r8,%rdx,4), %r12
	vmovups	%ymm5, 96(%rax)
	vmovups	(%r12), %ymm13
	vmovups	%ymm6, 128(%rax)
	vmovups	%ymm7, 160(%rax)
	vmovups	%ymm8, 192(%rax)
	vmovups	%ymm9, 224(%rax)
	vmovups	%ymm10, 256(%rax)
	vmovups	%ymm11, 288(%rax)
	vmovups	%ymm12, 320(%rax)
	vmovups	%ymm13, 352(%rax)
	testl	%r15d, %r15d
	jle	.L11
	movslq	%r15d, %r9
	leaq	(%rcx,%r9,4), %rdx
	salq	$3, %r9
	leaq	(%rcx,%r9), %r15
	.p2align 4,,10
	.p2align 3
.L10:
	vmovups	(%r10), %ymm1
	vmovups	32(%r10), %ymm0
	addq	%r11, %r10
	vbroadcastss	(%rcx), %ymm14
	vfmadd231ps	%ymm14, %ymm1, %ymm2
	vfmadd231ps	%ymm14, %ymm0, %ymm3
	vmovups	%ymm2, (%rax)
	vmovups	%ymm3, 32(%rax)
	vbroadcastss	(%rdx), %ymm14
	vfmadd231ps	%ymm14, %ymm1, %ymm4
	vfmadd231ps	%ymm14, %ymm0, %ymm5
	vmovups	%ymm4, 64(%rax)
	vmovups	%ymm5, 96(%rax)
	vbroadcastss	(%rcx,%r9), %ymm14
	vfmadd231ps	%ymm14, %ymm1, %ymm6
	vfmadd231ps	%ymm14, %ymm0, %ymm7
	vmovups	%ymm6, 128(%rax)
	vmovups	%ymm7, 160(%rax)
	vbroadcastss	(%rdx,%r9), %ymm14
	vfmadd231ps	%ymm14, %ymm1, %ymm8
	vfmadd231ps	%ymm14, %ymm0, %ymm9
	vmovups	%ymm8, 192(%rax)
	vmovups	%ymm9, 224(%rax)
	vbroadcastss	(%rcx,%r9,2), %ymm14
	addq	$4, %rcx
	vfmadd231ps	%ymm14, %ymm1, %ymm10
	vfmadd231ps	%ymm14, %ymm0, %ymm11
	vmovups	%ymm10, 256(%rax)
	vmovups	%ymm11, 288(%rax)
	vbroadcastss	(%rdx,%r9,2), %ymm14
	addq	$4, %rdx
	vfmadd231ps	%ymm14, %ymm1, %ymm12
	vfmadd231ps	%ymm14, %ymm0, %ymm13
	vmovups	%ymm12, 320(%rax)
	vmovups	%ymm13, 352(%rax)
	cmpq	%r15, %rdx
	jne	.L10
.L11:
	vmovups	(%rax), %ymm2
	vmovups	32(%rax), %ymm3
	vmovups	64(%rax), %ymm4
	vmovups	96(%rax), %ymm5
	vmovups	%ymm2, (%r8)
	vmovups	128(%rax), %ymm6
	vmovups	160(%rax), %ymm7
	vmovups	%ymm3, 32(%r8)
	vmovups	192(%rax), %ymm2
	vmovups	224(%rax), %ymm3
	vmovups	%ymm4, (%rbx)
	movq	16(%rsp), %rbx
	vmovups	256(%rax), %ymm4
	vmovups	%ymm5, (%rbx)
	movq	24(%rsp), %rbx
	vmovups	288(%rax), %ymm5
	vmovups	%ymm6, (%rsi)
	vmovups	320(%rax), %ymm6
	vmovups	%ymm7, (%rbx)
	vmovups	352(%rax), %ymm7
	movq	8(%rsp), %rbx
	vmovups	%ymm2, (%rdi)
	vmovups	%ymm3, 0(%r13)
	vmovups	%ymm4, 0(%rbp)
	vmovups	%ymm5, (%r14)
	vmovups	%ymm6, (%rbx)
	vmovups	%ymm7, (%r12)
	vzeroupper
	vmovups	432(%rsp), %xmm6
	vmovups	448(%rsp), %xmm7
	vmovups	464(%rsp), %xmm8
	vmovups	480(%rsp), %xmm9
	vmovups	496(%rsp), %xmm10
	vmovups	512(%rsp), %xmm11
	vmovups	528(%rsp), %xmm12
	vmovups	544(%rsp), %xmm13
	vmovups	560(%rsp), %xmm14
	addq	$584, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	ret
	.seh_endproc
	.section .rdata,"dr"
.LC0:
	.ascii "\12\0"
	.text
	.p2align 4
	.def	printf.constprop.0;	.scl	3;	.type	32;	.endef
	.seh_proc	printf.constprop.0
printf.constprop.0:
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$48, %rsp
	.seh_stackalloc	48
	.seh_endprologue
	movl	$1, %ecx
	leaq	72(%rsp), %rbx
	movq	%rdx, 72(%rsp)
	movq	%r8, 80(%rsp)
	movq	%r9, 88(%rsp)
	movq	%rbx, 40(%rsp)
	call	*__imp___acrt_iob_func(%rip)
	movq	%rbx, %r8
	leaq	.LC0(%rip), %rdx
	movq	%rax, %rcx
	call	__mingw_vfprintf
	addq	$48, %rsp
	popq	%rbx
	ret
	.seh_endproc
	.section .rdata,"dr"
.LC1:
	.ascii "GFLOPS = %.3f\12\0"
	.text
	.p2align 4
	.def	printf.constprop.1;	.scl	3;	.type	32;	.endef
	.seh_proc	printf.constprop.1
printf.constprop.1:
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$48, %rsp
	.seh_stackalloc	48
	.seh_endprologue
	movl	$1, %ecx
	leaq	72(%rsp), %rbx
	movq	%rdx, 72(%rsp)
	movq	%r8, 80(%rsp)
	movq	%r9, 88(%rsp)
	movq	%rbx, 40(%rsp)
	call	*__imp___acrt_iob_func(%rip)
	movq	%rbx, %r8
	leaq	.LC1(%rip), %rdx
	movq	%rax, %rcx
	call	__mingw_vfprintf
	addq	$48, %rsp
	popq	%rbx
	ret
	.seh_endproc
	.section .rdata,"dr"
.LC2:
	.ascii "Exec. time = %.3fms\12\0"
	.text
	.p2align 4
	.def	printf.constprop.2;	.scl	3;	.type	32;	.endef
	.seh_proc	printf.constprop.2
printf.constprop.2:
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$48, %rsp
	.seh_stackalloc	48
	.seh_endprologue
	movl	$1, %ecx
	leaq	72(%rsp), %rbx
	movq	%rdx, 72(%rsp)
	movq	%r8, 80(%rsp)
	movq	%r9, 88(%rsp)
	movq	%rbx, 40(%rsp)
	call	*__imp___acrt_iob_func(%rip)
	movq	%rbx, %r8
	leaq	.LC2(%rip), %rdx
	movq	%rax, %rcx
	call	__mingw_vfprintf
	addq	$48, %rsp
	popq	%rbx
	ret
	.seh_endproc
	.section .rdata,"dr"
.LC3:
	.ascii "%f \0"
	.text
	.p2align 4
	.def	printf.constprop.3;	.scl	3;	.type	32;	.endef
	.seh_proc	printf.constprop.3
printf.constprop.3:
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$48, %rsp
	.seh_stackalloc	48
	.seh_endprologue
	movl	$1, %ecx
	leaq	72(%rsp), %rbx
	movq	%rdx, 72(%rsp)
	movq	%r8, 80(%rsp)
	movq	%r9, 88(%rsp)
	movq	%rbx, 40(%rsp)
	call	*__imp___acrt_iob_func(%rip)
	movq	%rbx, %r8
	leaq	.LC3(%rip), %rdx
	movq	%rax, %rcx
	call	__mingw_vfprintf
	addq	$48, %rsp
	popq	%rbx
	ret
	.seh_endproc
	.p2align 4
	.def	_mm_malloc.constprop.0;	.scl	3;	.type	32;	.endef
	.seh_proc	_mm_malloc.constprop.0
_mm_malloc.constprop.0:
	subq	$40, %rsp
	.seh_stackalloc	40
	.seh_endprologue
	addq	$64, %rcx
	call	malloc
	testq	%rax, %rax
	je	.L19
	leaq	64(%rax), %rdx
	andq	$-64, %rdx
	movq	%rax, -8(%rdx)
	movq	%rdx, %rax
.L19:
	addq	$40, %rsp
	ret
	.seh_endproc
	.p2align 4
	.globl	kernel_16x6
	.def	kernel_16x6;	.scl	2;	.type	32;	.endef
	.seh_proc	kernel_16x6
kernel_16x6:
	pushq	%r15
	.seh_pushreg	%r15
	pushq	%r14
	.seh_pushreg	%r14
	pushq	%r13
	.seh_pushreg	%r13
	pushq	%r12
	.seh_pushreg	%r12
	pushq	%rbp
	.seh_pushreg	%rbp
	pushq	%rdi
	.seh_pushreg	%rdi
	pushq	%rsi
	.seh_pushreg	%rsi
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$584, %rsp
	.seh_stackalloc	584
	vmovups	%xmm6, 432(%rsp)
	.seh_savexmm	%xmm6, 432
	vmovups	%xmm7, 448(%rsp)
	.seh_savexmm	%xmm7, 448
	vmovups	%xmm8, 464(%rsp)
	.seh_savexmm	%xmm8, 464
	vmovups	%xmm9, 480(%rsp)
	.seh_savexmm	%xmm9, 480
	vmovups	%xmm10, 496(%rsp)
	.seh_savexmm	%xmm10, 496
	vmovups	%xmm11, 512(%rsp)
	.seh_savexmm	%xmm11, 512
	vmovups	%xmm12, 528(%rsp)
	.seh_savexmm	%xmm12, 528
	vmovups	%xmm13, 544(%rsp)
	.seh_savexmm	%xmm13, 544
	vmovups	%xmm14, 560(%rsp)
	.seh_savexmm	%xmm14, 560
	.seh_endprologue
	vmovups	(%r8), %ymm13
	vmovups	32(%r8), %ymm12
	movl	696(%rsp), %r15d
	movq	%rcx, %r10
	leal	(%r9,%r9), %ebp
	leaq	63(%rsp), %rax
	movq	%rdx, %rcx
	movslq	%r9d, %rdx
	movslq	%ebp, %rdi
	addl	%r9d, %ebp
	andq	$-32, %rax
	leaq	0(,%rdx,4), %r11
	leaq	32(%r8,%rdi,4), %rdi
	movslq	%ebp, %rbp
	salq	$4, %rdx
	leaq	32(%r8,%r11), %rsi
	leaq	(%r8,%r11), %rbx
	vmovups	(%rdi), %ymm3
	movq	%rdi, 24(%rsp)
	vmovups	(%rsi), %ymm11
	movq	%rsi, 16(%rsp)
	leaq	(%rbx,%r11), %rsi
	leaq	32(%r8,%rbp,4), %r13
	leaq	(%rsi,%r11), %rdi
	vmovups	(%rbx), %ymm10
	vmovups	(%rsi), %ymm2
	vmovups	%ymm13, (%rax)
	leaq	(%rdi,%r11), %rbp
	leaq	32(%r8,%rdx), %r14
	vmovups	(%rdi), %ymm4
	vmovups	0(%r13), %ymm5
	leaq	0(%rbp,%r11), %rdx
	vmovups	0(%rbp), %ymm6
	vmovups	(%r14), %ymm7
	vmovups	%ymm12, 32(%rax)
	vmovups	(%rdx), %ymm8
	movq	%rdx, 8(%rsp)
	leal	(%r9,%r9,4), %edx
	movslq	%edx, %rdx
	vmovups	%ymm10, 64(%rax)
	leaq	32(%r8,%rdx,4), %r12
	vmovups	%ymm11, 96(%rax)
	vmovups	(%r12), %ymm9
	vmovups	%ymm2, 128(%rax)
	vmovups	%ymm3, 160(%rax)
	vmovups	%ymm4, 192(%rax)
	vmovups	%ymm5, 224(%rax)
	vmovups	%ymm6, 256(%rax)
	vmovups	%ymm7, 288(%rax)
	vmovups	%ymm8, 320(%rax)
	vmovups	%ymm9, 352(%rax)
	testl	%r15d, %r15d
	jle	.L27
	movslq	%r15d, %r9
	leaq	(%rcx,%r9,4), %rdx
	salq	$3, %r9
	leaq	(%rcx,%r9), %r15
	.p2align 4,,10
	.p2align 3
.L26:
	vmovups	(%r10), %ymm1
	vmovups	32(%r10), %ymm0
	addq	%r11, %r10
	vbroadcastss	(%rcx), %ymm14
	vfmadd231ps	%ymm14, %ymm1, %ymm13
	vfmadd231ps	%ymm14, %ymm0, %ymm12
	vmovups	%ymm13, (%rax)
	vmovups	%ymm12, 32(%rax)
	vbroadcastss	(%rdx), %ymm14
	vfmadd231ps	%ymm14, %ymm1, %ymm10
	vfmadd231ps	%ymm14, %ymm0, %ymm11
	vmovups	%ymm10, 64(%rax)
	vmovups	%ymm11, 96(%rax)
	vbroadcastss	(%rcx,%r9), %ymm14
	vfmadd231ps	%ymm14, %ymm1, %ymm2
	vfmadd231ps	%ymm14, %ymm0, %ymm3
	vmovups	%ymm2, 128(%rax)
	vmovups	%ymm3, 160(%rax)
	vbroadcastss	(%rdx,%r9), %ymm14
	vfmadd231ps	%ymm14, %ymm1, %ymm4
	vfmadd231ps	%ymm14, %ymm0, %ymm5
	vmovups	%ymm4, 192(%rax)
	vmovups	%ymm5, 224(%rax)
	vbroadcastss	(%rcx,%r9,2), %ymm14
	addq	$4, %rcx
	vfmadd231ps	%ymm14, %ymm1, %ymm6
	vfmadd231ps	%ymm14, %ymm0, %ymm7
	vmovups	%ymm6, 256(%rax)
	vmovups	%ymm7, 288(%rax)
	vbroadcastss	(%rdx,%r9,2), %ymm14
	addq	$4, %rdx
	vfmadd231ps	%ymm14, %ymm1, %ymm8
	vfmadd231ps	%ymm14, %ymm0, %ymm9
	vmovups	%ymm8, 320(%rax)
	vmovups	%ymm9, 352(%rax)
	cmpq	%r15, %rdx
	jne	.L26
.L27:
	vmovups	(%rax), %ymm2
	vmovups	32(%rax), %ymm3
	vmovups	64(%rax), %ymm4
	vmovups	96(%rax), %ymm5
	vmovups	%ymm2, (%r8)
	vmovups	128(%rax), %ymm6
	vmovups	160(%rax), %ymm7
	vmovups	%ymm3, 32(%r8)
	vmovups	192(%rax), %ymm2
	vmovups	224(%rax), %ymm3
	vmovups	%ymm4, (%rbx)
	movq	16(%rsp), %rbx
	vmovups	256(%rax), %ymm4
	vmovups	%ymm5, (%rbx)
	movq	24(%rsp), %rbx
	vmovups	288(%rax), %ymm5
	vmovups	%ymm6, (%rsi)
	vmovups	320(%rax), %ymm6
	vmovups	%ymm7, (%rbx)
	vmovups	352(%rax), %ymm7
	movq	8(%rsp), %rbx
	vmovups	%ymm2, (%rdi)
	vmovups	%ymm3, 0(%r13)
	vmovups	%ymm4, 0(%rbp)
	vmovups	%ymm5, (%r14)
	vmovups	%ymm6, (%rbx)
	vmovups	%ymm7, (%r12)
	vzeroupper
	vmovups	432(%rsp), %xmm6
	vmovups	448(%rsp), %xmm7
	vmovups	464(%rsp), %xmm8
	vmovups	480(%rsp), %xmm9
	vmovups	496(%rsp), %xmm10
	vmovups	512(%rsp), %xmm11
	vmovups	528(%rsp), %xmm12
	vmovups	544(%rsp), %xmm13
	vmovups	560(%rsp), %xmm14
	addq	$584, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	ret
	.seh_endproc
	.section .rdata,"dr"
.LC4:
	.ascii "matmul_kernel_optim.c\0"
.LC5:
	.ascii "M % MR == 0\0"
.LC6:
	.ascii "N % NR == 0\0"
	.text
	.p2align 4
	.globl	matmul_kernel
	.def	matmul_kernel;	.scl	2;	.type	32;	.endef
	.seh_proc	matmul_kernel
matmul_kernel:
	pushq	%r15
	.seh_pushreg	%r15
	pushq	%r14
	.seh_pushreg	%r14
	pushq	%r13
	.seh_pushreg	%r13
	pushq	%r12
	.seh_pushreg	%r12
	pushq	%rbp
	.seh_pushreg	%rbp
	pushq	%rdi
	.seh_pushreg	%rdi
	pushq	%rsi
	.seh_pushreg	%rsi
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$72, %rsp
	.seh_stackalloc	72
	.seh_endprologue
	movl	176(%rsp), %r14d
	movl	184(%rsp), %r13d
	movq	%rcx, %rdi
	movq	%rdx, %r10
	movl	%r9d, %r15d
	testb	$15, %r9b
	jne	.L39
	movslq	%r14d, %rcx
	movl	%r14d, %edx
	imulq	$715827883, %rcx, %rcx
	sarl	$31, %edx
	shrq	$32, %rcx
	subl	%edx, %ecx
	leal	(%rcx,%rcx,2), %ecx
	addl	%ecx, %ecx
	cmpl	%ecx, %r14d
	jne	.L33
	testl	%r9d, %r9d
	jle	.L38
	testl	%r14d, %r14d
	jle	.L38
	leal	-1(%r9), %eax
	leal	0(%r13,%r13,2), %r12d
	xorl	%ecx, %ecx
	movq	%r10, 152(%rsp)
	leal	(%r9,%r9,2), %ebp
	andl	$-16, %eax
	addl	%r12d, %r12d
	movl	%ecx, %edx
	addl	%ebp, %ebp
	addl	$16, %eax
	movslq	%r12d, %r12
	movslq	%ebp, %rbp
	movl	%eax, 60(%rsp)
	salq	$2, %r12
	movq	%r8, %rax
	salq	$2, %rbp
	.p2align 4,,10
	.p2align 3
.L35:
	movq	%rax, 48(%rsp)
	movq	152(%rsp), %rsi
	movq	%rax, %r8
	xorl	%ebx, %ebx
	movl	%edx, 56(%rsp)
	.p2align 4,,10
	.p2align 3
.L36:
	movl	%r13d, 32(%rsp)
	movq	%rsi, %rdx
	movl	%r15d, %r9d
	movq	%rdi, %rcx
	addl	$6, %ebx
	addq	%r12, %rsi
	call	kernel_16x6.constprop.1
	addq	%rbp, %r8
	cmpl	%ebx, %r14d
	jg	.L36
	movl	56(%rsp), %edx
	movq	48(%rsp), %rax
	addq	$64, %rdi
	movl	60(%rsp), %ecx
	addl	$16, %edx
	addq	$64, %rax
	cmpl	%ecx, %edx
	jne	.L35
.L38:
	addq	$72, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	ret
.L39:
	movl	$72, %r8d
	leaq	.LC4(%rip), %rdx
	leaq	.LC5(%rip), %rcx
	call	*__imp__assert(%rip)
.L33:
	movl	$73, %r8d
	leaq	.LC4(%rip), %rdx
	leaq	.LC6(%rip), %rcx
	call	*__imp__assert(%rip)
	nop
	.seh_endproc
	.p2align 4
	.globl	matmul_naive
	.def	matmul_naive;	.scl	2;	.type	32;	.endef
	.seh_proc	matmul_naive
matmul_naive:
	pushq	%r13
	.seh_pushreg	%r13
	pushq	%r12
	.seh_pushreg	%r12
	pushq	%rbp
	.seh_pushreg	%rbp
	pushq	%rdi
	.seh_pushreg	%rdi
	pushq	%rsi
	.seh_pushreg	%rsi
	pushq	%rbx
	.seh_pushreg	%rbx
	.seh_endprologue
	movl	88(%rsp), %esi
	movslq	96(%rsp), %rax
	movslq	%r9d, %r12
	movq	%rcx, %rbx
	movq	%rdx, %r13
	movq	%r8, %rdi
	testl	%r12d, %r12d
	jle	.L49
	testl	%esi, %esi
	jle	.L49
	testl	%eax, %eax
	jle	.L49
	leaq	0(,%rax,4), %r11
	leaq	0(,%r12,4), %r9
	xorl	%ebp, %ebp
	addq	%r11, %r13
	.p2align 4,,10
	.p2align 3
.L43:
	movq	%r13, %r8
	movq	%rdi, %rcx
	xorl	%r10d, %r10d
	.p2align 4,,10
	.p2align 3
.L46:
	movq	%r8, %rax
	vmovss	(%rcx), %xmm0
	movq	%rbx, %rdx
	subq	%r11, %rax
	.p2align 4,,10
	.p2align 3
.L44:
	vmovss	(%rdx), %xmm1
	vfmadd231ss	(%rax), %xmm1, %xmm0
	addq	$4, %rax
	addq	%r9, %rdx
	vmovss	%xmm0, (%rcx)
	cmpq	%rax, %r8
	jne	.L44
	addl	$1, %r10d
	addq	%r9, %rcx
	addq	%r11, %r8
	cmpl	%r10d, %esi
	jne	.L46
	addq	$1, %rbp
	addq	$4, %rbx
	addq	$4, %rdi
	cmpq	%r12, %rbp
	jne	.L43
.L49:
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	popq	%r12
	popq	%r13
	ret
	.seh_endproc
	.p2align 4
	.globl	print_mat
	.def	print_mat;	.scl	2;	.type	32;	.endef
	.seh_proc	print_mat
print_mat:
	pushq	%r15
	.seh_pushreg	%r15
	pushq	%r14
	.seh_pushreg	%r14
	pushq	%r13
	.seh_pushreg	%r13
	pushq	%r12
	.seh_pushreg	%r12
	pushq	%rbp
	.seh_pushreg	%rbp
	pushq	%rdi
	.seh_pushreg	%rdi
	pushq	%rsi
	.seh_pushreg	%rsi
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$72, %rsp
	.seh_stackalloc	72
	vmovups	%xmm6, 48(%rsp)
	.seh_savexmm	%xmm6, 48
	.seh_endprologue
	leaq	.LC0(%rip), %r15
	movl	%edx, 36(%rsp)
	movq	%rcx, %r13
	movl	%r8d, %r12d
	testl	%edx, %edx
	jle	.L51
	movslq	%r8d, %rax
	vxorps	%xmm6, %xmm6, %xmm6
	xorl	%ebp, %ebp
	xorl	%edi, %edi
	movq	%rax, 40(%rsp)
	leaq	.LC3(%rip), %rsi
	.p2align 4,,10
	.p2align 3
.L52:
	testl	%r12d, %r12d
	jle	.L55
	movq	40(%rsp), %rbx
	movslq	%ebp, %rax
	leaq	0(%r13,%rax,4), %r14
	addq	%rbx, %rax
	leaq	0(%r13,%rax,4), %rbx
	.p2align 4,,10
	.p2align 3
.L53:
	vcvtss2sd	(%r14), %xmm6, %xmm0
	movq	%rsi, %rcx
	vmovq	%xmm0, %rdx
	vmovsd	%xmm0, %xmm0, %xmm1
	call	printf.constprop.3
	addq	$4, %r14
	cmpq	%r14, %rbx
	jne	.L53
.L55:
	movq	%r15, %rcx
	addl	$1, %edi
	addl	%r12d, %ebp
	call	printf.constprop.0
	cmpl	%edi, 36(%rsp)
	jne	.L52
.L51:
	vmovups	48(%rsp), %xmm6
	movq	%r15, %rcx
	addq	$72, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	jmp	printf.constprop.0
	.seh_endproc
	.p2align 4
	.globl	init_rand
	.def	init_rand;	.scl	2;	.type	32;	.endef
	.seh_proc	init_rand
init_rand:
	pushq	%rsi
	.seh_pushreg	%rsi
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$72, %rsp
	.seh_stackalloc	72
	vmovups	%xmm6, 32(%rsp)
	.seh_savexmm	%xmm6, 32
	vmovups	%xmm7, 48(%rsp)
	.seh_savexmm	%xmm7, 48
	.seh_endprologue
	imull	%r8d, %edx
	movq	%rcx, %rbx
	testl	%edx, %edx
	jle	.L62
	movslq	%edx, %rdx
	vmovss	.LC7(%rip), %xmm6
	vxorps	%xmm7, %xmm7, %xmm7
	leaq	(%rcx,%rdx,4), %rsi
	.p2align 4,,10
	.p2align 3
.L60:
	call	rand
	addq	$4, %rbx
	vcvtsi2ssl	%eax, %xmm7, %xmm0
	vdivss	%xmm6, %xmm0, %xmm0
	vmovss	%xmm0, -4(%rbx)
	cmpq	%rbx, %rsi
	jne	.L60
.L62:
	vmovups	32(%rsp), %xmm6
	vmovups	48(%rsp), %xmm7
	addq	$72, %rsp
	popq	%rbx
	popq	%rsi
	ret
	.seh_endproc
	.p2align 4
	.globl	init_const
	.def	init_const;	.scl	2;	.type	32;	.endef
	.seh_proc	init_const
init_const:
	pushq	%r14
	.seh_pushreg	%r14
	pushq	%r13
	.seh_pushreg	%r13
	pushq	%r12
	.seh_pushreg	%r12
	pushq	%rbp
	.seh_pushreg	%rbp
	pushq	%rdi
	.seh_pushreg	%rdi
	pushq	%rsi
	.seh_pushreg	%rsi
	pushq	%rbx
	.seh_pushreg	%rbx
	.seh_endprologue
	movq	%rcx, %rdx
	movl	%r8d, %esi
	testl	%r8d, %r8d
	jle	.L85
	testl	%r9d, %r9d
	jle	.L85
	movl	%r9d, %r8d
	movl	%r9d, %ebx
	movl	%r9d, %edi
	xorl	%r11d, %r11d
	andl	$-8, %r8d
	shrl	$3, %ebx
	leal	-1(%r9), %r12d
	vbroadcastss	%xmm1, %ymm0
	salq	$5, %rbx
	movl	%r8d, %ebp
	salq	$2, %rdi
	vshufps	$0, %xmm1, %xmm1, %xmm2
	salq	$2, %rbp
	.p2align 4,,10
	.p2align 3
.L65:
	cmpl	$6, %r12d
	jbe	.L86
.L68:
	movq	%rdx, %rax
	leaq	(%rbx,%rdx), %rcx
	testb	$32, %bl
	je	.L66
	leaq	32(%rdx), %rax
	vmovups	%ymm0, (%rdx)
	cmpq	%rcx, %rax
	je	.L83
	.p2align 4,,10
	.p2align 3
.L66:
	vmovups	%ymm0, (%rax)
	addq	$64, %rax
	vmovups	%ymm0, -32(%rax)
	cmpq	%rcx, %rax
	jne	.L66
.L83:
	cmpl	%r8d, %r9d
	je	.L87
	leaq	(%rdx,%rbp), %r10
	movl	%r8d, %ecx
	movl	%r8d, %eax
.L71:
	movl	%r9d, %r13d
	subl	%ecx, %r13d
	leal	-1(%r13), %r14d
	cmpl	$2, %r14d
	jbe	.L69
	vmovups	%xmm2, (%rdx,%rcx,4)
	movl	%r13d, %ecx
	andl	$-4, %ecx
	movl	%ecx, %r14d
	addl	%ecx, %eax
	andl	$3, %r13d
	leaq	(%r10,%r14,4), %r10
	je	.L70
.L69:
	leal	1(%rax), %ecx
	vmovss	%xmm1, (%r10)
	cmpl	%r9d, %ecx
	jge	.L70
	addl	$2, %eax
	vmovss	%xmm1, 4(%r10)
	cmpl	%eax, %r9d
	jle	.L70
	vmovss	%xmm1, 8(%r10)
.L70:
	addl	$1, %r11d
	addq	%rdi, %rdx
	cmpl	%r11d, %esi
	jne	.L65
.L84:
	vzeroupper
.L85:
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	popq	%r12
	popq	%r13
	popq	%r14
	ret
	.p2align 4,,10
	.p2align 3
.L87:
	addl	$1, %r11d
	addq	%rdi, %rdx
	cmpl	%r11d, %esi
	jne	.L68
	jmp	.L84
.L86:
	movq	%rdx, %r10
	xorl	%ecx, %ecx
	xorl	%eax, %eax
	jmp	.L71
	.seh_endproc
	.section .rdata,"dr"
	.align 8
.LC10:
	.ascii "MISMATCH! Element[%d][%d] %f != %f\12\0"
.LC11:
	.ascii "MATCH!\12\0"
	.text
	.p2align 4
	.globl	compare_mats
	.def	compare_mats;	.scl	2;	.type	32;	.endef
	.seh_proc	compare_mats
compare_mats:
	pushq	%rsi
	.seh_pushreg	%rsi
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$56, %rsp
	.seh_stackalloc	56
	.seh_endprologue
	testl	%r8d, %r8d
	jle	.L89
	movslq	%r8d, %rbx
	leaq	0(,%rbx,4), %r10
	testl	%r9d, %r9d
	jle	.L89
	vmovsd	.LC9(%rip), %xmm2
	xorl	%esi, %esi
	xorl	%r11d, %r11d
	vmovss	.LC8(%rip), %xmm4
.L94:
	leaq	0(,%rsi,4), %rax
	xorl	%r8d, %r8d
	jmp	.L93
	.p2align 4,,10
	.p2align 3
.L97:
	addl	$1, %r8d
	addq	%r10, %rax
	cmpl	%r8d, %r9d
	je	.L100
.L93:
	vmovss	(%rcx,%rax), %xmm3
	vmovss	(%rdx,%rax), %xmm1
	vsubss	%xmm1, %xmm3, %xmm0
	vandps	%xmm4, %xmm0, %xmm0
	vcvtss2sd	%xmm0, %xmm0, %xmm0
	vcomisd	%xmm2, %xmm0
	jbe	.L97
	vcvtss2sd	%xmm3, %xmm3, %xmm5
	vcvtss2sd	%xmm1, %xmm1, %xmm1
	vmovq	%xmm5, %r9
	vmovsd	%xmm1, 32(%rsp)
	vmovsd	%xmm5, %xmm5, %xmm3
	movl	%r11d, %edx
	leaq	.LC10(%rip), %rcx
	call	printf
	nop
	addq	$56, %rsp
	popq	%rbx
	popq	%rsi
	ret
	.p2align 4,,10
	.p2align 3
.L100:
	addq	$1, %rsi
	cmpq	%rsi, %rbx
	je	.L89
	movl	%esi, %r11d
	jmp	.L94
	.p2align 4,,10
	.p2align 3
.L89:
	leaq	.LC11(%rip), %rcx
	addq	$56, %rsp
	popq	%rbx
	popq	%rsi
	jmp	printf
	.seh_endproc
	.p2align 4
	.globl	timer
	.def	timer;	.scl	2;	.type	32;	.endef
	.seh_proc	timer
timer:
	subq	$56, %rsp
	.seh_stackalloc	56
	.seh_endprologue
	movl	$1, %ecx
	leaq	32(%rsp), %rdx
	call	clock_gettime
	movslq	40(%rsp), %rdx
	imulq	$1000000000, 32(%rsp), %rax
	addq	%rdx, %rax
	addq	$56, %rsp
	ret
	.seh_endproc
	.def	__main;	.scl	2;	.type	32;	.endef
	.section	.text.startup,"x"
	.p2align 4
	.globl	main
	.def	main;	.scl	2;	.type	32;	.endef
	.seh_proc	main
main:
	pushq	%r15
	.seh_pushreg	%r15
	pushq	%r14
	.seh_pushreg	%r14
	pushq	%r13
	.seh_pushreg	%r13
	pushq	%r12
	.seh_pushreg	%r12
	pushq	%rbp
	.seh_pushreg	%rbp
	pushq	%rdi
	.seh_pushreg	%rdi
	pushq	%rsi
	.seh_pushreg	%rsi
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$184, %rsp
	.seh_stackalloc	184
	vmovups	%xmm6, 80(%rsp)
	.seh_savexmm	%xmm6, 80
	vmovups	%xmm7, 96(%rsp)
	.seh_savexmm	%xmm7, 96
	vmovups	%xmm8, 112(%rsp)
	.seh_savexmm	%xmm8, 112
	vmovups	%xmm9, 128(%rsp)
	.seh_savexmm	%xmm9, 128
	vmovups	%xmm10, 144(%rsp)
	.seh_savexmm	%xmm10, 144
	vmovups	%xmm11, 160(%rsp)
	.seh_savexmm	%xmm11, 160
	.seh_endprologue
	vxorps	%xmm6, %xmm6, %xmm6
	call	__main
	movl	$3968000, %ecx
	call	_mm_malloc.constprop.0
	movl	$3984000, %ecx
	movq	%rax, %rbx
	movq	%rax, 48(%rsp)
	call	_mm_malloc.constprop.0
	movl	$3952128, %ecx
	movq	%rbx, %rdi
	movq	%rax, %rsi
	addq	$3968000, %rdi
	call	_mm_malloc.constprop.0
	movl	$3952128, %ecx
	movq	%rax, %rbp
	call	_mm_malloc.constprop.0
	vmovss	.LC7(%rip), %xmm7
	movq	%rax, %r15
.L103:
	call	rand
	addq	$4, %rbx
	vcvtsi2ssl	%eax, %xmm6, %xmm0
	vdivss	%xmm7, %xmm0, %xmm0
	vmovss	%xmm0, -4(%rbx)
	cmpq	%rdi, %rbx
	jne	.L103
	leaq	3984000(%rsi), %rbx
	movq	%rsi, %rdi
.L104:
	call	rand
	addq	$4, %rdi
	vcvtsi2ssl	%eax, %xmm6, %xmm0
	vdivss	%xmm7, %xmm0, %xmm0
	vmovss	%xmm0, -4(%rdi)
	cmpq	%rbx, %rdi
	jne	.L104
	leaq	64(%rsp), %rax
	movq	%r15, 56(%rsp)
	vmovsd	.LC12(%rip), %xmm10
	movl	$100, %edi
	movq	%rax, 40(%rsp)
	vmovsd	.LC13(%rip), %xmm9
	vmovsd	.LC14(%rip), %xmm8
	vmovsd	.LC15(%rip), %xmm7
	.p2align 4,,10
	.p2align 3
.L105:
	movl	$3952128, %r8d
	xorl	%edx, %edx
	movq	%rbp, %rcx
	movq	%rbp, %r13
	call	memset
	movq	40(%rsp), %rdx
	movl	$1, %ecx
	xorl	%r15d, %r15d
	call	clock_gettime
	movslq	72(%rsp), %r12
	movq	48(%rsp), %r10
	imulq	$1000000000, 64(%rsp), %r14
	.p2align 4,,10
	.p2align 3
.L111:
	movq	%rsi, %r11
	movq	%r13, %r8
	.p2align 4,,10
	.p2align 3
.L106:
	movq	%r11, %rdx
	movq	%r10, %rcx
	addq	$24000, %r11
	call	kernel_16x6.constprop.0
	addq	$23808, %r8
	cmpq	%rbx, %r11
	jne	.L106
	addl	$16, %r15d
	addq	$64, %r13
	addq	$64, %r10
	cmpl	$992, %r15d
	jne	.L111
	movq	40(%rsp), %rdx
	movl	$1, %ecx
	call	clock_gettime
	movslq	72(%rsp), %rax
	imulq	$1000000000, 64(%rsp), %rdx
	subq	%r12, %rdx
	addq	%rdx, %rax
	subq	%r14, %rax
	js	.L108
	vcvtsi2sdq	%rax, %xmm6, %xmm0
.L109:
	vmulsd	%xmm10, %xmm0, %xmm0
	leaq	.LC2(%rip), %rcx
	vdivsd	%xmm0, %xmm9, %xmm11
	vmulsd	%xmm8, %xmm0, %xmm1
	vmovq	%xmm1, %rdx
	call	printf.constprop.2
	leaq	.LC1(%rip), %rcx
	vdivsd	%xmm7, %xmm11, %xmm1
	vmovq	%xmm1, %rdx
	call	printf.constprop.1
	leaq	.LC0(%rip), %rcx
	call	printf.constprop.0
	subl	$1, %edi
	jne	.L105
	movq	48(%rsp), %rax
	movq	56(%rsp), %r15
	testq	%rax, %rax
	je	.L112
	movq	-8(%rax), %rcx
	call	free
.L112:
	testq	%rsi, %rsi
	je	.L113
	movq	-8(%rsi), %rcx
	call	free
.L113:
	movq	-8(%rbp), %rcx
	call	free
	testq	%r15, %r15
	je	.L114
	movq	-8(%r15), %rcx
	call	free
	nop
.L114:
	vmovups	80(%rsp), %xmm6
	vmovups	96(%rsp), %xmm7
	xorl	%eax, %eax
	vmovups	128(%rsp), %xmm9
	vmovups	112(%rsp), %xmm8
	vmovups	144(%rsp), %xmm10
	vmovups	160(%rsp), %xmm11
	addq	$184, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	ret
.L108:
	movq	%rax, %rdx
	andl	$1, %eax
	shrq	%rdx
	orq	%rax, %rdx
	vcvtsi2sdq	%rdx, %xmm6, %xmm0
	vaddsd	%xmm0, %xmm0, %xmm0
	jmp	.L109
	.seh_endproc
	.section .rdata,"dr"
	.align 4
.LC7:
	.long	1191181824
	.align 16
.LC8:
	.long	2147483647
	.long	0
	.long	0
	.long	0
	.align 8
.LC9:
	.long	-755914244
	.long	1062232653
	.align 8
.LC12:
	.long	-400107883
	.long	1041313291
	.align 8
.LC13:
	.long	0
	.long	1105031702
	.align 8
.LC14:
	.long	0
	.long	1083129856
	.align 8
.LC15:
	.long	0
	.long	1104006501
	.ident	"GCC: (Rev6, Built by MSYS2 project) 13.1.0"
	.def	__mingw_vfprintf;	.scl	2;	.type	32;	.endef
	.def	malloc;	.scl	2;	.type	32;	.endef
	.def	rand;	.scl	2;	.type	32;	.endef
	.def	clock_gettime;	.scl	2;	.type	32;	.endef
	.def	memset;	.scl	2;	.type	32;	.endef
	.def	free;	.scl	2;	.type	32;	.endef
