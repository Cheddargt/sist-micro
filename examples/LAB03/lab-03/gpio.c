// gpio.c
// Desenvolvido para a placa EK-TM4C1294XL
// Inicializa as portas A,H,J,K,L,M,N,P,Q 
// Prof. Guilherme Peron

#include <stdint.h>

#include "tm4c1294ncpdt.h"

#define GPIO_PORTALL (0x7F81) //bits 111 1111 1000 0001

// -------------------------------------------------------------------------------
// Função GPIO_Init
// Inicializa os ports J e N ... BLA BLA BLA
// Parâmetro de entrada: Não tem
// Parâmetro de saída: Não tem
void GPIO_Init(void)
{
	//1a. Ativar o clock para a porta setando o bit correspondente no registrador RCGCGPIO
	SYSCTL_RCGCGPIO_R |= GPIO_PORTALL;
	//1b.   após isso verificar no PRGPIO se a porta está pronta para uso.
  while((SYSCTL_PRGPIO_R & (GPIO_PORTALL) ) != (GPIO_PORTALL) ){};
	
	// 2. Limpar o AMSEL para desabilitar a analógica
	GPIO_PORTJ_AHB_AMSEL_R = 0x00;
	GPIO_PORTA_AHB_AMSEL_R = 0x00;
	GPIO_PORTH_AHB_AMSEL_R = 0x00;
	//PRA CIMA TEM AHB, PRA BAIXO N
	GPIO_PORTK_AMSEL_R = 0x00;	
	GPIO_PORTL_AMSEL_R = 0x00;		
	GPIO_PORTM_AMSEL_R = 0x00;	
  GPIO_PORTN_AMSEL_R = 0x00;		
	GPIO_PORTP_AMSEL_R = 0x00;
	GPIO_PORTQ_AMSEL_R = 0x00;
		
	// 3. Limpar PCTL para selecionar o GPIO
	GPIO_PORTJ_AHB_PCTL_R = 0x00;
	GPIO_PORTA_AHB_PCTL_R = 0x00;
	GPIO_PORTH_AHB_PCTL_R = 0x00;
	//PRA CIMA TEM AHB, PRA BAIXO N
	GPIO_PORTK_PCTL_R = 0x00;	
	GPIO_PORTL_PCTL_R = 0x00;		
	GPIO_PORTM_PCTL_R = 0x00;	
  GPIO_PORTN_PCTL_R = 0x00;		
	GPIO_PORTP_PCTL_R = 0x00;
	GPIO_PORTQ_PCTL_R = 0x00;

	// 4. DIR para 0 se for entrada, 1 se for saída
	GPIO_PORTJ_AHB_DIR_R = 0x00;	//user switches
	GPIO_PORTA_AHB_DIR_R = 0xF0;	//1111 0000 leds e display 7 seg
	GPIO_PORTH_AHB_DIR_R = 0x0F;	//entrada do uln2003
	//PRA CIMA TEM AHB, PRA BAIXO N
	GPIO_PORTK_DIR_R = 0xFF;	//1111 1111 LCD
	GPIO_PORTL_DIR_R = 0x00; 	//4 ultimos bits entrada teclado matricial	
	GPIO_PORTM_DIR_R = 0xF7;	//1111 0111 M012 lcd , M4567 teclado matricial
  GPIO_PORTN_DIR_R = 0x03;	//0000 0011 leds da tiva	
	GPIO_PORTP_DIR_R = 0x20;	//0010 0000	transistor ledzinhos
	GPIO_PORTQ_DIR_R = 0x0F;	  //0000 1111 leds e display 7 seg
		
	// 5. Limpar os bits AFSEL para 0 para selecionar GPIO sem função alternativa	
	GPIO_PORTJ_AHB_AFSEL_R = 0x00;
	GPIO_PORTA_AHB_AFSEL_R = 0x00;
	GPIO_PORTH_AHB_AFSEL_R = 0x00;
	//PRA CIMA TEM AHB, PRA BAIXO N
	GPIO_PORTK_AFSEL_R = 0x00;	
	GPIO_PORTL_AFSEL_R = 0x00;		
	GPIO_PORTM_AFSEL_R = 0x00;	
  GPIO_PORTN_AFSEL_R = 0x00;		
	GPIO_PORTP_AFSEL_R = 0x00;
	GPIO_PORTQ_AFSEL_R = 0x00;	
	
	// 6. Setar os bits de DEN para habilitar I/O digital	
	GPIO_PORTJ_AHB_DEN_R = 0x03;	//0000 0011 user switches
	GPIO_PORTA_AHB_DEN_R = 0xF0;	//1111 0000 leds e display 7 seg
	GPIO_PORTH_AHB_DEN_R = 0x0F;	//0000 1111 entrada do uln2003
	//PRA CIMA TEM AHB, PRA BAIXO N
	GPIO_PORTK_DEN_R = 0xFF;	//1111 1111 LCD
	GPIO_PORTL_DEN_R = 0x0F; 	//0000 1111 4 ultimos bits entrada teclado matricial	
	GPIO_PORTM_DEN_R = 0xF7;	//1111 0111 M012 lcd , M4567 teclado matricial
  GPIO_PORTN_DEN_R = 0x03;	//0000 0011 leds da tiva	
	GPIO_PORTP_DEN_R = 0x20;	//0010 0000	transistor ledzinhos
	GPIO_PORTQ_DEN_R = 0x0F;	//0000 1111 leds e display 7 seg
	
	// 7. Habilitar resistor de pull-up interno, setar PUR para 1
	GPIO_PORTJ_AHB_PUR_R = 0x03;   //Bit0 e bit1	
	GPIO_PORTL_PUR_R = 0x0F;   		 //0000 1111 4 ultimos bits entrada teclado matricial	
}	

// -------------------------------------------------------------------------------
// Função PortJ_Input
// Lê os valores de entrada do port J
// Parâmetro de entrada: Não tem
// Parâmetro de saída: o valor da leitura do port
uint32_t PortJ_Input(void)
{
	return GPIO_PORTJ_AHB_DATA_R;
}

uint32_t PortL_Input(void)
{
	return GPIO_PORTL_DATA_R;
}

// -------------------------------------------------------------------------------
// Função PortN_Output
// Escreve os valores no port N
// Parâmetro de entrada: Valor a ser escrito
// Parâmetro de saída: não tem
void PortA_Output(uint32_t valor)
{
    uint32_t temp;
    temp = GPIO_PORTA_AHB_DATA_R & 0x0F;
    //agora vamos fazer o OR com o valor recebido na função
    temp = temp | valor;
    GPIO_PORTA_AHB_DATA_R = temp; 
}

void PortH_Output(uint32_t valor)
{
    uint32_t temp;
    //vamos zerar somente os bits menos significativos
    //para uma escrita amigável nos bits 0 e 1
    temp = GPIO_PORTH_AHB_DATA_R & 0xF0;
    //agora vamos fazer o OR com o valor recebido na função
    temp = temp | valor;
    GPIO_PORTH_AHB_DATA_R = temp; 
}

void PortK_Output(uint32_t valor)
{
    uint32_t temp;
    //vamos zerar somente os bits menos significativos
    //para uma escrita amigável nos bits 0 e 1
    temp = GPIO_PORTK_DATA_R & 0x00;
    //agora vamos fazer o OR com o valor recebido na função
    temp = temp | valor;
    GPIO_PORTK_DATA_R = temp; 
}

void PortM_Output(uint32_t valor)
{
    uint32_t temp;
    //vamos zerar somente os bits menos significativos
    //para uma escrita amigável nos bits 0 e 1
    temp = GPIO_PORTM_DATA_R & 0x08; // INVERSO DE 1111 0111
    //agora vamos fazer o OR com o valor recebido na função
    temp = temp | valor;
    GPIO_PORTM_DATA_R = temp; 
}

void PortN_Output(uint32_t valor)
{
    uint32_t temp;
    //vamos zerar somente os bits menos significativos
    //para uma escrita amigável nos bits 0 e 1
    temp = GPIO_PORTN_DATA_R & 0xFC; 
    //agora vamos fazer o OR com o valor recebido na função
    temp = temp | valor;
    GPIO_PORTN_DATA_R = temp; 
}

void PortP_Output(uint32_t valor)
{
    uint32_t temp;
    //vamos zerar somente os bits menos significativos
    //para uma escrita amigável nos bits 0 e 1
    temp = GPIO_PORTP_DATA_R & 0xDF; // INVERSO DE 0010 0000
    //agora vamos fazer o OR com o valor recebido na função
    temp = temp | valor;
    GPIO_PORTP_DATA_R = temp; 
}

void PortQ_Output(uint32_t valor)
{
    uint32_t temp;
    //vamos zerar somente os bits menos significativos
    //para uma escrita amigável nos bits 0 e 1
    temp = GPIO_PORTQ_DATA_R & 0xF0; // INVERSO DE 0000 1111
    //agora vamos fazer o OR com o valor recebido na função
    temp = temp | valor;
    GPIO_PORTQ_DATA_R = temp; 
}

