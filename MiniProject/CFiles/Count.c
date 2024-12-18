// ---  COUNT.C -------------------

// Global Variables

// Subroutine Declarations
#include <pic18.h>

void Wait(unsigned int DATA)
{
   unsigned int i, j;
   for (i=0; i<DATA; i++) {
      for (j=0; j<1000; j++);
   }
}
   
// Main Routine



void main(void)
{
   unsigned long int i;

   TRISA = 0;
   TRISB = 0;
   TRISC = 0;
   TRISD = 0;
   TRISE = 0;
   ADCON1 = 0x0F;
   i = 0;
   
   while(1) {
      i = i + 1;
      PORTD = i;
      PORTC = i >> 8;
      PORTB = i >> 16;
      PORTA = i >> 24;
      Wait(1);
      }
   }