main:
	#set eax = 7
	push eax
	call fibonacci
	add esp, 4
	#show eax unsigned decimal
	#stop

fibonacci:
	push ebp
	mov ebp, esp
	push edi; return value

	mov ebx, dword[ebp+8];n
	cmp ebx, 1
	jle return_n
	dec ebx;n-1
	push ebx
	call fibonacci
	;#show eax unsigned decimal
	add esp, 4
	mov edi, eax

	mov ebx, dword[ebp+8];n
	sub ebx, 2
	push ebx
	call fibonacci
	add esp, 4
	add eax, edi
	jmp epilogue

return_n:
	pop edi
	mov esp, ebp
	pop ebp
	mov eax, ebx
	ret

epilogue:
	pop edi
	mov esp, ebp
	pop ebp
	ret
