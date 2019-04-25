.section .rodata
.intout: .string "%ld "
.strout: .string "%s "
.errout: .string "Wrong number of arguments"
.STR0: .string "Equal!"
.section .data
.globl main
.section .text
main:
	pushq   %rbp
	movq    %rsp, %rbp
	subq	$1,%rdi
	cmpq	$7,%rdi
	jne	ABORT
	cmpq	$0,%rdi
	jz	SKIP_ARGS
	movq	%rdi,%rcx
	addq $56, %rsi
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
	popq	%rdx
	popq	%rcx
	popq	%r8
	popq	%r9
SKIP_ARGS:
	call	_dingdong
	jmp	END
ABORT:
	movq	$.errout, %rdi
	call puts
END:
	movq    %rax, %rdi
	call    exit
_dingdong:
	pushq	%r9
	pushq	%r8
	pushq	%rcx
	pushq	%rdx
	pushq	%rsi
	pushq	%rdi
	pushq   %rbp
	movq    %rsp, %rbp
	pushq $0 /* local var no. 0 */
	movq	$42, %rax
	movq	%rax, -8(%rbp)/*x*/ 
	movq	8(%rbp)/*a*/ , %rsi
	movq	$.intout, %rdi
	call	printf
	movq	16(%rbp)/*b*/ , %rsi
	movq	$.intout, %rdi
	call	printf
	movq	24(%rbp)/*c*/ , %rsi
	movq	$.intout, %rdi
	call	printf
	movq	32(%rbp)/*d*/ , %rsi
	movq	$.intout, %rdi
	call	printf
	movq	40(%rbp)/*e*/ , %rsi
	movq	$.intout, %rdi
	call	printf
	movq	48(%rbp)/*f*/ , %rsi
	movq	$.intout, %rdi
	call	printf
	movq	56(%rbp)/*g*/ , %rsi
	movq	$.intout, %rdi
	call	printf
	movq	$0x0A, %rdi
	call	putchar
	movq	$.STR0, %rsi
	movq	$.strout, %rdi
	call	printf
	movq	$0x0A, %rdi
	call	putchar
	movq	$43, %rax
	movq	%rax, -8(%rbp)/*x*/ 
	movq	$44, %rax
	movq	%rax, -8(%rbp)/*x*/ 
	movq	-8(%rbp)/*x*/ , %rsi
	movq	$.intout, %rdi
	call	printf
	movq	$0x0A, %rdi
	call	putchar
	movq	-8(%rbp)/*x*/ , %rax
	pushq	%rax
	movq	$1, %rax
	subq	%rax, (%rsp)
	popq	%rax
	movq	%rax, -8(%rbp)/*x*/ 
	movq	-8(%rbp)/*x*/ , %rax
	leave
	ret
