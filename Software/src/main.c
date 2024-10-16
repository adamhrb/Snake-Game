// ##########################################################
// ##########################################################
// ##    __    ______   ______   .______        _______.   ##
// ##   |  |  /      | /  __  \  |   _  \      /       |   ##
// ##   |  | |  ,----'|  |  |  | |  |_)  |    |   (----`   ##
// ##   |  | |  |     |  |  |  | |   _  <      \   \       ##
// ##   |  | |  `----.|  `--'  | |  |_)  | .----)   |      ##
// ##   |__|  \______| \______/  |______/  |_______/       ##
// ##                                                      ##
// ##########################################################
// ##########################################################
//-----------------------------------------------------------
// main.c
// Author: Soriano Theo
// Update: 23-09-2020
//-----------------------------------------------------------

#include "system.h"
#include "arch_vga.h"
#include "arch.h"
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <stdlib.h>

#define _BTNU_MODE  GPIOC.MODEbits.P0
#define BTNU        GPIOC.IDRbits.P0

#define _BTNL_MODE  GPIOC.MODEbits.P1
#define BTNL        GPIOC.IDRbits.P1

#define _BTNR_MODE  GPIOC.MODEbits.P2
#define BTNR        GPIOC.IDRbits.P2

#define _BTND_MODE  GPIOC.MODEbits.P3
#define BTND        GPIOC.IDRbits.P3

#define _SW15_MODE   GPIOA.MODEbits.P15
#define SW15		 GPIOA.IDRbits.P15



#define SCREEN_WIDTH 640
#define SCREEN_HEIGHT 480
#define SPRITE_FIRE_WIDTH 20 
#define SPRITE_FIRE_HEIGHT 32
#define SPRITE_SNAKE_WIDTH 62 
#define SPRITE_SNAKE_HEIGHT 60
#define SPRITE_EGG_WIDTH 7
#define SPRITE_EGG_HEIGHT 7
#define SPRITE_WINNER_WIDTH 178
#define SPRITE_WINNER_HEIGHT 49
#define SPRITE_LOSE_WIDTH 127
#define SPRITE_LOSE_HEIGHT 90

int TIMER_FLAG = 0;


static void timer_clock_cb(int code)
{
	TIMER_FLAG=1;
	((void)code);
}

int seed=0;

/// @brief 
/// @param  
/// @return 
int main(void)
{
	
	
	

	RSTCLK.GPIOAEN = 1;
	RSTCLK.GPIOBEN = 1;
	RSTCLK.GPIOCEN = 1;

	GPIOB.ODR = 0x0000;
	GPIOB.MODER = 0xFFFF;

	GPIOA.ODR = 0x0000;
	GPIOA.MODER = 0xFFFF;

	_BTNU_MODE = GPIO_MODE_INPUT;
	_BTNL_MODE = GPIO_MODE_INPUT;
	_BTNR_MODE = GPIO_MODE_INPUT;
	_BTND_MODE = GPIO_MODE_INPUT;

	_SW15_MODE = GPIO_MODE_INPUT;

	// UART1 initialization
	UART1_Init(115200);
	UART1_Enable();
	IBEX_SET_INTERRUPT(IBEX_INT_UART1);

	IBEX_ENABLE_INTERRUPTS;

	myprintf("\n#####################\nDEMO\n#####################\n");

	set_timer_ms(1000, timer_clock_cb, 0);


	while(SW15==0)
	{
		seed++;		//INCREMENT SEED SO THAT WE WOULD HAVE DIFFERENT RANDOM VALUES EVERYTIME
	}

	srand(seed);

	MY_VGA.Background = 0x2dc4c4;//background color

	MY_VGA.X1_Position = (SCREEN_WIDTH/2)-(SPRITE_FIRE_WIDTH/2);
	MY_VGA.Y1_Position = SCREEN_HEIGHT-SPRITE_FIRE_HEIGHT;
	MY_VGA.X2_Position = 1;
	MY_VGA.Y2_Position = 1;
	MY_VGA.X3_Position = (rand() % (SCREEN_WIDTH-SPRITE_EGG_WIDTH - 0 + 1)) ;	// generate a random value for X3 EGG between 0 and 640 // on the screen
	MY_VGA.Y3_Position = (rand() % (SCREEN_HEIGHT-SPRITE_EGG_HEIGHT - 0 + 1)) ;// generate a random value for Y3 EGG between 0 and 480 // on the screen
	MY_VGA.X4_Position = -200;
	MY_VGA.Y4_Position = -200;
	MY_VGA.X5_Position = -200;
	MY_VGA.Y5_Position = -200;



	int direction;
	int direction_x= -1;	// STEP VALUE 
	int direction_y= -1;

	int SCORE = 0;
	int FIRE_DETECTION = 0;
	int END = 0;





	while(1) {
		do{
			//KEEP THE SPRITES IN THE SHOWING SCREEN(VIDON)
			if(MY_VGA.X1_Position<=0){direction = 1;}
			if(MY_VGA.Y1_Position<=0){direction = 2;}
			if(MY_VGA.X1_Position>=SCREEN_WIDTH-SPRITE_FIRE_WIDTH){direction = 3;}
			if(MY_VGA.Y1_Position>=SCREEN_HEIGHT-SPRITE_FIRE_HEIGHT){direction = 4;}

			
			if(BTNU && MY_VGA.Y2_Position-1>0){MY_VGA.Y2_Position--;}
			if(BTND && MY_VGA.Y2_Position+1<=SCREEN_HEIGHT-SPRITE_SNAKE_HEIGHT){MY_VGA.Y2_Position++;}
			if(BTNL && MY_VGA.X2_Position-1>0){MY_VGA.X2_Position--;}
			if(BTNR && MY_VGA.X2_Position+1<=SCREEN_WIDTH-SPRITE_SNAKE_WIDTH){MY_VGA.X2_Position++;}
			
			
			switch (direction) 
			{
				case 1: // left to up
					direction_x = 1;	//STEP VALUE
					break;
				case 2: // up to right
					direction_y = 1;
					break;
				case 3: // right to down
					direction_x = -1; 
					break;
				case 4: // down to left
					direction_y = -1;
					break;
    		}

			MY_VGA.X1_Position+=direction_x;//INCREASE X AND Y BY 1 PIXEL
			MY_VGA.Y1_Position+=direction_y;
			delay_ms(6);
			if(END==0)
			{

				//Detect collision between snake and EGG

				if(MY_VGA.Y3_Position+SPRITE_EGG_HEIGHT>=MY_VGA.Y2_Position && MY_VGA.Y3_Position<=(MY_VGA.Y2_Position+SPRITE_SNAKE_HEIGHT))
				{
					if(MY_VGA.X3_Position<=MY_VGA.X2_Position+SPRITE_SNAKE_WIDTH && (MY_VGA.X3_Position+SPRITE_EGG_WIDTH>=MY_VGA.X2_Position))
					{
						myprintf("collision\n");
						MY_VGA.X3_Position = (rand() % (SCREEN_WIDTH-SPRITE_EGG_WIDTH - 0 + 1)) ;	// generate a random value for X3 EGG between 0 and 640 // on the screen
						MY_VGA.Y3_Position = (rand() % (SCREEN_HEIGHT-SPRITE_EGG_HEIGHT - 0 + 1)) ;// generate a random value for Y3 EGG between 0 and 480 // on the screen
						myprintf("MY_VGA.X3_Position = %d\n", MY_VGA.X3_Position);
						SCORE++;
						myprintf("SCORE= %d\n",SCORE);
						if(SCORE<=10){MY_VGA.Background+=10;}
					}
				}

				//Detect collision between snake and FIRE

				if(MY_VGA.Y1_Position+SPRITE_FIRE_HEIGHT>=MY_VGA.Y2_Position && MY_VGA.Y1_Position<=(MY_VGA.Y2_Position+SPRITE_SNAKE_HEIGHT))
				{
					if(MY_VGA.X1_Position<=MY_VGA.X2_Position+SPRITE_SNAKE_WIDTH && (MY_VGA.X1_Position+SPRITE_FIRE_WIDTH>=MY_VGA.X2_Position))
					{	
						if(FIRE_DETECTION==0)
						{
							SCORE--;
							myprintf("SCORE= %d\n",SCORE);
							FIRE_DETECTION=1;
							if(SCORE>=0){MY_VGA.Background-=10;}
						}
					}
					else
					{
						FIRE_DETECTION=0;
					}
				}
			}

			//Check if win or lose
			if(SCORE==10)
			{
				MY_VGA.X1_Position = -200;
				MY_VGA.Y1_Position = -200;
				MY_VGA.X2_Position = -200;
				MY_VGA.Y2_Position = -200;
				MY_VGA.X3_Position = -200;
				MY_VGA.Y3_Position = -200;
				MY_VGA.X4_Position = (SCREEN_WIDTH/2)-(SPRITE_WINNER_WIDTH/2);
				MY_VGA.Y4_Position = (SCREEN_HEIGHT/2)-(SPRITE_WINNER_HEIGHT/2);
				MY_VGA.X5_Position = -200;
				MY_VGA.Y5_Position = -200;

				MY_VGA.Background=0xa88532;
				END=1;

				//MY_VGA.Background  = FFD700; //Set background color to gold

			}
			else if(SCORE<0)
			{
				//place the lose sprite at the center of the screen and remove the others
				MY_VGA.X1_Position = -200;
				MY_VGA.Y1_Position = -200;
				MY_VGA.X2_Position = -200;
				MY_VGA.Y2_Position = -200;
				MY_VGA.X3_Position = -200;
				MY_VGA.Y3_Position = -200;
				MY_VGA.X4_Position = -200;
				MY_VGA.Y4_Position = -200;
				MY_VGA.X5_Position = (SCREEN_WIDTH/2)-(SPRITE_LOSE_WIDTH/2);
				MY_VGA.Y5_Position = (SCREEN_HEIGHT/2)-(SPRITE_LOSE_HEIGHT/2);

				MY_VGA.Background=0x030303;
				END = 1;			
			}

			// show score on 7segment
			if(SCORE==10)
			{
				MY_PERIPH.REG1 = -1;
				MY_PERIPH.REG2 = -1;
				MY_PERIPH.REG3=  1;
				MY_PERIPH.REG4 = 0;
			}
			else
			{
				MY_PERIPH.REG1 = -1;
				MY_PERIPH.REG2 = -1;
				MY_PERIPH.REG3=  -1;
				MY_PERIPH.REG4 = SCORE;
			}

			myprintf("END = %d\n  ",END);
		}
		while(!TIMER_FLAG);
		 TIMER_FLAG = 0;

		
	}
	return 0;
}

void Default_Handler(void){
	GPIOB.ODR = 0xFFFF;
}


