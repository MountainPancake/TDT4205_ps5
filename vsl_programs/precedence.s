.section .rodata
.intout: .string "%ld "
.strout: .string "%s "
.errout: .string "Wrong number of arguments"
.STR0: .string "2*(3-1) := "
.STR1: .string "2*3-1 := "
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
	call	_precedence
	jmp	END
ABORT:
	movq	$.errout, %rdi
	call puts
END:
	movq    %rax, %rdi
	call    exit
_precedence:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	$0 /* local var no. 0 */
	pushq	$0 /* local var no. 1 */
	pushq	$0 /* local var no. 2 */
	pushq	$0 /* local var no. 3 */
	movq	$2, %rax
	movq	%rax, -8(%rbp) /*a*/
	movq	$3, %rax
	movq	%rax, -16(%rbp) /*b*/
	movq	$1, %rax
	movq	%rax, -24(%rbp) /*c*/
	pushq	%rdx
	movq	-16(%rbp) /*b*/, %rax
	pushq	%rax
	movq	-24(%rbp) /*c*/, %rax
	subq	%rax, (%rsp)
	popq	%rax
	pushq	%rax
	movq	-8(%rbp) /*a*/, %rax
	mulq	(%rsp)
	popq	%rdx
	popq	%rdx
	movq	%rax, -32(%rbp) /*d*/
	movq	$.STR0, %rsi
	movq	$.strout, %rdi
	call	printf
	movq	-32(%rbp) /*d*/, %rsi
	movq	$.intout, %rdi
	call	printf
	movq	$0x0A, %rdi
	call	putchar
	pushq	%rdx
	movq	-16(%rbp) /*b*/, %rax
	pushq	%rax
	movq	-8(%rbp) /*a*/, %rax
	mulq	(%rsp)
	popq	%rdx
	popq	%rdx
	pushq	%rax
	movq	-24(%rbp) /*c*/, %rax
	subq	%rax, (%rsp)
	popq	%rax
	movq	%rax, -32(%rbp) /*d*/
	movq	$.STR1, %rsi
	movq	$.strout, %rdi
	call	printf
	movq	-32(%rbp) /*d*/, %rsi
	movq	$.intout, %rdi
	call	printf
	movq	$0x0A, %rdi
	call	putchar
	movq	$0, %rax
	leave
	ret
