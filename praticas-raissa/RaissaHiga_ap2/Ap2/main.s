; main.s
; Desenvolvido para a placa EK-TM4C1294XL
; Prof. Guilherme Peron
; Rev1: 10/03/2018
; Rev2: 10/04/2019
; Este programa espera o usuário apertar a chave USR_SW1 e/ou a chave USR_SW2.
; Caso o usuário pressione a chave USR_SW1, acenderá o LED3 (PF4). Caso o usuário pressione 
; a chave USR_SW2, acenderá o LED4 (PF0). Caso as duas chaves sejam pressionadas, os dois 
; LEDs acendem.

; -------------------------------------------------------------------------------
        THUMB                        ; Instruções do tipo Thumb-2
; -------------------------------------------------------------------------------
; Declarações EQU - Defines
;<NOME>         EQU <VALOR>
; ========================


; -------------------------------------------------------------------------------
; Área de Dados - Declarações de variáveis
		AREA  DATA, ALIGN=2
		; Se alguma variável for chamada em outro arquivo
		;EXPORT  <var> [DATA,SIZE=<tam>]   ; Permite chamar a variável <var> a 
		                                   ; partir de outro arquivo
;<var>	SPACE <tam>                        ; Declara uma variável de nome <var>
                                           ; de <tam> bytes a partir da primeira 
                                           ; posição da RAM		

; -------------------------------------------------------------------------------
; Área de Código - Tudo abaixo da diretiva a seguir será armazenado na memória de 
;                  código
        AREA    |.text|, CODE, READONLY, ALIGN=2

		; Se alguma função do arquivo for chamada em outro arquivo	
        EXPORT Start                ; Permite chamar a função Start a partir de 
			                        ; outro arquivo. No caso startup.s
									
		; Se chamar alguma função externa	
        ;IMPORT <func>              ; Permite chamar dentro deste arquivo uma 
									; função <func>
		IMPORT  GPIO_Init
        IMPORT  PortF_Output
        IMPORT  PortJ_Input
		IMPORT	PortN_Output
		IMPORT  PLL_Init
		IMPORT  SysTick_Init
		IMPORT  SysTick_Wait1ms	
; -------------------------------------------------------------------------------
; Função main()
Start  			
	BL GPIO_Init                 ;Chama a subrotina que inicializa os GPIO
	BL PLL_Init                  ;Chama a subrotina para alterar o clock do microcontrolador para 80MHz
	BL SysTick_Init
	MOV R4,#0
	MOV R5,#0
	MOV R6,#0
	MOV R7,#0
MainLoop
	BL Verifica_Chaves
	BL Acende_LEDS
	BL Espera
	B MainLoop             ;Volta para o laço principal	
	
	
; -------------------------------------------------------------------------------
; Função que verifica chaves e muda operação e delay
Verifica_Chaves
	PUSH {LR}
	BL PortJ_Input	

	CMP R0, #2_00000010			 ;Verifica se somente a chave SW1 está pressionada
	BNE Verifica_S2			     ;Se o teste falhou, pula

	CMP R4,#0						;Muda modo de Operação
	ITE EQ
		MOVEQ R4,#1
		MOVNE R4,#0
	B fim
Verifica_S2
	CMP R0, #2_00000001				;Muda delay
	BNE fim 
	CMP R7,#3
	ITE NE
		ADDNE R7,#1
		MOVEQ R7,#0
fim
	MOV R0, #100               ;Chamar a rotina para esperar 0,1
	BL SysTick_Wait1ms
nenhumaPressionada
	BL PortJ_Input	
	CMP R0, #2_11
	BNE nenhumaPressionada
	POP {LR}
	BX LR
	

; -------------------------------------------------------------------------------
; Função que verifica modo de operação e acende os LEDs
Acende_LEDS
	PUSH {LR}
	
	CMP R4,#0 				;Verifica Modo
	BNE counter				;Pula pro contador
	
	CMP R5,#0				;Passeio do cavaleiro
	BEQ LED1
	CMP R5,#1
	BEQ LED2
	CMP R5,#2
	BEQ LED3
	CMP R5,#3
	BEQ LED4
	CMP R5,#4
	BEQ LED3
	CMP R5,#5
	BEQ LED2
LED1
	MOV R0, #2_10
	BL	PortN_Output
	MOV R0, #2_0
	BL	PortF_Output
	B fim3
LED2
	MOV R0, #2_1
	BL	PortN_Output
	MOV R0, #2_0
	BL	PortF_Output
	B fim3
LED3
	MOV R0, #2_10000
	BL	PortF_Output
	MOV R0, #2_0
	BL	PortN_Output
	B fim3
LED4
	MOV R0, #2_1
	BL	PortF_Output
	MOV R0, #2_0
	BL	PortN_Output
	B fim3	

counter
	CMP R6,#0
	BEQ ZERO
	CMP R6,#1
	BEQ UM
	CMP R6,#2
	BEQ DOIS
	CMP R6,#3
	BEQ TRES
	CMP R6,#4
	BEQ QUATRO
	CMP R6,#5
	BEQ CINCO
	CMP R6,#6
	BEQ SEIS
	CMP R6,#7
	BEQ SETE
	CMP R6,#8
	BEQ OITO
	CMP R6,#9
	BEQ NOVE
	CMP R6,#10
	BEQ DEZ
	CMP R6,#11
	BEQ ONZE
	CMP R6,#12
	BEQ DOZE
	CMP R6,#13
	BEQ TREZE
	CMP R6,#14
	BEQ QUATORZE
	CMP R6,#15
	BLEQ QUINZE
ZERO
	MOV R0, #2_0
	BL	PortF_Output
	BL	PortN_Output
	B fim2	
UM
	MOV R0, #2_1
	BL	PortF_Output
	MOV R0, #2_0
	BL	PortN_Output
	B fim2	
DOIS
	MOV R0, #2_10000
	BL	PortF_Output
	MOV R0, #2_0
	BL	PortN_Output
	B fim2	
TRES
	MOV R0, #2_10001
	BL	PortF_Output
	MOV R0, #2_0
	BL	PortN_Output
	B fim2	
QUATRO
	MOV R0, #2_0
	BL	PortF_Output
	MOV R0, #2_01
	BL	PortN_Output
	B fim2	
CINCO
	MOV R0, #2_1
	BL	PortF_Output
	MOV R0, #2_01
	BL	PortN_Output
	B fim2	
SEIS
	MOV R0, #2_10000
	BL	PortF_Output
	MOV R0, #2_1
	BL	PortN_Output
	B fim2	
SETE
	MOV R0, #2_10001
	BL	PortF_Output
	MOV R0, #2_01
	BL	PortN_Output
	B fim2	
OITO
	MOV R0, #2_0
	BL	PortF_Output
	MOV R0, #2_10
	BL	PortN_Output
	B fim2	
NOVE
	MOV R0, #2_1
	BL	PortF_Output
	MOV R0, #2_10
	BL	PortN_Output
	B fim2	
DEZ
	MOV R0, #2_10000
	BL	PortF_Output
	MOV R0, #2_10
	BL	PortN_Output
	B fim2	
ONZE
	MOV R0, #2_10001
	BL	PortF_Output
	MOV R0, #2_10
	BL	PortN_Output
	B fim2	
DOZE
	MOV R0, #2_0
	BL	PortF_Output
	MOV R0, #2_11
	BL	PortN_Output
	B fim2	
TREZE
	MOV R0, #2_1
	BL	PortF_Output
	MOV R0, #2_11
	BL	PortN_Output
	B fim2	
QUATORZE
	MOV R0, #2_10000
	BL	PortF_Output
	MOV R0, #2_11
	BL	PortN_Output
	B fim2	
QUINZE
	PUSH {LR}
	MOV R0, #2_10001
	BL	PortF_Output
	MOV R0, #2_11
	BL	PortN_Output
	POP {LR}
	B fim2	

fim2
	CMP R6,#15
	ITE EQ
		MOVEQ R6,#0
		ADDNE R6,#1
	POP {LR}
	BX LR

fim3
	CMP R5,#5
	ITE EQ
		MOVEQ R5,#0
		ADDNE R5,#1
	POP {LR}
	BX LR

; -------------------------------------------------------------------------------
; Função de Espera
Espera
	PUSH {LR}
	CMP R7,#0					;Verifica a velocidade  e pula
	BEQ t1
	CMP R7,#1
	BEQ t2
	CMP R7,#2
	BEQ t3
t1
	MOV R0, #1000                ;Chamar a rotina para esperar 1s
	BL SysTick_Wait1ms
	B final
t2	
	MOV R0, #500                ;Chamar a rotina para esperar 0,5s
	BL SysTick_Wait1ms
	B final
t3	
	MOV R0, #200               ;Chamar a rotina para esperar 0,2s
	BL SysTick_Wait1ms
final	
	POP {LR}
	BX LR
	

    ALIGN                        ;Garante que o fim da seção está alinhada 
    END                          ;Fim do arquivo
