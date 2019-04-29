.section .rodata
.intout: .string "%ld "
.strout: .string "%s "
.errout: .string "Wrong number of arguments"
.STR0: .string "Bigger"
.STR1: .string "Smaller"
.STR2: .string "Equal"
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
	call	_test
	jmp	END
ABORT:
	movq	$.errout, %rdi
	call puts
END:
	movq    %rax, %rdi
	call    exit
_test:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rdi
	pushq	$0 /* Stack padding for 16-byte alignment */
	movq	-8(%rbp)/*a*/, %rsi
	movq	$.intout, %rdi
	call	printf
	movq	$0x0A, %rdi
	call	putchar
/*IF STATEMENT*/
	movq	-8(%rbp)/*a*/, %rax
	pushq	%rax
	movq	$10, %rax
/*>*/
	cmpq	%rax, (%rsp)
	popq	%rax
	jg	IFTRUE_0
	jmp	ENDIF_0
IFTRUE_0:
	movq	$.STR0, %rsi
	movq	$.strout, %rdi
	call	printf
	movq	$0x0A, %rdi
	call	putchar
ENDIF_0:
/*IF STATEMENT*/
	movq	-8(%rbp)/*a*/, %rax
	pushq	%rax
	movq	$10, %rax
/*<*/
	cmpq	%rax, (%rsp)
	popq	%rax
	jl	IFTRUE_1
	jmp	ENDIF_1
IFTRUE_1:
	movq	$.STR1, %rsi
	movq	$.strout, %rdi
	call	printf
	movq	$0x0A, %rdi
	call	putchar
ENDIF_1:
/*IF STATEMENT*/
	movq	-8(%rbp)/*a*/, %rax
	pushq	%rax
	movq	$10, %rax
/*=*/
	cmpq	%rax, (%rsp)
	popq	%rax
	jz	IFTRUE_2
	jmp	ENDIF_2
IFTRUE_2:
	movq	$.STR2, %rsi
	movq	$.strout, %rdi
	call	printf
	movq	$0x0A, %rdi
	call	putchar
ENDIF_2:
	movq	$0, %rax
	leave
	ret
