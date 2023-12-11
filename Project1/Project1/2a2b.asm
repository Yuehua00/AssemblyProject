; 1. ��J
; 2. ��r���C�� �����Ʀr
;--------------------------------
; 3. rank (?)
; 4. �ۿ�������
; ...
;---------------------------------------
; �禡�w�޶i�о� : https://knowlet3389.blogspot.com/2014/12/visual-studio-assembly.html


INCLUDE Irvine32.inc
.data
	; message
	welcome BYTE "Welcome to the world of 2048! ; )", 0dh, 0ah, 0dh, 0ah
        BYTE "Ready for some blocky adventures?", 0dh, 0ah
        BYTE "Use 'w' to make blocks ascend like magic!", 0dh, 0ah
        BYTE "Use 's' to send them on a downward dance!", 0dh, 0ah
        BYTE "Use 'a' to make blocks boogie left!", 0dh, 0ah
        BYTE "Use 'd' to direct blocks in a rightward rave!", 0dh, 0ah
        BYTE "Let the games begin! May the merging madness unfold!", 0dh, 0ah, 0
	strT BYTE " ",0

	; Printmsg
	line BYTE "---------------------------------", 0dh, 0ah, 0
	blank BYTE "|   ", 0


	; data
	game DWORD 16 DUP (0)
	continue DWORD 1h
	direction DWORD 'w', 's', 'a', 'd'

	tmp DWORD 0


.code
main PROC
	LOCAL num : DWORD
	LOCAL cnt : DWORD

	; call print                 ; ���եΡA�n����

	mov edx, OFFSET welcome      ; ��X�w��
	call WriteString
	call Crlf

	mov eax, 1h                  ; �C���O�_�~��? 1 �~��
	cmp continue, eax
	je StartGame
	jne EndGame

	StartGame:                ; ��l���٨S�B�z
		Create: ;-------------------------------------------------------------------------create number to random space
			mov esi, OFFSET game
			call Randomize        ; ��l��Random32���_�l�ؤl�ȡA�ؤl����@�Ѥ����ɶ��A��T��1/100��
			mov ecx, 3            ; %3
			call creatNUM
			mov num, eax

			; x position
			mov ecx, 4           
			call creatPOS
			mov ecx, 16           ; esi += x * 16 + 4
			mul ecx
			add eax, 4
			add esi, eax

			; y position
			mov ecx, 4            ; esi += y * 4
			call creatPOS
			mov ecx, TYPE DWORD
			mul ecx
			add esi, eax

			sub esi, 4            ; esi -= 4
			mov eax, num
			mov ebx, 0
			cmp [esi], ebx
			jne Create            ; ����0 == ��l���F��A���s����
			mov [esi], eax
			call print
		;-----------------------------------------------------------------------------------------------------------------------
		
		call ReadChar
		mov esi, OFFSET direction
		L1:
			cmp eax, [esi]   ; ����V�r��
			inc cnt          ; �O�����Ӥ�V
			jne L1

		mov eax, cnt
		cmp eax, 1
		je Up
		cmp eax, 2
		je Down
		cmp eax, 3
		je Left
		cmp eax, 4
		je Right

		; �ƨg for �j��
		Up:

		Down:

		Left:

		Right:
			



	EndGame:
		; output end message
             

exit
main ENDP
;----------------------------------------------------
creatNUM PROC
; Creat random number(2 || 4) to game, saving in EAX.
;-----------------------------------------------------

	call Random32
	; call WriteDec                  ; �ΨӬݶüƥ��H
	mov edx, 0                        
	idiv ecx                         
	cmp edx, 0                       ; �l�Ʀbedx
	je four
	mov eax, 2
	jmp quit

	four:
		mov eax, 4                     
	quit:

	ret

creatNUM ENDP

;----------------------------------------------------
creatPOS PROC
; Creat position of gamw, saving in EAX.
;-----------------------------------------------------

	call Random32
	; call WriteDec                  ; �ΨӬݶüƥ��H
	mov edx, 0                        
	idiv ecx                         
	mov eax, edx

	ret

creatPOS ENDP

;---------------------------------------------
print PROC USES esi
; Print out the interface.
;---------------------------------------------

	mov ecx, 4
	mov esi, OFFSET game

	L1:
		push ecx
		mov edx, OFFSET line
		call WriteString
		mov ecx, 4
		L2:
			mov edx, OFFSET blank         ; ��X������D  '\t'�����
			call WriteString
			mov eax, [esi]
			cmp eax, 0
			je next
			call WriteDec

			next:
				add esi, TYPE DWORD
		loop L2
		pop ecx
		call Crlf
		
	loop L1

	mov edx, OFFSET line
	call WriteString
	call Crlf
		
	ret

print ENDP

END main