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
	pushq	%rsi
	pushq	%rdi
	pushq   %rbp
	movq    %rsp, %rbp
	movq	$-29, %rax
	movq	%rax, ._a/*a*/ 
	movq	$.STR0, %rsi
	movq	$.strout, %rdi
	call	printf
	movq	._a/*a*/ , %rsi
	movq	$.intout, %rdi
	call	printf
	movq	$0x0A, %rdi
	call	putchar
/* function call simplify */
	movq	._d/*d*/ , %rax
	movq 	%rax, %rsi
	movq	._c/*c*/ , %rax
	movq 	%rax, %rdi
	call 	_simplify
	movq	%rax, ._b/*b*/ 
	movq	$0, %rax
	leave
	ret
