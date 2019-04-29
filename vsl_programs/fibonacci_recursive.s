.section .rodata
.intout: .string "%ld "
.strout: .string "%s "
.errout: .string "Wrong number of arguments"
.STR0: .string "Fibonacci number #"
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
	call	_fibonacci_recursive
	jmp	END
ABORT:
	movq	$.errout, %rdi
	call puts
END:
	movq    %rax, %rdi
	call    exit
_fibonacci_recursive:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rdi
	pushq	$0 /* local var no. 0 */
/* function call fibonacci_number */
	movq	-8(%rbp)/*n*/, %rax
	movq	%rax, %rdi
	call 	_fibonacci_number
	movq	%rax, -16(%rbp) /*f*/
	movq	$.STR0, %rsi
	movq	$.strout, %rdi
	call	printf
	movq	-8(%rbp)/*n*/, %rsi
	movq	$.intout, %rdi
	call	printf
	movq	$.STR1, %rsi
	movq	$.strout, %rdi
	call	printf
	movq	-16(%rbp) /*f*/, %rsi
	movq	$.intout, %rdi
	call	printf
	movq	$0x0A, %rdi
	call	putchar
	movq	$0, %rax
	leave
	ret
_fibonacci_number:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rdi
	pushq	$0 /* local var no. 0 */
	movq	$0, %rax
	movq	%rax, -16(%rbp) /*y*/
/*IF STATEMENT*/
	movq	-8(%rbp)/*n*/, %rax
	pushq	%rax
	movq	$2, %rax
/*>*/
	cmpq	%rax, (%rsp)
	popq	%rax
	jg	IFTRUE_0
	movq	$1, %rax
	movq	%rax, -16(%rbp) /*y*/
	jmp	ENDIF_0
IFTRUE_0:
/* function call fibonacci_number */
	movq	-8(%rbp)/*n*/, %rax
	pushq	%rax
	movq	$1, %rax
	subq	%rax, (%rsp)
	popq	%rax
	movq	%rax, %rdi
	call 	_fibonacci_number
	pushq	%rax
/* function call fibonacci_number */
	movq	-8(%rbp)/*n*/, %rax
	pushq	%rax
	movq	$2, %rax
	subq	%rax, (%rsp)
	popq	%rax
	movq	%rax, %rdi
	call 	_fibonacci_number
	addq	%rax, (%rsp)
	popq	%rax
	movq	%rax, -16(%rbp) /*y*/
ENDIF_0:
	movq	-16(%rbp) /*y*/, %rax
	leave
	ret
