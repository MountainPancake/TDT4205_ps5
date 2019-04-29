.section .rodata
.intout: .string "%ld "
.strout: .string "%s "
.errout: .string "Wrong number of arguments"
.STR0: .string "Greatest common divisor of"
.STR1: .string "and"
.STR2: .string "is"
.STR3: .string "and"
.STR4: .string "are relative primes"
.section .data
.globl main
.section .text
main:
	pushq   %rbp
	movq    %rsp, %rbp
	subq	$1,%rdi
	cmpq	$2,%rdi
	jne	ABORT
	cmpq	$0,%rdi
	jz	SKIP_ARGS
	movq	%rdi,%rcx
	addq $16, %rsi
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
SKIP_ARGS:
	call	_euclid
	jmp	END
ABORT:
	movq	$.errout, %rdi
	call puts
END:
	movq    %rax, %rdi
	call    exit
_gcd:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rdi
	pushq	%rsi
	pushq	$0 /* local var no. 0 */
	pushq	$0 /* Stack padding for 16-byte alignment */
/*IF STATEMENT*/
	movq	-16(%rbp)/*b*/, %rax
	pushq	%rax
	movq	$0, %rax
/*>*/
	cmpq	%rax, (%rsp)
	popq	%rax
	jg	IFTRUE_0
	movq	-8(%rbp)/*a*/, %rax
	movq	%rax, -24(%rbp) /*g*/
	jmp	ENDIF_0
IFTRUE_0:
/* function call gcd */
	movq	-8(%rbp)/*a*/, %rax
	pushq	%rax
	pushq	%rdx
	movq	-16(%rbp)/*b*/, %rax
	pushq	%rax
	pushq	%rdx
	movq	-16(%rbp)/*b*/, %rax
	pushq	%rax
	movq	-8(%rbp)/*a*/, %rax
	cqo
	idivq	(%rsp)
	popq	%rdx
	popq	%rdx
	mulq	(%rsp)
	popq	%rdx
	popq	%rdx
	subq	%rax, (%rsp)
	popq	%rax
	movq	%rax, %rsi
	movq	-16(%rbp)/*b*/, %rax
	movq	%rax, %rdi
	call 	_gcd
	movq	%rax, -24(%rbp) /*g*/
ENDIF_0:
	movq	-24(%rbp) /*g*/, %rax
	leave
	ret
_euclid:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rdi
	pushq	%rsi
/*IF STATEMENT*/
	movq	-8(%rbp)/*a*/, %rax
	pushq	%rax
	movq	$0, %rax
/*<*/
	cmpq	%rax, (%rsp)
	popq	%rax
	jl	IFTRUE_1
	jmp	ENDIF_1
IFTRUE_1:
	movq	-8(%rbp)/*a*/, %rax
	negq	%rax
	movq	%rax, -8(%rbp)/*a*/
ENDIF_1:
/*IF STATEMENT*/
	movq	-16(%rbp)/*b*/, %rax
	pushq	%rax
	movq	$0, %rax
/*<*/
	cmpq	%rax, (%rsp)
	popq	%rax
	jl	IFTRUE_2
	jmp	ENDIF_2
IFTRUE_2:
	movq	-16(%rbp)/*b*/, %rax
	negq	%rax
	movq	%rax, -16(%rbp)/*b*/
ENDIF_2:
/*IF STATEMENT*/
/* function call gcd */
	movq	-16(%rbp)/*b*/, %rax
	movq	%rax, %rsi
	movq	-8(%rbp)/*a*/, %rax
	movq	%rax, %rdi
	call 	_gcd
	pushq	%rax
	movq	$1, %rax
/*>*/
	cmpq	%rax, (%rsp)
	popq	%rax
	jg	IFTRUE_3
	movq	-8(%rbp)/*a*/, %rsi
	movq	$.intout, %rdi
	call	printf
	movq	$.STR3, %rsi
	movq	$.strout, %rdi
	call	printf
	movq	-16(%rbp)/*b*/, %rsi
	movq	$.intout, %rdi
	call	printf
	movq	$.STR4, %rsi
	movq	$.strout, %rdi
	call	printf
	movq	$0x0A, %rdi
	call	putchar
	jmp	ENDIF_3
IFTRUE_3:
	movq	$.STR0, %rsi
	movq	$.strout, %rdi
	call	printf
	movq	-8(%rbp)/*a*/, %rsi
	movq	$.intout, %rdi
	call	printf
	movq	$.STR1, %rsi
	movq	$.strout, %rdi
	call	printf
	movq	-16(%rbp)/*b*/, %rsi
	movq	$.intout, %rdi
	call	printf
	movq	$.STR2, %rsi
	movq	$.strout, %rdi
	call	printf
/* function call gcd */
	movq	-16(%rbp)/*b*/, %rax
	movq	%rax, %rsi
	movq	-8(%rbp)/*a*/, %rax
	movq	%rax, %rdi
	call 	_gcd
	movq	%rax, %rsi
	movq	$.intout, %rdi
	call	printf
	movq	$0x0A, %rdi
	call	putchar
ENDIF_3:
	movq	$0, %rax
	leave
	ret
