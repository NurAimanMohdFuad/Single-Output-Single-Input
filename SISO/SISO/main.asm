
; SISO.asm
;
; Created: 11/15/2020 3:02:33 PM
; Author : Nur Aiman BINTI Mohd Fuad
;


.def temp = r19
.def switch_pressed = r17 
.def led = r18 
		
setup:		
		out DDRB,temp				; Set PB as output
		out DDRC,switch_pressed		; Set PC as input
		in switch_pressed, PINC		; Read input from PC
		out PORTB, led				; Send input to PB
loop:   
        rcall   debounce			; Routine call
        brcc    else				; Branch if Carry Cleared
        tst     switch_pressed		; Test for Zero or Minus
        brne    loop				; Branch if Not Equal
        in      temp,PORTB  
        ldi     led,(1 << PB0)
        eor     temp,led			; Exclusive OR Registers
        out     PORTB,temp 
        ldi     switch_pressed,1
        rjmp    loop				; Infinite loop
else:
        ldi     switch_pressed,0
        rjmp    loop				; Infinite loop

;--- subroutines ---;

debounce: .equ    d_time = 1000	
          sbic    PINC, PC0			; Skip if Bit in I/O Register Cleared, The bit is 0 then the switch is pressed
          rjmp    setBit
          ldi     r25,high(d_time)
          ldi     r24,low(d_time) 
		
delay:  sbiw    r25:r24,1			; Subtract Immediate from Word ; Subroutine delay
        brne    delay
        sbic    PINC,PC0			; To check whether the switch still pressed
        rjmp    setBit
        sec 
        ret							; Subroutine Return

setBit:								; Subroutine setBit
        clc							; Clear Carry Flag
        ret							; Subroutine Return