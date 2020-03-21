.define LED_ADDRESS 0x1000
.define HEX_ADDRESS 0x2000
.define SW_ADDRESS 0x3000


	//initializing registers r0, r1 and r2
	mv r0, #0 
	mv r1, #1
	mvt r2, #LED_ADDRESS

MAIN:	st r0, [r2]
	add r0, r1	
	mvt r5, #SW_ADDRESS
	ld r6, [r5]
	add r6, #0xFF
	b #LOOP

LOOP:	sub r6, #1
	bne #LOOP
	b #MAIN


	




