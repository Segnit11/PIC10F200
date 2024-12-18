
; PIC10F200 Configuration Bit Settings

; Assembly source line config statements

; CONFIG
  CONFIG  WDTE = OFF            ; Watchdog Timer (WDT disabled)
  CONFIG  CP = OFF              ; Code Protect (Code protection off)
  CONFIG  MCLRE = OFF           ; Master Clear Enable (GP3/MCLR pin fuction is digital I/O, MCLR internally tied to VDD)

// config statements should precede project file includes.
#include <xc.inc>

PSECT resetVect, class=CODE, delta=2
resetVect:
    PAGESEL main
    goto main

    
PSECT code, delta=2
 
main:
    nop
    nop
mainloop:
    nop
    movlw 5 ;Base ten number
    movwf 0x10
    goto mainloop
    nop
 

END resetVect



