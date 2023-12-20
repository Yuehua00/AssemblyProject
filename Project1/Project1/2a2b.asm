;---------------------------
; 2048 �M�D
; 411262283 �����
; 411262207 ���ɧD
;---------------------------

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
	InputWrong BYTE "Please enter again.", 0dh, 0ah, 0
	Lose BYTE "You lose!", 0dh, 0ah, 0
	Win BYTE "You win!", 0dh, 0ah, 0
	Continue BYTE "Do you want to play again? Y/N", 0dh, 0ah, 0
	EndGameS BYTE "Thanks for playing!", 0dh, 0ah, 0

	; Printmsg
	line BYTE "---------------------------------", 0dh, 0ah, 0
	blank7 BYTE "|       ", 0
	blank6 BYTE "|      ", 0
	blank5 BYTE "|     ", 0
	blank4 BYTE "|    ", 0
	blank3 BYTE "|   ", 0
	endLine BYTE "|", 0


	; data
	game DWORD 16 DUP (0)                ; �C���ѽL
	check DWORD 4 DUP (0)                ; �Ψ��קK�s��X��
	change DWORD 0                       ; �b���ʮ��ˬd�ѽL�O�_�����ܡA�H���P�_��J��V�O�_�����Ĥ�V
	direction BYTE 'w', 's', 'a', 'd'    ; ���ʤ�V
	input BYTE ?                         ; ���a��J�����ʤ�V
	startGame DWORD 0                    ; �O�_���Ĥ@���C��

	row DWORD ?
	crow DWORD ?
	col DWORD ?
	ccol DWORD ?


.code
main PROC
	
	LOCAL cnt : DWORD            ; �������a��J��V
	LOCAL wrongInput : DWORD     ; ���~��J
	LOCAL gameState : DWORD      ; �C�����A

	mov edx, OFFSET welcome      ; ��X�w��
	call WriteString
	call Crlf

	NewGame:
		call resetGame
		mov eax, 1
		inc startGame
		cmp startGame, eax          ; �P�_�O�_���Ĥ@���A�Ĥ@�����߰ݬO�_�~��
		je StartGameIt
		mov eax, 0
		call Readchar
		mov ebx, "Y"                 ; �C���O�_�~��? Y �~��
		cmp al, bl
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
			cmp gameState, ebx   ; �O�_���� (0 = ����)
			je CheckNow
			mov ebx, 2
			cmp gameState, ebx   ; �O�_���� (2 = ���� = 2048)
			je CheckNow
			mov wrongInput, 0
			mov eax, 0
			mov cnt, 0
			call ReadChar        ; Ū�J����� (��J�Ȧb al )
			mov input, al
			call writechar       ; ��ܭ���J��
			call crlf
		
		mov esi, OFFSET direction
		mov edx, 5        ; ��V�P�_���� ( = 5 ��ܿ�J���~)
		mov al, input
		L1:
			mov bl, [esi]
			inc cnt       ; �O�����Ӥ�V
			inc esi
			cmp cnt, edx
			je wrong
			cmp al, bl    ; ����V�r��
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
			 mov wrongInput, 1      ; ��ܥ��T��J
			 jmp next
		
		next:
			cmp ebx, 0              ; ���ʫ�^�ǬO�_�i��X�֪����G�s�� ebx �A ebx = 0 ��ܨS���i��X��
			je wrong
			call newNum
			call Game_now
			mov gameState, eax
			cmp wrongInput, 0
			je wrong
			call print
			jmp CheckNow
		wrong:                      ; ��J���~�h�n�D�R�s��J
			mov edx, OFFSET InputWrong
			call WriteString
			jmp Input00
		
	CheckNow:
		mov ebx, 2            ; gameState = 2 : 2048
		cmp gameState, ebx
		je WinGame
		mov ebx, 0            ; gameState = 0 : �L�k����
		cmp gameState, ebx
		jne Input00
		mov edx, OFFSET Lose  ; ��X lose
		call WriteString
		jmp NextGame          ; ���ܬO�_�~��C��

	WinGame:
		mov edx, OFFSET Win  ; ��X win
		call WriteString
	
	NextGame:
		mov edx, OFFSET Continue   ; �߰ݬO�_�U�@��
		call WriteString
		jmp NewGame

	EndGame:
		mov edx, OFFSET EndGameS   ; output end message
		call WriteString
             
	invoke ExitProcess, 0
exit
main ENDP

;---------------------------------------------------
resetGame PROC
; Reset game array.
;---------------------------------------------------
	LOCAL i : DWORD
	LOCAL j : DWORD

	mov i, 0                       ; ���� Row
	L1:
		mov esi, OFFSET game        
		mov eax, i      
		shl eax, 4                 ; i *= 16
		add esi, eax               ; esi ���V game �� i Row ���}�Y
		mov j, 0                   ; ���� Column
		L2:
			mov ebx, 0
			mov [esi], ebx         ; �N�C�@��M�Ŭ� 0
			inc j
			add esi, 4             ; eai ���V�U�@�� ( �]���O DWORD �ҥH +4)
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
	mov edx, 0   
	div ecx                         
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
	mov edx, 0                        
	idiv ecx                         
	mov eax, edx

	ret

creatPOS ENDP

;---------------------------------------------------------
newNum PROC USES esi ecx eax
; �N�ͦ����Ʀr�[�J��l
;-------------------------------------------------------
	LOCAL num : DWORD

	call Randomize        ; ��l��Random32���_�l�ؤl�ȡA�ؤl����@�Ѥ����ɶ��A��T��1/100��
	mov ecx, 3            ; %3
	call creatNUM
	mov num, eax          ; �ü�

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
	jne Pos            ; ���� 0 == ��l���F��A���s����
	mov [esi], eax
	
	ret
newNum ENDP

;-------------------------------------------------
Game_now PROC
; �^�ǹC�����p
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
			mov eax, [esi]
			cmp eax, edx          ; = 2048 ?
			je Find2048
			inc j
			mov eax, j
			add esi, 4
			cmp eax, 4
			jl Lj
		inc i
		cmp i, 4
		jl Li
	mov i, 0
	jmp Li2

	Find2048:
		mov eax, 2                ; ��� 2048 
		jmp quit

	Li2:
		mov esi, OFFSET game
		mov eax, i
		shl eax, 4
		add esi, eax
		mov j, 0
		Lj2:
			mov eax, [esi]
			cmp eax, 0
			je Zero

			checki:               ; �P�_ �k�� ����l�O�_�ۦP�Ʀr = �O�_�i�H�i��X��
				mov eax, i
				inc eax
				cmp eax, 4
				jge checkj
				mov eax, [esi]
				mov ebx, [esi+16]
				cmp eax, ebx
				jne checkj
				mov eax, 1
				jmp quit
			checkj:               ; �P�_ �U�� ����l�O�_�ۦP�Ʀr = �O�_�i�H�i��X��
				mov eax, j
				inc eax
				cmp eax, 4
				jge next
				mov eax, [esi]
				mov ebx, [esi+4]
				cmp eax, ebx
				jne next
				mov eax, 1
				jmp quit
			next:
			add esi, 4
			inc j
			mov eax, j
			cmp eax, 4
			jl Lj2
		inc i
		mov eax, i
		cmp eax, 4
		jl Li2
	mov eax, 0
	jmp quit
	
	Zero:                    ; �}�C�� 0 = �C���i�H�~��
		mov eax, 1
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
			mov eax, [esi]         ; �T�w�Ʀr���סA�M���X�����ťծ��
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
		mov edx, OFFSET endLine
		call WriteString
		pop ecx
		call Crlf
	loop L1

	mov edx, OFFSET line
	call WriteString

		
	ret

print ENDP

;----------------------------------------------------
Up PROC
; Move up.
;----------------------------------------------------
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

					shl eax, 1
					mov [esi], eax
					mov ebx, 0
					mov [esi+16], ebx
					inc change
				next:
					mov esi, OFFSET game
				inc col                        ; col++
				mov eax, col              
				cmp eax, 4                     ; col < 4
				jl forCol
			dec crow                           ; crow--
			mov eax, crow
			cmp eax, 1                         ; crow >= 1
			jge forCrow
		inc row                                ; row++
		mov eax, row
		cmp eax, 4                             ; row < Row = 4
		jl forRow
		mov ebx, change
	ret
Up ENDP

;------------------------------------------------------
Down PROC
; Move down.
;-----------------------------------------------------
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

					shl eax, 1
					mov [esi], eax
					mov ebx, 0
					mov [esi-16], ebx
					inc change

				next:
					mov esi, OFFSET game
				inc col                    ; col++
				mov eax, col
				cmp eax, 4                 ; col < Col = 4
				jl forCol
			inc crow                       ; crow++
			mov eax, crow
			cmp eax, 3                     ; crow < Row-1 = 3
			jl forCrow
		dec row                            ; row--
		mov eax, row
		cmp eax, 0                         ; row >= 0
		jge forRow
		mov ebx, change
	ret

Down ENDP

;-----------------------------------------------------
Left PROC
; Move left.
;---------------------------------------------------
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

					shl eax, 1
					mov [esi-4], eax
					mov ebx, 0
					mov [esi], ebx
					inc change
				next:
					mov esi, OFFSET game
				inc row                       ; row++
				mov eax, row
				cmp eax, 4                    ; row < Row = 4
				jl forRow
			dec ccol                          ; ccol--
			mov eax, ccol
			cmp eax, 1                        ; ccol >= 1
			jge forCcol
		inc col                               ; col++
		mov eax, col
		cmp eax, 4                            ; col < Col = 4
		jl forCol
		mov ebx, change
	ret
Left ENDP

;-----------------------------------------------------
Right PROC
; Move right.
;---------------------------------------------------
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

					shl eax, 1
					mov [esi+4], eax
					mov ebx, 0
					mov [esi], ebx
					inc change
				next:
					mov esi, OFFSET game
				inc row                     ; row++
				mov eax, row
				cmp eax, 4                  ; row < Row = 4
				jl forRow
			inc ccol                        ; ccol++
			mov eax, ccol
			cmp eax, 2                      ; ccol <= Col - 2 = 2
			jle forCcol
		dec col                             ; col--
		mov eax, col
		cmp eax, 0                          ; col >= 0
		jge forCol
		mov ebx, change
	ret
Right ENDP

END main