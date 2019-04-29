.section .rodata
.intout: .string "%ld "
.strout: .string "%s "
.errout: .string "Wrong number of arguments"
.STR0: .string "Parameter s is"
.STR1: .string "Parameter t is"
.STR2: .string "The sum of their squares is"
.STR3: .string "Calling my_function with parameters"
.STR4: .string "The returned result is"
.STR5: .string "The other returned result is"
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
	call	_funcall
	jmp	END
ABORT:
	movq	$.errout, %rdi
	call puts
END:
	movq    %rax, %rdi
	call    exit
_my_function:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rdi
	pushq	%rsi
	pushq	$0 /* local var no. 0 */
	pushq	$0 /* Stack padding for 16-byte alignment */
	pushq	%rdx
	movq	-8(%rbp)/*s*/, %rax
	pushq	%rax
	movq	-8(%rbp)/*s*/, %rax
	mulq	(%rsp)
	popq	%rdx
	popq	%rdx
	pushq	%rax
	pushq	%rdx
	movq	-16(%rbp)/*t*/, %rax
	pushq	%rax
	movq	-16(%rbp)/*t*/, %rax
	mulq	(%rsp)
	popq	%rdx
	popq	%rdx
	addq	%rax, (%rsp)
	popq	%rax
	movq	%rax, -24(%rbp) /*u*/
	movq	$.STR0, %rsi
	movq	$.strout, %rdi
	call	printf
	movq	-8(%rbp)/*s*/, %rsi
	movq	$.intout, %rdi
	call	printf
	movq	$0x0A, %rdi
	call	putchar
	movq	$.STR1, %rsi
	movq	$.strout, %rdi
	call	printf
	movq	-16(%rbp)/*t*/, %rsi
	movq	$.intout, %rdi
	call	printf
	movq	$0x0A, %rdi
	call	putchar
	movq	$.STR2, %rsi
	movq	$.strout, %rdi
	call	printf
	movq	-24(%rbp) /*u*/, %rsi
	movq	$.intout, %rdi
	call	printf
	movq	$0x0A, %rdi
	call	putchar
	movq	-24(%rbp) /*u*/, %rax
	leave
	ret
_funcall:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	$0 /* local var no. 0 */
	pushq	$0 /* local var no. 1 */
	pushq	$0 /* local var no. 2 */
	pushq	$0 /* Stack padding for 16-byte alignment */
	movq	$5, %rax
	movq	%rax, -8(%rbp) /*x*/
	movq	$10, %rax
	movq	%rax, -16(%rbp) /*y*/
	movq	$.STR3, %rsi
	movq	$.strout, %rdi
	call	printf
	movq	-8(%rbp) /*x*/, %rsi
	movq	$.intout, %rdi
	call	printf
	movq	-16(%rbp) /*y*/, %rsi
	movq	$.intout, %rdi
	call	printf
	movq	$0x0A, %rdi
	call	putchar
/* function call my_function */
	movq	-16(%rbp) /*y*/, %rax
	movq	%rax, %rsi
	movq	-8(%rbp) /*x*/, %rax
	movq	%rax, %rdi
	call 	_my_function
	movq	%rax, -24(%rbp) /*z*/
	movq	$.STR4, %rsi
	movq	$.strout, %rdi
	call	printf
	movq	-24(%rbp) /*z*/, %rsi
	movq	$.intout, %rdi
	call	printf
	movq	$0x0A, %rdi
	call	putchar
/* function call my_other_function */
	call 	_my_other_function
	movq	%rax, -24(%rbp) /*z*/
	movq	$.STR5, %rsi
	movq	$.strout, %rdi
	call	printf
	movq	-24(%rbp) /*z*/, %rsi
	movq	$.intout, %rdi
	call	printf
	movq	$0x0A, %rdi
	call	putchar
	movq	$0, %rax
	leave
	ret
_my_other_function:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	$0 /* local var no. 0 */
	pushq	$0 /* Stack padding for 16-byte alignment */
	movq	$42, %rax
	movq	%rax, -8(%rbp) /*x*/
	movq	-8(%rbp) /*x*/, %rax
	leave
	ret
