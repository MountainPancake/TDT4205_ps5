.section .rodata
.intout: .string "%ld "
.strout: .string "%s "
.errout: .string "Wrong number of arguments"
.STR0: .string "Hello, world!"
.STR1: .string "x:="
.STR2: .string "Outer scope has a:="
.STR3: .string "I have a:="
.STR4: .string "and b:="
.STR5: .string "B was reassigned to "
.STR6: .string "in inner"
.STR7: .string "Outer scope has a:="
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
	call	_hello
	jmp	END
ABORT:
	movq	$.errout, %rdi
	call puts
END:
	movq    %rax, %rdi
	call    exit
_hello:
	pushq   %rbp
	movq    %rsp, %rbp
	pushq $0 /* local var no. 0 */
	pushq	$0 /* Stack padding for 16-byte alignment */
	movq	$.STR0, %rsi
	movq	$.strout, %rdi
	call	printf
	movq	$0x0A, %rdi
	call	putchar
/* function call test_me */
	movq	$42, %rax
	movq 	%rax, %rdi
	call 	_test_me
	movq	%rax, -8(%rbp)/*x*/ 
	movq	$.STR1, %rsi
	movq	$.strout, %rdi
	call	printf
	movq	-8(%rbp)/*x*/ , %rsi
	movq	$.intout, %rdi
	call	printf
	movq	$0x0A, %rdi
	call	putchar
	movq	$0, %rax
	leave
	ret
_test_me:
	pushq	%rdi
	pushq   %rbp
	movq    %rsp, %rbp
	pushq $0 /* local var no. 0 */
	pushq $0 /* local var no. 1 */
	pushq $0 /* local var no. 2 */
	movq	$32, %rax
	movq	%rax, -8(%rbp)/*a*/ 
	movq	$.STR2, %rsi
	movq	$.strout, %rdi
	call	printf
	movq	-8(%rbp)/*a*/ , %rsi
	movq	$.intout, %rdi
	call	printf
	movq	$0x0A, %rdi
	call	putchar
	movq	$64, %rax
	movq	%rax, -24(%rbp)/*a*/ 
	movq	$27, %rax
	movq	%rax, -16(%rbp)/*b*/ 
	movq	$.STR3, %rsi
	movq	$.strout, %rdi
	call	printf
	movq	-24(%rbp)/*a*/ , %rsi
	movq	$.intout, %rdi
	call	printf
	movq	$.STR4, %rsi
	movq	$.strout, %rdi
	call	printf
	movq	-16(%rbp)/*b*/ , %rsi
	movq	$.intout, %rdi
	call	printf
	movq	$0x0A, %rdi
	call	putchar
	movq	$128, %rax
	movq	%rax, -16(%rbp)/*b*/ 
	movq	$.STR5, %rsi
	movq	$.strout, %rdi
	call	printf
	movq	-16(%rbp)/*b*/ , %rsi
	movq	$.intout, %rdi
	call	printf
	movq	$.STR6, %rsi
	movq	$.strout, %rdi
	call	printf
	movq	$0x0A, %rdi
	call	putchar
	movq	$.STR7, %rsi
	movq	$.strout, %rdi
	call	printf
	movq	-8(%rbp)/*a*/ , %rsi
	movq	$.intout, %rdi
	call	printf
	movq	$0x0A, %rdi
	call	putchar
	movq	8(%rbp)/*a*/ , %rax
	pushq	%rax
	movq	$1, %rax
	addq	%rax, (%rsp)
	popq	%rax
	leave
	ret
