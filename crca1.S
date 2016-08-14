.global array
.global crcInit
.global crcFast

.text

crcInit:
	pushq %rbx
	movq $array, %rbx /* rbx is array */
	movq $0, %rax /* rax is dividend or index */
	movq $0, %rdx /*dl is remainder */
	movq $0, %rcx /*cl is bit */
	jmp .L1
.L2: /* outer while loop */
	incq %rax
	cmpq $255,%rax
	jbe  .L1
	popq %rbx
	ret

.L1: /* outer do loop */
	movb %al,%dl /* remainder = dividend */
	movb $8, %cl
	jmp .L4
	
.L3: /* inner while loop */
	decb %cl
	cmpb $0,%cl
	je .L6
	jmp .L4

.L4: /*inner if-else */
	testb $0x80, %dl
	jne .L5
	salb $1,%dl
	jmp .L3
	
.L5: /* if branch */
	salb $1,%dl
	xorb $0xD5,%dl
	jmp .L3

.L6: /*assign result to hash table*/
	movb %dl, (%rbx,%rax)
	jmp .L2

crcFast: /* %rdi is message, %rsi is nBytes */
	movl $0,%eax /* byte */
	movb $0,%dl /* remainder */
	xorq %rcx,%rcx /* %cl is data */
	movq $array, %r8 
.L7: /* do */
	movb (%rdi,%rax),%cl /* %cl is data */
	xorb %dl,%cl
	movb (%r8,%rcx),%dl
	incl %eax
	cmpl %esi,%eax
	jb .L7
	xorq %rax,%rax
	movq %rdx,%rax
	ret

.data

array:
	.rept 256
	.byte 0
	.endr

