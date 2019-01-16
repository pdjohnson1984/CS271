TITLE Program #5     (Program05.asm)

; Author / Email: Marc Tibbs (tibbsm@oregonstate.edu)
; Class / Project ID: CS271-400 / Program #5                Due Date: 11/19/2017
; Description:	This program generates random numbers in the range 100 - 999. 
; It displays the original list, sorts the list, and calculates the median value. 
; Finally, it displays the list sorted in descending order.


INCLUDE Irvine32.inc

;Random integer range
HI = 999
LO = 100

;User integer request limits
MIN = 10
MAX = 200

.data
progTitle	BYTE	"Sorting Random Integers (CS271-400 Program Assignment #5) ", 0
studentInfo	BYTE	"Programmed by: Marc Tibbs (tibbsm@oregonstate.edu) ", 0
progInst_1	BYTE	"Instructions: ", 0 
progInst_2	BYTE	"Please input how many numbers you would like to be generated. ", 0 
progInst_3	BYTE	"Give the number as an integer in the range [10...200]. ", 0 
progInst_4	BYTE	"How many numbers should be generated? [10...200]: ", 0 
progInst_5	BYTE	"Out of Range! Try again. ", 0 
progDesc_1	BYTE	"This program generates random numbers in the range [100 .. 999], ", 0
progDesc_2	BYTE	"displays the original list, sorts the list, and calculates the median value. ", 0
progDesc_3	BYTE	"Finally, it displays the list sorted in descending order. ", 0
request		DWORD	?
array		DWORD	MAX DUP(0)
tempArray	DWORD	MAX	DUP(0)
srtTitle	BYTE	"The unsorted random numbers: ", 0
unsrtTitle	BYTE	"The sorted list: ", 0
medTitle	BYTE	"The median is: ", 0
ec1			BYTE	"**EC1: Display the numbers ordered by column instead of by row."


.code
main PROC

;initialize random generator
	call	Randomize					

;introduce the program
	push	OFFSET ec1						;pass ec1 by reference
	push	OFFSET progInst_3				;pass progInsts	by reference
	push	OFFSET progInst_2				;pass progInsts	by reference
	push	OFFSET progInst_1				;pass progInsts	by reference
	push	OFFSET progDesc_3				
	push	OFFSET progDesc_2				
	push	OFFSET progDesc_1				;pass progDescs by reference
	push	OFFSET studentInfo				;pass studentInfo by reference
	push	OFFSET progTitle				;pass progTitle by reference
	call	introduction		
	
;get user request for integer generator
	push	OFFSET progInst_4			;pass progInst_4 by reference
	push	OFFSET progInst_5			;pass progInst_5 by reference
	push	OFFSET request				;pass request by reference
	call	getData						

;fill array with random numbers
	push	OFFSET array				;pass array by reference
	push	request						;pass request by value
	call	fillArray					;fill array with random integers

;prints the contents of the array (unsorted)
	push	OFFSET srtTitle				;pass title by reference
	push	OFFSET array				;pass array by reference
	push	request						;pass request by value
	call	displayList					

;sort the array
	push	OFFSET array				;pass array by reference
	push	request						;pass request by value
	call	sortList
	
;prints the median of the array (sorted)
	push	OFFSET medTitle				;pass title by reference
	push	OFFSET array				;pass array by reference
	push	request						;pass request by value
	call	displayMed					

;prints the contents of the array (sorted)
	push	OFFSET unsrtTitle			;pass title by reference
	push	OFFSET array				;pass array by reference
	push	request						;pass request by value
	call	displayList					

	exit								; exit to operating system
main ENDP

;*************INTRODUCTION***************************************
;Procedure to introduce the program.
;receives: program title, description, instructions by reference
;			student info also passed by reference
;returns: none
;preconditionals: none
;registers changed: edx, ebp, esp
; ***************************************************************

introduction PROC

;Setup Stack Frame
	push	ebp
	mov		ebp, esp

;Get address of progTitle into edx
	mov		edx, [ebp+8]

;Print progTitle
	call	WriteString
	call	CrLf

;Get address of studentInfo into edx
	mov		edx, [ebp+12]

;Print student info
	call	WriteString
	call	CrLf
	call	CrLf

;Get address of progDescs into edx 
;Then print program description
	mov		edx, [ebp+16]				;progDesc_1 into edx
	call	WriteString
	call	CrLf
	mov		edx, [ebp+20]				;progDesc_2 into edx	
	call	WriteString
	call	CrLf
	mov		edx, [ebp+24]				;progDesc_3 into edx
	call	WriteString
	call	CrLf
	call	CrLf

;Extra Credit Info
	mov		edx, [ebp+40]		
	call	WriteString
	call	CrLf
	call	CrLf

;Program Instructions
	mov		edx, [ebp+28]				;progInst_1 into edx
	call	WriteString
	call	CrLf
	mov		edx, [ebp+32]				;progInst_2 into edx
	call	WriteString
	call	CrLf
	mov		edx, [ebp+36]				;progInst_3 into edx
	call	WriteString
	call	CrLf
	call	CrLf

;Restore stack
	pop		ebp

	ret		36
introduction ENDP

; ******GETDATA**************************************************
;Procedure to get the number of random integers to generate and sort.
;receives: address of request parameter on the stack and progInst 4&5
;returns: user input value for the number of integers to be generated
;preconditionals: none
;registers changed: eax, ebx, edx, ebp, esp
; ***************************************************************

getData PROC

;Setup Stack Frame
	push	ebp
	mov		ebp, esp

;Get address of request into ebx
	mov		ebx, [ebp+8]

;Initial jump ahead to skip the invalid data entry message
	jmp		getNum

;Instructions for invalid data entries
tryAgain:
	mov		edx, [ebp+12]				;get address of prog_5 into edx
	call	WriteString
	call	CrLf
	call	CrLf

;Prompt user for number of intergers to be generated
getNum:
	mov		edx, [ebp+16]				;get address of prog_4 into edx
	call	WriteString
	call	ReadInt

;Validate that the user input is in range
	cmp		eax, MAX					
	ja		tryAgain
	cmp		eax, MIN
	jb		tryAgain

;Store user input at address in ebx
	mov		[ebx], eax					
	call	CrLf

;Restore stack
	pop		ebp

;Return and remove 12 bytes from stack
	ret		12
getData ENDP

; ******FILLARRAY**************************************************
;Procedure to fill the array with random numbers
;receives: the value of reuqest parameter and address 
;          of array parameter on the stack
;returns: an array filled with random integers
;preconditionals: request is initialized, 0<=request<=999
;registers changed: eax, ebx, ecx, edi,
; ***************************************************************

fillArray PROC

;Setup Stack Frame
	push	ebp
	mov		ebp, esp
	mov		ecx, [ebp+8]		; get request in ecx
	mov		edi, [ebp+12]		; get address of array in edi

next:
	mov		eax, HI-99			;get HI into eax (0-899)
	call	RandomRange			;generate random integer
	add		eax, 100			;adjust for min (100-999)
	mov		[edi], eax			;get random int into @ in edi
	add		edi, 4				;increment edi by 4, next arr item
	loop	next				

;Restore stack
	pop		ebp

;Return and remove 8 bytes from stack
	ret		8

fillArray ENDP

; *****SORTLIST**************************************************
;Sorts the passed array
;receives: the value of request parameter and address 
;          of array parameter on the stack
;returns: an sorted array
;preconditionals: array is filled with random integers
;registers changed: eax, ebx, ecx, edx, ebp, esp, edi
; ***************************************************************

sortList PROC

;Setup Stack Frame
	push	ebp
	mov		ebp, esp

	mov		ecx, [ebp+8]		; request in ecx
	dec		ecx					; outer loop counter (request-1)
	mov		edi, [ebp+12]		; address of array in edi
	mov		ebx, edi			; get address of array in ebx

sortNext:						;outer loop
	mov		eax, edi			;get address of current array item in eax
	mov		esi, ecx			;get ecx in esi to save counter

	compareNext:
	add		edi, 4				;increment address in edi (next item)

	mov		edx, [eax]			;get value in stored in @ in eax into edx
	cmp		edx, [edi]			;compare value in edi with the one in edx
	ja		keep				;if edx value greater, jump ahead
	mov		eax, edi			;get @ from edi in eax

keep:
	loop	compareNext

	mov		edx, [ebx]			;get number from list position in edx
	xchg	[eax], edx			;xchg largest number and number in list location
	xchg	[ebx], edx			;xchg list number into open space left by lrgest

	add		ebx, 4				;increment ebx to next item in array
	mov		edi, ebx			;get the next list position in edi
	mov		ecx, esi			;restore outer loop counter

	loop	sortNext 

;Restore stack
	pop		ebp

;Return and remove 8 bytes from stack
	ret		8

sortList ENDP


; *****DISPLAYLIST**************************************************
;Prints an array of integers
;receives: the value of request parameter and address 
;          of array parameter on the stack
;returns: none
;preconditionals: array is filled with integers
;registers changed: eax, ebx, ecx, edx, ebp, esp, edi, esi
; ***************************************************************

displayList PROC

;Setup Stack Frame
	push	ebp
	mov		ebp, esp
	
;Print list title
	mov		edx, [ebp+16]		; get address of title in al
	call	WriteString			
	call	CrLf

	mov		ecx, 200			; loop counter
	mov		edi, [ebp+12]		; get address of array in edi

;initialize print counter
	mov		ebx, 0		

printNext:
	mov		eax, [edi]			;get array int into eax
	cmp		eax, MIN
	jb		blank
	call	WriteDec

blank:

;Tab space between numbers
	mov		al, 9
	call	WriteChar

;Increment print counter
	inc		ebx

;Increment edi(array position)
	add		edi, 80	

;Check to see if program should start printing on the next line
	cmp		ebx, 10
	je		nextLine

;Jump back here after going to the next line in the output
cont:
	loop	printNext
	jmp		ender

;Go to the next line after printing 10 numbers
nextLine:
	call	CrLf
	mov		ebx, 0			;reset print counter
	sub		edi, 796
	jmp		cont

;End of printing the composite numbers
ender:
	call	CrLf
	call	CrLf

;Restore stack
	pop		ebp

;Return and remove 8 bytes from stack
	ret		8

displayList ENDP

; *****DISPLAYMED**************************************************
;Prints an median of an array list
;receives: the value of request parameter and address 
;          of array and title parameter on the stack
;returns: median of the list
;preconditionals: array is filled with sorted integers
;registers changed: eax, ebx, ecx, edx, ebp, esp
; ***************************************************************

displayMed PROC

;Setup Stack Frame
	push	ebp
	mov		ebp, esp

	mov		eax, [ebp+8]		; get request in ecx
	mov		edi, [ebp+12]		; get address of array in edi
	mov		edx, [ebp+16]		; get address of title in edx

;Print list title
	call	WriteString
	call	CrLf

;Divide request by 2
	mov		ecx, 2				
	cdq
	div		ecx

;If there's remainder (odd), else (even)
	cmp		edx, 0
	je		evenNum

;If odd, print int in middle of the range
	mov		ecx, 4				;get size of array type in ecx
	mul		ecx					;mult quotient(eax) by ecx
	add		edi, eax			;add product to edi (middle of range)
	mov		eax, [edi]			;get the middle int into eax
	call	WriteDec			
	jmp		endMed

;If even, print avg of the ints in middle of range
evenNum:
	mov		ecx, 4				;get size of array type in ecx
	mul		ecx					;mult quotient(eax) by ecx
	add		edi, eax			;add product to edi (@ of 1st int)
	mov		eax, [edi]			;first int into eax
	sub		edi, ecx			;sub by type size (@ of 2nd int)
	add		eax, [edi]			;add second int to first int
	mov		ecx, 2				
	cdq
	div		ecx					;get average of the two numbers
	cmp		edx, 0				;check if need to round up
	je		noRound				;skip round up	
	inc		eax					;round up

noRound:
	call	WriteDec

endMed:
	call	CrLf
	call	CrLf

;Restore stack
	pop		ebp

;Return and remove 8 bytes from stack
	ret		8

displayMed ENDP

END main
