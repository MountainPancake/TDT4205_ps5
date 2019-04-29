.section .rodata
.intout: .string "%ld "
.strout: .string "%s "
.errout: .string "Wrong number of arguments"
.STR0: .string "Parameter a is a:="
.STR1: .string "Outer scope has a:="
.STR2: .string "Inner scope has a:="
.STR3: .string "and b:="
.STR4: .string "b was updated to "
.STR5: .string "in inner scope"
.STR6: .string "Outer scope (still) has a:="
.STR7: .string "Return expression (a-1) using a:="
.STR8: .string "Nested scopes coming up..."
.STR9: .string "x:="
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
	call	_start
	jmp	END
ABORT:
	movq	$.errout, %rdi
	call puts
END:
	movq    %rax, %rdi
	call    exit
_test_me:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rdi
	pushq	$0 /* local var no. 0 */
	pushq	$0 /* local var no. 1 */
	pushq	$0 /* local var no. 2 */
	movq	$.STR0, %rsi
	movq	$.strout, %rdi
	call	printf
	movq	-8(%rbp)/*a*/, %rsi
	movq	$.intout, %rdi
	call	printf
	movq	$0x0A, %rdi
	call	putchar
	movq	$2, %rax
	movq	%rax, -16(%rbp) /*a*/
	movq	$.STR1, %rsi
	movq	$.strout, %rdi
	call	printf
	movq	-16(%rbp) /*a*/, %rsi
	movq	$.intout, %rdi
	call	printf
	movq	$0x0A, %rdi
	call	putchar
	movq	$3, %rax
	movq	%rax, -32(%rbp) /*a*/
	movq	$4, %rax
	movq	%rax, -24(%rbp) /*b*/
	movq	$.STR2, %rsi
	movq	$.strout, %rdi
	call	printf
	movq	-32(%rbp) /*a*/, %rsi
	movq	$.intout, %rdi
	call	printf
	movq	$.STR3, %rsi
	movq	$.strout, %rdi
	call	printf
	movq	-24(%rbp) /*b*/, %rsi
	movq	$.intout, %rdi
	call	printf
	movq	$0x0A, %rdi
	call	putchar
	movq	$5, %rax
	movq	%rax, -24(%rbp) /*b*/
	movq	$.STR4, %rsi
	movq	$.strout, %rdi
	call	printf
	movq	-24(%rbp) /*b*/, %rsi
	movq	$.intout, %rdi
	call	printf
	movq	$.STR5, %rsi
	movq	$.strout, %rdi
	call	printf
	movq	$0x0A, %rdi
	call	putchar
	movq	$.STR6, %rsi
	movq	$.strout, %rdi
	call	printf
	movq	-16(%rbp) /*a*/, %rsi
	movq	$.intout, %rdi
	call	printf
	movq	$0x0A, %rdi
	call	putchar
	movq	$.STR7, %rsi
	movq	$.strout, %rdi
	call	printf
	movq	-8(%rbp)/*a*/, %rsi
	movq	$.intout, %rdi
	call	printf
	movq	$0x0A, %rdi
	call	putchar
	movq	-8(%rbp)/*a*/, %rax
	pushq	%rax
	movq	$1, %rax
	subq	%rax, (%rsp)
	popq	%rax
	leave
	ret
_start:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	$0 /* local var no. 0 */
	pushq	$0 /* Stack padding for 16-byte alignment */
	movq	$.STR8, %rsi
	movq	$.strout, %rdi
	call	printf
	movq	$0x0A, %rdi
	call	putchar
/* function call test_me */
	movq	$1, %rax
	movq	%rax, %rdi
	call 	_test_me
	movq	%rax, -8(%rbp) /*x*/
	movq	$.STR9, %rsi
	movq	$.strout, %rdi
	call	printf
	movq	-8(%rbp) /*x*/, %rsi
	movq	$.intout, %rdi
	call	printf
	movq	$0x0A, %rdi
	call	putchar
	movq	$0, %rax
	leave
	ret
