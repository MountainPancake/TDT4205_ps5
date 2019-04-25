.section .rodata
.intout: .string "%ld "
.strout: .string "%s "
.errout: .string "Wrong number of arguments"
.STR0: .string "foobar"
.STR1: .string "Skip..."
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
	call	_while_test
	jmp	END
ABORT:
	movq	$.errout, %rdi
	call puts
END:
	movq    %rax, %rdi
	call    exit
_while_test:
	pushq   %rbp
	movq    %rsp, %rbp
	pushq $0 /* local var no. 0 */
	pushq	$0 /* Stack padding for 16-byte alignment */
	movq	$20, %rax
	movq	%rax, -8(%rbp)/*a*/ 
	movq	-8(%rbp)/*a*/ , %rsi
	movq	$.intout, %rdi
	call	printf
	movq	$0x0A, %rdi
	call	putchar
	movq	$.STR0, %rsi
	movq	$.strout, %rdi
	call	printf
	movq	$0x0A, %rdi
	call	putchar
	movq	-8(%rbp)/*a*/ , %rax
	pushq	%rax
	movq	$1, %rax
	subq	%rax, (%rsp)
	popq	%rax
	movq	%rax, -8(%rbp)/*a*/ 
	movq	$.STR1, %rsi
	movq	$.strout, %rdi
	call	printf
	movq	$0x0A, %rdi
	call	putchar
	movq	-8(%rbp)/*a*/ , %rax
	pushq	%rax
	movq	$1, %rax
	subq	%rax, (%rsp)
	popq	%rax
	movq	%rax, -8(%rbp)/*a*/ 
	movq	-8(%rbp)/*a*/ , %rsi
	movq	$.intout, %rdi
	call	printf
	movq	$0x0A, %rdi
	call	putchar
	movq	$0, %rax
	leave
	ret
