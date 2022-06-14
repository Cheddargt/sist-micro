// main.c
// Desenvolvido para a placa EK-TM4C1294XL


#include <stdint.h>

#define UART0_DR_R              (*((volatile uint32_t *)0x4000C000))
#define UART0_RSR_R             (*((volatile uint32_t *)0x4000C004))
#define UART0_ECR_R             (*((volatile uint32_t *)0x4000C004))
#define UART0_FR_R              (*((volatile uint32_t *)0x4000C018))
#define UART0_ILPR_R            (*((volatile uint32_t *)0x4000C020))
#define UART0_IBRD_R            (*((volatile uint32_t *)0x4000C024))
#define UART0_FBRD_R            (*((volatile uint32_t *)0x4000C028))
#define UART0_LCRH_R            (*((volatile uint32_t *)0x4000C02C))
#define UART0_CTL_R             (*((volatile uint32_t *)0x4000C030))
#define UART0_IFLS_R            (*((volatile uint32_t *)0x4000C034))
#define UART0_IM_R              (*((volatile uint32_t *)0x4000C038))
#define UART0_RIS_R             (*((volatile uint32_t *)0x4000C03C))
#define UART0_MIS_R             (*((volatile uint32_t *)0x4000C040))
#define UART0_ICR_R             (*((volatile uint32_t *)0x4000C044))
#define UART0_DMACTL_R          (*((volatile uint32_t *)0x4000C048))
#define UART0_9BITADDR_R        (*((volatile uint32_t *)0x4000C0A4))
#define UART0_9BITAMASK_R       (*((volatile uint32_t *)0x4000C0A8))
#define UART0_PP_R              (*((volatile uint32_t *)0x4000CFC0))
#define UART0_CC_R              (*((volatile uint32_t *)0x4000CFC8))
	

#define TIMER2_ICR_R 	(*((volatile uint32_t *)0x40032024))
#define TIMER2_CTL_R	(*((volatile uint32_t *)0x4003200C))
#define TIMER2_TAILR_R	(*((volatile uint32_t *)0x40032028))	

void PLL_Init(void);
void SysTick_Init(void);
void SysTick_Wait1ms(uint32_t delay);
void GPIO_Init(void);
void	GPIOPortJ_Handler(void);
void Timer2A_Handler(void);
void PortF_Output(uint32_t parametro);
void PortN_Output(uint32_t parametro);

typedef enum 
{	
	ESTADO_ON,
	ESTADO_OFF

}estadosLED;

typedef enum 
{	
	i_1,
	i_20,
	i_40,
	i_60,
	i_80,
	i_99

}intensidade;



estadosLED estados = ESTADO_ON;
intensidade i =i_1;

char receptor(){
		char data;
		while((UART0_FR_R  & (1<<4)) != 0){};
		data =UART0_DR_R;
		return data; 
}
void transmissor(char data){ 
	
		while((UART0_FR_R & (1<<5)) != 0){}; 
    UART0_DR_R = data; 
}
void printstring(char *str)
{
  while(*str)
	{
		transmissor(*(str++));
	}
}

void inverte(){
		if(estados==ESTADO_ON)
		{
			estados=ESTADO_OFF;
			PortF_Output(0);
			switch(i){
					case i_1:
						TIMER2_TAILR_R=79199;
					break;
					case i_20:
						TIMER2_TAILR_R=63999;
					break;
					case i_40:
						TIMER2_TAILR_R=47999;
					break;
					case i_60:
						TIMER2_TAILR_R=31999;
					break;
					case i_80:
						TIMER2_TAILR_R=15999;
					break;
					case i_99:
						TIMER2_TAILR_R=799;
					break;
				}
			return;
		}
		else{
			estados=ESTADO_ON;
			PortF_Output(1);
			switch(i){
					case i_99:
						TIMER2_TAILR_R=79199;
					break;
					case i_80:
						TIMER2_TAILR_R=63999;
					break;
					case i_60:
						TIMER2_TAILR_R=47999;
					break;
					case i_40:
						TIMER2_TAILR_R=31999;
					break;
					case i_20:
						TIMER2_TAILR_R=15999;
					break;
					case i_1:
						TIMER2_TAILR_R=799;
					break;
				}
			return;
		}
}

void Timer2A_Handler(){
	TIMER2_ICR_R=1;
	inverte();
	TIMER2_CTL_R=1;
	return;
}
int main(void)
{
	PLL_Init();
	SysTick_Init();
	GPIO_Init();
	printstring("\r\nStart 1%");
	while(1){
	
	char c=receptor();

	switch(c){
					case '1':
						printstring("\r\nLED a 1%");
						i =i_1;
					break;
					case '2':
						printstring("\r\nLED a 20%");
						i =i_20;
					break;
					
					case '3':
						printstring("\r\nLED a 40%");
						i =i_40;
					break;
					case '4':
						printstring("\r\nLED a 60%");
						i =i_60;
					break;
					case '5':
						printstring("\r\nLED a 80%");
						i =i_80;
					break;
					case '6':
						printstring("\r\nLED a 99%");
						i =i_99;
					break;
					default:
					break;
	}
	}
     
}



