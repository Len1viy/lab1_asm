bits 64
;(a * b * c - c * d * e)/(a/b + c/d)
section .data
res:
	dq	0
a:
	dq	1000
b:
	dd	200
c:
	dd	320	
d:
	db	20
e:
	dw	100
;16
section .text
global _start
_start:
	mov	ecx, dword[c]
	movzx	edi, byte[d]
	movzx	esi, word[e]
	cmp	edi, 0
	je	zf
	mov	eax, ecx
	cdqe
	mul	edi
	jc	cf
	mul	esi
	jc	cf
	mov	r9d, eax
	mov	rbp, qword[a]
	mov	ebx, dword[b]
	cmp	ebx, 0
	je	zf
	mov	rax, rbp
	mul	ebx
	jc	cf
	mul	ecx
	jc	cf
	mov	r8, rax
	mov	rax, rbp
	div	ebx
	
	mov	r10, rax
	mov	eax, ecx
	cdqe
	mov	rdx, 0
	div	edi
	add	rax, r10
	cmp	rax, 0
	je	zf
	mov	rsp, rax
	mov	rax, r8
	sub	rax, r9
	jc	cf
	div	rsp
	mov	qword[res], rax
	mov	eax, 60
	mov	edi, 0
	syscall

zf:
	mov eax, 60
	mov edi, 1
	syscall

cf:
	mov eax, 60
	mov	edi, 2
	syscall
