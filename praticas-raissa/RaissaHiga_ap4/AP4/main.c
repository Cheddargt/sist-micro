// main.c
// Desenvolvido para a placa EK-TM4C1294XL


#include <stdint.h>

void PLL_Init(void);
void SysTick_Init(void);
void SysTick_Wait1ms(uint32_t delay);
void GPIO_Init(void);
void	GPIOPortJ_Handler(void);

void PortF_Output(uint32_t parametro);
void PortN_Output(uint32_t parametro);

extern uint32_t A;
//typedef enum estSemaforo
typedef enum 
{	
	ESTADO_1,
	ESTADO_2,
	ESTADO_3,
	ESTADO_4,
	ESTADO_5,
	ESTADO_6,
	ESTADO_7

}estadosSemaforo;



estadosSemaforo estados = ESTADO_1;

void est1(void)
{
	if (A==1){
		estados=ESTADO_7;
		return;
	}
	PortF_Output(17);
	PortN_Output(3);
	SysTick_Wait1ms(1000);
	estados=ESTADO_2;
}
void est2(void)
{
	PortF_Output(17);
	PortN_Output(2);
	SysTick_Wait1ms(6000);
	estados= ESTADO_3;
}
void est3(void)
{
	PortF_Output(17);
	PortN_Output(1);
	SysTick_Wait1ms(2000);
	estados=ESTADO_4;
}
void est4(void)
{
	PortF_Output(17);
	PortN_Output(3);
	SysTick_Wait1ms(1000);
	estados=ESTADO_5;
}
void est5(void)
{
	PortF_Output(16);
	PortN_Output(3);
	SysTick_Wait1ms(6000);
	estados=ESTADO_6;
}
void est6(void)
{
	PortF_Output(1);
	PortN_Output(3);
	SysTick_Wait1ms(2000);
	estados=ESTADO_1;
}

void est7(void)
{
	PortF_Output(1);
	PortN_Output(1);
	SysTick_Wait1ms(1000);
	PortF_Output(16);
	PortN_Output(2);
	SysTick_Wait1ms(1000);
		PortF_Output(1);
	PortN_Output(1);
	SysTick_Wait1ms(1000);
		PortF_Output(16);
	PortN_Output(2);
	SysTick_Wait1ms(1000);
		PortF_Output(1);
	PortN_Output(1);
	SysTick_Wait1ms(1000);
	A=0;
	estados=ESTADO_2;
}
int main(void)
{
	PLL_Init();
	SysTick_Init();
	GPIO_Init();
	A=0;
	while (1)
	{
      switch(estados){
					case ESTADO_1:
						est1();
					break;
					case ESTADO_2:
						est2();
					break;
					case ESTADO_3:
						est3();
					break;
					case ESTADO_4:
						est4();
					break;
					case ESTADO_5:
						est5();
					break;
					case ESTADO_6:
						est6();
					break;
					case ESTADO_7:
						est7();
						break;
			}
	}
}


