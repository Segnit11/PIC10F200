; Simple Blink Program for PIC10F200

PROCESSOR 10F200

; PIC10F200 Configuration Bit Settings
; CONFIG
CONFIG WDTE = OFF          ; Disable Watchdog Timer
CONFIG CP = OFF            ; Disable Code Protection
CONFIG MCLRE = OFF         ; Set GP3/MCLR as digital I/O

#include <xc.inc>          ; Include XC8 assembly header

; === Reset Vector ===
PSECT resetVect, class=CODE, delta=2
resetVect:
    PAGESEL main           ; Jump to main program
    goto main

; === Code Section ===
PSECT code, delta=2

main:
    ; Configure GPIO pins
    movlw 0b00001110       ; GP3=input, GP2=input, GP1=input, GP0=output
    tris 6                 ; Set GPIO direction (write W to TRIS register)
    nop

    ; Configure OPTION register
    movlw 0b11011111       ; Disable external clock on GP2
    option                 ; Write W to OPTION register
    nop

mainloop:
    ; Check the state of GP1 (button input)
    btfss GP1              ; If GP1 is high (button not pressed), skip next line
    call gp1clear          ; Adjust blink rate for GP1 low state
    btfsc GP1              ; If GP1 is low (button pressed), skip next line
    call gp1set            ; Adjust blink rate for GP1 high state
    nop

    ; Blink LED on GP0
    call blink             ; Run the blink routine
    goto mainloop          ; Repeat the loop

blink:
    ; Turn LED on
    bsf GP0                ; Set GP0 high
    movlw 30               ; Set delay (adjustable in subroutines below)
    call delay             ; Wait
    ; Turn LED off
    bcf GP0                ; Set GP0 low
    movlw 30               ; Set delay again
    call delay             ; Wait
    goto blink             ; Repeat blinking

delay:
    ; Simple delay routine
    movwf 0x10             ; Store W value in memory (delay counter)
delay_loop:
    decfsz 0x10, f         ; Decrement counter, skip if zero
    goto delay_loop        ; Repeat until counter reaches zero
    retlw 0                ; Return to caller

gp1clear:
    ; Adjust blink rate for GP1 = 0 (button not pressed)
    btfss GP2              ; Check state of GP2 (optional input)
    call gpA               ; If GP2 = 0, set blink rate to fast
    btfsc GP2              ; Check state of GP2 (optional input)
    call gpB               ; If GP2 = 1, set blink rate to medium
    retlw 0                ; Return to mainloop

gp1set:
    ; Adjust blink rate for GP1 = 1 (button pressed)
    btfss GP2              ; Check state of GP2 (optional input)
    call gpC               ; If GP2 = 0, set blink rate to slower
    btfsc GP2              ; Check state of GP2 (optional input)
    call gpD               ; If GP2 = 1, set blink rate to slowest
    retlw 0                ; Return to mainloop

; === Subroutines for Blink Rates ===
gpA:
    movlw 20               ; Fast blink (short delay)
    movwf 0x10             ; Store in memory
    retlw 0

gpB:
    movlw 50               ; Medium blink (medium delay)
    movwf 0x10             ; Store in memory
    retlw 0

gpC:
    movlw 100              ; Slow blink (longer delay)
    movwf 0x10             ; Store in memory
    retlw 0

gpD:
    movlw 150              ; Slowest blink (longest delay)
    movwf 0x10             ; Store in memory
    retlw 0

END resetVect              ; End of program
