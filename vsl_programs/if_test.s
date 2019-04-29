.section .rodata
.intout: .string "%ld "
.strout: .string "%s "
.errout: .string "Wrong number of arguments"
.STR0: .string "A equals 10"
.STR1: .string "B is greater than -15"
.STR2: .string "B is smaller than or equal to -15"
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
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	$0 /* local var no. 0 */
	pushq	$0 /* local var no. 1 */
	movq	$10, %rax
	movq	%rax, -8(%rbp) /*a*/
	movq	$-15, %rax
	movq	%rax, -16(%rbp) /*b*/
	movq	-8(%rbp) /*a*/, %rsi
	movq	$.intout, %rdi
	call	printf
	movq	$0x0A, %rdi
	call	putchar
/*IF STATEMENT*/
	movq	-8(%rbp) /*a*/, %rax
	pushq	%rax
	movq	$10, %rax
/*=*/
	cmpq	%rax, (%rsp)
	popq	%rax
	jz	IFTRUE_0
	jmp	ENDIF_0
IFTRUE_0:
	movq	$.STR0, %rsi
	movq	$.strout, %rdi
	call	printf
	movq	$0x0A, %rdi
	call	putchar
ENDIF_0:
/*IF STATEMENT*/
	movq	-8(%rbp) /*a*/, %rax
	pushq	%rax
	movq	$0, %rax
/*>*/
	cmpq	%rax, (%rsp)
	popq	%rax
	jg	IFTRUE_1
	jmp	ENDIF_1
IFTRUE_1:
/*IF STATEMENT*/
	movq	-16(%rbp) /*b*/, %rax
	pushq	%rax
	movq	$-15, %rax
/*>*/
	cmpq	%rax, (%rsp)
	popq	%rax
	jg	IFTRUE_2
	movq	$.STR2, %rsi
	movq	$.strout, %rdi
	call	printf
	movq	$0x0A, %rdi
	call	putchar
	jmp	ENDIF_2
IFTRUE_2:
	movq	$.STR1, %rsi
	movq	$.strout, %rdi
	call	printf
	movq	$0x0A, %rdi
	call	putchar
ENDIF_2:
ENDIF_1:
	movq	$0, %rax
	leave
	ret
