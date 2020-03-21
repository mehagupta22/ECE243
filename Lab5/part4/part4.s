/* 
* NAME: Meha Gupta

   * STUDENT NUMBER: 1005138717

   * Lab-5 - Part-4 
*/



/* Program displays clock on HEX3-0*/

          
	
	.text                   // executable code follows
 
	.global _start

_start: 
	LDR	R0, =0xFF200020		// HEX Address
	LDR	R1, =0xFF200050		// KEY Address
	LDR	R8, =0xFFFEC600		// A9 Private Timer Address
	LDR	R6, =2000000		// 200MHz * 0.01s (Clock Rate * Desired Delay)
	STR	R6, [R8]
	MOV	R6, #0b011
	STR	R6, [R8, #8]
START:	MOV	R2, #0			// Counter
COUNT:	BL	CHECK_KEY
BACK:	LDR 	R5, =6000
	CMP	R2, R5
	BEQ	START
	BL	DELAY
	BL	DISPLAY
	ADD	R2, #1
	B	COUNT

// Increments counter every 0.01 seconds

DELAY:	PUSH	{LR}
	BL	CHECK_KEY
CONTINUE:
	LDR	R6, [R8, #0xC]
	CMP	R6, #0
	BEQ	CONTINUE
	STR	R6, [R8, #0xC]
	POP	{PC}

// Checks when key is pressed and then waits for the next key to be pressed restart the counter

CHECK_KEY:
	LDR	R7, [R1, #0xC] 		// Address of the Edge Capture Register
	CMP	R7, #0
	BNE	KEY_1
RETURN:	
	MOV	PC, LR			// If no key is pressed

KEY_1:	STR	R7, [R1, #0xC]		// When the first key is pressed, wait for the next key to be pressed to restart the counter
WAIT:	LDR	R7, [R1, #0xC]
	CMP	R7, #0
	BEQ	WAIT
	STR	R7, [R1, #0xC]
	B	RETURN


// Displays counter value on HEX display

DISPLAY: 
	PUSH	{R2, R6, R7, LR}
	MOV	R5, #0
	MOV	R6, #0
	MOV	R7, #0
DIV_1000: 
	CMP	R2, #1000
	BGE	DIVIDE_1000
DIV_100:
	CMP	R2, #100
	BGE	DIVIDE_100

DIV_10:	CMP	R2, #10
	BGE	DIVIDE_10

	MOV	R3, R2
	BL	SEG_7
	MOV	R2, R3

	MOV	R3, R5
	BL	SEG_7
	MOV	R5, R3
	LSL	R5, #24

	MOV	R3, R6
	BL	SEG_7
	MOV	R6, R3
	LSL	R6, #16

	MOV	R3, R7
	BL	SEG_7
	MOV	R7, R3
	LSL	R7, #8

	ORR	R2, R2, R5
	ORR	R2, R2, R6
	ORR	R2, R2, R7
	STR	R2, [R0]
	POP	{R2, R6, R7, PC}

DIVIDE_1000:
	SUB	R2, #1000
	ADD	R5, #1
	B	DIV_1000

DIVIDE_100:
	SUB	R2, #100
	ADD	R6, #1
	B	DIV_100

DIVIDE_10:
	SUB	R2, #10
	ADD	R7, #1
	B	DIV_10

// Converts decimal values for HEX display
	
SEG_7:
	MOV	R4, #BIT_CODES
	ADD	R4, R4, R3
	LDRB	R3, [R4]
	MOV	PC, LR


BIT_CODES: .byte  0b00111111, 0b00000110, 0b01011011, 0b01001111, 0b01100110
	   .byte  0b01101101, 0b01111101, 0b00000111, 0b01111111, 0b01100111
	   .skip  2
  	   .end    