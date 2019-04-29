.section .rodata
.intout: .string "%ld "
.strout: .string "%s "
.errout: .string "Wrong number of arguments"
.STR0: .string "Inner a is "
.STR1: .string "Outer a is "
.STR2: .string "Global k is "
.section .data
._j: .zero 8
._i: .zero 8
._k: .zero 8
.globl main
.section .text
main:
	pushq   %rbp
	movq    %rsp, %rbp
	subq	$1,%rdi
	cmpq	$3,%rdi
	jne	ABORT
	cmpq	$0,%rdi
	jz	SKIP_ARGS
	movq	%rdi,%rcx
	addq $24, %rsi
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
	popq	%rdx
SKIP_ARGS:
	call	_nesting_scopes
	jmp	END
ABORT:
	movq	$.errout, %rdi
	call puts
END:
	movq    %rax, %rdi
	call    exit
_nesting_scopes:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx
	pushq	$0 /* local var no. 0 */
	pushq	$0 /* local var no. 1 */
	pushq	$0 /* local var no. 2 */
	pushq	$0 /* local var no. 3 */
	pushq	$0 /* local var no. 4 */
	pushq	$0 /* local var no. 5 */
	pushq	$0 /* local var no. 6 */
	pushq	$0 /* local var no. 7 */
	pushq	$0 /* Stack padding for 16-byte alignment */
	movq	$21, %rax
	movq	%rax, -32(%rbp) /*a*/
	movq	$42, %rax
	movq	%rax, -80(%rbp) /*a*/
	movq	$.STR0, %rsi
	movq	$.strout, %rdi
	call	printf
	movq	-80(%rbp) /*a*/, %rsi
	movq	$.intout, %rdi
	call	printf
	movq	$0x0A, %rdi
	call	putchar
	movq	$.STR1, %rsi
	movq	$.strout, %rdi
	call	printf
	movq	-32(%rbp) /*a*/, %rsi
	movq	$.intout, %rdi
	call	printf
	movq	$0x0A, %rdi
	call	putchar
	movq	$.STR2, %rsi
	movq	$.strout, %rdi
	call	printf
	movq	._k, %rsi
	movq	$.intout, %rdi
	call	printf
	movq	$0x0A, %rdi
	call	putchar
	movq	$0, %rax
	leave
	ret
