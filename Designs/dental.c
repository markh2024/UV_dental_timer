#include <system.h>
// DATA CONFIGURATION FOR 12F675

#ifndef _PIC12F675
#error "This sample code was designed for PIC12F675"
#pragma DATA_CONFIG, _CPD_OFF & _CP_OFF  & _WDT_OFF & _BODEN_OFF & _PWRTE_OFF  & _MCLRE_OFF & _INTRC_OSC_NOCLKOUT
#endif //_PIC12F675


// CONFIG FOR OSCAL 344C

// GLOBAL VARIABLES


/* These are the Interrupts and flags for later use 
GIE					Global intterupt enable 
PIE					Peripheral interrupt enable 
INTF				Interrupt Flag must be cleared after intterupt
TOIE                Timer intterupt enable 
TIOF                Timer interrupt Overflow Flag 
GPIE                general purpose interrupt enable 
GPIF 				general pupose interrupt flag 
*/

#define 	CLEAR  0x00 ;
#define 	Pressed  0 ;      // this is bit 0 of our Flags register
#define     State    1 ;	  // this  is bit 1 of our Flags Register
#define     TimerState 2 ;    // this is bit 2 of ourFlags register 



unsigned swVal = 0 ; 

unsigned char  curState ;
unsigned char  timer    ;
unsigned char seconds ;       // stores and increments seconds 
unsigned char minutes ;       // stores and increments minutes 
unsigned char milliseconds ;  // stores and  increments the milliseconds 
unsigned char TMRFlag  ;      /* stores the status of the timer 
							  when timer is activated for light is Zero  
							  for final minute countdown this is 1 */
unsigned char max_seconds ;   /* For storing the maximum seconds
								 when light is on this 9 when final minute 
								 this is equals  1 */

unsigned char tmrOffset ; 
unsigned char oldseconds = 0x00 ;

// method forward declaration 


void startTimerLight(unsigned char maxMinutes); 
void init(void) ; 
void sound(unsigned char period , unsigned char cycles, unsigned char duration) ;
unsigned char startTimer(unsigned char maxvalue) ;
unsigned char  getKeyPress(void) ;
void notifyFinish(unsigned char lastSecs , unsigned char secsInterrupt) ;


/*
	personal notes for PCB Layout this may differ 
	from time to time
	Soundport gpio.2 ;
    button    gpio.0 ;
    Luxion    gpio.1 ;
*/



void interrupt(void)
{
 // HANDLES  TIMER INTERRUPT 
 // disable GIE 
clear_bit(intcon, T0IE);            // Disable Timer 0 Interrupts
clear_bit(intcon, GIE);             // clear Global interrupt 

			if(TMRFlag == 0x00)
			{
			startTimerLight(9) ;
			}

			



clear_bit(intcon, T0IF);

		 if((timer == 1)&&(TMRFlag == 0x00))
		{
		 
		 set_bit(intcon,GIE) ;
		 set_bit(intcon, T0IE);
		}

			if ((TMRFlag == 0x01)&&(timer ==0))
						{
						 set_bit(intcon,GIE) ;
						 set_bit(intcon, T0IE);
						  // final minute call notify 
						  notifyFinish(60,1);	
						}


}
// 12F675 register settings

       /* | 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0 |
          NU   NU  out in  nu  out out  in
          0    0   0    1   0   0    0   1
		=  0x11 hex 
	 */ 



void init(void)
{
    vrcon = CLEAR;                    // Turn off the voltage reference peripheral
    cmcon = 0b00000111;              // Disble comparator module - make Port  digital I/O port
    ansel = CLEAR;                    // For the 12F675 Only
    gpio = CLEAR;                    // Clear the output ports
	trisio = 0x11  ;                 // set up port direction 
    wpu = 0b00000000;                // En/disable Weak Pull Ups
    
	/*	T1CON — TIMER1 CONTROL REGISTER (ADDRESS: 10h)
          7 
          6   Gate enable bit sued for external triggering
	      5   T1CKPS1: Next two bits are the prescale bits 
          4   T1CKPS0 
		  3   T1OSCEN: LP Oscillator Enable Control bit If INTOSC without CLKOUT oscillator is active:
		  2	  T1SYNC: Timer1 External Clock Input Synchronization Control bit							
		  1   TMR1CS: Timer1 Clock Source Select bit
          0   TMR1ON: Timer1 On bit setting enables timer
    */

    
   // clear all registers     

    seconds = CLEAR ; 
    minutes = CLEAR ;
    milliseconds = CLEAR ;
    TMRFlag = CLEAR ;
    max_seconds = CLEAR ;
    tmrOffset = CLEAR  ; 
    oldseconds = CLEAR ;
    timer = 0x00 ;

	// Enable/disbale interrupts
    clear_bit(intcon, T0IE);            // Disable Timer 0 Interrupts
    clear_bit(intcon, GIE);             // Disable Global Interrupts
    clear_bit(intcon, T0IF);
	                      
	
	delay_us(100) ; // allow time for cpu to settle 
    
}

void sound(unsigned char period , unsigned char cycles, unsigned char duration)
{

			for(int j = 0 ; j < duration; j++ )
			{	
				for(int i = 0 ; i < cycles; i ++)
				{
					delay_us(period);
					{
					 toggle_bit(gpio,2) ;
					}
				}
			
			}

	gpio.2 = 0 ; // switch off luxian 
}

/*Notes A simpler way to access a bit within a byte is to use a constant expression of the form

	(1 << n)

where n is the bit number and << is the left shift operator

*/


// starts the TMR0 interrupt loads timer with value and 
// begins light time on sequence 

unsigned char startTimer(unsigned char maxvalue)
{
    tmr0 = CLEAR ;
    
  	// GPPU INTEDG T0CS T0SE PSA PS2 PS1 PS0
	//   0    0     0     0   0   1    1  1
    option_reg = 0x07 ; // use  256 prescaling 
    // enable interrupts and timer interrupt 
    // clear overflow flag to start with 
    clear_bit(intcon, T0IF);
    set_bit(intcon, GIE);             // enable Global Interrupts
    tmr0 = maxvalue ;
	set_bit(intcon, T0IE);            // enable Timer 0 Interrupts
    

    
    
    return 0x01 ;
}


unsigned char getKeyPress(void)
{    
        unsigned char  value = 0x00 ;
       
	 

	    while(value == 0x00)
		{
	   	value = gpio.0 ; // get the value 
		delay_us(255);
		}
		value = (0x11 & value) ;  // masking to ensure we have correct bits for input
	    return value  ;
	
}



void startTimerLight(unsigned char maxMinutes)
{

milliseconds += 1 ; // increment milliseconds by one 


		
           	if(milliseconds == 60) 
			{	milliseconds  = 0 ; // reset milliseconds 
				seconds +=1 ;  // increment seconds by one 
				if(seconds == 60)
				{
				 seconds = 0 ;
				 minutes += 1 ;

						  if(minutes == maxMinutes)
						  {
							minutes = 0 ;
						    TMRFlag = 0x01 ;
							timer = 0 ;
						  }// end if minutes 
				}// end if seconds 
			
			}// end if milliseconds 





 tmr0 = CLEAR ;	 
 tmr0 = tmrOffset ;

}



void notifyFinish(unsigned char lastSecs , unsigned char secsInterrupt)
{
	 
	 milliseconds +=1 ;
     if(milliseconds == 60) 
     {	
				milliseconds  = 0 ; // reset milliseconds 
				seconds +=1 ;  // increment seconds by one
				oldseconds+=1 ; 
				if(oldseconds == secsInterrupt)
				{
				  // sound alarm for finishing 
				  sound(200,200,5);  // makes a beep noise for number of reps 
				  oldseconds = 0 ;
				}
				if(seconds == lastSecs)
				{
					seconds = 0; 
					
                    timer = 0 ; // we have finshed back to key press
					TMRFlag = 0x00 ; // reset this flag to notify back into timer state 
					gpio.1 = 0 ; // switch off led 
					gpio = CLEAR ;

					// finally disable intrerrupts again 

					 // disable intterupt 
    				clear_bit(intcon, T0IE);            // Disable Timer 0 Interrupts
    				clear_bit(intcon, GIE);             // Disable Global Interrupts
    				clear_bit(intcon, T0IF);
					
					
				}



	 }
 tmr0 = CLEAR ;	 
 tmr0 = tmrOffset ;
}


void main()
{
	
   // sets up the calibration of Osscal	
		
	asm{
	bsf _status,RP0
        call 0x3ff
        movwf _osccal
        bcf _status,RP0
	}// end asm 

// sound the buzzer once and light the led for a second 

   init() ;
   gpio.1 = 1 ;         // turn on the led
   sound(200,255,10);  // makes a beep noise for number of reps 
   gpio.1 = 0 ; // turn this off 
	
	
 //main program loop start here 

 while(1)
  {

	
   	    // check to see if timer is on Zero indicates off
        if(timer == 0)
        {
        	swVal= getKeyPress();

			if(swVal==1)
			{	TMRFlag = 0x00 ;
			    tmrOffset  = 188 ;
				timer =  startTimer(tmrOffset) ;
				gpio.1 = 1;
				
			}
			
         }	
   }



}
