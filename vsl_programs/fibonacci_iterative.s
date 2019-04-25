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
	call	_fibonacci_iterative
	jmp	END
ABORT:
	movq	$.errout, %rdi
	call puts
END:
	movq    %rax, %rdi
	call    exit
_fibonacci_iterative:
	pushq	%rdi
	pushq   %rbp
	movq    %rsp, %rbp
	pushq $0 /* local var no. 0 */
	pushq $0 /* local var no. 1 */
	pushq $0 /* local var no. 2 */
	pushq $0 /* local var no. 3 */
	pushq	$0 /* Stack padding for 16-byte alignment */
	movq	8(%rbp)/*n*/ , %rax
	movq	%rax, -8(%rbp)/*w*/ 
	movq	$1, %rax
	movq	%rax, -16(%rbp)/*x*/ 
	movq	$1, %rax
	movq	%rax, -24(%rbp)/*y*/ 
	movq	$1, %rax
	movq	%rax, -32(%rbp)/*f*/ 
	movq	-24(%rbp)/*y*/ , %rax
	pushq	%rax
	movq	-16(%rbp)/*x*/ , %rax
	addq	%rax, (%rsp)
	popq	%rax
	movq	%rax, -32(%rbp)/*f*/ 
	movq	-24(%rbp)/*y*/ , %rax
	movq	%rax, -16(%rbp)/*x*/ 
	movq	-32(%rbp)/*f*/ , %rax
	movq	%rax, -24(%rbp)/*y*/ 
	movq	-8(%rbp)/*w*/ , %rax
	pushq	%rax
	movq	$1, %rax
	subq	%rax, (%rsp)
	popq	%rax
	movq	%rax, -8(%rbp)/*w*/ 
	movq	$0, %rax
	movq	%rax, -32(%rbp)/*f*/ 
	movq	$.STR0, %rsi
	movq	$.strout, %rdi
	call	printf
	movq	8(%rbp)/*n*/ , %rsi
	movq	$.intout, %rdi
	call	printf
	movq	$.STR1, %rsi
	movq	$.strout, %rdi
	call	printf
	movq	-32(%rbp)/*f*/ , %rsi
	movq	$.intout, %rdi
	call	printf
	movq	$0x0A, %rdi
	call	putchar
	movq	$0, %rax
	leave
	ret
