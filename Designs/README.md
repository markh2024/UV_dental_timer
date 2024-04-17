
# UV_dental_timer MD Harrington Kent London UK

This design I did quite a while  back to help a  friend  whom  needed a solution over night
to make sure  his wife at the  time didnt lose her  job after  she broke  the one she  had  about a weekends solid non stop 48 hrs to get him out of trouble 

I dont think I have come  across people as I have over the last  30 years  How  people and companies have changed  apart from the very odd few 
 

I used the Boost C compiler for pic micro which originally  you could buy from maplin electronics  before they went bust

This was after they decided to enter the market rapid  expansion , paid thier staff ultra low pay , badly trained staff and a mangeress who was abonably rude , ignorant and arrogent with it

Before  this they   were a very good outfit  having   exceptionally proffesional staff  whom had at that stage an interest in thier carreers but as usual they lose the lot including  very good staff 

The days when  companies  did well and based thier bussiness on decency and professionalism 

How few they have left now  equally decent engineers 

Typical of the companies  that  always start this way then get to big for thier themselves  thinking  they can treat all any old  how 

Anyway  this is  a very good compiler and was at that time  good competition for the  well known compilers around at the time

# Below is the schematic for this dental UV timer which uses interrupts 

![CircuitJPG](https://github.com/markh2024/UV_dental_timer/assets/159157948/00187e6e-4580-4e18-83e6-68f7bb4a5315)


This was a code all , design and make PCB  by hand , test it and  deliver  finished 

Below this is the PCB layout  and yes it all works beautifully  



![DentalLighttimerPCB](https://github.com/markh2024/UV_dental_timer/assets/159157948/1a09960a-d345-40d3-acba-2b3f6bbe6487)

Below is also the parts list 

Author 	: 	MD Harrington

Revision 	: 	1.1

Design Created 	: 	18 February 2011

Design Last Modified 	: 	28 November 2011

Total Parts In Design 	: 	23

10 Resistors

Quantity: 		  References 		Value 	

	2 		        R1, R9 		    10k All 0.6 watt 	
 
	4 		        R2-R5 		    22R 
 
	3 		        R6, R8, R10 	100k 	
 
	1 		        R7 		        10R 	

4 Capacitors

Quantity: 		References 		Value 	

1 		        C1 		        100u 16volt working 	

3 		        C2-C4 		     10p 	


2 Integrated Circuits

Quantity: 		References 		Value 	
 1 		        U1 		        PIC12F675 	
	
 1 		        U2 		        FUSE_1 500ma 	
 
2 Transistors
	
 Quantity: 		References 		Value 	
	1 		      Q1 		        IRF540 	
	1 		      Q2 		        2SD667 	

3 Diodes
	Quantity: 		References 		Value 	
	
 1 		            D1 		    1N5237B 	
 
 1 		            D2 		    1N4001 	
 
 1 		            D3 		Luxian Led 	

2 Miscellaneous
	
Quantity: 		References 		Value 	
	
 
 1 		          BUZ1 		    BUZZER 	
 
 1 		          SW1 		    SW-SPST-MOM 	
  

C Code  using the boost c compiler 

```
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
    
	/*	T1CON  TIMER1 CONTROL REGISTER (ADDRESS: 10h)
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
```


# The  following is the hex file

If  you cant compile the code then ive included this for you and this is where knowing how this works and what that hex file  both  contains and does  my well come into play 


I wont be telling you why  but you can work all of that out youself  which  now is going to become  very important to some  because  you will  not know what is contained within 

Your true meaning of , "Message in a  bottle "  , Your very next enigma , the art of modern day warefare and I bet that has really  got you thinking 
```
:02000000E228F4
:08000800DF00030E8312A000CB
:0E0010000A0EA100040EA2008A110A12E928AD
:100020000330B807B80CB80C7F30B8050000B80B27
:1000300016280800B401B501330834023508031846
:10004000232803192528B51F3D28B601B70132081A
:100050003602370803182E2803193028B71F39280D
:100060003108B800102004308506B60A0319B70A13
:100070002728B40A0319B50A1C2805110800A80A84
:1000800028083C3A031D5428A801A60A26083C3A31
:10009000031D5428A601A70A2F082706031D54286C
:1000A000A7010130A900A50181012B0881000800EA
:1000B000A80A28083C3A031D7728A801A60AAC0A1A
:1000C00030082C06031D6B28C830B100B200053083
:1000D000B3001A20AC012F082606031D7728A601BD
:1000E000A501A901851085018B128B130B118101CC
:1000F0002B088100080081010730831681008312DC
:100100000B118B172D0881008B160130AE000800F3
:100110008316990107308312990083169F01831279
:10012000850111308316850095018312A601A70170
:10013000A801A901AA01AB01AC01A5018B128B1387
:100140000B116430B800102008008312AD01AD0817
:10015000031DB228AD01051CAE28AD0AFF30B80062
:100160001020A7282D081139AD002D08AE00080079
:1001700083128316FF2383169000831283128A1141
:100180000A1288208514C830B100FF30B2000A304E
:10019000B3001A208510A508031DCB28A5202E0822
:1001A000A300A4010130230603192408031DCB2852
:1001B000A901BC30AB002B08AD007B202E08A500A8
:1001C0008514CB288312A301A401AC018A110A1261
:1001D000B82883128B128B13A908031DF22809304B
:1001E000AF003F200B112503031DFB28A908031DA9
:1001F000FB288B178B162903031D0829A508031D4F
:1002000008298B178B163C30AF000130B000582006
:10021000220E8400210E8A00200E8300DF0E5F0E66
:020220000900D3
:00000001FF

```
