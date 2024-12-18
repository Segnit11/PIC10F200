// NeoPixel1.C
//
// This program drives a NeoPixel connected to RD0
// The color sent to the NeoPixel changes from red
// to green to blue and repeats
//

// Global Variables

unsigned char PIXEL @ 0x000;

const unsigned char MSG0[20] = "NeoPixel1.C         ";
const unsigned char MSG1[20] = "Level:              ";

// Subroutine Declarationsb
#include <pic18.h>

// Subroutines
#include        "lcd_portd.c"
  
void NeoPixel_Display(unsigned char RED, 
		unsigned char GREEN, unsigned char BLUE)
{
   PIXEL = GREEN;	asm("  call Pixel_8 ");
   PIXEL = RED;		asm("  call Pixel_8 ");
   PIXEL = BLUE;	asm("  call Pixel_8 ");

   asm("    return");


#asm
Pixel_8:
    call	Pixel_1
    call	Pixel_1
    call	Pixel_1
    call	Pixel_1
    call	Pixel_1
    call	Pixel_1
    call	Pixel_1
    call	Pixel_1
    return

Pixel_1:
	bsf		((c:3971)),0	; PORTD,0
    nop
	btfss   ((c:0000)),7
	bcf		((c:3971)),0
	rlncf   ((c:0000)),F
    nop
    nop
    bcf		((c:3971)),0
    return

#endasm
   }

  
// Main Routine

void main(void)
{
   unsigned int i, N;
   unsigned char RED, GREEN, BLUE;

   TRISA = 0;
   TRISB = 0xFF;
   TRISC = 0;
   TRISD = 0;
   TRISE = 0;
   TRISA = 0;
   PORTB = 0;
   PORTC = 0;
   PORTD = 0;
   PORTE = 0;
   ADCON1 = 0x0F;

   LCD_Init();                  // initialize the LCD
   TRISD0 = 0;

   LCD_Move(0,0);  for (i=0; i<20; i++) LCD_Write(MSG0[i]); 
   LCD_Move(1,0);  for (i=0; i<20; i++) LCD_Write(MSG1[i]); 
   Wait_ms(100); 

   N = 0;

   RED = 10;
   GREEN = 0;
   BLUE = 20;

   while(1) {
      if(RB5) RED += 1;
      if(RB4) RED -= 1;
      if(RB3) GREEN += 1;
      if(RB2) GREEN -= 1;
      if(RB1) BLUE += 1;
      if(RB0) BLUE -= 1;

      LCD_Move(1,0);   LCD_Out(RED, 3, 0);
      LCD_Move(6,0);   LCD_Out(GREEN, 3, 0);
      LCD_Move(11,0);  LCD_Out(BLUE, 3, 0);

      NeoPixel_Display(RED, GREEN, BLUE);
      NeoPixel_Display(RED, GREEN, BLUE);
      NeoPixel_Display(RED, GREEN, BLUE);
      NeoPixel_Display(RED, GREEN, BLUE);
      NeoPixel_Display(RED, GREEN, BLUE);
      NeoPixel_Display(RED, GREEN, BLUE);
      NeoPixel_Display(RED, GREEN, BLUE);
      NeoPixel_Display(RED, GREEN, BLUE);

      Wait_ms(50);
      } 
   }
    