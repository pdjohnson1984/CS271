TITLE Program #2     (Program02.asm)

; Author / Email: Marc Tibbs (tibbsm@oregonstate.edu)
; Class / Project ID: CS271-400 / Program #2                 Due Date: 10/16/2017
; Description:	This program displays fibonacci numbers up to how many the user
; inputs that they would like to see. 

INCLUDE Irvine32.inc

FIB_LIMIT = 46
ONE = 1

.data
progTitle	BYTE	"Fibonacci Numbers (CS271-400 Program Assignment #2) ", 0
studentInfo	BYTE	"Programmed by: Marc Tibbs (tibbsm@oregonstate.edu) ", 0
ec1			BYTE	"**EC1: Display the numbers in aligned columns.", 0
prompt_1	BYTE	"What's your name? ", 0
userName	BYTE	33 DUP(0)
intro_1		BYTE	"Hello, ", 0
intro_2		BYTE	". Nice to meet you! ", 0
progInst_1	BYTE	"Instructions: ", 0 
progInst_2	BYTE	"Enter the number of Fibonacci terms to be displayed. ", 0 
progInst_3	BYTE	"Give the number as an integer in the range [1-46]. ", 0 
progInst_4	BYTE	"Enter the number of Fibonacci terms you want: ", 0 
progInst_5	BYTE	"Out of Range! Number must be in the range [1-46]: ", 0 
num_1		DWORD	?
count		DWORD	?
fib1		DWORD	1
fib2		DWORD	1
space		BYTE	"     ", 0 

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
	mov		edx, OFFSET	ec1
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
	jmp		getNum

;Start of user entry validation loop
tryAgain:
	mov		edx, OFFSET progInst_5
	call	WriteString
	call	CrLf
	call	CrLf

;Get number of fibonacci numbers wanted
getNum:
	mov		edx, OFFSET progInst_4
	call	WriteString
	call	ReadInt
	mov		num_1, eax

;Jump back if the number is greater/lower than the limits (1-46)
	mov		edx, num_1
	cmp		edx, FIB_LIMIT
	ja		tryAgain
	cmp		edx, ONE
	jl		tryAgain

;Calculate and display the fibonacci numbers up to the user's limit
	mov		ecx, num_1
	mov		count, 0

;Start of loop for calculting and printing the fibonacci numbers
fibTop:
	mov		eax, fib1
	call	WriteDec
	cmp		fib1, 9999999
	jbe		twoTab
	ja		oneTab

oneTab:
	mov		al, 9
	call	WriteChar
	jmp		afterTab

twoTab:
	mov		al, 9
	call	WriteChar
	call	WriteChar

afterTab:
	mov		eax, fib1
	mov		ebx, fib2
	mov		fib1, ebx
	add		eax, fib2
	mov		fib2, eax
	inc		count

;Check to see if program should start printing on the next line
	mov		edx, count
	cmp		edx, 5
	je		nextLine

;Jump back here after going to the next line in the output
cont:
	loop fibTop
	jmp		ender

;Go to the next line after printing 5 numbers
nextLine:
	call	CrLf
	mov		count, 0
	jmp		cont

;End of printing our the fibonacci numbers
ender:
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
