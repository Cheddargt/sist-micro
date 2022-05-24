; main.s
; Desenvolvido para a placa EK-TM4C1294XL
; Prof. Guilherme Peron
; 24/08/2020
; Este programa espera o usuário apertar a chave USR_SW1.
; Caso o usuário pressione a chave, o LED1 piscará a cada 0,5 segundo.

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
		IMPORT  PLL_Init
		IMPORT  SysTick_Init
		IMPORT  SysTick_Wait1ms			
		IMPORT  GPIO_Init
        IMPORT  PortB_Output
        IMPORT  PortJ_Input
		IMPORT  PortP_Output
		IMPORT  PortA_Output
		IMPORT  PortQ_Output


DISPLAY_ESQUERDO EQU 0x20000A00 ;Pilha que guarda os valores do display esquerdo
DISPLAY_DIREITO EQU 0x20000B00 ;Pilha que guarda os valores do display direito
LED EQU 0x20000C00 ;Pilha que guarda os valores dos led

; -------------------------------------------------------------------------------
; Função main()
Start  		
	BL PLL_Init                  ;Chama a subrotina para alterar o clock do microcontrolador para 80MHz
	BL SysTick_Init
	BL GPIO_Init                 ;Chama a subrotina que inicializa os GPIO
	
	MOV R4,#0 ;Número do display esquerdo
	MOV R5,#0 ;Número do display direito
	MOV R6,#0 ;Número do LED
	MOV R7,#0 ;Quantidade que apertou o botão
	
	LDR R8, =DISPLAY_ESQUERDO ;Início dos vetores
	LDR R9, =DISPLAY_DIREITO
	LDR R10, =LED
	
	MOV R11,#0 ;Iterador do LED
	MOV R12, #150 ;Passo
 

MainLoop					
	BL Verifica_Chaves 	; aumentar passo = diminuir velocidade e vice-versa
	BL Acende_LEDS
	BL Espera 			; "pisca" os transistores pros leds poderem ser visualizados
	B MainLoop          ; Volta para o laço principal	
	
	
; -------------------------------------------------------------------------------
; Função que verifica chaves e muda operação e delay
Verifica_Chaves
	PUSH {LR}
	BL PortJ_Input  			 ; porta de saída da chave

	CMP R0, #2_00000010			 ;Verifica se somente a chave SW1 está pressionada
	BNE Verifica_S2			     ;Se o teste falhou, pula

	CMP R7,#9						;Muda modo de Operação
	ITE CC
		ADDCC R7, R7, #1
		MOVCS R7,#0
	B fim
Verifica_S2
	CMP R0, #2_00000001				;Muda delay
	BNE fim 
	CMP R7,#0						;Muda modo de Operação
	ITE EQ
		MOVEQ R7, #9
		SUBNE R7, R7, #1
	B fim 
	
fim
	MOV R0, #5               ; Chamar a rotina para esperar 0,1
	BL SysTick_Wait1ms
nenhumaPressionada
	BL PortJ_Input	
	CMP R0, #2_11
	BNE nenhumaPressionada
	POP {LR}				; remove o registrador LR da pilha
	BX LR


; -------------------------------------------------------------------------------
; Função que verifica modo de operação e acende os LEDs
Acende_LEDS
	PUSH {LR}

Cavaleiro	
	CMP R6,#0				;Passeio do cavaleiro
	BEQ LED1
	CMP R6,#1
	BEQ LED2
	CMP R6,#2
	BEQ LED3
	CMP R6,#3
	BEQ LED4
	CMP R6,#4
	BEQ LED5
	CMP R6,#5
	BEQ LED6
	CMP R6,#6
	BEQ LED7
	CMP R6,#7
	BEQ LED8
	CMP R6,#8
	BEQ LED7
	CMP R6,#9
	BEQ LED6
	CMP R6,#10
	BEQ LED5
	CMP R6,#11
	BEQ LED4
	CMP R6,#12
	BEQ LED3
	CMP R6,#13
	BEQ LED2
LED1
	MOV R0, #2_00000001
	STRB R0, [R10], #8
;	BL	PortQ_Output
	MOV R0, #2_00000000
	STRB R0, [R10], #8
	LDR R10, =LED
;	BL	PortA_Output
;	MOV R0, #2_100000
;	BL	PortP_Output
	B forexterno
LED2
	MOV R0, #2_00000010
	STRB R0, [R10], #8
;	BL	PortQ_Output
	MOV R0, #2_00000000
	STRB R0, [R10], #8
	LDR R10, =LED
;	BL	PortA_Output
;	MOV R0, #2_100000
;	BL	PortP_Output
	B forexterno
LED3
	MOV R0, #2_00000100
	STRB R0, [R10], #8
;	BL	PortQ_Output
	MOV R0, #2_00000000
	STRB R0, [R10], #8
	LDR R10, =LED
;	BL	PortA_Output
;	MOV R0, #2_100000
;	BL	PortP_Output
	B forexterno
LED4
	MOV R0, #2_00001000
	STRB R0, [R10], #8
;	BL	PortQ_Output
	MOV R0, #2_00000000
	STRB R0, [R10], #8
	LDR R10, =LED
;	BL	PortA_Output
;	MOV R0, #2_100000
;	BL	PortP_Output
	B forexterno
	
LED5
	MOV R0, #2_00000000
	STRB R0, [R10], #8
;	BL	PortQ_Output
	MOV R0, #2_00010000
	STRB R0, [R10], #8
	LDR R10, =LED
;	BL	PortA_Output
;	MOV R0, #2_100000
;	BL	PortP_Output
	B forexterno
	
LED6
	MOV R0, #2_00000000
	STRB R0, [R10], #8
;	BL	PortQ_Output
	MOV R0, #2_00100000
	STRB R0, [R10], #8
	LDR R10, =LED
;	BL	PortA_Output
;	MOV R0, #2_100000
;	BL	PortP_Output
	B forexterno

LED7
	MOV R0, #2_00000000
	STRB R0, [R10], #8
;	BL	PortQ_Output
	MOV R0, #2_01000000
	STRB R0, [R10], #8
	LDR R10, =LED
;	BL	PortA_Output
;	MOV R0, #2_100000
;	BL	PortP_Output
	B forexterno
	
LED8
	MOV R0, #2_00000000
	STRB R0, [R10], #8
;	BL	PortQ_Output
	MOV R0, #2_10000000
	STRB R0, [R10], #8
	LDR R10, =LED
;	BL	PortA_Output
;	MOV R0, #2_100000
;	BL	PortP_Output
	B forexterno

forexterno
	
	;Compara para o display externo
	CMP R4,#0				
	BEQ displayEsq0
	CMP R4,#1
	BEQ displayEsq1
	CMP R4,#2
	BEQ displayEsq2
	CMP R4,#3
	BEQ displayEsq3
	CMP R4,#4
	BEQ displayEsq4
	CMP R4,#5
	BEQ displayEsq5
	CMP R4,#6
	BEQ displayEsq6
	CMP R4,#7
	BEQ displayEsq7
	CMP R4,#8
	BEQ displayEsq8
	CMP R4,#9
	BEQ displayEsq9
	
displayEsq0
	MOV R0, #2_00001111
	STRB R0, [R8], #8
;	BL	PortQ_Output
	MOV R0, #2_00110000
	STRB R0, [R8], #8
	LDR R8, =DISPLAY_ESQUERDO
;	BL	PortA_Output
;	MOV R0, #2_010000
;	BL	PortB_Output
	B forinterno
	
displayEsq1
	MOV R0, #2_00000110
	STRB R0, [R8], #8
;	BL	PortQ_Output
	MOV R0, #2_00000000
	STRB R0, [R8], #8
	LDR R8, =DISPLAY_ESQUERDO
;	BL	PortA_Output
;	MOV R0, #2_010000
;	BL	PortB_Output
	B forinterno

displayEsq2
	MOV R0, #2_00001011
	STRB R0, [R8], #8
;	BL	PortQ_Output
	MOV R0, #2_01010000
	STRB R0, [R8], #8
	LDR R8, =DISPLAY_ESQUERDO
;	BL	PortA_Output
;	MOV R0, #2_010000
;	BL	PortB_Output
	B forinterno

displayEsq3
	MOV R0, #2_00001111
	STRB R0, [R8], #8
;	BL	PortQ_Output
	MOV R0, #2_01000000
	STRB R0, [R8], #8
	LDR R8, =DISPLAY_ESQUERDO
;	BL	PortA_Output
;	MOV R0, #2_010000
;	BL	PortB_Output
	B forinterno

displayEsq4
	MOV R0, #2_00000110
	STRB R0, [R8], #8
;	BL	PortQ_Output
	MOV R0, #2_01100000
	STRB R0, [R8], #8
	LDR R8, =DISPLAY_ESQUERDO
;	BL	PortA_Output
;	MOV R0, #2_010000
;	BL	PortB_Output
	B forinterno

displayEsq5
	MOV R0, #2_00001101
	STRB R0, [R8], #8
;	BL	PortQ_Output
	MOV R0, #2_01100000
	STRB R0, [R8], #8
	LDR R8, =DISPLAY_ESQUERDO
;	BL	PortA_Output
;	MOV R0, #2_010000
;	BL	PortB_Output
	B forinterno

displayEsq6
	MOV R0, #2_00001101
	STRB R0, [R8], #8
;	BL	PortQ_Output
	MOV R0, #2_01110000
	STRB R0, [R8], #8
	LDR R8, =DISPLAY_ESQUERDO
;	BL	PortA_Output
;	MOV R0, #2_010000
;	BL	PortB_Output
	B forinterno

displayEsq7
	MOV R0, #2_00000111
	STRB R0, [R8], #8
;	BL	PortQ_Output
	MOV R0, #2_00000000
	STRB R0, [R8], #8
	LDR R8, =DISPLAY_ESQUERDO
;	BL	PortA_Output
;	MOV R0, #2_010000
;	BL	PortB_Output
	B forinterno

displayEsq8
	MOV R0, #2_00001111
	STRB R0, [R8], #8
;	BL	PortQ_Output
	MOV R0, #2_01110000
	STRB R0, [R8], #8
	LDR R8, =DISPLAY_ESQUERDO
;	BL	PortA_Output
	B forinterno

displayEsq9
	MOV R0, #2_00001111
	STRB R0, [R8], #8
;	BL	PortQ_Output
	MOV R0, #2_01100000
	STRB R0, [R8], #8
	LDR R8, =DISPLAY_ESQUERDO
;	BL	PortA_Output
	B forinterno
	
forinterno	
	
	;Compara
	CMP R5,#0				
	BEQ dirZero
	CMP R5,#1
	BEQ dirUm
	CMP R5,#2
	BEQ dirDois
	CMP R5,#3
	BEQ dirTres
	CMP R5,#4
	BEQ dirQuatro
	CMP R5,#5
	BEQ dirCinco
	CMP R5,#6
	BEQ dirSeis
	CMP R5,#7
	BEQ dirSete
	CMP R5,#8
	BEQ dirOito
	CMP R5,#9
	BEQ dirNove
	
dirZero
	MOV R0, #2_00001111
	STRB R0, [R9], #8
;	BL	PortQ_Output
	MOV R0, #2_00110000
	STRB R0, [R9], #8
	LDR R9, =DISPLAY_DIREITO
;	BL	PortA_Output
;	MOV R0, #2_100000
;	BL	PortB_Output
	B fimacende
	
dirUm
	MOV R0, #2_00000110
	STRB R0, [R9], #8
;	BL	PortQ_Output
	MOV R0, #2_00000000
	STRB R0, [R9], #8
	LDR R9, =DISPLAY_DIREITO
;	BL	PortA_Output
;	MOV R0, #2_100000
;	BL	PortB_Output
	B fimacende

dirDois
	MOV R0, #2_00001011
	STRB R0, [R9], #8
;	BL	PortQ_Output
	MOV R0, #2_01010000
	STRB R0, [R9], #8
	LDR R9, =DISPLAY_DIREITO
;	BL	PortA_Output
;	MOV R0, #2_100000
;	BL	PortB_Output
	B fimacende

dirTres
	MOV R0, #2_00001111
	STRB R0, [R9], #8
;	BL	PortQ_Output
	MOV R0, #2_01000000
	STRB R0, [R9], #8
	LDR R9, =DISPLAY_DIREITO
;	BL	PortA_Output
;	MOV R0, #2_100000
;	BL	PortB_Output
	B fimacende

dirQuatro
	MOV R0, #2_00000110
	STRB R0, [R9], #8
;	BL	PortQ_Output
	MOV R0, #2_01100000
	STRB R0, [R9], #8
	LDR R9, =DISPLAY_DIREITO
;	BL	PortA_Output
;	MOV R0, #2_100000
;	BL	PortB_Output
	B fimacende

dirCinco
	MOV R0, #2_00001101
	STRB R0, [R9], #8
;	BL	PortQ_Output
	MOV R0, #2_01100000
	STRB R0, [R9], #8
	LDR R9, =DISPLAY_DIREITO
;	BL	PortA_Output
;	MOV R0, #2_100000
;	BL	PortB_Output
	B fimacende

dirSeis
	MOV R0, #2_00001101
	STRB R0, [R9], #8
;	BL	PortQ_Output
	MOV R0, #2_01110000
	STRB R0, [R9], #8
	LDR R9, =DISPLAY_DIREITO
;	BL	PortA_Output
;	MOV R0, #2_100000
;	BL	PortB_Output
	B fimacende

dirSete
	MOV R0, #2_00000111
	STRB R0, [R9], #8
;	BL	PortQ_Output
	MOV R0, #2_00000000
	STRB R0, [R9], #8
	LDR R9, =DISPLAY_DIREITO
;	BL	PortA_Output
;	MOV R0, #2_100000
;	BL	PortB_Output
	B fimacende

dirOito
	MOV R0, #2_00001111
	STRB R0, [R9], #8
;	BL	PortQ_Output
	MOV R0, #2_01110000
	STRB R0, [R9], #8
	LDR R9, =DISPLAY_DIREITO
;	BL	PortA_Output
	B fimacende

dirNove
	MOV R0, #2_00001111
	STRB R0, [R9], #8
;	BL	PortQ_Output
	MOV R0, #2_01100000
	STRB R0, [R9], #8
	LDR R9, =DISPLAY_DIREITO
;	BL	PortA_Output
	B fimacende


fimacende

	CMP R5, #9
	ITEE	CC
		ADDCC R5, R5, #1
		ADDCS R4, R4, #1
		MOVCS R5, #0
		
	CMP R4, #10 ;compara para ver qual é o número do display externo
	IT CS
		MOVCS R4, #0
	
	CMP R6, #13 ;compara para ver qual é o número do display externo
	ITE CC
		ADDCC R6, R6, #1
		MOVCS R6, #0
	
	POP {LR}
	BX LR
	
	

; -------------------------------------------------------------------------------

; -------------------------------------------------------------------------------
 ;Função de Espera
Espera
	PUSH {LR}

	CMP R7,#0				
	BEQ passo1
	CMP R7,#1
	BEQ passo2
	CMP R7,#2
	BEQ passo3
	CMP R7,#3
	BEQ passo4
	CMP R7,#4
	BEQ passo5
	CMP R7,#5
	BEQ passo6
	CMP R7,#6
	BEQ passo7
	CMP R7,#7
	BEQ passo8
	CMP R7,#8
	BEQ passo9

passo1
	MOV R12, #150
	B acendendo
passo2
	MOV R12, #200
	B acendendo
passo3
	MOV R12, #250
	B acendendo
passo4
	MOV R12, #300
	B acendendo
passo5
	MOV R12, #350
	B acendendo
passo6
	MOV R12, #400
	B acendendo
passo7
	MOV R12, #450
	B acendendo
passo8
	MOV R12, #500
	B acendendo
passo9
	MOV R12, #550
	B acendendo


acendendo
	LDRB R0, [R10], #8
	BL	PortQ_Output
	LDRB R0, [R10], #8
	BL	PortA_Output
	LDR R10, =LED
	MOV R0, #2_100000
	BL	PortP_Output
	MOV R0, #1                
	BL SysTick_Wait1ms
	MOV R0, #2_000000
	BL	PortP_Output

	LDRB R0, [R8], #8
	BL	PortQ_Output
	LDRB R0, [R8], #8
	BL	PortA_Output
	LDR R8, =DISPLAY_ESQUERDO
	MOV R0, #2_010000
	BL	PortB_Output
	MOV R0, #1                
	BL SysTick_Wait1ms
	
	LDRB R0, [R9], #8
	BL	PortQ_Output
	LDRB R0, [R9], #8
	BL	PortA_Output
	LDR R9, =DISPLAY_DIREITO
	MOV R0, #2_100000
	BL	PortB_Output
	MOV R0, #1                
	BL SysTick_Wait1ms
	MOV R0, #2_000000
	BL	PortB_Output
	
	CMP R11, R12
	IT CC
		ADDCC R11, R11, #1
		BCC acendendo
		MOVCS R11, #0

	B final


final	
	POP {LR}
	BX LR
	

    ALIGN                        ;Garante que o fim da seção está alinhada 
    END  

; -------------------------------------------------------------------------------------------------------------------------
; Fim do Arquivo
; -------------------------------------------------------------------------------------------------------------------------	
    ALIGN                        ;Garante que o fim da seção está alinhada 
    END                          ;Fim do arquivo
