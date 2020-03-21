/* 
* NAME: Meha Gupta

   * STUDENT NUMBER: 1005138717
   
* Lab-5 - Part-1 
*/



/* Program that displays a decimal digit on HEX0 (HEX5-1 remain blank) */


          
	.text                   // executable code follows
          
	.global _start   




_start:
	
	LDR	R0, =0xff200050 // holds KEYs address
	
	LDR	R1, =0xff200020 // holds HEX address
	MOV	R6, #0
LOOP:   LDR	R2, [R0] // read from KEYs

WAIT:   LDR	R5, [R0] // I/O polling
	
	CMP	R5, #0
	
	BNE	WAIT
	
	CMP	R2, #1 // if KEY[0] is pressed
	
	BEQ	KEY_0 
	
	CMP	R2, #2 // if KEY[1] is pressed
	
	BEQ	KEY_1
	
	CMP	R2, #4 // if KEY[2] is pressed
	
	BEQ	KEY_2
	
	CMP	R2, #8 // if KEY[3] is pressed
	
	BEQ	KEY_3
	
	B 	LOOP




// displays 0


KEY_0: 
	MOV	R3, #0
	
	MOV	R6, #0
	
	BL	HEX_DISPLAY
	
	STR	R3, [R1]
	
	B	LOOP




// increments by 1


KEY_1:
	ADDS	R6, #1
	
	MOV	R3, R6
	
	BL	HEX_DISPLAY
	
	STR	R3, [R1]
	
	B	LOOP




// decrements by 1


KEY_2:	
	
	SUBS	R6, #1
	
	MOV	R3, R6
	
	BL	HEX_DISPLAY
	
	STR	R3, [R1]
	
	B	LOOP




// blanks display and then starts from 0 when any other key is pressed


KEY_3:
	MOV	R3, #0b00000000
	
	STR	R3, [R1]

BACK:	LDR	R2, [R0]

IN_LOOP:
	
	LDR	R5, [R0]

	CMP	R5, #0
	
	BNE	IN_LOOP
	MOV	R5, R2
	
	CMP	R5, #0
	
	BEQ	BACK

	MOV	R3, #0b00111111

	STR	R3, [R1]

   	MOV	R6, #0

	B 	LOOP




// converts decimal number for HEX display

HEX_DISPLAY: 
	
	CMP	R3, #0
	BLT	BOUNDS_DOWN
	CMP	R3, #10
	
	BGE	BOUNDS_UP
	MOV	R4, #BIT_CODES

	ADD	R4, R4, R3

	LDRB	R3, [R4]

	MOV	PC, LR



BOUNDS_DOWN:
	ADD	R3, #10
	B	HEX_DISPLAY

BOUNDS_UP:
	SUB	R3, #10
	
	B	HEX_DISPLAY





BIT_CODES: .byte   0b00111111, 0b00000110, 0b01011011, 0b01001111, 0b01100110

	   .byte   0b01101101, 0b01111101, 0b00000111, 0b01111111, 0b01100111

  	   .end    
