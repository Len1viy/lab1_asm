bits 64
;(a * b * c - c * d * e)/(a/b + c/d)
section .data
res:
	dq	0
a:
	dq	4294967144
b:
	dd	1048224
c:
	dd	32
d:
	db	203
e:
	dw	8892
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
	;cdqe
	mul	edi
	jnc	back1
carry1:
	mov	r9, rdx
	mov	rdx, 0
back1:
	mul	esi
	jnc	back2
carry2:
	sal	rdx, 32
	add	rax, rdx
back2:
	mov	r10, rax
	mov	rdx, 0
	mov	rax, r9
	mul	esi
	sal	rax, 32
	add	rax, r10
	xor	r10, r10
	mov	r8, rax ; запись результата в r8
	mov	rbp, qword[a] ; начало подсчета части a*b*c
	mov	ebx, dword[b]
	cmp	ebx, 0 
	je	zf
	mov	rax, rbp
	xor	rdx, 0
	mul	rbx
	jc	cf
	mul	rcx
	jc	cf
	xor	r9, r9
	mov	r9, rax	
	mov	rax, rbp ; начало деления a // b
	div	ebx
	mov	r10, rax
	mov	rax, rcx ; начало деления c // d 
	xor	edx, edx
	div	edi
	add	rax, r10 ; a // b + c // d
	cmp	rax, 0
	je	zf
	mov	r14, rax 
	mov	rax, r9
	sub	rax, r8 ; a*b*c  - c*d*e
	jc	cf
	xor	rdx, rdx
	div	r14 ; конечное деление
	mov	qword[res], rax
	mov	eax, 60
	mov	edi, 0
	syscall

zf:
	mov eax, 60
	mov edi, 1
	syscall

cf:
	mov 	eax, 60
	mov	edi, 2
	syscall
sf:
	mov	eax, 60
	mov	edi, 3
	syscall
