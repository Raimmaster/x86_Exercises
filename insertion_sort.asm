Main:
	#set eax = 0x10000000
	#set dword[eax] = [55, 44, 20, 99, 3]
	#set ebx = 5

	push ebx
	push eax
	call insertion_sort
	#set eax = 0x10000000
	#show dword[eax] signed decimal
	#show dword[eax+4] signed decimal
	#show dword[eax+8] signed decimal
	#show dword[eax+12] signed decimal
	#show dword[eax+16] signed decimal
	add esp, 8
	#stop


insertion_sort:
	push ebp
	mov ebp, esp
	sub esp, 12 ; i, temp, j

	mov dword[ebp - 4], 1

	for:
		mov eax, dword[ebp + 12] ; s
		cmp dword[ebp -4], eax 
		jge end_for

		mov eax, dword[ebp-4] ; i
		mov ebx, dword[ebp+8] ; a
		mov ebx, dword[eax*4 + ebx] ; a[i]

		mov dword[ebp-8], ebx ; temp
		dec eax
		mov dword[ebp - 12], eax

		while:
			mov eax, dword[ebp - 12] ; j
			cmp eax, 0
			jl end_while

			mov ebx, dword[ebp + 8] ; a
			mov ecx, dword[ebx + eax*4] ; a[j]

			cmp dword[ebp - 8], ecx
			jge end_while

			inc eax
			mov dword[ebx + eax*4], ecx
			dec dword[ebp - 12]
			jmp while

		end_while:
			mov eax, dword[ebp - 8] ; temp
			mov ebx, dword[ebp - 12] ; j
			mov ecx, dword[ebp + 8]
			inc ebx
			mov dword[ecx + ebx*4], eax
		inc dword[ebp -4]
		jmp for

	end_for:
		leave
		ret