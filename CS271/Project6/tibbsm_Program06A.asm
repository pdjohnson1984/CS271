;***************************************************************
	TITLE: Program #6A     (Program06A.asm)
;***************************************************************
; Author / Email: Marc Tibbs (tibbsm@oregonstate.edu)
; Class / Project ID: CS271-400 / Program #6                
; Due Date: 12/3/2017
; Description:	This program takes (and verifies) 10 unsigned numbers from the user
;				and prints the list of numbers, their sum and average.
;***************************************************************


INCLUDE Irvine32.inc

HI = 4294967295  						; user entry upper limit
LO = 0									; user entry lower limit
MAX = 10								; number of integers the program will accept rom user
MAXSIZE = 32							; 32-bit/DWORD


;***************************************************************
; displayString Macro
;***************************************************************
;displayString prints a string stored in a specified memory location.

displayString	MACRO stringOut
	push	edx
	mov		edx, stringOut
	call	WriteString
	pop		edx
ENDM
;***************************************************************


;***************************************************************
; getString Macro
;***************************************************************
;getString displays a prompt, then get the user’s keyboard input 
;into a memory location

getString	MACRO prompt, stringIn
	push	edx
	push	ecx
	displayString prompt
	mov		edx, stringIn
	mov		ecx, MAXSIZE - 1 
	call	ReadString
	mov		[stringIn], edx
	pop		ecx
	pop		edx
ENDM
;***************************************************************




.data



;***************************************************************
progTitle	BYTE	"Designing low-level I/O proceduress (CS271-400 Program Assignment #6) ", 0
studentInfo	BYTE	"Programmed by: Marc Tibbs (tibbsm@oregonstate.edu) ", 0
progInst_1	BYTE	"Instructions: Please provide 10 unsigned decimal integers.", 0 
progInst_2	BYTE	"Each number needs to be small enough to fit inside a 32 bit register. ", 0 
progInst_3	BYTE	"After you have finished inputting the numbers I will display a list of", \
					"the integers, their sum, and their average.", 0 
progInst_4	BYTE	"Please enter an unsigned number: ", 0 
progInst_5	BYTE	"ERROR: You did not enter an unsigned number or your number was too big. ", 0 
stringIn	BYTE	MAXSIZE DUP (?)
numOut		DWORD	?
numIn		DWORD	?
stringOut	BYTE	MAXSIZE DUP (?)
array		DWORD	MAX DUP(?)
dspList		BYTE	"You entered the following numbers: ", 0
sumTitle	BYTE	"The sum of these numbers is: ", 0
avgTitle	BYTE	"The average is: ", 0
sum			DWORD	?
average		DWORD	?
goodbye		BYTE	"Goodbye!",0
;***************************************************************



.code



;***************************************************************
;Main Procedure
;***************************************************************
main PROC

;introduce the program 
	push	OFFSET progInst_3				
	push	OFFSET progInst_2				
	push	OFFSET progInst_1				
	push	OFFSET studentInfo				
	push	OFFSET progTitle				
	call	introduction		
	
;get user data stored into an array
	push	OFFSET array		
	push	OFFSET progInst_4			
	push	OFFSET progInst_5			
	push	OFFSET numOut
	push	OFFSET stringIn	
	call	getData

;calculate the sum and average
	push	OFFSET sum
	push	OFFSET average
	push	OFFSET array
	call	calculate

;display the results
	push	OFFSET goodbye
	push	OFFSET dspList
	push	OFFSET average
	push	OFFSET sum
	push	OFFSET sumTitle
	push	OFFSET avgTitle
	push	OFFSET array
	push	OFFSET stringOut
	call	displayResults

	exit								; exit to operating system
main ENDP
;***************************************************************


;***************************************************************
;introduction Procedure
;*************INTRODUCTION**************************************
;Procedure to introduce the program.
;receives: program title, description, instructions by reference
;			student info also passed by reference
;returns: none
;preconditionals: none
;registers changed: ebp, esp
;***************************************************************
introduction PROC

;Setup Stack Frame
	push	ebp
	mov		ebp, esp

;Print progTitle
	displayString [ebp+8]
	call	CrLf

;Print studentInfo 
	displayString [ebp+12]
	call	CrLf
	call	CrLf

;Program Instructions
	displayString [ebp+16]				;progInst_1 
	call	CrLf
	displayString [ebp+20]				;progInst_2 
	call	CrLf	
	displayString [ebp+24]				;progInst_3 
	call	CrLf
	call	CrLf

;Restore stack
	pop		ebp

	ret		20
introduction ENDP
;***************************************************************



;***************************************************************
; readVal Procedure
;***************************************************************
;Procedure invokes the getString macro to get the user’s string 
;of digits. It then converts the digit string to numeric, while 
;validating the user’s input.
;receives:	- address of stringIn parameter on the stack 
;			- address of numOut paramter on the stack 
;			- addresses of progInst 4 & 5 on the stack 
;returns: numeric value of string input
;preconditionals: none
;registers changed: eax, ebx, ecx, edx, ebp, esp, esi
; ***************************************************************
readVal PROC

;Setup Stack Frame
	push	ebp
	mov		ebp, esp

;Save registers
	pushad

;Initial jump ahead to skip the invalid data entry message
	jmp		getNum

;Instructions for invalid data entries
tryAgain:
	displayString [ebp+16]				;print prog_5 instruction (Error)
	call	CrLf	
	call	CrLf

;Prompt user for input
getNum:
	
	getString [ebp+20], [ebp+8]			;print prog_4 and get user input
	call	CrLf

	mov		edx, 0						;initialize numeric value
	mov		ebx, 10						;multiplier for each digit
	mov		ecx, eax					;length of user input
	mov		esi, [ebp+8]				;user input
	cld									;clear direction flag

converter:
	lodsb								;load string byte

	cmp		al, 48						;'0' is char 48
	jb		tryAgain
	cmp		al, 57						;'9' is char 57
	ja		tryAgain

	sub		al, 48						;adjust ASCII
	movzx	edi, al	

	mov		eax, edx					;numeric value in eax
	mul		ebx							;multiply by 10
	add		eax, edi					;add last digit to the numeric value
	mov		edx, eax					;save new num into edx

	loop	converter

;Validate that the user input is in range
	cmp		edx, HI						
	ja		tryAgain
	cmp		edx, LO						
	jb		tryAgain

;Store user input at address (numOut)	
	mov		eax, [ebp+12]				
	mov		[eax], edx

;Restore registers
	popad

;Restore stack
	pop		ebp

;Return and remove 16 bytes from stack
	ret		16
readVal ENDP
;***************************************************************



;***************************************************************
; writeVal Procedure										   
;***************************************************************
;description: converts a numeric value to a string of digits, 
;and invoke the displayString macro to produce the output.
;receives:	-the address of stringOut parameter on the stack
;			-the address of array parameter on the stack
;returns: string with numeric value
;preconditionals: none
;registers changed: eax, ebx, ecx, edx, ebp, esp, esi, edi
;***************************************************************
writeVal PROC

;Setup Stack Frame
	push	ebp
	mov		ebp, esp

;Save registers
	pushad

;get address in esi
	mov		esi, [ebp+8]

;initialize counter in ecx
	mov		ecx, 0			

;get value @ esi in eax
	mov		eax, [esi]	
	cdq

;get 10 in ebx
	mov		ebx, 10

;get the length of the string/number
stringLength:


	mov		edx, 0						;clear edx

	div		ebx							;divide numeric val. by 10
	cdq

	inc		ecx							;increment counter

	cmp		eax, 0			
	ja		stringLength				;loop until number is 0

;get value @ esi in eax
	mov		eax, [esi]					;move numeric value in eax
	cdq

	mov		edi, [ebp+12]				;move @ of stringOut in edi
	dec		ecx							;decrement the str. len. counter
	add		edi, ecx					;address of last digit in edi

toString:
	mov		edx, 0						;clear edx
	
	div		ebx							;divide num. val. by 10

	mov		ecx, eax					;move dividend in ecx

	mov		eax, edx					;move remainder in eax

	add		al, 48						;ASCII adjust

	std									;direction = reverse
	stosb								;store EAX into [EDI] (stringOut)
	
	mov		eax, ecx					;move dividend back in EAX 
	cdq
	cmp		eax, 0						;jump back if above 0
	ja		toString						

	displayString [ebp+12]				;print final string 

	mov		eax, 0
	mov		[edi], eax					;clear stringOut

;Restore registers
	popad

;Restore stack
	pop		ebp

;Return and remove 8 bytes from stack
	ret		8

writeVal ENDP
;***************************************************************

;***************************************************************
; getData Procedure										   
;***************************************************************
;description: converts a numeric value to a string of digits, 
;and invoke the displayString macro to produce the output.
;receives:	- the address of the array parameter on the stack
;			- the address of progInst 4 & 5 on the stack
;			- the address of numOut on the stack
;			- the address of stringIn on the stack
;returns: none
;preconditionals: none 
;registers changed: eax, ebx, edi, ebp, esp 
;***************************************************************
getData PROC

;Setup Stack Frame
	push	ebp
	mov		ebp, esp

	mov		ecx, MAX
	mov		edi, [ebp+24]				;OFFSET array

mainLoop:

;get user input(parameters passed by reference)		
	push	[ebp+20]					;OFFSET progInst_4			
	push	[ebp+16]					;OFFSET progInst_5			
	push	[ebp+12]					;OFFSET numOut
	push	[ebp+8]						;OFFSET stringIn				
	call	readVal	

;store user input in array

	mov		ebx, [ebp+12]				;@ of numOut in ebx
	mov		eax, [ebx]					;numOut value in eax
	mov		[edi], eax					;move num. val. in array
	add		edi, 4						;inc. to next spot in array	
	loop	mainLoop

;Restore stack
	pop		ebp

;Return and remove 20 bytes from stack
	ret 20

getData ENDP

;***************************************************************
; displayResults Procedure										   
;***************************************************************
;description: displays the list of numbers, their average and 
; their sum.
;receives:	- the address of goodbye parameter on the stack
;			- the address of dspList parameter on the stack
;			- the address of the average paramter on the stack
;			- the address of the sum parameter on the stack
;			- the address of the sumTitle parameter on the stack
;			- the address of the avgTitle parameter on the satck
;			- the address of the array parameter on the stack
;			- the address of the stringOut parameter on the stack
;returns: none
;preconditionals: none 
;registers changed: eax, ecx, edi, esp, ebp
;***************************************************************
displayResults PROC

;Setup Stack Frame
	push	ebp
	mov		ebp, esp

	displayString [ebp+32]				;print dspList
	call	CrLf

	mov		ecx, MAX					
	mov		edi, [ebp+12]				;OFFSET array in edi
	
printLoop:

	push	[ebp+8]						;OFFSET stringOut
	push	edi							;OFFSET array
	call	writeVal

;put a comma and space after each number except last 
	cmp		ecx, 1
	je		noComma
	
	mov		al, 44						;',' in al
	call	writechar
	mov		al, 32						;' ' in al
	call	writechar
	
	add		edi, 4						;go to next in array

noComma:
	loop	printLoop

	call	CrLf

	displayString [ebp+20]				;print sumTitle
	mov		ebx, [ebp+24]				;@sum into ebx
	mov		eax, [ebx]					;sum into eax
	call	writeDec					;print sum
	call	CrLf

	displayString [ebp+16]				;print avgTitle
	mov		ebx, [ebp+28]				;@average in ebx
	mov		eax, [ebx]					;average in eac
	call	writeDec					;print average
	call	CrLf
	call	CrLf

	displayString [ebp+36]				;print goodbye
	call	CrLf
	call	CrLf

;Restore stack
	pop		ebp

;Return and remove 32 bytes from stack
	ret 32

displayResults ENDP


;***************************************************************
; calculate Procedure										   
;***************************************************************
;description: calculates the sum and average of the numbers in 
; the passed array
;receives:	- the address of the sum parameter on the stack
;			- the address of the average parameter on the stack
;			- the address of the array paramter on the stack
;returns: the value of the sum and average of the array numbers
;preconditionals: a filled array 
;registers changed: eax, ebc, ecx, edi, esp, ebp
;***************************************************************
calculate PROC

;Setup Stack Frame
	push	ebp
	mov		ebp, esp

	mov		edi, [ebp+8]				;@ of array in edi
	mov		eax, 0						;initialize sum
	mov		ecx, MAX					;array counter in ecx

calcSum:
	mov		ebx, [edi]					;array value in ebx
	add		eax, ebx					;add to sum
	add		edi, 4						;next value in array
	loop	calcSum

	
	mov		ebx, [ebp+16]				;OFFSET sum into ebx
	mov		[ebx], eax					;eax (total sum) into [ebx] (sum)

	
	mov		ebx, MAX					;number of items in array
	cdq		
	mov		edx, 0						;clear edx

	div		ebx							;sum / array size

	mov		ebx, [ebp+12]				;OFFSET average into ebx
	mov		[ebx], eax					;eax into [ebx] (average)

;Restore stack
	pop		ebp

;Return and remove 12 bytes from stack
	ret 12

calculate ENDP

END main