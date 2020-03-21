/* Program that converts a binary number to decimal */
           .text               // executable code follows
           .global _start
_start:
            MOV    R4, #N
            MOV    R5, #Digits  // R5 points to the decimal digits storage location
            LDR    R4, [R4]     // R4 holds N
            MOV    R0, R4       // parameter for DIVIDE goes in R0
            BL     DIV_1000
            STRB   R2, [R5, #3] // Thousands digit is now in R2
            STRB   R3, [R5, #2] // Hundreds digit is now in R3
            STRB   R6, [R5, #1] // Tens digit is now in R6
            STRB   R0, [R5]     // Ones digit is in R0
END:        B      END

// ******************************************************************************** //

DIV_1000:     MOV    R2, #0
CONT_1000:    CMP    R0, #1000
              BLT    DIV_100
              SUB    R0, #1000
              ADD    R2, #1
              B      CONT_1000

DIV_100:      MOV    R3, #0
COUNT_100:    CMP    R0, #100
	      BLT    DIV_10
	      SUB    R0, #100
	      ADD    R3, #1
	      B      COUNT_100

DIV_10:       MOV    R6, #0
COUNT_10:     CMP    R0, #10
	      BLT    DIV_END
	      SUB    R0, #10
	      ADD    R6, #1
	      B      COUNT_10

DIV_END:      MOV    PC, LR     //go back to main

N:          .word  9876         // the decimal number to be converted
Digits:     .space 4          // storage space for the decimal digits

            .end
