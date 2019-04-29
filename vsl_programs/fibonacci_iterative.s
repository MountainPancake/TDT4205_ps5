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
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rdi
	pushq	$0 /* local var no. 0 */
	pushq	$0 /* local var no. 1 */
	pushq	$0 /* local var no. 2 */
	pushq	$0 /* local var no. 3 */
	pushq	$0 /* Stack padding for 16-byte alignment */
	movq	-8(%rbp)/*n*/, %rax
	movq	%rax, -16(%rbp) /*w*/
	movq	$1, %rax
	movq	%rax, -24(%rbp) /*x*/
	movq	$1, %rax
	movq	%rax, -32(%rbp) /*y*/
	movq	$1, %rax
	movq	%rax, -40(%rbp) /*f*/
/*IF STATEMENT*/
	movq	-16(%rbp) /*w*/, %rax
	pushq	%rax
	movq	$0, %rax
/*>*/
	cmpq	%rax, (%rsp)
	popq	%rax
	jg	IFTRUE_0
	movq	$0, %rax
	movq	%rax, -40(%rbp) /*f*/
	jmp	ENDIF_0
IFTRUE_0:
/*IF STATEMENT*/
	movq	-16(%rbp) /*w*/, %rax
	pushq	%rax
	movq	$1, %rax
/*>*/
	cmpq	%rax, (%rsp)
	popq	%rax
	jg	IFTRUE_1
	jmp	ENDIF_1
IFTRUE_1:
/*IF STATEMENT*/
	movq	-16(%rbp) /*w*/, %rax
	pushq	%rax
	movq	$2, %rax
/*>*/
	cmpq	%rax, (%rsp)
	popq	%rax
	jg	IFTRUE_2
	jmp	ENDIF_2
IFTRUE_2:
	jmp ENDWHILE_3
WHILE_3:
	movq	-32(%rbp) /*y*/, %rax
	pushq	%rax
	movq	-24(%rbp) /*x*/, %rax
	addq	%rax, (%rsp)
	popq	%rax
	movq	%rax, -40(%rbp) /*f*/
	movq	-32(%rbp) /*y*/, %rax
	movq	%rax, -24(%rbp) /*x*/
	movq	-40(%rbp) /*f*/, %rax
	movq	%rax, -32(%rbp) /*y*/
	movq	-16(%rbp) /*w*/, %rax
	pushq	%rax
	movq	$1, %rax
	subq	%rax, (%rsp)
	popq	%rax
	movq	%rax, -16(%rbp) /*w*/
ENDWHILE_3:
	movq	-16(%rbp) /*w*/, %rax
	pushq	%rax
	movq	$3, %rax
/*>*/
	cmpq	%rax, (%rsp)
	popq	%rax
	jg	WHILE_3
ENDIF_2:
ENDIF_1:
ENDIF_0:
	movq	$.STR0, %rsi
	movq	$.strout, %rdi
	call	printf
	movq	-8(%rbp)/*n*/, %rsi
	movq	$.intout, %rdi
	call	printf
	movq	$.STR1, %rsi
	movq	$.strout, %rdi
	call	printf
	movq	-40(%rbp) /*f*/, %rsi
	movq	$.intout, %rdi
	call	printf
	movq	$0x0A, %rdi
	call	putchar
	movq	$0, %rax
	leave
	ret
