; ---  RANDOM.ASM ----
; This program generates a random number 0..7 every time RB0 is pressed
; and sends the result to PORTC

#include <p18f4620.inc>

; Variables
DIE   EQU   0		; random number located at address 0

; --- Main Routine ---

	org 0x800
	call  Init
Main:	
	btfsc PORTB,0
	call  Roll
	call  Display
	goto  Main

; ---  Subroutines ---

Init:
	clrf  TRISA
	movlw 0xFF
	movwf TRISB
	clrf  TRISC
	clrf  TRISD
	clrf  TRISE
	movlw 0x0F
	movwf ADCON1
	return

Roll:
	incf   DIE,W
	andlw  0x07
	movwf  DIE
	return

Display:			
	movf   DIE,W
	movwf  PORTC
	return

	end