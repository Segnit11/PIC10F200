# 1 "main.s"
# 1 "<built-in>" 1
# 1 "main.s" 2
; simple blink program

PROCESSOR 10F200

; PIC10F200 Configuration Bit Settings

; Assembly source line config statements

; CONFIG
  CONFIG WDTE = OFF ; Disable Watchdog Timer
CONFIG CP = OFF ; Disable Code Protection
CONFIG MCLRE = OFF ; Set GP3/MCLR as digital input

; config statements should precede project file includes.

# 1 "C:\\Program Files\\Microchip\\xc8\\v2.50\\pic\\include\\xc.inc" 1 3






# 1 "C:/Program Files/Microchip/MPLABX/v6.20/packs/Microchip/PIC10-12Fxxx_DFP/1.7.178/xc8\\pic\\include\\pic.inc" 1 3



# 1 "C:/Program Files/Microchip/MPLABX/v6.20/packs/Microchip/PIC10-12Fxxx_DFP/1.7.178/xc8\\pic\\include\\pic_as_chip_select.inc" 1 3
# 43 "C:/Program Files/Microchip/MPLABX/v6.20/packs/Microchip/PIC10-12Fxxx_DFP/1.7.178/xc8\\pic\\include\\pic_as_chip_select.inc" 3
# 1 "C:/Program Files/Microchip/MPLABX/v6.20/packs/Microchip/PIC10-12Fxxx_DFP/1.7.178/xc8\\pic\\include\\proc\\pic10f200.inc" 1 3
# 47 "C:/Program Files/Microchip/MPLABX/v6.20/packs/Microchip/PIC10-12Fxxx_DFP/1.7.178/xc8\\pic\\include\\proc\\pic10f200.inc" 3
INDF equ 0000h

INDF_INDF_POSN equ 0000h
INDF_INDF_POSITION equ 0000h
INDF_INDF_SIZE equ 0008h
INDF_INDF_LENGTH equ 0008h
INDF_INDF_MASK equ 00FFh



TMR0 equ 0001h

TMR0_TMR0_POSN equ 0000h
TMR0_TMR0_POSITION equ 0000h
TMR0_TMR0_SIZE equ 0008h
TMR0_TMR0_LENGTH equ 0008h
TMR0_TMR0_MASK equ 00FFh



PCL equ 0002h

PCL_PCL_POSN equ 0000h
PCL_PCL_POSITION equ 0000h
PCL_PCL_SIZE equ 0008h
PCL_PCL_LENGTH equ 0008h
PCL_PCL_MASK equ 00FFh



STATUS equ 0003h

STATUS_C_POSN equ 0000h
STATUS_C_POSITION equ 0000h
STATUS_C_SIZE equ 0001h
STATUS_C_LENGTH equ 0001h
STATUS_C_MASK equ 0001h
STATUS_DC_POSN equ 0001h
STATUS_DC_POSITION equ 0001h
STATUS_DC_SIZE equ 0001h
STATUS_DC_LENGTH equ 0001h
STATUS_DC_MASK equ 0002h
STATUS_Z_POSN equ 0002h
STATUS_Z_POSITION equ 0002h
STATUS_Z_SIZE equ 0001h
STATUS_Z_LENGTH equ 0001h
STATUS_Z_MASK equ 0004h
STATUS_nPD_POSN equ 0003h
STATUS_nPD_POSITION equ 0003h
STATUS_nPD_SIZE equ 0001h
STATUS_nPD_LENGTH equ 0001h
STATUS_nPD_MASK equ 0008h
STATUS_nTO_POSN equ 0004h
STATUS_nTO_POSITION equ 0004h
STATUS_nTO_SIZE equ 0001h
STATUS_nTO_LENGTH equ 0001h
STATUS_nTO_MASK equ 0010h
STATUS_GPWUF_POSN equ 0007h
STATUS_GPWUF_POSITION equ 0007h
STATUS_GPWUF_SIZE equ 0001h
STATUS_GPWUF_LENGTH equ 0001h
STATUS_GPWUF_MASK equ 0080h
STATUS_CARRY_POSN equ 0000h
STATUS_CARRY_POSITION equ 0000h
STATUS_CARRY_SIZE equ 0001h
STATUS_CARRY_LENGTH equ 0001h
STATUS_CARRY_MASK equ 0001h
STATUS_ZERO_POSN equ 0002h
STATUS_ZERO_POSITION equ 0002h
STATUS_ZERO_SIZE equ 0001h
STATUS_ZERO_LENGTH equ 0001h
STATUS_ZERO_MASK equ 0004h



FSR equ 0004h

FSR_FSR_POSN equ 0000h
FSR_FSR_POSITION equ 0000h
FSR_FSR_SIZE equ 0008h
FSR_FSR_LENGTH equ 0008h
FSR_FSR_MASK equ 00FFh



OSCCAL equ 0005h

OSCCAL_FOSC4_POSN equ 0000h
OSCCAL_FOSC4_POSITION equ 0000h
OSCCAL_FOSC4_SIZE equ 0001h
OSCCAL_FOSC4_LENGTH equ 0001h
OSCCAL_FOSC4_MASK equ 0001h
OSCCAL_CAL_POSN equ 0001h
OSCCAL_CAL_POSITION equ 0001h
OSCCAL_CAL_SIZE equ 0007h
OSCCAL_CAL_LENGTH equ 0007h
OSCCAL_CAL_MASK equ 00FEh
OSCCAL_CAL0_POSN equ 0001h
OSCCAL_CAL0_POSITION equ 0001h
OSCCAL_CAL0_SIZE equ 0001h
OSCCAL_CAL0_LENGTH equ 0001h
OSCCAL_CAL0_MASK equ 0002h
OSCCAL_CAL1_POSN equ 0002h
OSCCAL_CAL1_POSITION equ 0002h
OSCCAL_CAL1_SIZE equ 0001h
OSCCAL_CAL1_LENGTH equ 0001h
OSCCAL_CAL1_MASK equ 0004h
OSCCAL_CAL2_POSN equ 0003h
OSCCAL_CAL2_POSITION equ 0003h
OSCCAL_CAL2_SIZE equ 0001h
OSCCAL_CAL2_LENGTH equ 0001h
OSCCAL_CAL2_MASK equ 0008h
OSCCAL_CAL3_POSN equ 0004h
OSCCAL_CAL3_POSITION equ 0004h
OSCCAL_CAL3_SIZE equ 0001h
OSCCAL_CAL3_LENGTH equ 0001h
OSCCAL_CAL3_MASK equ 0010h
OSCCAL_CAL4_POSN equ 0005h
OSCCAL_CAL4_POSITION equ 0005h
OSCCAL_CAL4_SIZE equ 0001h
OSCCAL_CAL4_LENGTH equ 0001h
OSCCAL_CAL4_MASK equ 0020h
OSCCAL_CAL5_POSN equ 0006h
OSCCAL_CAL5_POSITION equ 0006h
OSCCAL_CAL5_SIZE equ 0001h
OSCCAL_CAL5_LENGTH equ 0001h
OSCCAL_CAL5_MASK equ 0040h
OSCCAL_CAL6_POSN equ 0007h
OSCCAL_CAL6_POSITION equ 0007h
OSCCAL_CAL6_SIZE equ 0001h
OSCCAL_CAL6_LENGTH equ 0001h
OSCCAL_CAL6_MASK equ 0080h



GPIO equ 0006h

GPIO_GP0_POSN equ 0000h
GPIO_GP0_POSITION equ 0000h
GPIO_GP0_SIZE equ 0001h
GPIO_GP0_LENGTH equ 0001h
GPIO_GP0_MASK equ 0001h
GPIO_GP1_POSN equ 0001h
GPIO_GP1_POSITION equ 0001h
GPIO_GP1_SIZE equ 0001h
GPIO_GP1_LENGTH equ 0001h
GPIO_GP1_MASK equ 0002h
GPIO_GP2_POSN equ 0002h
GPIO_GP2_POSITION equ 0002h
GPIO_GP2_SIZE equ 0001h
GPIO_GP2_LENGTH equ 0001h
GPIO_GP2_MASK equ 0004h
GPIO_GP3_POSN equ 0003h
GPIO_GP3_POSITION equ 0003h
GPIO_GP3_SIZE equ 0001h
GPIO_GP3_LENGTH equ 0001h
GPIO_GP3_MASK equ 0008h
# 248 "C:/Program Files/Microchip/MPLABX/v6.20/packs/Microchip/PIC10-12Fxxx_DFP/1.7.178/xc8\\pic\\include\\proc\\pic10f200.inc" 3
psect udata,class=RAM,space=1,noexec
psect udata_bank0,class=BANK0,space=1,noexec
psect code,class=CODE,space=0,delta=2
psect data,class=STRCODE,space=0,delta=2,noexec
# 44 "C:/Program Files/Microchip/MPLABX/v6.20/packs/Microchip/PIC10-12Fxxx_DFP/1.7.178/xc8\\pic\\include\\pic_as_chip_select.inc" 2 3
# 5 "C:/Program Files/Microchip/MPLABX/v6.20/packs/Microchip/PIC10-12Fxxx_DFP/1.7.178/xc8\\pic\\include\\pic.inc" 2 3



stk_offset SET 0
auto_size SET 0


; stack_auto defines a symbol /name/_offset which equates to the
; stack offset of the auto object in question

stack_auto MACRO name, size
name&_offset EQU stk_offset-size
stk_offset SET name&_offset
auto_size SET -stk_offset
ENDM


; stack_param defines a symbol /name/_offset which equates to the
; stack offset of the parameter object in question

stack_param MACRO name, size
name&_offset EQU stk_offset-size
stk_offset SET name&_offset
ENDM


; alloc_stack adjusts the SP to allocate space for auto objects
; it also links in to the btemp symbol so that can be used

alloc_stack MACRO
GLOBAL btemp
addfsr FSR1,auto_size
ENDM


; restore_stack adjusts the SP to remove all auto and parameter
; objects from the stack prior to returning from a function

restore_stack MACRO
addfsr FSR1,stk_offset
stk_offset SET 0
auto_size SET 0
ENDM
# 7 "C:\\Program Files\\Microchip\\xc8\\v2.50\\pic\\include\\xc.inc" 2 3
# 16 "main.s" 2

  ; Symbol Definitions
delayValue equ 0x10 ; Define memory address for delayValue
buttonState equ 0x11 ; Define memory address for buttonState

PSECT resetVect, class=CODE, delta=2
resetVect:
    PAGESEL main
    goto main


PSECT code, delta=2
main: ; up to mainloop is boilerplate that I automatically put into my programs

    movlw 0b00001110 ; first four zeros are irrelevent.
       ; last four ((GPIO) and 01Fh), 3, ((GPIO) and 01Fh), 2, ((GPIO) and 01Fh), 1, ((GPIO) and 01Fh), 0
       ; 1 will set to input, 0 will set to output
       ; ((GPIO) and 01Fh), 3 is input only.

       ;use ((GPIO) and 01Fh), 0 for output blinker
       ;use ((GPIO) and 01Fh), 1 for clock
       ;use ((GPIO) and 01Fh), 2 for reading data

    tris 6 ;the 6 sets tris to the value stored in W
    nop
    movlw 0b11011111 ;the zero here will set ((GPIO) and 01Fh), 2 to IO rather than external clock
    option ; the contents of the working register is moved to OPTION register
    nop

mainloop:
    ; Check if button is pressed
    btfsc ((GPIO) and 01Fh), 1 ; Skip if button is not pressed
    call change_rate ; Change the blink rate

    ; Blink LED
    call blink
    goto mainloop ; Repeat the loop

blink:
    bsf ((GPIO) and 01Fh), 0 ; Turn LED on
    call delay ; Wait
    bcf ((GPIO) and 01Fh), 0 ; Turn LED off
    call delay ; Wait
    retlw 0
    nop ; Return to mainloop

delay:
    ; Simple delay loop
    movlw 0xFF ; Load W with delay value
    movwf delayValue ; Store in delayValue register
delay_loop:
    decfsz delayValue, f ; Decrement delayValue, skip if zero
    goto delay_loop ; Repeat until zero
    retlw 0
    nop ; Return to caller

change_rate:
    ; Change blink rate dynamically
    movlw 0x50 ; Example: Set a shorter delay value
    movwf delayValue ; Update delayValue
    retlw 0
    nop ; Return to mainloop

END resetVect
