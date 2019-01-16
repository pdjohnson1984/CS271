TITLE Program #3     (Program3.asm)

; Author / Email: Marc Tibbs (tibbsm@oregonstate.edu)
; Class / Project ID: CS271-400 / Program #3                 Due Date: 10/29/2017
; Description:	This program accumulates the numbers the user inputs and returns the
; number of valid numbers that were input, their sum, and rounded average.

INCLUDE Irvine32.inc

LOW_LIMIT = -100
UP_LIMIT = -1

.data
progTitle	BYTE	"Integer Accumulator (CS271-400 Program Assignment #3) ", 0
ec1			BYTE	"**EC1: Number the lines during user input. ", 0
ec2			BYTE	"**EC2: Calculate and display the average as a floating-point number, rounded to the nearest .001.", 0
studentInfo	BYTE	"Programmed by: Marc Tibbs (tibbsm@oregonstate.edu) ", 0
prompt_1	BYTE	"What's your name? ", 0
userName	BYTE	33 DUP(0)
intro_1		BYTE	"Hello, ", 0
intro_2		BYTE	"! ", 0
progInst_1	BYTE	"Instructions: ", 0 
progInst_2	BYTE	"Enter numbers in the range [-100, -1]. ", 0 
progInst_3	BYTE	"Enter a non-negative number when you are finished to see their count, sum, and average. ", 0 
progInst_4	BYTE	". Enter number: ", 0 
outOfRange	BYTE	"Out of Range! Number must be in the range [-100, -1]. ", 0 
finalCnt_1	BYTE	"You entered ", 0 
finalCnt_2	BYTE	" valid numbers. ", 0 
finalSum	BYTE	"The sum of your valid numbers is ", 0 
finalAvg	BYTE	"The rounded average is -", 0 
floatAvg	BYTE	"The average rounded to the nearest thousandth is -", 0 
point		BYTE	".", 0
num			DWORD	?
count		DWORD	?
sum			DWORD	?
avg			DWORD	?
frac		DWORD	?
lineNum		DWORD	1
oneThou		DWORD	1000
goodbye1	BYTE	"Thanks for your time, ", 0	
goodbye2	BYTE	". Goodbye :D", 0	

.code
main PROC

;Program info
	mov		edx, OFFSET progTitle
	call	WriteString
	call	CrLf

;Student info
	mov		edx, OFFSET	studentInfo
	call	WriteString
	call	CrLf
	call	CrLf

;Extra Credit Info
	mov		edx, OFFSET ec1
	call	WriteString
	call	CrLf	
	mov		edx, OFFSET ec2
	call	WriteString
	call	CrLf	
	call	CrLf

;Get user name
	mov		edx, OFFSET prompt_1
	call	WriteString
	mov		edx, OFFSET userName
	mov		ecx, 32
	call	ReadString
	mov		edx, OFFSET intro_1
	call	WriteString
	mov		edx, OFFSET userName
	call	WriteString
	mov		edx, OFFSET intro_2
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
	jmp		GetNum

;Display out of range message
OutOR:
	mov		edx, OFFSET outOfRange
	call	WriteString
	call	CrLf
	call	CrLf

;Get user number
GetNum:
	mov		eax, lineNum
	call	WriteDec
	mov		edx, OFFSET progInst_4
	call	WriteString
	call	ReadInt

;Validate if number is positive
	cmp		eax, UP_LIMIT
	jg		Ender

;Validate the number is in range
	cmp		eax, LOW_LIMIT
	jb		OutOR

;If the number is valid, add to count and sum
	add		sum, eax
	inc		count
	inc		lineNum

;Get next number
	jmp		getNum

Ender:

;Display the count
	call	CrLf
	mov		edx, OFFSET finalCnt_1
	call	WriteString
	mov		eax, count
	call	WriteDec
	mov		edx, OFFSET finalCnt_2
	call	WriteString
	call	CrLf

;Display the sum
	mov		edx, OFFSET finalSum
	call	WriteString
	mov		eax, sum
	call	WriteInt
	call	CrLf

;Calculate the average
	mov		eax, sum
	mov		ebx, count
	cdq
	idiv	ebx
	mov		avg, eax

;Calculate the fractional
	mov		eax, edx
	neg		eax
	mul		oneThou
	div		ebx
	mov		frac, eax

;Round to the nearest thousandth
	mov		eax, edx
	mov		ebx, 10
	mul		ebx
	mov		ebx, count
	cdq
	div		ebx
	cmp		eax, 5
	jae		RoundUp
	jb		NoRound

RoundUp:
	inc		frac

NoRound:

;Display the average
	mov		edx, OFFSET finalAvg
	call	WriteString
	neg		avg
	mov		eax, avg
	call	WriteDec
	call	CrLf

;Display the floating point average
	mov		edx, OFFSET floatAvg
	call	WriteString
	mov		eax, avg
	call	WriteDec
	mov		edx, OFFSET point
	call	WriteString
	mov		eax, frac
	call	WriteDec
	call	CrLf
	call	CrLf

;Say goodbye
	mov		edx, OFFSET goodbye1
	call	WriteString
	mov		edx, OFFSET userName
	call	WriteString
	mov		edx, OFFSET goodbye2
	call	WriteString
	call	CrLf
	call	CrLf

	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
