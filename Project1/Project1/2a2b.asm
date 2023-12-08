; 1. 輸入
; 2. 比對答案
; 3. 答案產生，不能有重複
; 4. 文字有顏色
;--------------------------------
; 5. rank (?)
; 6. 自選答案長度
; 7. 可兌換功能牌
; ...
;---------------------------------------
; 函式庫引進教學 : https://knowlet3389.blogspot.com/2014/12/visual-studio-assembly.html


INCLUDE Irvine32.inc
.data
	; message
	welcome BYTE "Unlock the fun with a 4-digit code—no repeats allowed!",0dh ,0ah, 0dh, 0ah
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
	call print                 ; 測試用，要拿掉
	call WriteString
	call Crlf
	mov eax, 1h
	cmp continue, eax
	je StartGame
	jne EndGame

	StartGame:
		call Randomize        ; 初始化Random32的起始種子值，種子等於一天中的時間，精確到1/100秒
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
		; call WriteDec                  ; 用來看亂數本人
		mov edx, 0                        
		idiv ecx                         ; 取餘數，還沒解決重複數字
		mov [esi], edx                   ; 餘數在edx
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
			
			mov eax, [esi]     ; 有錯
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