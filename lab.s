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
	mov	ecx, dword[c]
	movzx	edi, byte[d]
	movzx	esi, word[e]
	mov	eax, ecx
	mul	edi
	mul	esi
	mov	dword[proizv2], eax
	mov	rbp, qword[a]
	mov	ebx, dword[b]
	mov	rax, rbp
	mul	ebx
	mul	ecx
	mov	qword[proizv1], rax
	mov	rax, rbp
	div	ebx
	mov	qword[div1], rax
	mov	eax, ecx
	div	edi
	add	eax, dword[div1]
	mov	esp, eax
	mov	rax, qword[proizv1]
	sub	rax, qword[proizv2]
	div	esp
	mov	qword[res], rax
	mov	eax, 60
	mov	edi, 0
	syscall
