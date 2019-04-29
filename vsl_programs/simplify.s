.section .rodata
.intout: .string "%ld "
.strout: .string "%s "
.errout: .string "Wrong number of arguments"
.STR0: .string "a="
.section .data
._a: .zero 8
._d: .zero 8
._c: .zero 8
._b: .zero 8
.globl main
.section .text
main:
	pushq   %rbp
	movq    %rsp, %rbp
	subq	$1,%rdi
	cmpq	$2,%rdi
	jne	ABORT
	cmpq	$0,%rdi
	jz	SKIP_ARGS
	movq	%rdi,%rcx
	addq $16, %rsi
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
	popq	%rsi
SKIP_ARGS:
	call	_simplify
	jmp	END
ABORT:
	movq	$.errout, %rdi
	call puts
END:
	movq    %rax, %rdi
	call    exit
_simplify:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rdi
	pushq	%rsi
	movq	$-29, %rax
	movq	%rax, ._a
	movq	$.STR0, %rsi
	movq	$.strout, %rdi
	call	printf
	movq	._a, %rsi
	movq	$.intout, %rdi
	call	printf
	movq	$0x0A, %rdi
	call	putchar
/*IF STATEMENT*/
	movq	._a, %rax
	pushq	%rax
	movq	$0, %rax
/*=*/
	cmpq	%rax, (%rsp)
	popq	%rax
	jz	IFTRUE_0
	jmp	ENDIF_0
IFTRUE_0:
/* function call simplify */
	movq	._d, %rax
	movq	%rax, %rsi
	movq	._c, %rax
	movq	%rax, %rdi
	call 	_simplify
	movq	%rax, ._b
ENDIF_0:
	movq	$0, %rax
	leave
	ret
