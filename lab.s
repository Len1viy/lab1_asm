bits 64
;(a * b * c - c * d * e)/(a/b + c/d)
section .data
res:
	dq	0
a:
	dq	100
b:
	dd	20
c:
	dd	80
d:
	db	40
e:
	dw	10
proizv1:
	dq	0
proizv2:
	dq	0
div1:
	dq	0
div2:
	dq	0
;16
section .text
global _start
_start:
	mov	eax, dword[c]
	cdqe
	mov	rcx, rax
	mov	eax, dword[b]
	cdqe
	mov	rbx, rax
	movzx	rbp, word[e]
	movzx	rsi, byte[d]
	mov	rax, qword[a]
	mov	rdi, rax
	imul	rdi, rbx
	imul	rdi, rcx
	mov	qword[proizv1], rdi
	mov	rdi, rcx
	imul	rdi, rbp
	imul	rdi, rsi
	mov	qword[proizv2], rdi
	div	rbx
	mov 	qword[div1], rax
	mov 	rax, rcx
	div	rsi
	add	rax, qword[div1]
	mov	qword[div2], rax
	mov	rax, qword[proizv1]
	sub	rax, qword[proizv2]
	mov	rsi, qword[div2]
	div	rsi
	mov	qword[res], rax
	mov	eax, 60
	mov	edi, 0
	syscall
