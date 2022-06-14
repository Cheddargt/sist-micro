// main.c
// Desenvolvido para a placa EK-TM4C1294XL


#include <stdint.h>

void PLL_Init(void);
void SysTick_Init(void);
void SysTick_Wait1ms(uint32_t delay);
void GPIO_Init(void);
void	GPIOPortJ_Handler(void);
void Timer2A_Handler(void);
void PortF_Output(uint32_t parametro);
void PortN_Output(uint32_t parametro);


//typedef enum estSemaforo
typedef enum 
{	
	ESTADO_1,
	ESTADO_2

}estadosLED;



estadosLED estados = ESTADO_1;

void est1(void)
{

	PortF_Output(0);
}
void est2(void)
{
	PortF_Output(1);
}


void inverte(){
		if(estados==ESTADO_1)
		{
			estados=ESTADO_2;
			return;
		}
		else
			estados=ESTADO_1;
			return;
}


int main(void)
{
	PLL_Init();
	SysTick_Init();
	GPIO_Init();
	while (1)
	{
      switch(estados){
					case ESTADO_1:
						est1();
					break;
					case ESTADO_2:
						est2();
					break;
			}
	}
}


