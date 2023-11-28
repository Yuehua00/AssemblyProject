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

	; data
	ans DWORD 4 DUP(?)
	input DWORD 4 DUP(?)
	continue DWORD 1h

	tmp DWORD 0

.code
main PROC
	mov edx, OFFSET welcome
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

	call WaitMsg              

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

END main