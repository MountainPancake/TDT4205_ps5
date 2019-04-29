.section .rodata
.intout: .string "%ld "
.strout: .string "%s "
.errout: .string "Wrong number of arguments"
.STR0: .string "The square root of"
.STR1: .string "is"
.section .data
.globl main
.section .text
main:
	pushq   %rbp
	movq    %rsp, %rbp
	subq	$1,%rdi
	cmpq	$1,%rdi
	jne	ABORT
	cmpq	$0,%rdi
	jz	SKIP_ARGS
	movq	%rdi,%rcx
	addq $8, %rsi
PARSE_ARGV:
	pushq %rcx
	pushq %rsi
	movq	(%rsi),%rdi
	movq	$0,%rsi
	movq	$10,%rdx
	call	strtol
	popq %rsi
	popq %rcx
	pushq %rax
	subq $8, %rsi
	loop PARSE_ARGV
	popq	%rdi
SKIP_ARGS:
	call	_newton
	jmp	END
ABORT:
	movq	$.errout, %rdi
	call puts
END:
	movq    %rax, %rdi
	call    exit
_newton:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rdi
	pushq	$0 /* Stack padding for 16-byte alignment */
	movq	$.STR0, %rsi
	movq	$.strout, %rdi
	call	printf
	movq	-8(%rbp)/*n*/, %rsi
	movq	$.intout, %rdi
	call	printf
	movq	$.STR1, %rsi
	movq	$.strout, %rdi
	call	printf
/* function call improve */
	movq	$1, %rax
	movq	%rax, %rsi
	movq	-8(%rbp)/*n*/, %rax
	movq	%rax, %rdi
	call 	_improve
	movq	%rax, %rsi
	movq	$.intout, %rdi
	call	printf
	movq	$0x0A, %rdi
	call	putchar
	movq	$0, %rax
	leave
	ret
_improve:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rdi
	pushq	%rsi
	pushq	$0 /* local var no. 0 */
	pushq	$0 /* Stack padding for 16-byte alignment */
	movq	-16(%rbp)/*estimate*/, %rax
	pushq	%rax
	pushq	%rdx
	pushq	%rdx
	movq	-16(%rbp)/*estimate*/, %rax
	pushq	%rax
	movq	$2, %rax
	mulq	(%rsp)
	popq	%rdx
	popq	%rdx
	pushq	%rax
	pushq	%rdx
	movq	-16(%rbp)/*estimate*/, %rax
	pushq	%rax
	movq	-16(%rbp)/*estimate*/, %rax
	mulq	(%rsp)
	popq	%rdx
	popq	%rdx
	pushq	%rax
	movq	-8(%rbp)/*n*/, %rax
	subq	%rax, (%rsp)
	popq	%rax
	cqo
	idivq	(%rsp)
	popq	%rdx
	popq	%rdx
	subq	%rax, (%rsp)
	popq	%rax
	movq	%rax, -24(%rbp) /*next*/
/*IF STATEMENT*/
	movq	-24(%rbp) /*next*/, %rax
	pushq	%rax
	movq	-16(%rbp)/*estimate*/, %rax
	subq	%rax, (%rsp)
	popq	%rax
	pushq	%rax
	movq	$0, %rax
/*=*/
	cmpq	%rax, (%rsp)
	popq	%rax
	jz	IFTRUE_0
/* function call improve */
	movq	-24(%rbp) /*next*/, %rax
	movq	%rax, %rsi
	movq	-8(%rbp)/*n*/, %rax
	movq	%rax, %rdi
	call 	_improve
	leave
	ret
	jmp	ENDIF_0
IFTRUE_0:
	movq	-24(%rbp) /*next*/, %rax
	pushq	%rax
	movq	$1, %rax
	subq	%rax, (%rsp)
	popq	%rax
	leave
	ret
ENDIF_0:
