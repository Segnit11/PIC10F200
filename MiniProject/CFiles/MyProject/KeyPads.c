// Keypad.C
//
//   Read a Keypad on PORTC
//   Functions are
//      *    Push
//      #    +/-

  
// Global Variables
unsigned char PIXEL @ 0x000;

const unsigned char MSG00[20] = "Choose Brightness: ";
const unsigned char MSG0[20] = " Invalid ";
const unsigned char MSG1[20] = " Brightness "; 
const unsigned char MSGclear[20] = "            ";


// Subroutine Declarations
#include <pic18.h>

// Subroutines
#include        "lcd_portd.c"

char GetKey(void)
{
   int i;
   unsigned char RESULT;
   TRISC = 0xF8;
   RESULT = 0xFF;
   PORTC = 4;
   for (i=0; i<100; i++);
   if (RC6) RESULT = 1;
   if (RC5) RESULT = 4;
   if (RC4) RESULT = 7;
   if (RC3) RESULT = 10;
   PORTC = 2;
   for (i=0; i<100; i++);
   if (RC6) RESULT = 2;
   if (RC5) RESULT = 5;
   if (RC4) RESULT = 8;
   if (RC3) RESULT = 0;
   PORTC = 1;
   for (i=0; i<100; i++);
   if (RC6) RESULT = 3;
   if (RC5) RESULT = 6;
   if (RC4) RESULT = 9;
   if (RC3) RESULT = 11;
   if (RB0) RESULT = 12;
   if (RB1) RESULT = 13;
   if (RB2) RESULT = 14;
   if (RB3) RESULT = 15;
   if (RB4) RESULT = 16;
   PORTC = 0;
   return(RESULT);
}
      
char ReadKey(void)
{
   char X, Y;
   do {
      X = GetKey();
      }   while(X > 20);
   do {
      Y= GetKey();
      }   while(Y < 20);
   Wait_ms(100);  // debounce
   return(X);
   }
 
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

void screenClear(){
unsigned int i;
// clear screen and reset to code input
LCD_Move(0,0); for (i=0; i<20; i++) LCD_Write(MSGclear[i]);
LCD_Move(1,0); for (i=0; i<20; i++) LCD_Write(MSGclear[i]);
//set X and Y again
LCD_Move(0,0); LCD_Write('Y');
 LCD_Move(1,0); LCD_Write('X');
return;
}

//routine to set brightness
void setBrightness(int brightnessLevel){
int maxBrightness = 255;
unsigned int i, N;
 unsigned char RED, GREEN, BLUE;
N = 0;
RED = 0;
GREEN = 0;
BLUE = 0;

// check if valid brightness
if( brightnessLevel > maxBrightness){
LCD_Move(0,0); for (i=0; i<20; i++) LCD_Write(MSG0[i]); // message is invalid
LCD_Move(1,0); for (i=0; i<20; i++) LCD_Write(MSG1[i]); //message is brightness
Wait_ms(4000);
screenClear();
return;
} else{
// SET RED GREEN AND BLUE (WHITE) TO SAME VALUES
// RED = GREEN = BLUE = brightnessLevel;

for( int i =0; i<= brightnessLevel; i++){
 RED += 1;
 GREEN += 1;
 BLUE += 1;
}

//set pixels
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
return;
}

         
// Main Routine

void main(void)
{
   unsigned int i, j;
   int X, Y, Z, T, TEMP;

   TRISA = 0;
   TRISB = 0xFF;
   TRISC = 0xF8;
   TRISD = 0;
   TRISE = 0;
   TRISA = 0;
   ADCON1 = 15;

   LCD_Init();                  // initialize the LCD

   LCD_Move(0,0);  for (i=0; i<20; i++) LCD_Write(MSG0[i]);
   Wait_ms(2000);
   LCD_Inst(1);

   X = 0;
   Y = 0;
   Z = 0;
   T = 0;

   LCD_Move(0,0);  LCD_Write('Y');
   LCD_Move(1,0);  LCD_Write('X');


   while(1) {
      TEMP = ReadKey();

      if (TEMP < 10) X = (X*10) + TEMP;
 
      if (TEMP == 10) {
         T = Z;
         Z = Y;
         Y = X;
         X = 0;

		setBrightness(Y);

         }   
      if (TEMP == 11) {
         X = X/10;
         } 
 
      LCD_Move(1,5);  LCD_Out(X, 5, 0);
      LCD_Move(0,5);  LCD_Out(Y, 5, 0);
      
      }      


   }
