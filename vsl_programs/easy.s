.section .rodata
.intout: .string "%ld "
.strout: .string "%s "
.errout: .string "Wrong number of arguments"
.STR0: .string "Testing plain call/return and expression evaluation"
.STR1: .string "The function returned y:="
.STR2: .string "My parameters are a:="
.STR3: .string "and b:="
.STR4: .string "Their sum is c:="
.STR5: .string "Their difference is c:="
.STR6: .string "Their product is c:="
.STR7: .string "Their ratio is c:="
.STR8: .string "(-c):="
.STR9: .string "The sum of their squares is "
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
	call	_main
	jmp	END
ABORT:
	movq	$.errout, %rdi
	call puts
END:
	movq    %rax, %rdi
	call    exit
_main:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rdi
	pushq	$0 /* local var no. 0 */
	pushq	$0 /* local var no. 1 */
	pushq	$0 /* local var no. 2 */
	movq	$.STR0, %rsi
	movq	$.strout, %rdi
	call	printf
	movq	$0x0A, %rdi
	call	putchar
	movq	$15, %rax
	movq	%rax, -16(%rbp) /*x*/
	movq	$5, %rax
	movq	%rax, -32(%rbp) /*z*/
/* function call test */
	movq	-32(%rbp) /*z*/, %rax
	movq	%rax, %rsi
	movq	-16(%rbp) /*x*/, %rax
	movq	%rax, %rdi
	call 	_test
	movq	%rax, -24(%rbp) /*y*/
	movq	$.STR1, %rsi
	movq	$.strout, %rdi
	call	printf
	movq	-24(%rbp) /*y*/, %rsi
	movq	$.intout, %rdi
	call	printf
	movq	$0x0A, %rdi
	call	putchar
	movq	$0, %rax
	leave
	ret
_test:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rdi
	pushq	%rsi
	pushq	$0 /* local var no. 0 */
	pushq	$0 /* Stack padding for 16-byte alignment */
	movq	$.STR2, %rsi
	movq	$.strout, %rdi
	call	printf
	movq	-8(%rbp)/*a*/, %rsi
	movq	$.intout, %rdi
	call	printf
	movq	$.STR3, %rsi
	movq	$.strout, %rdi
	call	printf
	movq	-16(%rbp)/*b*/, %rsi
	movq	$.intout, %rdi
	call	printf
	movq	$0x0A, %rdi
	call	putchar
	movq	-8(%rbp)/*a*/, %rax
	pushq	%rax
	movq	-16(%rbp)/*b*/, %rax
	addq	%rax, (%rsp)
	popq	%rax
	movq	%rax, -24(%rbp) /*c*/
	movq	$.STR4, %rsi
	movq	$.strout, %rdi
	call	printf
	movq	-24(%rbp) /*c*/, %rsi
	movq	$.intout, %rdi
	call	printf
	movq	$0x0A, %rdi
	call	putchar
	movq	-8(%rbp)/*a*/, %rax
	pushq	%rax
	movq	-16(%rbp)/*b*/, %rax
	subq	%rax, (%rsp)
	popq	%rax
	movq	%rax, -24(%rbp) /*c*/
	movq	$.STR5, %rsi
	movq	$.strout, %rdi
	call	printf
	movq	-24(%rbp) /*c*/, %rsi
	movq	$.intout, %rdi
	call	printf
	movq	$0x0A, %rdi
	call	putchar
	pushq	%rdx
	movq	-16(%rbp)/*b*/, %rax
	pushq	%rax
	movq	-8(%rbp)/*a*/, %rax
	mulq	(%rsp)
	popq	%rdx
	popq	%rdx
	movq	%rax, -24(%rbp) /*c*/
	movq	$.STR6, %rsi
	movq	$.strout, %rdi
	call	printf
	movq	-24(%rbp) /*c*/, %rsi
	movq	$.intout, %rdi
	call	printf
	movq	$0x0A, %rdi
	call	putchar
	pushq	%rdx
	movq	-16(%rbp)/*b*/, %rax
	pushq	%rax
	movq	-8(%rbp)/*a*/, %rax
	cqo
	idivq	(%rsp)
	popq	%rdx
	popq	%rdx
	movq	%rax, -24(%rbp) /*c*/
	movq	$.STR7, %rsi
	movq	$.strout, %rdi
	call	printf
	movq	-24(%rbp) /*c*/, %rsi
	movq	$.intout, %rdi
	call	printf
	movq	$0x0A, %rdi
	call	putchar
	movq	$.STR8, %rsi
	movq	$.strout, %rdi
	call	printf
	movq	-24(%rbp) /*c*/, %rax
	negq	%rax
	movq	%rax, %rsi
	movq	$.intout, %rdi
	call	printf
	movq	$0x0A, %rdi
	call	putchar
	movq	$.STR9, %rsi
	movq	$.strout, %rdi
	call	printf
	pushq	%rdx
	movq	-8(%rbp)/*a*/, %rax
	pushq	%rax
	movq	-8(%rbp)/*a*/, %rax
	mulq	(%rsp)
	popq	%rdx
	popq	%rdx
	pushq	%rax
	pushq	%rdx
	movq	-16(%rbp)/*b*/, %rax
	pushq	%rax
	movq	-16(%rbp)/*b*/, %rax
	mulq	(%rsp)
	popq	%rdx
	popq	%rdx
	addq	%rax, (%rsp)
	popq	%rax
	movq	%rax, %rsi
	movq	$.intout, %rdi
	call	printf
	movq	$0x0A, %rdi
	call	putchar
	movq	-8(%rbp)/*a*/, %rax
	pushq	%rax
	movq	-16(%rbp)/*b*/, %rax
	subq	%rax, (%rsp)
	popq	%rax
	leave
	ret
