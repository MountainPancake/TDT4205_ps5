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
	pushq	%rdi
	pushq   %rbp
	movq    %rsp, %rbp
	pushq	$0 /* Stack padding for 16-byte alignment */
	movq	8(%rbp)/*a*/ , %rsi
	movq	$.intout, %rdi
	call	printf
	movq	$0x0A, %rdi
	call	putchar
	movq	$.STR0, %rsi
	movq	$.strout, %rdi
	call	printf
	movq	$0x0A, %rdi
	call	putchar
	movq	$.STR1, %rsi
	movq	$.strout, %rdi
	call	printf
	movq	$0x0A, %rdi
	call	putchar
	movq	$.STR2, %rsi
	movq	$.strout, %rdi
	call	printf
	movq	$0x0A, %rdi
	call	putchar
	movq	$0, %rax
	leave
	ret