.section .rodata
.intout: .string "%ld "
.strout: .string "%s "
.errout: .string "Wrong number of arguments"
.STR0: .string "a is"
.STR1: .string "and b is"
.STR2: .string "a/(-b) is"
.STR3: .string "10/(-2) is"
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
	call	_negatives
	jmp	END
ABORT:
	movq	$.errout, %rdi
	call puts
END:
	movq    %rax, %rdi
	call    exit
_negatives:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	$0 /* local var no. 0 */
	pushq	$0 /* local var no. 1 */
	movq	$100, %rax
	movq	%rax, -8(%rbp) /*a*/
	movq	$20, %rax
	movq	%rax, -16(%rbp) /*b*/
	movq	$.STR0, %rsi
	movq	$.strout, %rdi
	call	printf
	movq	-8(%rbp) /*a*/, %rsi
	movq	$.intout, %rdi
	call	printf
	movq	$.STR1, %rsi
	movq	$.strout, %rdi
	call	printf
	movq	-16(%rbp) /*b*/, %rsi
	movq	$.intout, %rdi
	call	printf
	movq	$0x0A, %rdi
	call	putchar
	movq	$.STR2, %rsi
	movq	$.strout, %rdi
	call	printf
	pushq	%rdx
	movq	-16(%rbp) /*b*/, %rax
	negq	%rax
	pushq	%rax
	movq	-8(%rbp) /*a*/, %rax
	cqo
	idivq	(%rsp)
	popq	%rdx
	popq	%rdx
	movq	%rax, %rsi
	movq	$.intout, %rdi
	call	printf
	movq	$0x0A, %rdi
	call	putchar
	movq	$.STR3, %rsi
	movq	$.strout, %rdi
	call	printf
	movq	$-5, %rsi
	movq	$.intout, %rdi
	call	printf
	movq	$0x0A, %rdi
	call	putchar
	movq	$0, %rax
	leave
	ret
