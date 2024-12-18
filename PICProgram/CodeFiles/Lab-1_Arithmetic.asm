; Program to practice arithmetic operations:
; Includes multiplication, comparison, and modulo calculations

PROCESSOR 10F200

; PIC10F200 Configuration Bit Settings
; CONFIG
  CONFIG  WDTE = OFF      ; Watchdog Timer (WDT disabled)
  CONFIG  CP = OFF        ; Code Protect (Code protection off)
  CONFIG  MCLRE = OFF     ; Master Clear Enable (GP3/MCLR pin function is digital I/O, MCLR internally tied to VDD)

; Include file for register definitions
#include <xc.inc>

; Define reset vector
PSECT resetVect, class=CODE, delta=2
resetVect:
    PAGESEL main
    goto main

; Main code section
PSECT code, delta=2
main:
    ; Set GP pins as input/output
    movlw 0b00001110      ; Configure GP pins: GP3 (input only), GP2, GP1 as input; GP0 as output
    tris 6                ; Set TRIS register based on W register value
    nop
    movlw 0b11011111      ; Disable external clock input on GP2
    option                ; Move W register contents to OPTION register
    nop

mainloop:
    ; Updated example values for arithmetic operations
    movlw 8               ; Load new example value 1
    movwf 0x10            ; Store example value 1 in address 0x10
    movwf 0x15            ; Counter initialized with example value 1 for multiplication loop
    movlw 15              ; Load new example value 2
    movwf 0x11            ; Store example value 2 in address 0x11
    clrw                  ; Clear W register as a precaution

; Multiplication (repeated addition)
multiply:
    addwf 0x11,0          ; Add example value 2 to W register (accumulator)
    decfsz 0x15           ; Decrement counter until zero
    goto multiply         ; Repeat addition if counter not zero
    movwf 0x12            ; Store multiplication result in 0x12

; Comparison
compare:
    movf 0x10,0           ; Load example value 1 into W register
    subwf 0x11,0          ; Subtract example value 1 from example value 2
    movwf 0x17            ; Store result in 0x17
    btfss 0x17,7          ; Check bit 7 for sign (positive/negative)
    call ispositive       ; Call ispositive if result is positive
    btfsc 0x17,7          ; Check bit 7 for sign again (negative)
    call isnegative       ; Call isnegative if result is negative

; Modulo operation
modulo:
    movf 0x11,0           ; Load example value 2 into W register
    movwf 0x14            ; Store example value 2 in 0x14 (dummy register)
    movf 0x10,0           ; Load example value 1 into W register
removeinteger:
    subwf 0x14,1          ; Subtract example value 1 from 0x14 until result is negative
    btfss 0x14,7          ; Check for sign change to negative
    goto removeinteger    ; Repeat subtraction until result is negative
    nop
findresidue:
    addwf 0x14,1          ; Add example value 1 back once to correct overshoot
    goto mainloop         ; Loop back to mainloop for further operations

; Subroutine for positive result
ispositive:
    movlw 'P'             ; Load ASCII for 'P' (indicating positive result)
    movwf 0x13            ; Store in address 0x13
    retlw 0               ; Return to calling location

; Subroutine for negative result
isnegative:
    movlw 'N'             ; Load ASCII for 'N' (indicating negative result)
    movwf 0x13            ; Store in address 0x13
    retlw 0               ; Return to calling location

END resetVect
