// Lock Code
//
//   Read a Keypad on PORTC
//   Output stepper on PORTA
//   Play notes on PORTD
//      *    Push
//      #    +/-

  
// Global Variables
const unsigned char MSG0[21] = "    Wrong code      "; 
const unsigned char MSG1[21] = "  WOMP WOMP WOMP    ";
const unsigned char MSG2[21] = "       Yay          ";
const unsigned char MSG3[21] = "    Unlocking       "; 
const unsigned char MSGclear[21] = "                    ";

const unsigned int lockCode = 1234; //code to the lock
unsigned int STEP = 0;
unsigned int PLAY1, PLAY2, PLAY3, N0, N1, N2; //used to set frequencies and timing of notes
unsigned char TABLE[4] = {1, 2, 4, 8};

// Subroutine Declarations
#include <pic18.h>

// Subroutines
#include        "lcd_portd.c"

// Interrupt Service Routine (plays notes)
void interrupt IntServe(void) 
{
if (TMR0IF) {
      TMR0 = -N0;
      if (PLAY1) RD0 = !RD0;
      TMR0IF = 0;
      }
if (TMR1IF) {
      TMR1 = -N1;
      if (PLAY2) RD0 = !RD0;
      TMR1IF = 0;
      }
if (TMR3IF) {
      TMR3 = -N2;
      if (PLAY3) RD0 = !RD0;
      TMR3IF = 0;
      }  
 }

char GetKey(void)
{
   int i;
   unsigned char RESULT;
   TRISC = 0xF8;  // Set PORTC pins RC0-RC2 as outputs and RC3-RC7 as inputs
   RESULT = 0xFF; // Initialize RESULT with a default value (no key pressed)

   PORTC = 4;  // Set RC2 high
   for (i=0; i<100; i++);  // Small delay for signal stabilization
   if (RC6) RESULT = 1;  // Key in Column 1 pressed
   if (RC5) RESULT = 4;  // Key in Column 2 pressed
   if (RC4) RESULT = 7;  // Key in Column 3 pressed
   if (RC3) RESULT = 10; // Key in Column 4 pressed

   PORTC = 2;  // Set RC1 high
   for (i=0; i<100; i++);
   if (RC6) RESULT = 2;
   if (RC5) RESULT = 5;
   if (RC4) RESULT = 8;
   if (RC3) RESULT = 0;

   PORTC = 1;  // Set RC0 high
   for (i=0; i<100; i++);
   if (RC6) RESULT = 3;
   if (RC5) RESULT = 6;
   if (RC4) RESULT = 9;
   if (RC3) RESULT = 11;
   // Check Additional Inputs (RB0-RB4)
   if (RB0) RESULT = 12;
   if (RB1) RESULT = 13;
   if (RB2) RESULT = 14;
   if (RB3) RESULT = 15;
   if (RB4) RESULT = 16;
   PORTC = 0;  // Reset all rows to low
   return(RESULT);  // Return the detected key value
}

// X: Stores the value of the detected key press.
// Y: Used to confirm that the key is released after being pressed.      
char ReadKey(void)
{
   char X, Y;
   do {
      X = GetKey();
   } while(X > 20); // Wait until X is a valid key press
   do {
      Y = GetKey();
   } while(Y < 20); // Wait until Y confirms key release
   Wait_ms(100);  // debounce
   return(X);
}

//clears LCD screen and moves X and Y back to the begining:
void screenClear()
{
	unsigned int i;
   // clear screen and reset to code input
	LCD_Move(0,0);  for (i=0; i<20; i++) LCD_Write(MSGclear[i]);
	LCD_Move(1,0);  for (i=0; i<20; i++) LCD_Write(MSGclear[i]);
   //set X and Y again
	LCD_Move(0,0);  LCD_Write('Y');
   LCD_Move(1,0);  LCD_Write('X');
return;
}

//Plays one of two sounds depending on if the entered code is right or not
void playNote(int flag)
{
// right combo lock notes
	if(flag == 1){ 
      N0 = 38222; //C3 note
      N1 = 45454; //A2 note

      // Ding Ding! sound
      PLAY1 = 1;
      Wait_ms(800);
      PLAY1 =0; 
      PLAY2 = 1;
      Wait_ms(800);
      PLAY2 =0;
	}

// wrong combo lock notes
	if(flag == 0){ 
      N0 = 10726; //b flat
      N1 = 11363; //A note
      N2 = 6019;  //A flat note

      // WOMP WOMP WOOOMMMPP
      PLAY1 = 1;
      Wait_ms(800);
      PLAY1 = 0; 
      PLAY2 = 1;
      Wait_ms(800);
      PLAY2 = 0; 
      PLAY3 = 1;
      Wait_ms(1500);
      PLAY3 = 0;
	}
   return;
}

//moves the stepper motor to the given refrence
void move(int REF)
{
	unsigned int i;
	while(1) {
      if (STEP < REF) STEP = STEP + 1; // Increment step position
      if (STEP > REF) STEP = STEP - 1; // Decrement step position
      if (STEP == REF) break;          // Exit loop when at target position

      PORTA = TABLE[STEP % 4];         // Update stepper motor control signal
      LCD_Move(0,8);  LCD_Out(REF, 5, 0);  // Display target position
      LCD_Move(1,8);  LCD_Out(STEP, 5, 0); // Display current position
      Wait_ms(30);                      // Delay for smooth motor operation
   }

	return;
}

// Unlocks the mechanism if the provided code matches the lock code (lockCode),
// plays a sound, and moves the motor accordingly
void unlock(int code)
{
	int i,j;
	int REF = 100; //180 degrees

   //move the stepper to 180 to unlock	
	if(code == lockCode){
      LCD_Move(0,0);  for (i=0; i<20; i++) LCD_Write(MSG2[i]);
      LCD_Move(1,0);  for (i=0; i<20; i++) LCD_Write(MSG3[i]);
      
      // play vicotry sound
      playNote(1);
      screenClear();
      move(REF);
	}

   //code is wrong, go back to loop and enter new code
	else{ 
      LCD_Move(0,0);  for (i=0; i<20; i++) LCD_Write(MSG0[i]);
      LCD_Move(1,0);  for (i=0; i<20; i++) LCD_Write(MSG1[i]);
      
      playNote(0);
      screenClear();
	}

   //Move motor back to 0 if it moved 180	
	if(code == lockCode){
      Wait_ms(5000);
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
   TRISB = 0xFF;
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

   LCD_Init();          // initialize the LCD

   X = 0;
   Y = 0;
   Z = 0;
   T = 0;

   LCD_Move(0,0);  LCD_Write('Y');
   LCD_Move(1,0);  LCD_Write('X');

   while(1) {
      //read the stack:
      TEMP = ReadKey();

      if (TEMP < 10) X = (X*10) + TEMP;
 
      if (TEMP == 10) {  //* is pressed and stack is pushed
         T = Z;
         Z = Y;
         Y = X;
         X = 0;
         
         unlock(Y); // calls the function to check the unlock code
         }   
      if (TEMP == 11) {  //# is pressed and deletes
         X = X/10;
         } 
 
      LCD_Move(1,5);  LCD_Out(X, 5, 0);
      LCD_Move(0,5);  LCD_Out(Y, 5, 0);
      
      }      


   }