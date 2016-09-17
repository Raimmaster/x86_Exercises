main:
	mov eax, 0x10000000
	#set dword [eax]= [5,4,9]
	push 2
	push 0
	push eax
	call quicksort
	#show dword[eax][3] signed decimal
	add esp, 12
	#stop

;offset 8 = *arr
;offset 12 = low
;offset 16 = high
quicksort:
	push ebp
	mov ebp, esp
	mov eax, dword [ebp +12] ; low 
	cmp  eax, dword [ebp + 16]
	jge epilogo
	sub esp, 16
	;ebp -4 = pivot
	;ebp -8 = i
	;ebp -12 = j
	;ebp -16 = temp

	mov dword [ebp -4], eax
	mov dword [ebp -8], eax 
	
	mov ebx, dword [ebp +16]; high

	mov dword[ebp -12], ebx

while_1:
	mov ecx, dword [ebp -8] ; i
	cmp ecx, dword[ebp -12]
	jge end_while_1
while_i_inc:
	mov edx, dword[ebp +8]
	mov edx, dword[edx+ecx*4]; arr[i]

	mov eax, dword[ebp +8]; arr
	mov ecx, dword [ebp - 4] ; pivot
	mov eax, dword[eax + ecx*4]; arr[pivot]

	cmp edx, eax
	jg while_j_dec
	cmp dword[ebp - 8], ebx
	jg while_j_dec
	inc dword[ebp -8]
	jmp while_i_inc

while_j_dec:
	mov edx, dword[ebp +8]; arr
	mov ecx, dword[ebp -12] ; j
	mov edx, dword[edx+ecx*4]; arr[j]

	mov eax, dword[ebp +8]; arr
	mov ecx, dword [ebp - 4] ; pivot
	mov eax, dword[eax + ecx*4]; arr[pivot]

	cmp edx, eax
	jle if_scn
	mov ecx, dword[ebp -12] ; j
	mov eax, dword[ebp + 12]; low
	cmp ecx, eax
	jl if_scn
	dec dword[ebp - 12]
	jmp while_j_dec

if_scn:
	mov ecx, dword [ebp - 8]; i
	mov edx, dword[ebp - 12]; j
	cmp ecx, edx
	jge while_1
	mov ebx, dword[ebp + 8]; arr
	mov eax, dword[ebx + ecx*4]; arr[i]
	mov dword[ebp -16], eax ; temp = arr[i]

	mov eax, dword[ebx + edx*4]; arr[j]
	mov dword[ebx +ecx], eax; arr[i] = arr[j]
	mov eax, dword[ebp - 16]; temp
	mov dword[ebx + edx], eax
	jmp  while_1

end_while_1:
	mov eax, dword[ebp + 8];arr
	mov ebx, dword[ebp -12]; j
	mov ecx, dword[eax+ebx*4]; arr[j]
	mov dword[ebp-16], ecx ; temp = arr[j]
	mov edx, dword[ebp -4]; pivot 
	mov ecx, dword[eax+edx*4]; arr[pivot]
	mov dword[eax + ebx], ecx; arr[j] = arr[pivot]
	mov ecx, dword[ebp -16];temp
	mov dword[eax + edx], ecx; arr[pivot] = temp

	mov eax, dword[ebp - 12];j
	dec eax

	push eax
	push dword[ebp + 12]
	push dword[ebp + 8]
	call quicksort
	add esp, 12

	mov eax, dword[ebp - 12];j
	inc eax
	push dword[ebp + 16]; high stored in sp
	push eax
	push dword[ebp + 8]; arr stored in sp
	call quicksort

epilogo:
	mov esp, ebp
	pop ebp
	ret