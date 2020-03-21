/* 
* NAME: Meha Gupta

   * STUDENT NUMBER: 1005138717

   * Lab-5 - Part-2 
*/



/* Program that counts up until 99 before looping back, incrementing every 0.25 seconds */

          
	
	.text                   // executable code follows
 
	.global _start

_start: 
	LDR	R0, =0xFF200020		// HEX Address
	LDR	R1, =0xFF200050		// KEY Address
START:	MOV	R2, #0			// Counter
COUNT:	BL	CHECK_KEY
BACK:	CMP	R2, #100
	BEQ	START
	BL	DELAY
	BL	DISPLAY
	ADD	R2, #1
	B	COUNT

// Increments counter every 0.25 seconds

DELAY:	LDR	R6, =200000000			
	PUSH	{LR}
	BL	CHECK_KEY
CONTINUE:	
	SUB	R6, #1	
	CMP	R6, #0
	BNE	CONTINUE
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
	PUSH	{R2, LR}
	MOV	R5, #0
DIV_10:	CMP	R2, #10
	BGE	DIVIDE
	MOV	R3, R2
	BL	SEG_7
	MOV	R2, R3
	MOV	R3, R5
	BL	SEG_7
	MOV	R5, R3
	LSL	R5, #8
	ORR	R2, R2, R5
	STR	R2, [R0]
	POP	{R2, PC}

DIVIDE:
	SUB	R2, #10
	ADD	R5, #1
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