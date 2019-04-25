.section .rodata
.intout: .string "%ld "
.strout: .string "%s "
.errout: .string "Wrong number of arguments"
.STR0: .string "Morna"
.section .data
._x: .zero 8
._z: .zero 8
._w: .zero 8
._y: .zero 8
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
/* function call goodbye */
	movq	$8, %rax
	pushq 	%rax
	movq	$7, %rax
	pushq 	%rax
	movq	$6, %rax
	movq 	%rax, %r9
	movq	$5, %rax
	movq 	%rax, %r8
	movq	$4, %rax
	movq 	%rax, %rcx
	movq	$3, %rax
	movq 	%rax, %rdx
	movq	$2, %rax
	movq 	%rax, %rsi
	movq	$1, %rax
	movq 	%rax, %rdi
	call 	_goodbye
	movq	%rax, ._w/*w*/ 
	movq	._w/*w*/ , %rsi
	movq	$.intout, %rdi
	call	printf
	movq	$0x0A, %rdi
	call	putchar
	movq	._w/*w*/ , %rax
	leave
	ret
_goodbye:
	pushq	%r9
	pushq	%r8
	pushq	%rcx
	pushq	%rdx
	pushq	%rsi
	pushq	%rdi
	pushq   %rbp
	movq    %rsp, %rbp
	movq	8(%rbp)/*a*/ , %rsi
	movq	$.intout, %rdi
	call	printf
	movq	16(%rbp)/*b*/ , %rsi
	movq	$.intout, %rdi
	call	printf
	movq	24(%rbp)/*c*/ , %rsi
	movq	$.intout, %rdi
	call	printf
	movq	32(%rbp)/*d*/ , %rsi
	movq	$.intout, %rdi
	call	printf
	movq	40(%rbp)/*e*/ , %rsi
	movq	$.intout, %rdi
	call	printf
	movq	48(%rbp)/*f*/ , %rsi
	movq	$.intout, %rdi
	call	printf
	movq	56(%rbp)/*g*/ , %rsi
	movq	$.intout, %rdi
	call	printf
	movq	64(%rbp)/*h*/ , %rsi
	movq	$.intout, %rdi
	call	printf
	movq	$0x0A, %rdi
	call	putchar
	movq	$.STR0, %rsi
	movq	$.strout, %rdi
	call	printf
	movq	$0x0A, %rdi
	call	putchar
/* function call tralala */
	movq	$1, %rax
	movq 	%rax, %rdi
	call 	_tralala
	leave
	ret
_tralala:
	pushq	%rdi
	pushq   %rbp
	movq    %rsp, %rbp
	pushq $0 /* local var no. 0 */
	pushq $0 /* local var no. 1 */
	pushq $0 /* local var no. 2 */
	pushq $0 /* local var no. 3 */
	pushq	$0 /* Stack padding for 16-byte alignment */
	movq	$3, %rax
	movq	%rax, -8(%rbp)/*x*/ 
	movq	$5, %rax
	movq	%rax, -16(%rbp)/*y*/ 
	movq	$2, %rax
	movq	%rax, -24(%rbp)/*z*/ 
	movq	$4, %rax
	movq	%rax, -32(%rbp)/*w*/ 
	movq	$42, %rax
	movq	%rax, 8(%rbp)/*wang*/ 
	movq	8(%rbp)/*wang*/ , %rsi
	movq	$.intout, %rdi
	call	printf
	pushq	%rdx
	movq	-16(%rbp)/*y*/ , %rax
	pushq	%rax
	movq	-8(%rbp)/*x*/ , %rax
	mulq	(%rsp)
	popq	%rdx
	popq	%rdx
	movq	%rax, %rsi
	movq	$.intout, %rdi
	call	printf
	pushq	%rdx
	movq	-32(%rbp)/*w*/ , %rax
	pushq	%rax
	movq	-24(%rbp)/*z*/ , %rax
	mulq	(%rsp)
	popq	%rdx
	popq	%rdx
	movq	%rax, %rsi
	movq	$.intout, %rdi
	call	printf
	movq	$0x0A, %rdi
	call	putchar
	movq	$1, %rax
	leave
	ret
