;---------------------------
; 2048 專題
; 
; 411262207 陳怡伶
;---------------------------


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
	Lose BYTE "You lose!", 0dh, 0ah, 0
	Win BYTE "You win!", 0dh, 0ah, 0
	Continue BYTE "Do you want to play again? Y/N", 0dh, 0ah, 0

	; Printmsg
	line BYTE "---------------------------------", 0dh, 0ah, 0
	blank7 BYTE "|       ", 0
	blank6 BYTE "|      ", 0
	blank5 BYTE "|     ", 0
	blank4 BYTE "|    ", 0
	blank3 BYTE "|   ", 0


	; data
	game DWORD 15 DUP (0)                ; 遊戲棋盤
	check DWORD 4 DUP (0)                ; 用來避免連續合併
	change DWORD 0                       ; 在移動時檢查棋盤是否有改變，以此判斷輸入方向是否為有效方向
	continueGame DWORD 1h                ; 是否繼續遊戲
	direction BYTE 'w', 's', 'a', 'd'    ; 移動方向
	input BYTE ?                         ; 玩家輸入的移動方向
	startGame DWORD 0                    ; 是否為第一局遊戲

	row DWORD ?
	crow DWORD ?
	col DWORD ?
	ccol DWORD ?


.code
main PROC
	
	LOCAL cnt : DWORD            ; 紀錄玩家輸入方向
	LOCAL wrongInput : DWORD     ; 錯誤輸入
	LOCAL gameState : DWORD      ; 遊戲狀態

	mov edx, OFFSET welcome      ; 輸出歡迎
	call WriteString
	call Crlf

	NewGame:
		call resetGame
		mov eax, 1
		inc startGame
		cmp startGame, eax          ; 判斷是否為第一局
		je StartGameIt
		call Readchar
		mov ebx, 1                  ; 遊戲是否繼續? 1 繼續
		cmp continueGame, ebx
		je StartGameIt
		jne EndGame

	StartGameIt:
		call newNum
		call newNum
		call print
		call Game_now
		mov gameState, eax
		
		input00:
			mov ebx, 0
			cmp gameState, ebx   ; 是否結束 (0 = 結束)
			jne CheckNow
			mov wrongInput, 0
			mov eax, 0
			mov cnt, 0
			call ReadChar        ; 讀入不顯示 (輸入值在 al )
			mov input, al
			call writechar       ; 顯示剛剛輸入的
			call crlf
		
		mov esi, OFFSET direction
		mov edx, 5        ; 方向判斷次數 ( = 5 表示輸入錯誤)
		mov al, input
		L1:
			mov bl, [esi]
			inc cnt       ; 記錄哪個方向
			inc esi
			cmp cnt, edx
			je wrong
			cmp al, bl    ; 比對方向字元
			jnz L1        ; ZF = 0, AL != BL

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
		
		call Game_now
		mov gameState, eax

		next:
			cmp ebx, 0
			je wrong
			call newNum
			cmp wrongInput, 0
			je wrong
			call print
			jmp CheckNow
		wrong:
			mov edx, OFFSET InputWrong
			call WriteString
			jmp Input00
		
	CheckNow:
		mov ebx, 2           ; gameState = 2 : 2048
		cmp gameState, ebx
		je WinGame
		mov ebx, 0           ; gameState = 0 : 無法移動
		jne Input00
		mov edx, OFFSET Lose ; 輸出 lose
		call WriteString
		jmp NextGame          ; 跳至是否繼續遊玩

	WinGame:
		mov edx, OFFSET Win  ; 輸出 win
		call WriteString
	
	NextGame:
		mov edx, OFFSET Continue
		call WriteString
		jmp NewGame

	EndGame:
		; output end message
             
	invoke ExitProcess, 0
exit
main ENDP

;---------------------------------------------------
resetGame PROC
; Reset game array.
;---------------------------------------------------
	LOCAL i : DWORD
	LOCAL j : DWORD

	mov i, 0
	L1:
		mov esi, OFFSET game
		mov eax, i
		shl eax, 4
		add esi, eax
		mov j, 0
		L2:
			add esi, 4
			mov ebx, 0
			mov [esi], ebx
			inc j
			mov eax, j
			cmp eax, 4
			jl L2
		inc i
		mov eax, i
		cmp eax, 4
		jl L1

	ret
resetGame ENDP

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
; 將生成的數字加入格子
;-------------------------------------------------------
	LOCAL num : DWORD

	call Randomize        ; 初始化Random32的起始種子值，種子等於一天中的時間，精確到1/100秒
	mov ecx, 3            ; %3
	call creatNUM
	mov num, eax          ; 亂數

	Pos:
		mov esi, OFFSET game
		; x position
		mov ecx, 4           
		call creatPOS
		mov ecx, 16           ; esi += x * 16
		mul ecx
		add esi, eax

		; y position
		mov ecx, 4            ; esi += y * 4
		call creatPOS
		mov ecx, TYPE DWORD
		mul ecx
		add esi, eax

	mov eax, num
	mov ebx, 0
	cmp [esi], ebx
	jne Pos            ; 不為 0 == 格子有東西，重新產生
	mov [esi], eax
	
	ret
newNum ENDP

;-------------------------------------------------
Game_now PROC
; 回傳遊戲狀況
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
		mov j, 0
		Lj:
			mov eax, j
			shl eax, 2
			add esi, eax
			cmp [esi], edx
			je Find2048
			inc j
			mov eax, j
			cmp eax, 4
			jl Lj
		inc i
		cmp i, 4
		jl Li
	mov i, 0
	jmp Li2

	Find2048:
		mov eax, 2
		jmp quit

	
	Li2:
		mov esi, OFFSET game
		mov eax, i
		shl eax, 4
		add esi, eax
		mov j, 0
		Lj2:
			mov eax, j
			shl eax, 2
			add esi, eax
			mov eax, [esi]
			cmp eax, 0
			je quit

			checki:
				mov eax, i
				inc eax
				cmp eax, 4
				jg checkj
				mov eax, [esi]
				mov ebx, [esi+16]
				cmp eax, ebx
				jne checkj
				mov eax, 1
				jmp quit
			checkj:
				mov eax, j
				inc eax
				cmp eax, 4
				jg next
				mov eax, [esi]
				mov ebx, [esi+4]
				cmp eax, ebx
				jne next
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
			; mov edx, OFFSET blank         ; 輸出對齊問題  '\t'不能用
			; call WriteString
			mov eax, [esi]
			cmp eax, 1000
			jae blk3
			cmp eax, 100
			jae blk4
			cmp eax, 10
			jae blk5
			cmp eax, 1
			jae blk6
			mov edx, OFFSET blank7
			call WriteString
			jmp next2

			blk6:
				mov edx, OFFSET blank6
				call WriteString
				jmp next
			blk5:
				mov edx, OFFSET blank5
				call WriteString
				jmp next
			blk4:
				mov edx, OFFSET blank4
				call WriteString
				jmp next
			blk3:
				mov edx, OFFSET blank3
				call WriteString
				jmp next
			

			next:
				call WriteDec
			next2:
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
	; call resetCheck
	mov change, 0
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
				mov edx, 0
				cmp [esi], edx
				je next
				inc change
				; -if (game[crow-1][col] != 0) change++;
				jmp next

				notZero:
					mov eax, [esi]
					mov ebx, [esi+16]
					cmp eax, ebx
					jne next

					; mov ebp, OFFSET check
					; mov edx, crow
					; shl edx, 2
					; add ebp, edx
					; mov edx, 0
					; cmp [ebp], edx
					; jne next
					; -check[crow] == 0

					shl eax, 1
					mov [esi], eax
					mov ebx, 0
					mov [esi+16], ebx
					inc change
					; change++;
					; push esi
					; mov esi, OFFSET check
					; mov edx, crow
					; shl edx, 2
					; add esi, edx
					; mov edx, [esi]
					; inc edx
					; mov [esi], edx
					; pop esi
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
		mov ebx, change
	ret
Up ENDP

;------------------------------------------------------
Down PROC
; Move down.
;-----------------------------------------------------
	; call resetCheck
	mov change, 0
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
				cmp [esi], eax
				je next
				inc change
				; if (game[crow+1][col]) change++
				jmp next

				notZero:
					mov eax, [esi]
					mov ebx, [esi-16]
					cmp eax, ebx
					jne next

					; mov ebp, OFFSET check
					; mov edx, crow
					; shl edx, 2
					; add ebp, edx
					; mov edx, 0
					; cmp [ebp], edx
					; jne next
					; check[crow] == 0

					shl eax, 1
					mov [esi], eax
					mov ebx, 0
					mov [esi-16], ebx
					inc change
					; change++;
					; push esi
					; mov esi, OFFSET check
					; mov edx, crow
					; shl edx, 2
					; add esi, edx
					; mov edx, [esi]
					; inc edx
					; mov [esi], edx
					; pop esi
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
		mov ebx, change
	ret

Down ENDP

;-----------------------------------------------------
Left PROC
; Move left.
;---------------------------------------------------
	; call resetCheck
	mov change, 0
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
				cmp [esi-4], eax
				je next
				inc change
				; if (game[row][ccol-1]) change++
				jmp next

				notZero:
					mov eax, [esi-4]
					mov ebx, [esi]
					cmp eax, ebx
					jne next

					; mov ebp, OFFSET check
					; mov edx, ccol
					; shl edx, 2
					; add ebp, edx
					; mov edx, 0
					; cmp [ebp], edx
					; jne next
					; check[ccol] == 0

					shl eax, 1
					mov [esi-4], eax
					mov ebx, 0
					mov [esi], ebx
					inc change
					; change++;
					; push esi
					; mov esi, OFFSET check
					; mov edx, ccol
					; shl edx, 2
					; add esi, edx
					; mov edx, [esi]
					; inc edx
					; mov [esi], edx
					; pop esi
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
		mov ebx, change
	ret
Left ENDP

;-----------------------------------------------------
Right PROC
; Move right.
;---------------------------------------------------
	; call resetCheck
	mov change, 0
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
				cmp [esi+4], eax
				je next
				inc change
				; if (game[row][ccol+1]) change++
				jmp next

				notZero:
					mov eax, [esi+4]
					mov ebx, [esi]
					cmp eax, ebx
					jne next

					; mov ebp, OFFSET check
					; mov edx, ccol
					; shl edx, 2
					; add ebp, edx
					; mov edx, 0
					; cmp [ebp], edx
					; jne next
					; check[ccol] == 0

					shl eax, 1
					mov [esi+4], eax
					mov ebx, 0
					mov [esi], ebx
					inc change
					; change++;
					; push esi
					; mov esi, OFFSET check
					; mov edx, ccol
					; shl edx, 2
					; add esi, edx
					; mov edx, [esi]
					; inc edx
					; mov [esi], edx
					; pop esi
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
		mov ebx, change
	ret
Right ENDP

;---------------------------------------------------------
resetCheck PROC
; Reset check array.
;---------------------------------------------------------
	mov ecx, 4
	mov esi, OFFSET check
	mov ebx, 0
	L1:
		mov [esi], ebx
		add esi, 4
		loop L1
	ret
resetCheck ENDP

END main

