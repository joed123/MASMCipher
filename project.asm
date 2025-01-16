TITLE Final Project     (Finalproject.asm)

; Author: Joseph Di Lullo
; Last Modified: 3/13/2022
; Description: Encrypt and decrypt messages

INCLUDE Irvine32.inc

.data

.code

main PROC

exit
main ENDP

;Description: Compute procedure, calls the encrypt, decrypt, and decoy procedures
;Receives: dest
;Returns: nothing
;Preconditions: none
;Register changed: eax, esi, ebp, esp, ebx
compute PROC

	push ebp 
	mov ebp, esp							;set ebp

								
	mov eax, [ebp + 8]
	mov eax, [eax]							;put the value of dest into eax
	
	cmp eax, -1								;if dest is -1 then jump to encrypt function
	je encryptionmode1

	cmp eax, -2								;if dest is -2 then jump to decrypt function
	je decryptionmode1

	call decoymode							;else go into decoy

	pop ebp
ret 

encryptionmode1:
	mov eax, [ebp + 12]
	push eax
	mov ebx, [ebp + 16]						;push the strings onto the stack
	push ebx

	call encryptionmode

ret 12

decryptionmode1:
	mov eax, [ebp + 12]
	push eax								;push the strings onto the stack
	mov ebx, [ebp + 16]
	push ebx

	call decryptionmode

ret 12

compute ENDP

;Description: decoy procedure
;Receives: dest
;Returns: dest
;Preconditions: dest must not be -1 or -2
;Register changed: eax, ebp
decoymode PROC

	push ebp 
	mov ebp, esp

	mov eax, 26
	mov [dest], eax							;move 26 into dest

	pop ebp
ret 
decoymode ENDP

;Description: encryption procedure, encrptes the message
;Receives: message
;Returns: modified message
;Preconditions: dest is -1
;Register changed: eax, esi, ebp, esp, edi, ebx
encryptionmode PROC

	push ebp 
	mov ebp, esp

	mov esi, [ebp + 12]						;set the address of message into esi
	mov edi, [ebp + 8]						;set the address of message into edi
	sub esi, 1

outerloop:
	add esi, 1								;increment esi to go to the next element in message

	mov eax, 0								;zero the registers
	mov ebx, 0

	mov al, [esi]							;move the element of esi into al
	cmp al, 0
	je done

	cmp al, 97								;testing for spaces
	jl space

	sub al, 'a'								;getting the proper value

	mov bl, [edi + eax]						;moving that value into bl

	again:

	mov [esi], bl							;moving bl into message
	mov eax, ebx

	jmp outerloop

space:
	mov bl, ' '									;when a space is hit add a space into message
	jmp again

done:
	mov bl, '.'									;add a period into the end of messsage
	mov [esi - 1], bl

	pop ebp

ret 12
encryptionmode ENDP

;Description: decryption procedure, decrypts message
;Receives: message
;Returns: modified message
;Preconditions: dest is -2
;Register changed: eax, esi, ebx, bl, al, ebp, esp, edi
decryptionmode PROC

	push ebp 
	mov ebp, esp

	mov esi, [ebp + 12]						;set the address of message into esi
	mov edi, [ebp + 8]						;set the address of message into edi

	sub esi, 1	

theouterloop:
	add esi, 1

	mov al, [esi]							;move value of esi into al
	cmp al , 0
	je ender

	cmp al, 97								;check for spaces
	jl space1

	mov cl, 0								;zero cl

	mov edi, [ebp + 8]						;move the adress of key inot edi

	sub edi, 1

	theinnerloop:
	inc cl									;counter that counts until the end of the string

	add edi, 1								;increment through key

	mov bl, [edi]							;move value of key into bl

	cmp cl, 26								;when fully incremented through key, go to next letter in message
	jg theouterloop

	cmp bl, al								;when the value in key and message are equal, jump
	je equal

	jmp theinnerloop						;keep going through key

equal:
	dec cl 

	add cl, 97								;add 97 to the index in key
	mov al, cl
	mov [esi], al							;move the new letter into message

	jmp theinnerloop


space1:
	mov al, ' '								;add space
	mov [esi], al

	jmp theinnerloop
	
ender:
	mov al, '.'
	mov [esi - 1], al						;add period at the end

	pop ebp

ret 12
decryptionmode ENDP


END main
