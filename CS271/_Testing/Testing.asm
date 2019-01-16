TITLE For Testing Purposes (testing.asm)  

; Author / Email: Marc Tibbs (tibbsm@oregonstate.edu)
; Class / Project ID: CS271-400 / Program #1                 Due Date: 10/08/2017
; Description:	This program is for tinkering and testing out snippets of code.

INCLUDE Irvine32.inc

MAXSIZE = 32

;***************************************************************
;displayString prints a string stored in a specified memory location.

displayString	MACRO stringOut
	push	edx
	mov		edx, stringOut
	call	WriteString
	pop		edx
ENDM
;***************************************************************

quiz4   MACRO p,q
        LOCAL here
        push   eax
        push   ecx
        mov    eax, p
        mov    ecx, q
here:
        mul    P
        loop   here

        mov    p, eax
        pop    ecx
        pop    eax
ENDM


.data
str1	BYTE	"Introduction",0

.code
main PROC

	mov	esi, OFFSET str1
	add	esi, 5
	mov	ecx, 4
	cld
more1:
	lodsb
	call	WriteChar
	loop	more1

	mov	ecx, 4
	std
more2:
	lodsb
	call	WriteChar
	loop	more2

	call crlf

	exit	; exit to operating system
main ENDP


END main
