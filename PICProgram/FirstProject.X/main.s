; Program to demonstrate indirect access to memory - both write and read

; PIC10F200 Configuration Bit Settings

; Assembly source line config statements

; CONFIG
  CONFIG  WDTE = OFF            ; Watchdog Timer (WDT disabled)
  CONFIG  CP = OFF              ; Code Protect (Code protection off)
  CONFIG  MCLRE = OFF           ; Master Clear Enable (GP3/MCLR pin function is digital I/O, MCLR internally tied to VDD)

; Include processor definitions
#include <xc.inc>

; Reset vector, setting up the main program entry
PSECT resetVect, class=CODE, delta=2
resetVect:
    PAGESEL main
    goto main
    
PSECT code, delta=2

; Main program
main:
    nop
    nop

; Main loop
mainloop:
    movlw 0x20           ; Assign starting address (0x20 for this example)
    movwf FSR            ; Set FSR to starting address
    movlw 0x03           ; Example base number, used for increment steps
    movwf 0x17           ; Store the step value in register 0x17
    clrf INDF            ; Clear INDF to initialize memory

storeloop:
    movwf INDF           ; Store base number in the address pointed to by FSR
    addwf 0x17,0         ; Add step value to W for each store (3 in this case)
    incf FSR, 1          ; Increment FSR to point to next address (0x20 -> 0x21, etc.)
    btfss FSR, 3         ; Check if FSR has reached the end of range (limit at 0x24 for this example)
    goto storeloop       ; Repeat storing until end address is reached
    nop
    movlw 0x20           ; Reset FSR to starting address for reading
    movwf FSR            ; Initialize FSR to first address (0x20)

readloop:
    movf INDF,0          ; Load the value from address pointed by FSR to W register
    incf FSR, 1          ; Move FSR to next address in sequence
    btfss FSR, 3         ; Check if FSR has reached the end address (0x24 for this example)
    goto readloop        ; Repeat reading until end of address range
    goto mainloop        ; Loop back to main to restart program cycle
    nop                  ; Necessary for proper looping behavior

END resetVect
