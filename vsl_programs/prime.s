.section .rodata
.intout: .string "%ld "
.strout: .string "%s "
.errout: .string "Wrong number of arguments"
.STR0: .string "is a prime factor"
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
	call	_main
	jmp	END
ABORT:
	movq	$.errout, %rdi
	call puts
END:
	movq    %rax, %rdi
	call    exit
_factor:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rdi
	pushq	$0 /* local var no. 0 */
	pushq	$0 /* local var no. 1 */
	pushq	$0 /* Stack padding for 16-byte alignment */
	pushq	%rdx
	movq	$2, %rax
	pushq	%rax
	movq	-8(%rbp)/*n*/, %rax
	cqo
	idivq	(%rsp)
	popq	%rdx
	popq	%rdx
	movq	%rax, -16(%rbp) /*f*/
	jmp ENDWHILE_0
WHILE_0:
	movq	-16(%rbp) /*f*/, %rax
	pushq	%rax
	movq	$1, %rax
	subq	%rax, (%rsp)
	popq	%rax
	movq	%rax, -16(%rbp) /*f*/
ENDWHILE_0:
	movq	-8(%rbp)/*n*/, %rax
	pushq	%rax
	pushq	%rdx
	pushq	%rdx
	movq	-16(%rbp) /*f*/, %rax
	pushq	%rax
	movq	-8(%rbp)/*n*/, %rax
	cqo
	idivq	(%rsp)
	popq	%rdx
	popq	%rdx
	pushq	%rax
	movq	-16(%rbp) /*f*/, %rax
	mulq	(%rsp)
	popq	%rdx
	popq	%rdx
	subq	%rax, (%rsp)
	popq	%rax
	pushq	%rax
	movq	$0, %rax
/*>*/
	cmpq	%rax, (%rsp)
	popq	%rax
	jg	WHILE_0
/*IF STATEMENT*/
	movq	-16(%rbp) /*f*/, %rax
	pushq	%rax
	movq	$1, %rax
/*>*/
	cmpq	%rax, (%rsp)
	popq	%rax
	jg	IFTRUE_1
	movq	-8(%rbp)/*n*/, %rsi
	movq	$.intout, %rdi
	call	printf
	movq	$.STR0, %rsi
	movq	$.strout, %rdi
	call	printf
	movq	$0x0A, %rdi
	call	putchar
	jmp	ENDIF_1
IFTRUE_1:
/* function call factor */
	movq	-16(%rbp) /*f*/, %rax
	movq	%rax, %rdi
	call 	_factor
	movq	%rax, -24(%rbp) /*r*/
/* function call factor */
	pushq	%rdx
	movq	-16(%rbp) /*f*/, %rax
	pushq	%rax
	movq	-8(%rbp)/*n*/, %rax
	cqo
	idivq	(%rsp)
	popq	%rdx
	popq	%rdx
	movq	%rax, %rdi
	call 	_factor
	movq	%rax, -24(%rbp) /*r*/
ENDIF_1:
	movq	$0, %rax
	leave
	ret
_main:
	pushq	%rbp
	movq	%rsp, %rbp
/* function call factor */
	movq	$1836311903, %rax
	movq	%rax, %rdi
	call 	_factor
	leave
	ret
