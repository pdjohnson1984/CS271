TITLE Program #1     (Program01.asm)

; Author / Email: Marc Tibbs (tibbsm@oregonstate.edu)
; Class / Project ID: CS271-400 / Program #1                 Due Date: 10/08/2017
; Description:	This program will display the program's title and programmer's name, display instructions for the user,
;	prompt the user to input 2 numbers, show the sum, difference, product, quotient and remainder, then display a terminating
;	message.

INCLUDE Irvine32.inc

.data
progTitle	BYTE	"Elementary Arithmetic (CS271-400 Program Assignment #1) ", 0
ec1			BYTE	"**EC1: Repeat program until user chooses to quit. ", 0
ec2			BYTE	"**EC2: Validate the second number to be less than the first.. ", 0
ec3			BYTE	"**EC3: Calculate and display the quotient as a floating-point number, rounded to the nearest .001. ", 0
studentInfo	BYTE	"Created by: Marc Tibbs (tibbsm@oregonstate.edu) ", 0
progInstruc	BYTE	"Enter 2 numbers, and I'll show you their sum, difference, product, quotient and remainder. ", 0 
prompt_1	BYTE	"First Number: ", 0
prompt_2	BYTE	"Second Number: ", 0
try_again	BYTE	"[Second number must be less than the first and cannot be 0.] ", 0
equal		BYTE	" = ", 0
plus		BYTE	" + ", 0
minus		BYTE	" - ", 0
times		BYTE	" x ", 0
divided		BYTE	" / ", 0
remainder	BYTE	" remainder ", 0
floater		BYTE	".", 0
num_1		DWORD	?
num_2		DWORD	?
sum			DWORD	?
dif			DWORD	?
pro			DWORD	?
quo			DWORD	?
rem			DWORD	?
flo			DWORD	?
oneThou		DWORD	1000
goodbye		BYTE	"Thank you for testing me out. Goodbye :)", 0	
prompt_rpt	BYTE	"Enter '0' to quit. Enter any other number to try again. ", 0

.code
main PROC

;Introduce the program
	mov		edx, OFFSET progTitle
	call	WriteString
	call	CrLf

;Student info
	mov		edx, OFFSET	studentInfo
	call	WriteString
	call	CrLf
	call	CrLf

;Extra credit info
	mov		edx, OFFSET ec1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET ec2
	call	WriteString
	call	CrLf
	mov		edx, OFFSET ec3
	call	WriteString
	call	CrLf
	call	CrLf

;Program Instructions
	mov		edx, OFFSET progInstruc
	call	WriteString
	call	CrLf

;Start loop (Extra Credit 1)
	mov		ecx, 1
top:
	call	CrLf

;Get first number
	mov		edx, OFFSET prompt_1
	call	WriteString
	call	ReadInt
	mov		num_1, eax

;Start validation loop to check the second number is less than the first (Extra Credit 2)
TryAgain:
NoZero:

;Get second number
	mov		edx, OFFSET try_again
	call	WriteString
	call	CrLf
	mov		edx, OFFSET prompt_2
	call	WriteString
	call	ReadInt
	mov		num_2, eax
	call	CrLf

;Jump back if the second number is greater than the first
	mov		edx, num_1
	cmp		edx, num_2	
	jl		TryAgain

;Jump back if the second number is 0
	mov		edx, num_2
	cmp		edx, 0
	je		NoZero

;Calculate the sum
	mov		eax, num_1
	add		eax, num_2
	mov		sum, eax
	
;Display the sum
	mov		eax, num_1
	call	WriteDec
	mov		edx, OFFSET plus
	call	WriteString
	mov		eax, num_2
	call	WriteDec
	mov		edx, OFFSET equal
	call	WriteString
	mov		eax, sum
	call	WriteDec
	call	CrLf

;Calculate the difference
	mov		eax, num_1
	sub		eax, num_2
	mov		dif, eax
	
;Display the difference
	mov		eax, num_1
	call	WriteDec
	mov		edx, OFFSET minus
	call	WriteString
	mov		eax, num_2
	call	WriteDec
	mov		edx, OFFSET equal
	call	WriteString
	mov		eax, dif
	call	WriteDec
	call	CrLf

;Calculate the product
	mov		eax, num_1
	mul		num_2
	mov		pro, eax
	
;Display the product
	mov		eax, num_1
	call	WriteDec
	mov		edx, OFFSET times
	call	WriteString
	mov		eax, num_2
	call	WriteDec
	mov		edx, OFFSET equal
	call	WriteString
	mov		eax, pro
	call	WriteDec
	call	CrLf

;Calculate the quotient and remainder
	mov		eax, num_1
	mov		ebx, num_2
	cdq
	div		ebx
	mov		quo, eax
	mov		rem, edx
	
;Display the quotient and remainder
	mov		eax, num_1
	call	WriteDec
	mov		edx, OFFSET divided
	call	WriteString
	mov		eax, num_2
	call	WriteDec
	mov		edx, OFFSET equal
	call	WriteString
	mov		eax, quo
	call	WriteDec
	mov		edx, OFFSET remainder
	call	WriteString
	mov		eax, rem
	call	WriteDec
	call	CrLf

;Calculate the floating-point number (Extra Credit 3)
	mov		rem, eax
	mul		oneThou
	mov		ebx, num_2
	cdq
	div		ebx	
	mov		flo, eax

;Check the ten-thousandth's digit and round if necessary
	mov		eax, edx
	mov		ebx, 10
	mul		ebx
	mov		ebx, num_2
	cdq
	div		ebx	
	cmp		eax, 5
	jae		RoundUp			;if digit is >= 5, round up
	jb		NoRound			;else do nothing
	
RoundUp:
	mov		eax, flo
	mov		ebx, 1
	add		eax, ebx
	mov		flo, eax

NoRound:

;Display the quotient and remainder
	mov		eax, num_1
	call	WriteDec
	mov		edx, OFFSET divided
	call	WriteString
	mov		eax, num_2
	call	WriteDec
	mov		edx, OFFSET equal
	call	WriteString
	mov		eax, quo
	call	WriteDec
	mov		edx, OFFSET floater
	call	WriteString
	mov		eax, flo
	call	WriteDec
	call	CrLf
	call	CrLf

;Ask if user would like to try again
	mov		edx, OFFSET prompt_rpt
	call	WriteString
	call	CrLf
	call	ReadInt
	mov		ecx, eax
	jnz		top

;Say goodbye
	mov		edx, OFFSET goodbye
	call	WriteString
	call	CrLf

	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
