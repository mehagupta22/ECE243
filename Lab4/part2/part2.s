/* 
* NAME: Meha Gupta
* STUDENT NUMBER: 1005138717
* Lab-4 Part-2 
*/

/* Program that counts consecutive 1's in different words and stores the highest number of 1's */

          .text                   // executable code follows
          .global _start                  

_start:
          MOV 	  R3, #0	  // R3 will hold sub-routine ONES return value
	  MOV 	  R5, #0	  // R5 will hold the greatest number of consecutive 1's
	  MOV     R2, #TEST_NUM   // load the data word ...

LOOP_A:	  LDR     R6, [R2]
	  CMP	  R6, #0	  // check for end-of-list
	  BEQ	  END
	  B	  ONES

DONE_A:	  B 	  STORE_LARGE
DONE_B:	  ADD	  R2, #4
	  B	  LOOP_A
 
END:	  B	  END


/* Subroutine returns the largest number of consecutive 1's in a word of data. */
// Parameter: R1, Return: R0
 
ONES:	  LDR	  R1, [R2]	  // load data word ... into R1
	  MOV     R0, #0          // R0 will hold the result
LOOP_B:   CMP     R1, #0          // loop until the data contains no more 1's
          BEQ     DONE_A             
          LSR     R4, R1, #1      // perform SHIFT, followed by AND
          AND     R1, R1, R4      
          ADD     R0, #1          // count the string length so far
          B       LOOP_B                       


/* Subroutine stores the largest number of consecutive 1's */
// Parameters: R3, R5

STORE_LARGE:	MOV 	R3, R0
		CMP 	R5, R3
		BGE 	DONE_B
		MOV 	R5, R3
		B  	DONE_B  



TEST_NUM: .word   0x103fe00f
	  .word   0x10fff00f  
	  .word   0x103fe002
	  .word   0x103fe003
	  .word   0x103fe004
	  .word   0x103fe005
	  .word   0x103fe006
	  .word   0x103fe007
	  .word   0x103fe008
	  .word   0x00000000

          .end    

