; 1. ��J
; 2. ��ﵪ��
; 3. ���ײ��͡A���঳����
; 4. ��r���C��
;--------------------------------
; 5. rank (?)
; 6. �ۿﵪ�ת���
; 7. �i�I���\��P
; ...
;---------------------------------------
; �禡�w�޶i�о� : https://knowlet3389.blogspot.com/2014/12/visual-studio-assembly.html


INCLUDE Irvine32.inc
.data
	; message
	welcome BYTE "Unlock the fun with a 4-digit code�Xno repeats allowed!",0dh ,0ah, 0dh, 0ah
		BYTE "Get an 'A' for the right digit in the right spot, and a 'B' if it's in the mix but not in its place. ",0dh, 0ah
		BYTE "Let the guessing games begin! ", 0dh, 0ah, 0
	strT BYTE " ",0

	; Printmsg
	line BYTE "---------------------------------", 0dh, 0ah, 0
	zeroOutput BYTE "|   \t"
	blank BYTE "|   "


	; data
	game DWORD 16 DUP (0)
	ans DWORD 4 DUP(?)
	input DWORD 4 DUP(?)
	continue DWORD 1h

	tmp DWORD 0

.code
main PROC
	mov edx, OFFSET welcome
	call print                 ; ���եΡA�n����
	call WriteString
	call Crlf
	mov eax, 1h
	cmp continue, eax
	je StartGame
	jne EndGame

	StartGame:
		call Randomize        ; ��l��Random32���_�l�ؤl�ȡA�ؤl����@�Ѥ����ɶ��A��T��1/100��
		call creatANS

	EndGame:
		; output end message
             

exit
main ENDP
;---------------------------------------------
creatANS PROC
; Creat random number to ans array.
;---------------------------------------------
	mov esi, OFFSET ans
	mov ecx, 4
	L1:
		
		mov tmp, ecx
		mov ecx, 9
		call Random32
		; call WriteDec                  ; �ΨӬݶüƥ��H
		mov edx, 0                        
		idiv ecx                         ; ���l�ơA�٨S�ѨM���ƼƦr
		mov [esi], edx                   ; �l�Ʀbedx
		add esi, TYPE ans
		mov ecx, tmp
	loop L1

	COMMENT ! Show ans
		mov ecx, 4
		mov esi, OFFSET ans
		L2:
			mov eax, [esi]
			call writeDec
			 mov edx,OFFSET strT
			 call WriteString
			add esi, TYPE ans
		loop L2
		call crlf
	!
	ret

creatANS ENDP

;---------------------------------------------
print PROC USES esi
; Print out the interface.
;---------------------------------------------

	mov ecx, 4

	L1:
		
		mov edx, OFFSET line
		call WriteString
		call Crlf
		push ecx
		mov ecx, 4
		L2:
			
			mov eax, [esi]     ; ����
			cmp eax, 0
			je isZero
			push eax
			mov eax, OFFSET blank
			call WriteString
			pop eax
			call WriteString
			mov eax, "\t"
			call WriteString
			jmp next

		isZero:
			push eax
			mov eax, OFFSET zeroOutput
			call WriteString
		next:
			add esi, TYPE DWORD
		loop L2
		pop ecx
	loop L1

		
		ret

print ENDP

END main