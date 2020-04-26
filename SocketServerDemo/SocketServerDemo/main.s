	.section	__TEXT,__text,regular,pure_instructions
	.macosx_version_min 10, 11
	.globl	_main
	.align	4, 0x90
_main:                                  ## @main
	.cfi_startproc
## BB#0:
	pushq	%rbp
Ltmp0:
	.cfi_def_cfa_offset 16
Ltmp1:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
Ltmp2:
	.cfi_def_cfa_register %rbp
	subq	$4256, %rsp             ## imm = 0x10A0
	leaq	L_.str(%rip), %rax
	movl	$0, -4(%rbp)
	movl	%edi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	%rax, %rdi
	movb	$0, %al
	callq	_printf
	movl	$2, %edi
	movl	$1, %esi
	xorl	%edx, %edx
	movl	%eax, -4152(%rbp)       ## 4-byte Spill
	callq	_socket
	movl	%eax, -20(%rbp)
	cmpl	$-1, %eax
	jne	LBB0_2
## BB#1:
	callq	___error
	movl	(%rax), %edi
	callq	_strerror
	movq	%rax, -4160(%rbp)       ## 8-byte Spill
	callq	___error
	leaq	L_.str.1(%rip), %rdi
	movl	(%rax), %edx
	movq	-4160(%rbp), %rsi       ## 8-byte Reload
	movb	$0, %al
	callq	_printf
	xorl	%edi, %edi
	movl	%eax, -4164(%rbp)       ## 4-byte Spill
	callq	_exit
LBB0_2:
	movl	$16, %edx
	leaq	-40(%rbp), %rax
	xorl	%esi, %esi
	movl	$16, %ecx
	movl	%ecx, %edi
	movq	%rax, %r8
	movq	%rdi, -4176(%rbp)       ## 8-byte Spill
	movq	%r8, %rdi
	movq	-4176(%rbp), %r8        ## 8-byte Reload
	movl	%edx, -4180(%rbp)       ## 4-byte Spill
	movq	%r8, %rdx
	movq	%rax, -4192(%rbp)       ## 8-byte Spill
	callq	_memset
	movb	$2, -39(%rbp)
	movl	$0, -36(%rbp)
	movw	$2586, -38(%rbp)        ## imm = 0xA1A
	movl	-20(%rbp), %edi
	movq	-4192(%rbp), %rax       ## 8-byte Reload
	movq	%rax, %rsi
	movl	-4180(%rbp), %edx       ## 4-byte Reload
	callq	_bind
	cmpl	$-1, %eax
	jne	LBB0_4
## BB#3:
	callq	___error
	movl	(%rax), %edi
	callq	_strerror
	movq	%rax, -4200(%rbp)       ## 8-byte Spill
	callq	___error
	leaq	L_.str.2(%rip), %rdi
	movl	(%rax), %edx
	movq	-4200(%rbp), %rsi       ## 8-byte Reload
	movb	$0, %al
	callq	_printf
	xorl	%edi, %edi
	movl	%eax, -4204(%rbp)       ## 4-byte Spill
	callq	_exit
LBB0_4:
	movl	$10, %esi
	movl	-20(%rbp), %edi
	callq	_listen
	cmpl	$-1, %eax
	jne	LBB0_6
## BB#5:
	callq	___error
	movl	(%rax), %edi
	callq	_strerror
	movq	%rax, -4216(%rbp)       ## 8-byte Spill
	callq	___error
	leaq	L_.str.3(%rip), %rdi
	movl	(%rax), %edx
	movq	-4216(%rbp), %rsi       ## 8-byte Reload
	movb	$0, %al
	callq	_printf
	xorl	%edi, %edi
	movl	%eax, -4220(%rbp)       ## 4-byte Spill
	callq	_exit
LBB0_6:
	leaq	L_.str.4(%rip), %rdi
	movb	$0, %al
	callq	_printf
	movl	%eax, -4224(%rbp)       ## 4-byte Spill
LBB0_7:                                 ## =>This Inner Loop Header: Depth=1
	xorl	%eax, %eax
	movl	%eax, %ecx
	movl	-20(%rbp), %edi
	movq	%rcx, %rsi
	movq	%rcx, %rdx
	callq	_accept
	movl	%eax, -24(%rbp)
	cmpl	$-1, %eax
	jne	LBB0_9
## BB#8:                                ##   in Loop: Header=BB0_7 Depth=1
	callq	___error
	movl	(%rax), %edi
	callq	_strerror
	movq	%rax, -4232(%rbp)       ## 8-byte Spill
	callq	___error
	leaq	L_.str.5(%rip), %rdi
	movl	(%rax), %edx
	movq	-4232(%rbp), %rsi       ## 8-byte Reload
	movb	$0, %al
	callq	_printf
	movl	%eax, -4236(%rbp)       ## 4-byte Spill
	jmp	LBB0_7
LBB0_9:                                 ##   in Loop: Header=BB0_7 Depth=1
	movl	$4096, %eax             ## imm = 0x1000
	movl	%eax, %edx
	xorl	%ecx, %ecx
	leaq	-4144(%rbp), %rsi
	movl	-24(%rbp), %edi
	callq	_recv
	leaq	L_.str.6(%rip), %rdi
	leaq	-4144(%rbp), %rsi
	movl	%eax, %ecx
	movl	%ecx, -4148(%rbp)
	movslq	-4148(%rbp), %rax
	movb	$0, -4144(%rbp,%rax)
	movb	$0, %al
	callq	_printf
	movl	-24(%rbp), %edi
	movl	%eax, -4240(%rbp)       ## 4-byte Spill
	movb	$0, %al
	callq	_close
	movl	%eax, -4244(%rbp)       ## 4-byte Spill
	jmp	LBB0_7
	.cfi_endproc

	.section	__TEXT,__cstring,cstring_literals
L_.str:                                 ## @.str
	.asciz	"Hello, World!\n"

L_.str.1:                               ## @.str.1
	.asciz	"create socket error: %s(errno: %d)\n"

L_.str.2:                               ## @.str.2
	.asciz	"bind socket error: %s(errno: %d)\n"

L_.str.3:                               ## @.str.3
	.asciz	"listen socket error: %s(errno: %d)\n"

L_.str.4:                               ## @.str.4
	.asciz	"======waiting for client's request======\n"

L_.str.5:                               ## @.str.5
	.asciz	"accept socket error: %s(errno: %d)"

L_.str.6:                               ## @.str.6
	.asciz	"recv msg from client: %s\n"


.subsections_via_symbols
