// main.c
// Desenvolvido para a placa EK-TM4C1294XL
// Verifica o estado da chave USR_SW2 e acende os LEDs 1 e 2 caso esteja pressionada
// Prof. Guilherme Peron

#include <stdint.h>
											//LINHA COLUNA
#define UM 0x77;   //0111 0111
#define DOIS 0x7B; 	//0111 1011
#define TRES 0x7D;	  //0111 1101
#define QUATRO 0xB7;   //1011 0111
#define CINCO 0xBB;   //1011 1011
#define SEIS 0xBD;   //1011 1101
#define SETE 0xD7;   //1101 0111
#define OITO 0xDB;   //1101 1011
#define NOVE 0xDD;   //1101 1101
#define ZERO 0xEB;   //1110 1011
#define ESTRELA 0xE7;		//1110 0111


void PLL_Init(void);
void DisplayInit (void);
void SysTick_Init(void);
void SysTick_Wait1ms(uint32_t delay);
void SysTick_Wait1us(uint32_t delay);
void GPIO_Init(void);

void Ledzinhos (void);
void DisplayEscreve (char *mensagem);
void DisplayLimpa(void);
void PassoCompletoDir (void);
void PassoCompletoEsq (void);
void MeioPassoDir (void);
void MeioPassoEsq (void);
void VaiDirecao(void);


int32_t Debounce(void);
int32_t LeMatriz(void);

uint32_t PortJ_Input(void);
uint32_t PortL_Input(void);
void PortA_Output(uint32_t leds);
void PortH_Output(uint32_t leds);
void PortJ_Output(uint32_t leds);
void PortK_Output(uint32_t leds);
void PortL_Output(uint32_t leds);
void PortM_Output(uint32_t leds);
void PortN_Output(uint32_t leds);
void PortP_Output(uint32_t leds);
void PortQ_Output(uint32_t leds);


int main(void)
{
	int32_t numeroDeVoltas;
	PLL_Init();
	SysTick_Init();
	GPIO_Init();
	DisplayInit();
	PortP_Output(0x20);
	while (1)
	{
		  DisplayLimpa();
			DisplayEscreve("Digite o numero de voltas: ");
			int32_t numDigitado = 20;
			while(numDigitado > 10)
			{
					numDigitado = Debounce();
					int32_t aux = UM;
					if(numDigitado == aux)
					{
							DisplayEscreve("1");
							numDigitado = 1;
					}
					aux = DOIS;
					if(numDigitado == aux)
					{
							DisplayEscreve("2");
							numDigitado = 2;
					}
					aux = TRES;
					if(numDigitado == aux)
					{
							DisplayEscreve("3");
							numDigitado = 3;
					}
					aux = QUATRO;
					if(numDigitado == aux)
					{
							DisplayEscreve("4");
							numDigitado = 4;
					}
					aux = CINCO;
					if(numDigitado == aux)
					{
							DisplayEscreve("5");
							numDigitado = 5;
					}
					aux = SEIS;
					if(numDigitado == aux)
					{
							DisplayEscreve("6");
							numDigitado = 6;
					}
					aux = SETE;
					if(numDigitado == aux)
					{
							DisplayEscreve("7");
							numDigitado = 7;
					}
					aux = OITO;
					if(numDigitado == aux)
					{
							DisplayEscreve("8");
							numDigitado = 8;
					}
					aux = NOVE;
					if(numDigitado == aux)
					{
							DisplayEscreve("9");
							numDigitado = 9;
					}
					if(numDigitado == 1)
					{
							numDigitado = Debounce();
							aux = ZERO;
							if(numDigitado == aux)
							{
									DisplayEscreve("0");
									numDigitado = 10;
							}
							else
								numDigitado = 1;
					}
			}
			numeroDeVoltas = numDigitado;
			SysTick_Wait1ms(1000);
			DisplayLimpa();
			DisplayEscreve("Sentido rotacao 1 dir 2 esq: ");
			numDigitado = 5; // valor qql pra entrar no whileee
			while(numDigitado > 2)
			{
					numDigitado = Debounce();
					int32_t aux = UM;
					if(numDigitado == aux)
					{
					
						DisplayEscreve("1");
							numDigitado = 1;
					}
					aux = DOIS;
					if(numDigitado == aux)
					{
							DisplayEscreve("2");
							numDigitado = 2;
					}
			}
			
			int32_t sentido = numDigitado;
			SysTick_Wait1ms(1000);
			DisplayLimpa();
			DisplayEscreve("1 Passo Completo2 Meio Passo: ");
			numDigitado = 5; // valor qql pra entrar no whileee
			while(numDigitado > 2)
			{
					numDigitado = Debounce();
					int32_t aux = UM;
					if(numDigitado == aux)
					{
							DisplayEscreve("1");
							numDigitado = 1;
					}
					aux = DOIS;
					if(numDigitado == aux)
					{
							DisplayEscreve("2");
							numDigitado = 2;
					}
			}
			
			int32_t passo = numDigitado;
		
			if(passo == 1)
			{
				if(sentido == 1)
				{		
						DisplayLimpa();
						DisplayEscreve("Passo Completo  p/ dir, falta:");
				}
				if(sentido == 2)
				{		
						DisplayLimpa();
						DisplayEscreve("Passo Completo  p/ esq, falta:");
				}
			}
			else
			{
				if(sentido == 1)
				{		
						DisplayLimpa();
						DisplayEscreve("Meio Passo      p/ dir, falta:");
				}
				if(sentido == 2)
				{		
						DisplayLimpa();
						DisplayEscreve("Meio Passo      p/ esq, falta:");
				}
			}
			
			char a = numeroDeVoltas + '0';
			if(numeroDeVoltas ==10)
				DisplayEscreve("10");
			else
				DisplayEscreve(&a);
			
			int x = 0,z=1;
			float graus = 0;
			
			for(int i=1;i<=numeroDeVoltas*525;i++)
			{
				graus += (360.0/525.0);
				if(graus >= 20.0)
				{
					if(x == 8)
					{
						PortA_Output(0);		//zera as portas A
						z=1;
						x = 0;
					}
					if(x == 4)
						PortQ_Output(0);		//zera as portas Q
					if(x < 4)
					{
						PortQ_Output(z);
						z = z << 1;
						x++;
					}
					
					else if(x >= 4 && x<8)
					{
						PortA_Output(z);
						z = z << 1;
						x++;
					}
					
					graus -= 20.0;
				}
				if(i%270 == 0)
				{
					a = numeroDeVoltas-(i/525)+'0'; 
					VaiDirecao();
					DisplayEscreve(&a);
					DisplayEscreve(" ");
				}
				if(passo == 1)
				{
					if(sentido == 1)
					{	
							PassoCompletoDir();
					}
					else
						PassoCompletoEsq();
				}
				if(passo == 2)
				{
					if(sentido == 1)
						MeioPassoDir();
					else
						MeioPassoEsq();
				}
			}
			DisplayLimpa();
			DisplayEscreve("FIM");
			int32_t aux = ESTRELA;
			while(numDigitado != aux)
				numDigitado = Debounce();
			
			PortQ_Output(0);
			PortA_Output(0);
	}	
}

void PassoCompletoDir (void)
{
	PortH_Output(0x01);
	SysTick_Wait1ms(5);
	PortH_Output(0x02);
	SysTick_Wait1ms(5);
	PortH_Output(0x04);
	SysTick_Wait1ms(5);
	PortH_Output(0x08);
	SysTick_Wait1ms(5);
}


void PassoCompletoEsq (void)
{
	PortH_Output(0x08);
	SysTick_Wait1ms(3);
	PortH_Output(0x04);
	SysTick_Wait1ms(3);
	PortH_Output(0x02);
	SysTick_Wait1ms(3);
	PortH_Output(0x01);
	SysTick_Wait1ms(3);
}

void MeioPassoDir (void)
{
	PortH_Output(0x01);
	SysTick_Wait1ms(3);
	PortH_Output(0x03);
	SysTick_Wait1ms(3);
	PortH_Output(0x02);
	SysTick_Wait1ms(3);
	PortH_Output(0x06);
	SysTick_Wait1ms(3);
	PortH_Output(0x04);
	SysTick_Wait1ms(3);
	PortH_Output(0x0C);
	SysTick_Wait1ms(3);
	PortH_Output(0x08);
	SysTick_Wait1ms(3);
	PortH_Output(0x09);
	SysTick_Wait1ms(3);
}

void MeioPassoEsq (void)
{
	PortH_Output(0x09);
	SysTick_Wait1ms(3);
	PortH_Output(0x08);
	SysTick_Wait1ms(3);
	PortH_Output(0x12);
	SysTick_Wait1ms(3);
	PortH_Output(0x04);
	SysTick_Wait1ms(3);
	PortH_Output(0x06);
	SysTick_Wait1ms(3);
	PortH_Output(0x02);
	SysTick_Wait1ms(3);
	PortH_Output(0x03);
	SysTick_Wait1ms(3);
	PortH_Output(0x01);
	SysTick_Wait1ms(3);
}


int32_t Debounce(void)
{
		int32_t lido = 0, aux, i, estaveis = 0;
		while(!lido)
				lido = LeMatriz();
		
		SysTick_Wait1ms(10);
		
		for(i = 1; i <= 60; i++)
		{
				aux = LeMatriz();
				if(aux == lido)
					estaveis++;
				SysTick_Wait1ms(1);
		}
		if(estaveis < 45)
			return 0;
		
		while(LeMatriz());
		
		return lido;
}

int32_t LeMatriz(void)
{
		int32_t aux, retorno;
		retorno = 0xE0; 				//2_11100000
		PortM_Output(retorno); 	//DETECTA SE ALGM DA 1 COLUNA FOI PRESSIONADO
		aux = PortL_Input();
		if (aux != 0xF) 				//VERIFICA SE ALGUMA LINHA FOI PRESSIONADA
		{
				return retorno+aux;
		}
		
		retorno = 0xD0; //2_1101 0000
		PortM_Output(retorno); //DETECTA SE ALGM DA 2 COLUNA FOI PRESSIONADO
		aux = PortL_Input();
		if (aux != 0xF) 				//VERIFICA SE ALGUMA LINHA FOI PRESSIONADA
		{
				return retorno+aux;
		}
		
		retorno = 0xB0; //2_1011 0000
		PortM_Output(retorno); //DETECTA SE ALGM DA 3 COLUNA FOI PRESSIONADO
		aux = PortL_Input();
		if (aux != 0xF) 				//VERIFICA SE ALGUMA LINHA FOI PRESSIONADA
		{
				return retorno+aux;
		}
		
		retorno = 0x70; //2_0111 0000
		PortM_Output(retorno); //DETECTA SE ALGM DA 3 COLUNA FOI PRESSIONADO
		aux = PortL_Input();
		if (aux != 0xF) 				//VERIFICA SE ALGUMA LINHA FOI PRESSIONADA
		{
				return retorno+aux;
		}
		return 0;
}	


void DisplayInit (void)
{
		PortM_Output(4);			//ATIVA A ENTRADA DE INTSTRUCOES
		PortK_Output(0x38);		//iniciando no modo 2 linhas
		SysTick_Wait1us(10);
		PortM_Output(0);			//ATIVA A ENTRADA DE INTSTRUCOES
		SysTick_Wait1us(40);
													//iniciando cursor com autoincremento p direita
		PortM_Output(4);			//ATIVA A ENTRADA DE INTSTRUCOES
		PortK_Output(0x06);		 
		SysTick_Wait1us(10);
		PortM_Output(0);			//ATIVA A ENTRADA DE INTSTRUCOES
		SysTick_Wait1us(40);
													//iniciando o cursor (habilitar o display + cursor + não-pisca)
	  PortM_Output(4);			//ATIVA A ENTRADA DE INTSTRUCOES
		PortK_Output(0x0E);
		SysTick_Wait1us(10);
	  PortM_Output(0);
		SysTick_Wait1us(40);
}

void DisplayEscreve (char *mensagem)
{
		int i=0;
		for(i=0;mensagem[i];i++)
		{
			PortM_Output(5);			// Ativa entrada de dados
			PortK_Output(mensagem[i]); //valor que vai ser escrito
			SysTick_Wait1us(40);
			PortM_Output(0);
			SysTick_Wait1us(1640);
			if(i==15)
			{
				PortM_Output(4);			//ATIVA A ENTRADA DE INTSTRUCOES
				PortK_Output(0xC0);		//intrução para limpar
				SysTick_Wait1us(40);
				PortM_Output(0);			//ATIVA A ENTRADA DE INTSTRUCOES
				SysTick_Wait1us(1640);
			}
		}
}

void VaiDirecao (void)
{
		PortM_Output(4);			//ATIVA A ENTRADA DE INTSTRUCOES
		PortK_Output(0xCE);		//intrução para limpar
		SysTick_Wait1us(40);
		PortM_Output(0);			//ATIVA A ENTRADA DE INTSTRUCOES
		SysTick_Wait1us(1640);
}

void DisplayLimpa(void)
{
		PortM_Output(4);			//ATIVA A ENTRADA DE INTSTRUCOES
		PortK_Output(0x1);		//intrução para limpar
		SysTick_Wait1us(40);
		PortM_Output(0);			//ATIVA A ENTRADA DE INTSTRUCOES
		SysTick_Wait1us(1640);
}	



void Ledzinhos (void)
{
	int i,j=1;
	for (i=0; i<4 ; i++)
		{
			PortQ_Output(j);
			j = j << 1;
		}
		PortQ_Output(0);		//zera as portas Q
		for (i=4;i<8;i++)
		{
			PortA_Output(j);
			j = j << 1;
		}
		PortA_Output(0);		//zera as portas A
		j=1;
}
