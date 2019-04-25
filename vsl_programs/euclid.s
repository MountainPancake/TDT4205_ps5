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
	pushq	%rsi
	pushq	%rdi
	pushq   %rbp
	movq    %rsp, %rbp
	pushq $0 /* local var no. 0 */
	pushq	$0 /* Stack padding for 16-byte alignment */
/* function call gcd */
	movq	8(%rbp)/*a*/ , %rax
	pushq	%rax
	pushq	%rdx
	movq	16(%rbp)/*b*/ , %rax
	pushq	%rax
	pushq	%rdx
	movq	16(%rbp)/*b*/ , %rax
	pushq	%rax
	movq	8(%rbp)/*a*/ , %rax
	cqo
	idivq	(%rsp)
	popq	%rdx
	popq	%rdx
	mulq	(%rsp)
	popq	%rdx
	popq	%rdx
	subq	%rax, (%rsp)
	popq	%rax
	movq 	%rax, %rsi
	movq	16(%rbp)/*b*/ , %rax
	movq 	%rax, %rdi
	call 	_gcd
	movq	%rax, -8(%rbp)/*g*/ 
	movq	8(%rbp)/*a*/ , %rax
	movq	%rax, -8(%rbp)/*g*/ 
	movq	-8(%rbp)/*g*/ , %rax
	leave
	ret
_euclid:
	pushq	%rsi
	pushq	%rdi
	pushq   %rbp
	movq    %rsp, %rbp
	movq	8(%rbp)/*a*/ , %rax
	negq	%rax
	movq	%rax, 8(%rbp)/*a*/ 
	movq	16(%rbp)/*b*/ , %rax
	negq	%rax
	movq	%rax, 16(%rbp)/*b*/ 
	movq	$.STR0, %rsi
	movq	$.strout, %rdi
	call	printf
	movq	8(%rbp)/*a*/ , %rsi
	movq	$.intout, %rdi
	call	printf
	movq	$.STR1, %rsi
	movq	$.strout, %rdi
	call	printf
	movq	16(%rbp)/*b*/ , %rsi
	movq	$.intout, %rdi
	call	printf
	movq	$.STR2, %rsi
	movq	$.strout, %rdi
	call	printf
/* function call gcd */
	movq	16(%rbp)/*b*/ , %rax
	movq 	%rax, %rsi
	movq	8(%rbp)/*a*/ , %rax
	movq 	%rax, %rdi
	call 	_gcd
	movq	%rax, %rsi
	movq	$.intout, %rdi
	call	printf
	movq	$0x0A, %rdi
	call	putchar
	movq	8(%rbp)/*a*/ , %rsi
	movq	$.intout, %rdi
	call	printf
	movq	$.STR3, %rsi
	movq	$.strout, %rdi
	call	printf
	movq	16(%rbp)/*b*/ , %rsi
	movq	$.intout, %rdi
	call	printf
	movq	$.STR4, %rsi
	movq	$.strout, %rdi
	call	printf
	movq	$0x0A, %rdi
	call	putchar
	movq	$0, %rax
	leave
	ret
