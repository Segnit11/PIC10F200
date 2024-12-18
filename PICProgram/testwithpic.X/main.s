; simple blink program
    
PROCESSOR 10F200

; PIC10F200 Configuration Bit Settings

; Assembly source line config statements

; CONFIG
  CONFIG WDTE = OFF    ; Disable Watchdog Timer
CONFIG CP = OFF      ; Disable Code Protection
CONFIG MCLRE = OFF   ; Set GP3/MCLR as digital input

; config statements should precede project file includes.
#include <xc.inc>

  ; Symbol Definitions
delayValue  equ  0x10     ; Define memory address for delayValue
buttonState equ  0x11     ; Define memory address for buttonState

PSECT resetVect, class=CODE, delta=2
resetVect:
    PAGESEL main
    goto main
    
    
PSECT code, delta=2
main: ; up to mainloop is boilerplate that I automatically put into my programs
    
    movlw 0b00001110 ; first four zeros are irrelevent. 
		     ; last four GP3, GP2, GP1, GP0
		     ; 1 will set to input, 0 will set to output
		     ; GP3 is input only.
		     
		     ;use GP0 for output blinker
		     ;use GP1 for clock
		     ;use GP2 for reading data

    tris 6 ;the 6 sets tris to the value stored in W
    nop
    movlw 0b11011111 ;the zero here will set GP2 to IO rather than external clock
    option ; the contents of the working register is moved to OPTION register 
    nop

mainloop:
    ; Check if button is pressed
    btfsc   GP1            ; Skip if button is not pressed
    call    change_rate    ; Change the blink rate
    
    ; Blink LED
    call    blink
    goto    mainloop       ; Repeat the loop

blink:
    bsf     GP0            ; Turn LED on
    call    delay          ; Wait
    bcf     GP0            ; Turn LED off
    call    delay          ; Wait
    retlw 0
    nop                 ; Return to mainloop

delay:
    ; Simple delay loop
    movlw   0xFF           ; Load W with delay value
    movwf   delayValue     ; Store in delayValue register
delay_loop:
    decfsz  delayValue, f  ; Decrement delayValue, skip if zero
    goto    delay_loop     ; Repeat until zero
    retlw 0
    nop                 ; Return to caller

change_rate:
    ; Change blink rate dynamically
    movlw   0x50           ; Example: Set a shorter delay value
    movwf   delayValue     ; Update delayValue
    retlw 0
    nop                 ; Return to mainloop
        
END resetVect  

