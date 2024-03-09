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
	mov	ecx, dword[c] ; выгрузка c
	movzx	edi, byte[d] ; выгрузка d
	movzx	esi, word[e] ; выгрузка e
	cmp	edi, 0 ; проверка на 0 d
	je	zf 
	mov	eax, ecx ; начало подсчета части c*d*e
	cdqe
	mul	edi
	jc	cf
	mul	esi
	jc	cf
	mov	r9d, eax ; запись результата в r9d
	mov	rbp, qword[a] ; начало подсчета части a*b*c
	mov	ebx, dword[b]
	cmp	ebx, 0 
	je	zf
	mov	rax, rbp
	mul	ebx
	jc	cf
	mul	ecx
	jc	cf
	mov	r8, rax
	mov	rax, rbp ; начало деления a // b
	div	ebx
	
	mov	r10, rax
	mov	eax, ecx ; начало деления c // d 
	cdqe
	mov	rdx, 0
	div	edi
	add	rax, r10 ; a // b + c // d
	cmp	rax, 0
	je	zf
	mov	rsp, rax 
	mov	rax, r8
	sub	rax, r9 ; a*b*c  - c*d*e
	jc	cf
	div	rsp ; конечное деление
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
