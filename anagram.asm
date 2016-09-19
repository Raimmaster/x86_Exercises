Main:
	#set ebx = 0x10000000
	#set byte[ebx] =['a', 'r', 'm', 'a', 0]
	#set byte[ebx + 8] =['a', 'm', 'a', 'r', 0]
	mov eax, ebx
	add eax, 8
	push eax
	push ebx
	call Anagram
	add esp, 8
	#show eax
	#stop

Anagram: 
	push ebp
	mov  ebp, esp
	sub  esp, 212 ;saving space for arrays and c
	#show ebp hex
	mov eax, 0
	mov ebx, 53
	init: ;init arrays and c in zero
		;#show eax hex
		;#show ebp hex
		mov edx, 0
		sub edx, eax
		lea edx, dword[ebp + edx*4]
		mov edx, 0 ; first = {0}
		inc eax
		cmp eax, ebx
		jnz init

		mov eax, dword[ebp + 8]   ;a
	while_a: ;'a' = 97
		mov ebx, dword[ebp - 208] ;c
		mov cl, byte[eax + ebx] ; a[c]
		cmp cl, 0
		jnz fin_while_a
		sub cl, 97 ; a[c] - 97
		inc dword[ebp - cl*4];first[a[c] - 97]++
		inc dword[ebp - 208]
		jmp while_a

	fin_while_a:
		mov dword[ebp - 208], 0
		mov eax, dword[ebp + 12] ;b

	while_b:
		mov ebx, dword[ebp - 208] ;c
		mov cl, byte[eax + ebx*4] ;b[c]
		cmp cl, 0
		jnz fin_while_b
		sub cl, 97; b[c] - 97
		inc dword[ebp - 104 - cl*4] ;second[b[c] - 97]++
		inc dword[ebp - 208]
		jmp while_b

	fin_while_b:
		mov dword[ebp - 208], 0
		mov eax, dword[ebp - 4]; first[]
		lea ebx, dword[ebp - 104]; second[]

	for:
		mov ecx, dword[ebp - 208] ;c		
		cmp ecx, 26
		jge end_for
		mov esi, 0
		sub esi, ecx
		#show esi signed decimal
		#show ebx hex
		#show eax hex
		mov edx, dword[eax + esi*4]; first[c]
		cmp edx, dword[ebx + esi*4]
		jne return_zero
		inc dword[ebp - 208]
		jmp for

	end_for:	
		mov eax, 1
		jmp epilogue

	return_zero:
		mov eax, 0
		jmp epilogue

	epilogue:
		mov esp, ebp
		pop ebp
		ret