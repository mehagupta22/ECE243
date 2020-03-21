/* 
* NAME: Meha Gupta
* STUDENT NUMBER: 1005138717
* Lab-4 Part-2 
*/

/* Program that counts consecutive and alternating 1's and 0's in different words */

          .text                   // executable code follows
          .global _start                  

_start:
	  MOV     R2, #TEST_NUM   // load the data word ...

	  // initializing registers R5, R6, R7, which will hold the longest strings of 1's, 0's and alternating 1's and 0's respectively
	  MOV     R5, #0	  
	  MOV     R6, #0
	  MOV     R7, #0

LOOP_A:	  LDR     R9, [R2]	  // data is loaded into R9
	  CMP	  R9, #0	  // to check if end-of-list is reached
	  BEQ	  END
	  B	  ONES

// loop to store the longest number of consecutive 1's among all words
DONE_A:	  MOV 	  R11, R0
	  CMP 	  R5, R11
	  BGE 	  ZEROS
	  MOV 	  R5, R11 
	  B	  ZEROS

// loop to store the longest number of consecutive 0's among all words
DONE_B:	  MOV 	  R11, R4
	  CMP 	  R6, R11
	  BGE 	  ALTERNATE
	  MOV 	  R6, R11
	  B	  ALTERNATE

// loop to store the longest number of alternating 1's and 0's among all words
DONE_C:	  MOV 	  R11, R9
	  ADD	  R11, #1	  // to account for loosing 1 while performing arithmetic shift
	  CMP 	  R7, R11
	  BGE 	  FINAL
	  MOV 	  R7, R11
	  B   	  FINAL

FINAL:	  ADD	  R2, #4	  // to move to next word in the list
	  B	  LOOP_A
 
END:	  B	  END


/* Subroutine returns the largest number of consecutive 1's in a word of data */
// Parameter: R1, Return: R0
 
ONES:	  LDR	  R1, [R2]	  // load data word ... into R1
	  MOV     R0, #0          // R0 will hold the result
LOOP_B:   CMP     R1, #0          // loop until the data contains no more 1's
          BEQ     DONE_A             
          LSR     R10, R1, #1      // perform SHIFT, followed by AND
          AND     R1, R1, R10      
          ADD     R0, #1          // count the string length so far
          B       LOOP_B                       


/* Subroutine returns the largest number of consecutive 0's in a word of data */
// Parameter: R3, Return: R4 
 
ZEROS:	  LDR	  R3, [R2]	  // load data word ... into R3
	  MVN	  R3, R3	  // move the complement of the data into R3 and find the largest number of consecutive 1's
	  MOV     R4, #0          // R4 will hold the result
LOOP_C:   CMP     R3, #0          // loop until the data contains no more 1's
          BEQ     DONE_B             
          LSR     R10, R3, #1      // perform SHIFT, followed by AND
          AND     R3, R3, R10      
          ADD     R4, #1          // count the string length so far
          B       LOOP_C     


/* Subroutine returns the largest number of alternating 0's and 1's in a word of data */
// Parameter: R8, Return: R9
 
ALTERNATE:	  LDR	  R8, [R2]	  // load data word ... into R8
		  ASR	  R12, R8, #1	  // perform arithmetic shift followed by XOR and find the largest number of consecutive 1's
		  EOR	  R8, R8, R12
	  	  MOV     R9, #0          // R9 will hold the result
LOOP_D:   	  CMP     R8, #0          // loop until the data contains no more 1's
          	  BEQ     DONE_C             
          	  LSR     R10, R8, #1      // perform SHIFT, followed by AND
          	  AND     R8, R8, R10      
          	  ADD     R9, #1          // count the string length so far
          	  B       LOOP_D   



TEST_NUM: .word   0x103fe00f
	  .word   0x10fff00f  
	  .word   0x103fe002
	  .word   0x103fe003
	  .word   0x103fe004
	  .word   0x103fe005
	  .word   0x103fe006
	  .word   0x103fe007
	  .word   0xf0aab0f5
	  .word   0x00000000

          .end    

