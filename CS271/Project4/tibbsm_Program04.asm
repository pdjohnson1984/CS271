TITLE Program #4     (Program04.asm)

; Author / Email: Marc Tibbs (tibbsm@oregonstate.edu)
; Class / Project ID: CS271-400 / Program #4                 Due Date: 11/05/2017
; Description:	This program displays composite numbers up to how many the user
; inputs that they would like to see. 

INCLUDE Irvine32.inc

COMP_LIMIT = 400
ONE = 1

.data
progTitle	BYTE	"Composite Numbers (CS271-400 Program Assignment #4) ", 0
studentInfo	BYTE	"Programmed by: Marc Tibbs (tibbsm@oregonstate.edu) ", 0
ec1			BYTE	"**EC1: Display the numbers in aligned columns.", 0
progInst_1	BYTE	"Instructions: ", 0 
progInst_2	BYTE	"Enter the number of composite numbers to be displayed. ", 0 
progInst_3	BYTE	"Give the number as an integer in the range [1...400]. ", 0 
progInst_4	BYTE	"Enter the number of composite numbers to display [1...400]: ", 0 
progInst_5	BYTE	"Out of Range! Try again. ", 0 
userLimit	DWORD	?
isValid		DWORD	?
count		DWORD	?
comp		DWORD	2
isComp		DWORD	0

goodbye1	BYTE	"Thanks for your time. Goodbye :D ", 0	

.code
main PROC

	call	introduction	

	call	getUserData		

	call	showComposites	

	call	farewell		

	exit					; exit to operating system
main ENDP


;Procedure to introduce the program.
;receives: none
;returns: none
;preconditionals: none
;registers changed: edx
introduction PROC

;Program info
	mov		edx, OFFSET progTitle
	call	WriteString
	call	CrLf

;Student info
	mov		edx, OFFSET	studentInfo
	call	WriteString
	call	CrLf
	mov		edx, OFFSET	ec1
	call	WriteString
	call	CrLf
	call	CrLf

;Program Instructions
	mov		edx, OFFSET progInst_1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET progInst_2
	call	WriteString
	call	CrLf
	mov		edx, OFFSET progInst_3
	call	WriteString
	call	CrLf
	call	CrLf

	ret
introduction ENDP


;Procedure to get the number of composite numbers to be seen by the user.
;receives: none
;returns: user input value for userLimit variable
;preconditionals: none
;registers changed: eax, edx
getUserData PROC

	jmp		getNum

;Instructions for invalid data entries
tryAgain:
	mov		edx, OFFSET progInst_5
	call	WriteString
	call	CrLf
	call	CrLf

;Get number of composite numbers wanted
getNum:
	mov		edx, OFFSET progInst_4
	call	WriteString
	call	ReadInt
	call	CrLf
	mov		userLimit, eax

;Validate that the user numbers is in range.
	call	validate

;Jump back if the number is not valid
	mov		edx, isValid
	cmp		edx, 0
	je		tryAgain

	ret
getUserData ENDP



;Procedure to validate that the users input is in range.
;receives: userLimit is a global variable
;returns: global variable isValid
;preconditionals: none
;registers changed: edx
validate PROC

;Check if the user input is greater/lower than the limits (1-400)
	mov		edx, userLimit
	cmp		edx, COMP_LIMIT
	ja		outOfRange
	cmp		edx, ONE
	jl		outOfRange

;If it is in range, flag the number as valid
	mov		isValid, 1
	jmp		validated

;If it is NOT in range, flag the number as INVALID
outOfRange:
	mov		isValid, 0

validated:
	ret
validate ENDP





;Procedure to display composite numbers.
;receives: global variable userLimit
;returns: global variable comp
;preconditionals: none
;registers changed: ecx, edx
showComposites PROC

;Set the user's limit as the loop limit & initialize counter to 0
	mov		ecx, userLimit
	mov		count, 0

;Start of the loop to print composite numbers 
compTop:

	inc		comp

;Save registers
	pushad	

;Check if the current number is a composite number
	call	isComposite

;Restore registers
	popad

;If the number is marked as a composite number print the number
;Otherwise, go to the next number
	cmp		isComp, 0
	je		compTop
	jne		print

print:
	mov		eax, comp
	call	WriteDec

;Tab space between numbers
	mov		al, 9
	call	WriteChar

;Increase counter for numbers printed
	inc		count

;Check to see if program should start printing on the next line
	mov		edx, count
	cmp		edx, 10
	je		nextLine

;Jump back here after going to the next line in the output
cont:
	loop compTop
	jmp		ender

;Go to the next line after printing 10 numbers
nextLine:
	call	CrLf
	mov		count, 0
	jmp		cont

;End of printing the composite numbers
ender:
	call	CrLf
	call	CrLf

	ret
showComposites ENDP




;Procedure to check if a number is composite
;receives: global variable comp
;returns: global variable isComp
;preconditionals: none
;registers changed: eax, ebx, ecx, edx
isComposite PROC

;Initialize the "isComp" flag to 0(false)
	mov		isComp, 0

;Initialize the loop count to the number being tested
;Subtract 2 from the loop as we will not divide it by itself or 1
	mov		ecx, comp
	sub		ecx, 2

;Initialize the divisor. We will decrement it shortly.
	mov		ebx, comp

compCheck:
;Repeatedly initialize the dividend to the number being tested
	mov		eax, comp

;Decrement the divisor with each loop and divide. 
	dec		ebx
	cdq
	div		ebx

;Check if the remainder is 0.
;If the remainder is 0, it is composite/not prime.
	cmp		edx, 0
	je		notPrime
	loop compCheck

;If the number is never flagged as composite, it is prime.
	jmp	checked

;Flag that the number is composite.
notPrime:
	mov		isComp, 1

checked:

	ret
isComposite ENDP


;Procedure display parting message to the user. 
;receives: none
;returns: none
;preconditionals: none
;registers changed: edx
farewell PROC

;Display the farewell message for the user.
	mov		edx, OFFSET goodbye1
	call	WriteString
	call	CrLf
	call	CrLf

	ret
farewell ENDP


END main
