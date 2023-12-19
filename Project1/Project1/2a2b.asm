; 2. 文字有顏色 對應數字
; 3. 狀態
;--------------------------------
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
	InputWrong BYTE "Please input 'w' or 's' or 'a' or 'd'.", 0dh, 0ah, 0

	; Printmsg
	line BYTE "---------------------------------", 0dh, 0ah, 0
	blank BYTE "|   ", 0


	; data
	game DWORD 16 DUP (0)
	continue DWORD 1h
	direction BYTE 'w', 's', 'a', 'd'

	row DWORD ?
	crow DWORD ?
	col DWORD ?
	ccol DWORD ?


.code
main PROC
	
	LOCAL cnt : DWORD
	LOCAL wrongInput : DWORD

	; call print                 ; 測試用，要拿掉

	mov edx, OFFSET welcome      ; 輸出歡迎
	call WriteString
	call Crlf

	mov eax, 1h                  ; 遊戲是否繼續? 1 繼續
	cmp continue, eax
	je StartGame
	jne EndGame

	StartGame:                ; 格子滿還沒處理
		call newNum
		call newNum
		call print

		input:
			mov wrongInput, 0
			mov eax, 0
			mov cnt, 0
			call ReadChar        ; 讀入不顯示
			call writechar       ; 顯示剛剛輸入的
			call newNum
			call crlf
		
		mov esi, OFFSET direction
		mov edx, 5
		L1:
			mov bl, [esi]
			inc cnt       ; 記錄哪個方向
			inc esi
			cmp cnt, edx
			je wrong
			cmp al, bl    ; 比對方向字元
			jnz L1

		mov esi, OFFSET game
		mov eax, cnt
		move_up: cmp eax, 1
			jne move_down    
			call Up
			mov wrongInput, 1
			jmp next

		move_down: cmp eax, 2
			jne move_left
			call Down
			mov wrongInput, 1
			jmp next

		move_left: cmp eax, 3
			jne move_right
			call Left
			mov wrongInput, 1
			jmp next

		move_right: cmp eax, 4
			 call Right
			 mov wrongInput, 1
			 jmp next
		
		next:
			cmp wrongInput, 0
			je wrong
			call print
			jmp Input
		wrong:
			mov edx, OFFSET InputWrong
			call WriteString
			jmp Input
		
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
	div ecx                         
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

;---------------------------------------------------------
newNum PROC USES esi ecx eax
;
;-------------------------------------------------------
	LOCAL num : DWORD

	call Randomize        ; 初始化Random32的起始種子值，種子等於一天中的時間，精確到1/100秒
	mov ecx, 3            ; %3
	call creatNUM
	mov num, eax

	Pos:
		mov esi, OFFSET game
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
	jne Pos            ; 不為0 == 格子有東西，重新產生
	mov [esi], eax
	
	ret
newNum ENDP

;-------------------------------------------------
Game_now PROC
;
;------------------------------------------------
	LOCAL i : DWORD
	LOCAL j : DWORD

	mov edx, 2048
	mov i, 0
	Li:
		mov esi, OFFSET game
		mov eax, i
		shl eax, 4
		add esi, eax
		Lj:
			mov j, 0
			mov eax, j
			shl eax, 2
			add esi, eax
			cmp [esi], edx
			je Find2048
			inc j
			cmp j, 4
			jl Lj
		inc i
		cmp i, 4
		jl Li
	jmp quit

	Find2048:
		mov eax, 2
		jmp quit

	mov i, 0
	Li2:
		mov esi, OFFSET game
		mov eax, i
		shl eax, 4
		add esi, eax
		Lj2:
			mov j, 0
			mov eax, j
			shl eax, 2
			add esi, eax
			mov eax, [esi]
			cmp eax, 0
			je Zero
			mov eax, 1
			jmp quit

			Zero:
				mov eax, i
				inc eax
				cmp eax, 4
				jg checkj
				mov eax, 1
				jmp quit
			checkj:
				mov eax, j
				inc eax
				cmp eax, 4
				jg next
				mov eax, 1
				jmp quit
			next:
			inc j
			mov eax, j
			cmp eax, 4
			jl Lj2
		inc i
		mov eax, i
		cmp eax, 4
		jl Li2

	quit:

	ret
Game_now ENDP

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

;----------------------------------------------------
Up PROC
; Move up.
;----------------------------------------------------
	mov row, 1                  ; int row = 1
	forRow:
		mov eax, row
		mov crow, eax           ; int crow = row
		forCrow:
			mov col, 0          ; int col = 0
			forCol:
				mov eax, crow
				dec eax
				; mov ebx, 16
				; mul ebx
				shl eax, 4 
				add esi, eax
				mov eax, col
				shl eax, 2
				add esi, eax
				mov eax, 0
				cmp [esi], eax
				jne notZero
				mov eax, [esi+16]
				mov [esi], eax
				mov eax, 0
				mov [esi+16], eax
				; if (game[crow-1][col]) change++;
				jmp next

				notZero:
					mov eax, [esi]
					mov ebx, [esi+16]
					cmp eax, ebx
					jne next
					; check[crow] == 0
					shl eax, 1
					mov [esi], eax
					mov ebx, 0
					mov [esi+16], ebx
					; change++;
					; check[crow]++;
				next:
					mov esi, OFFSET game
				inc col
				mov eax, col
				cmp eax, 4
				jl forCol
			dec crow
			mov eax, crow
			cmp eax, 1
			jge forCrow
		inc row
		mov eax, row
		cmp eax, 4
		jl forRow
	ret
Up ENDP

;------------------------------------------------------
Down PROC
; Move down.
;-----------------------------------------------------
	mov row, 2                    ; int row = Row - 2 = 2
	forRow:
		mov eax, row            
		mov crow, eax             ; int crow = row
		forCrow:
			mov col, 0            ; int col = 0
			forCol:
				mov eax, crow
				inc eax
				shl eax, 4
				add esi, eax
				mov eax, col
				shl eax, 2
				add esi, eax
				mov eax, 0
				cmp [esi], eax
				jne notZero
				mov eax, [esi-16]
				mov [esi], eax
				mov eax, 0
				mov [esi-16], eax
				; if (game[crow+1][col]) change++
				jmp next

				notZero:
					mov eax, [esi]
					mov ebx, [esi-16]
					cmp eax, ebx
					jne next
					; check[crow] == 0
					shl eax, 1
					mov [esi], eax
					mov ebx, 0
					mov [esi-16], ebx
					; change++
					; check[crow]++
				next:
					mov esi, OFFSET game
				inc col
				mov eax, col
				cmp eax, 4
				jl forCol
			inc crow
			mov eax, crow
			cmp eax, 3
			jl forCrow
		dec row
		mov eax, row
		cmp eax, 0
		jge forRow
	ret

Down ENDP

;-----------------------------------------------------
Left PROC
; Move left.
;---------------------------------------------------
	mov col, 1                    ; int col = 1
	forCol:
		mov eax, col            
		mov ccol, eax             ; int ccol = col
		forCcol:
			mov row, 0            ; int row = 0
			forRow:
				mov eax, row
				shl eax, 4
				add esi, eax
				mov eax, ccol
				shl eax, 2
				add esi, eax
				mov eax, 0
				cmp [esi-4], eax
				jne notZero
				mov eax, [esi]
				mov [esi-4], eax
				mov eax, 0
				mov [esi], eax
				; if (game[row][ccol-1]) change++
				jmp next

				notZero:
					mov eax, [esi-4]
					mov ebx, [esi]
					cmp eax, ebx
					jne next
					; check[ccol] == 0
					shl eax, 1
					mov [esi-4], eax
					mov ebx, 0
					mov [esi], ebx
					; change++
					; check[ccol]++
				next:
					mov esi, OFFSET game
				inc row
				mov eax, row
				cmp eax, 4
				jl forRow
			; call print
			dec ccol
			mov eax, ccol
			cmp eax, 1
			jge forCcol
		inc col
		mov eax, col
		cmp eax, 4
		jl forCol
	ret
Left ENDP

;-----------------------------------------------------
Right PROC
; Move right.
;---------------------------------------------------
	mov col, 2                    ; int col = Col - 2 = 2
	forCol:
		mov eax, col            
		mov ccol, eax             ; int ccol = col
		forCcol:
			mov row, 0            ; int row = 0
			forRow:
				mov eax, row
				shl eax, 4
				add esi, eax
				mov eax, ccol
				shl eax, 2
				add esi, eax
				mov eax, 0
				cmp [esi+4], eax
				jne notZero
				mov eax, [esi]
				mov [esi+4], eax
				mov eax, 0
				mov [esi], eax
				; if (game[row][ccol+1]) change++
				jmp next

				notZero:
					mov eax, [esi+4]
					mov ebx, [esi]
					cmp eax, ebx
					jne next
					; check[ccol] == 0
					shl eax, 1
					mov [esi+4], eax
					mov ebx, 0
					mov [esi], ebx
					; change++
					; check[ccol]++
				next:
					mov esi, OFFSET game
				inc row
				mov eax, row
				cmp eax, 4
				jl forRow
			; call print
			inc ccol
			mov eax, ccol
			cmp eax, 2
			jle forCcol
		dec col
		mov eax, col
		cmp eax, 0
		jge forCol
	ret
Right ENDP
	

END main

