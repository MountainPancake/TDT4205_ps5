.section .rodata
.intout: .string "%ld "
.strout: .string "%s "
.errout: .string "Wrong number of arguments"
.STR0: .string "Parameter s is"
.STR1: .string "t is "
.section .data
.globl main
.section .text
main:
	pushq   %rbp
	movq    %rsp, %rbp
	subq	$1,%rdi
	cmpq	$0,%rdi
	jne	ABORT
	cmpq	$0,%rdi
	jz	SKIP_ARGS
	movq	%rdi,%rcx
	addq $0, %rsi
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
SKIP_ARGS:
	call	_funcall
	jmp	END
ABORT:
	movq	$.errout, %rdi
	call puts
END:
	movq    %rax, %rdi
	call    exit
_my_function:
	pushq	%rsi
	pushq	%rdi
	pushq   %rbp
	movq    %rsp, %rbp
	movq	$.STR0, %rsi
	movq	$.strout, %rdi
	call	printf
	movq	8(%rbp)/*s*/ , %rsi
	movq	$.intout, %rdi
	call	printf
	movq	$.STR1, %rsi
	movq	$.strout, %rdi
	call	printf
	movq	16(%rbp)/*t*/ , %rsi
	movq	$.intout, %rdi
	call	printf
	movq	$0x0A, %rdi
	call	putchar
	movq	$0, %rax
	leave
	ret
_funcall:
	pushq   %rbp
	movq    %rsp, %rbp
	pushq $0 /* local var no. 0 */
	pushq	$0 /* Stack padding for 16-byte alignment */
/* function call my_function */
	movq	$10, %rax
	movq 	%rax, %rsi
	movq	$5, %rax
	movq 	%rax, %rdi
	call 	_my_function
	movq	%rax, -8(%rbp)/*x*/ 
	movq	$0, %rax
	leave
	ret
