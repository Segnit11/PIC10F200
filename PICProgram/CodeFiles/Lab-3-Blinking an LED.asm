; Simple blink program

PROCESSOR 10F200

; PIC10F200 Configuration Bit Settings

; CONFIG
  CONFIG  WDTE = OFF            ; Watchdog Timer (WDT disabled)
  CONFIG  CP = OFF              ; Code Protect (Code protection off)
  CONFIG  MCLRE = OFF           ; Master Clear Enable (GP3/MCLR pin is digital I/O)

#include <xc.inc>

PSECT resetVect, class=CODE, delta=2
resetVect:
    PAGESEL main
    goto main

PSECT code, delta=2
main:
    movlw 0b00001110       ; Set GP0 as output, GP1 as input (clock), GP2 as input
    tris 6                 ; Initialize TRIS register
    movlw 0b11011111       ; Set GP2 as I/O, not external clock
    option                 ; Load W register contents into OPTION register

mainloop:
    nop
blink:
    bsf GP0                ; Set GP0 high
    movlw 30
    call delay
    bcf GP0                ; Set GP0 low
    movlw 30
    call delay
    goto blink             ; Infinite loop to keep blinking

delay:                     ; Nested delay loop
    movwf 0x12
out_out_loop:
    movwf 0x11
outer_loop:
    movwf 0x10
delay_loop:
    decfsz 0x10, 1
    goto delay_loop
    decfsz 0x11, 1
    goto outer_loop
    decfsz 0x12, 1
    goto out_out_loop
    retlw 0

END resetVect  
