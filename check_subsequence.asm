Main:
	#set eax = 0x10000000
	#set ebx = 0x10000008
	#set byte[eax] = ['h','o','l','a', 0]
	;#set byte[ebx] = ['h','o','l','a', 0]
	#set byte[ebx] = ['o','r', 0]

	;#show byte[eax] ascii
	;#show byte[ebx] ascii

	push eax
	push ebx
	call Check
	add esp, 8

	#show eax
	#stop


Check:
	;Prologue
	push ebp
	mov ebp, esp
	sub esp, 8
	;Body

	;#show dword[ebp]
	mov dword[ebp-4], 0 ; 	c
	;#show dword[ebp + 8] hex
	mov dword[ebp -8], 0 ; 	d
	;#show dword[ebp+12] hex

	;mov eax, dword[ebp+8] ; a
	;mov ebx, dword[ebp+12] ; b
	while_1:
		mov eax, dword[ebp+8] ; a
		mov ebx, dword[ebp-4] ; c
		mov al, byte[eax + ebx] ; a[c]
		#show al ascii
		cmp eax, 0
		je end_while_1

		;#show dword[ebp]
		;#show dword[ebp-4]

		while_2:
			mov ebx, dword[ebp-8] ; d
			mov ecx, dword[ebp+12] ; b
			mov bl, byte[ecx + ebx] ; b[d]

			cmp al, bl
			je end_while_2

			cmp bl, 0
			je end_while_2

			;#show al ascii
			;#show bl ascii

			inc dword[ebp-8]
			;#show dword[ebp-4]
			jmp while_2

		end_while_2:

			mov eax, dword[ebp-8] ; d
			mov ebx, dword[ebp+12] ; b
			mov al, byte[ebx + eax] ; b[d]
			;#show al ascii

			cmp al, 0
			je end_while_1


			inc dword[ebp-8]
			inc dword[ebp-4]

			jmp while_1

	end_while_1:
		
		mov eax, dword[ebp-4] ;c
		mov ebx, dword[ebp+8] ;a
		cmp byte[ebx + eax], 0
		jne Epilogue
		mov eax, 1
		leave
		ret


	Epilogue:
		mov eax, 0
		leave
		ret