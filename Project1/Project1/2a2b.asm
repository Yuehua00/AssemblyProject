; 1. 輸入
; 2. 文字有顏色 對應數字
;--------------------------------
; 3. rank (?)
; 4. 自選方塊長度
; ...
;---------------------------------------
; 函式庫引進教學 : https://knowlet3389.blogspot.com/2014/12/visual-studio-assembly.html


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

	; call print                 ; 測試用，要拿掉

	mov edx, OFFSET welcome      ; 輸出歡迎
	call WriteString
	call Crlf

	mov eax, 1h                  ; 遊戲是否繼續? 1 繼續
	cmp continue, eax
	je StartGame
	jne EndGame

	StartGame:                ; 格子滿還沒處理
		Create: ;-------------------------------------------------------------------------create number to random space
			mov esi, OFFSET game
			call Randomize        ; 初始化Random32的起始種子值，種子等於一天中的時間，精確到1/100秒
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
			jne Create            ; 不為0 == 格子有東西，重新產生
			mov [esi], eax
			call print
		;-----------------------------------------------------------------------------------------------------------------------
		
		call ReadChar
		mov esi, OFFSET direction
		L1:
			cmp eax, [esi]   ; 比對方向字元
			inc cnt          ; 記錄哪個方向
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

		; 瘋狂 for 迴圈
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
	; call WriteDec                  ; 用來看亂數本人
	mov edx, 0                        
	idiv ecx                         
	cmp edx, 0                       ; 餘數在edx
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
	; call WriteDec                  ; 用來看亂數本人
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
			mov edx, OFFSET blank         ; 輸出對齊問題  '\t'不能用
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