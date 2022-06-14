// main.c
// Desenvolvido para a placa EK-TM4C1294XL


#include <stdint.h>
#include <string.h>
#include <stdlib.h>

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

#define TIMER2_TAR_R            (*((volatile uint32_t *)0x40032048))
	


#define GPIO_PORTJ_AHB_ICR_R    (*((volatile uint32_t *)0x4006041C))
	
void PLL_Init(void);
void SysTick_Init(void);
void SysTick_Wait1ms(uint32_t delay);
void GPIO_Init(void);
void	GPIOPortJ_Handler(void);
void Timer2A_Handler(void);
void PortF_Output(uint32_t parametro);
void PortN_Output(uint32_t parametro);

extern uint32_t INICIAR;
uint32_t gameover=1;
uint32_t espera=0;

typedef struct jogador {
	 char nome[15];
		int pontos;
	short noRank;
	
}jogadorTipo;

jogadorTipo *lista[3];


char receptor(){
		char data;
		while((UART0_FR_R  & (1<<4)) != 0){
		
			if(!gameover){
			break;
			}
		};
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


void printranking(){
		
	printstring("\r\nRanking Atualizado\r\n");
	if(lista[0]==NULL){
		printstring("Ranking Vazio , nenhum jogador teve a audacia de jogar\r\n");
	}
	else{
		for(int i=0;(i<3)&&(lista[i]!=NULL);i++){
			char colocacao=(i+1)+'0';
			printstring("\r\n ");
			printstring(&colocacao);
			printstring("   ");
			printstring(lista[i]->nome);
			printstring("   ");
			char p=  lista[i]->pontos+'0';
			printstring(&p);
			printstring(" pontos ");
		}
	}
}



char* getName(){
	static char name[15];
	int i=0;
	while(1){
		char c=receptor();
		
		if(!gameover){
			return NULL;
		}
		if(c=='\x0D'){
				name[i]='\0';
				break;
		}
		else{
			name[i]=c;
			i++;	
		}
		
	}
	return name;
}
void jogo(void);

void gameOVER(jogadorTipo *p){ 
		espera=0;
		gameover=1;
	
		printstring("\r\n   Voce Perdeu!!!");
		printstring("\r\n   ");
		printstring(p->nome);
		printstring("   ");
		char j=  p->pontos+'0';
		printstring(&j);
		printstring("   pontos ");
	
		jogo();
}
int rodada(int i){

		static char certa[15];
		int j;
		printstring("\r\n Rodada ");
		
		char r=  i+'0';
		printstring(&r); 
		
		printstring(", Olhe para a placa ");
		for (j=0;j<i;j++){
			certa[j]='0';
		}
		certa[j]='\0';
		
		
		for(int j=i;j!=0;j--){
			int random=TIMER2_TAR_R%15;
			switch(random+1){
				case 1:
					certa[i-j]='1';
					PortF_Output(0);
					PortN_Output(0);
					SysTick_Wait1ms(2000);
					PortF_Output(1);
					PortN_Output(0);
					SysTick_Wait1ms(3000);
					break;
				case 2:
					certa[i-j]='2';
					PortF_Output(0);
					PortN_Output(0);
					SysTick_Wait1ms(2000);
					PortF_Output(16);
					PortN_Output(0);
					SysTick_Wait1ms(3000);
					break;
				case 3:
					certa[i-j]='3';
					PortF_Output(0);
					PortN_Output(0);
					SysTick_Wait1ms(2000);
					PortF_Output(17);
					PortN_Output(0);
					SysTick_Wait1ms(3000);
					break;
				case 4:
					certa[i-j]='4';
					PortF_Output(0);
					PortN_Output(0);
					SysTick_Wait1ms(2000);
					PortF_Output(0);
					PortN_Output(1);
					SysTick_Wait1ms(3000);
					break;
				case 5:
					certa[i-j]='5';
					PortF_Output(0);
					PortN_Output(0);
					SysTick_Wait1ms(2000);
					PortF_Output(1);
					PortN_Output(1);
					SysTick_Wait1ms(3000);
					break;
				case 6:
					certa[i-j]='6';
					PortF_Output(0);
					PortN_Output(0);
					SysTick_Wait1ms(2000);
					PortF_Output(16);
					PortN_Output(1);
					SysTick_Wait1ms(3000);
					break;
				case 7:
					certa[i-j]='7';
					PortF_Output(0);
					PortN_Output(0);
					SysTick_Wait1ms(2000);
					PortF_Output(17);
					PortN_Output(1);
					SysTick_Wait1ms(3000);
					break;
				case 8:
					certa[i-j]='8';
					PortF_Output(0);
					PortN_Output(0);
					SysTick_Wait1ms(2000);
					PortF_Output(0);
					PortN_Output(2);
					SysTick_Wait1ms(3000);
					break;
				case 9:
					certa[i-j]='9';
					PortF_Output(0);
					PortN_Output(0);
					SysTick_Wait1ms(2000);
					PortF_Output(1);
					PortN_Output(2);
					SysTick_Wait1ms(3000);
					break;
				case 10:
					certa[i-j]='a';
					PortF_Output(0);
					PortN_Output(0);
					SysTick_Wait1ms(2000);
					PortF_Output(16);
					PortN_Output(2);
					SysTick_Wait1ms(3000);
					break;
				case 11:
					certa[i-j]='b';
					PortF_Output(0);
					PortN_Output(0);
					SysTick_Wait1ms(2000);
					PortF_Output(17);
					PortN_Output(2);
					SysTick_Wait1ms(3000);
					break;
				case 12:
					certa[i-j]='c';
					PortF_Output(0);
					PortN_Output(0);
					SysTick_Wait1ms(2000);
					PortF_Output(0);
					PortN_Output(3);
					SysTick_Wait1ms(3000);
					break;
				case 13:
					certa[i-j]='d';
					PortF_Output(0);
					PortN_Output(0);
					SysTick_Wait1ms(2000);
					PortF_Output(1);
					PortN_Output(3);
					SysTick_Wait1ms(3000);
					break;
				case 14:
					certa[i-j]='e';
					PortF_Output(0);
					PortN_Output(0);
					SysTick_Wait1ms(2000);
					PortF_Output(16);
					PortN_Output(3);
					SysTick_Wait1ms(3000);
					break;
				case 15:
					certa[i-j]='f';
					PortF_Output(0);
					PortN_Output(0);
					SysTick_Wait1ms(2000);
					PortF_Output(17);
					PortN_Output(3);
					SysTick_Wait1ms(3000);
					break;
				default:
					break;
			}	
			
		}
		
		TIMER2_TAILR_R=799999999;
		TIMER2_CTL_R=0;
		TIMER2_TAR_R=0;
		TIMER2_CTL_R=1;
		
		PortF_Output(0);
		PortN_Output(0);
		
		espera=1;
		
		//Testes
		printstring("CERTA ");
		printstring(certa);
		
		printstring("\r\nDigite a sequencia: ");
			char *resposta=getName();
			if(!gameover){
				return i;
			}
			for(int k=0;k<i;k++){
				
				if(certa[k]!=resposta[k]){
					gameover=0;
					return i;
				}
			}
		
			espera=0;
			
			return ++i;
		
}
void iniciarjogo(char *name){
	
	int i=1;
	espera=0;
	gameover=1;
	
	jogadorTipo player;
	player.pontos=-1;
	player.noRank=0;
	for (int l=0;l<15;l++)
	{
		player.nome[l]=name[l];
	}
	
	while(gameover){
		
		player.pontos++;
		
		//insere na lista.
		if(player.noRank==0){
			if(lista[2]!=NULL){
				if(player.pontos>lista[2]->pontos){
						lista[2]=&player;
						player.noRank=1;
				}
			}
			else{
				
				lista[2]=&player;
				player.noRank=1;
			}
		}
		
		//Ordena
		for(int j=2;j>0;j--){   //j>0
			if(lista[j-1]==NULL){
				lista[j-1]=lista[j];
				jogadorTipo *p=NULL;
				lista[j]=p;
			}
			else if(lista[j]!=NULL){
				if(lista[j-1]->pontos<lista[j]->pontos){
					jogadorTipo *aux=lista[j];
					lista[j]=lista[j-1];
					lista[j-1]=aux;			
				}
			}
		
		}
		
		i=rodada(i);
	}
	gameOVER(&player);
}
void jogo(){
		INICIAR=1;
		printstring("\r\n\nPressione USR_SW1 para iniciar um novo jogo...");
		while(INICIAR){
		}
		
		printranking();
		printstring("\r\n\nDigite seu nome e aperte <enter>");
		char *name=getName();

	
		iniciarjogo(name);
		return ;
}
void Timer2A_Handler(){
	
	TIMER2_ICR_R=1;	
	TIMER2_CTL_R=1;

	if(espera){
		gameover=0;
		espera=0;
		}
	return;
}

int main(void)
{
	PLL_Init();
	SysTick_Init();
	GPIO_Init();
	
		lista[0]=NULL;
		lista[1]=NULL;
		lista[2]=NULL;
		printstring("\r\nBem vindo ao jogo Genius");
		

		
		jogo();
	
}



