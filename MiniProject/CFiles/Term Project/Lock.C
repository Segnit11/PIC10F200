// Lock Code
//
// Read a Keypad on PORTC
// Output stepper on PORTA and speaker on PORTB
// * Push
// # +/-
 
// Global Variables
const unsigned char MSG00[21] = " Hello          ";
const unsigned char MSG0[21] = " Wrong code     "; 
const unsigned char MSG1[21] = " Try again      ";
const unsigned char MSG2[21] = " Yay            ";
const unsigned char MSG3[21] = " Unlocking      "; 
const unsigned char MSGclear[21] = "                ";

const unsigned int lockCode = 1234; //code to the lock
 unsigned int STEP = 0, N0,N1,N2, PLAY = 0;
unsigned char TABLE[4] = {1, 2, 4, 8};

// Subroutine Declarations
#include <pic18.h>

// Subroutines
#include        "lcd_portd.c"

// Interrupt Service Routine
void interrupt IntServe(void) 
{
if (TMR0IF) {
      TMR0 = -N0;
      if (PLAY) RB0 = !RB0;
      TMR0IF = 0;
      }
if (TMR1IF) {
      TMR1 = -N1;
      if (PORTB) RB1 = !RB1;
      TMR1IF = 0;
      }
if (TMR3IF) {
      TMR3 = -N2;
      if (PORTB) RB2 = !RB2;
      TMR3IF = 0;
      }
 
 }

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

//sets note frequescies
void playNote(int f0, int f1, int f2){
	PLAY = 1;
	N0 = f0; N1 = f1; N2 = f2;
	Wait_ms(2000);
	PLAY =0;
	return;
} 

//moves the stepper motor to the given refrence
void move(int REF){
unsigned int i;
while(1) {
 if (STEP < REF) STEP = STEP + 1;
 if (STEP > REF) STEP = STEP - 1;
 if (STEP == REF) break;
 PORTA = TABLE[STEP % 4];
 LCD_Move(0,8); LCD_Out(REF, 5, 0);
 LCD_Move(1,8); LCD_Out(STEP, 5, 0);
 Wait_ms(30);
 }
return;
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
void unlock(int code){
int i,j;
int REF = 100; //180 degrees
//move the stepper to 180 to unlock
if(code == lockCode){
	LCD_Move(0,0); for (i=0; i<20; i++) LCD_Write(MSG2[i]);
	LCD_Move(1,0); for (i=0; i<20; i++) LCD_Write(MSG3[i]);

	Wait_ms(3000);
	screenClear();
	move(REF);
}//code is wrong, go back to loop and enter new code
else{ 
	LCD_Move(0,0); for (i=0; i<20; i++) LCD_Write(MSG0[i]);
	LCD_Move(1,0); for (i=0; i<20; i++) LCD_Write(MSG1[i]);

	playNote(22727, 15169, 11363); //call ur routine to play a note
	screenClear();
}

//Move motor back to 0 if it moved 180
if(code == lockCode){
	Wait_ms(3000);
	move(0);
	screenClear();
}
return;
}


         
// Main Routine

void main(void)
{
   unsigned int i, j;
   int X, Y, Z, T, TEMP;

   TRISA = 0;
   TRISB = 0;
   TRISC = 0xF8;
   TRISD = 0;
   TRISE = 0;
   TRISA = 0;
   ADCON1 = 15;

//enable interrupts: 
// set up Timer0 for PS = 1
   T0CS = 0;
   T0CON = 0x88;
   TMR0ON = 1;
   TMR0IE = 1;
   TMR0IP = 1;
   PEIE = 1;
// set up Timer1 for PS = 1
   TMR1CS = 0;
   T1CON = 0x81;
   TMR1ON = 1;
   TMR1IE = 1;
   TMR1IP = 1;
   PEIE = 1;
// set up Timer3 for PS = 1
   TMR3CS = 0;
   T3CON = 0x81;
   TMR3ON = 1;
   TMR3IE = 1;
   TMR3IP = 1;
   PEIE = 1;

// turn on all interrupts
   GIE = 1;

   LCD_Init();                  // initialize the LCD

   LCD_Move(0,0);  for (i=0; i<20; i++) LCD_Write(MSG00[i]);
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
		
		unlock(Y); // calls the function to check the unlock code
         }   
      if (TEMP == 11) {
         X = X/10;
         } 
 
      LCD_Move(1,5);  LCD_Out(X, 5, 0);
      LCD_Move(0,5);  LCD_Out(Y, 5, 0);
      
      }      


   }