; gpio.s
; Desenvolvido para a placa EK-TM4C1294XL
; Prof. Guilherme Peron
; 24/08/2020

; -------------------------------------------------------------------------------
        THUMB                        ; Instruções do tipo Thumb-2
; -------------------------------------------------------------------------------
; Declarações EQU - Defines
; ========================
; Definições de Valores
BIT0	EQU 2_0001
BIT1	EQU 2_0010
; ========================
; Definições dos Registradores Gerais
SYSCTL_RCGCGPIO_R	 EQU	0x400FE608
SYSCTL_PRGPIO_R		 EQU    0x400FEA08
; ========================
; Definições dos Ports
; PORT J
GPIO_PORTJ_AHB_LOCK_R    	EQU    0x40060520
GPIO_PORTJ_AHB_CR_R      	EQU    0x40060524
GPIO_PORTJ_AHB_AMSEL_R   	EQU    0x40060528
GPIO_PORTJ_AHB_PCTL_R    	EQU    0x4006052C
GPIO_PORTJ_AHB_DIR_R     	EQU    0x40060400
GPIO_PORTJ_AHB_AFSEL_R   	EQU    0x40060420
GPIO_PORTJ_AHB_DEN_R     	EQU    0x4006051C
GPIO_PORTJ_AHB_PUR_R     	EQU    0x40060510	
GPIO_PORTJ_AHB_DATA_R    	EQU    0x400603FC
GPIO_PORTJ_AHB_DATA_BITS_R  EQU    0x40060000
GPIO_PORTJ               	EQU    2_000000100000000
; PORT N
GPIO_PORTN_LOCK_R    	EQU    0x40064520
GPIO_PORTN_CR_R      	EQU    0x40064524
GPIO_PORTN_AMSEL_R   	EQU    0x40064528
GPIO_PORTN_PCTL_R    	EQU    0x4006452C
GPIO_PORTN_DIR_R     	EQU    0x40064400
GPIO_PORTN_AFSEL_R   	EQU    0x40064420
GPIO_PORTN_DEN_R     	EQU    0x4006451C
GPIO_PORTN_PUR_R     	EQU    0x40064510	
GPIO_PORTN_DATA_R    	EQU    0x400643FC
GPIO_PORTN_DATA_BITS_R  EQU    0x40064000
GPIO_PORTN              EQU    2_001000000000000	
	
; PORT M
GPIO_PORTM_DATA_BITS_R        EQU  0x40063000
GPIO_PORTM_DATA_R             EQU  0x400633FC
GPIO_PORTM_DIR_R              EQU  0x40063400
GPIO_PORTM_AFSEL_R            EQU  0x40063420
GPIO_PORTM_PUR_R              EQU  0x40063510
GPIO_PORTM_DEN_R              EQU  0x4006351C
GPIO_PORTM_LOCK_R             EQU  0x40063520
GPIO_PORTM_CR_R               EQU  0x40063524
GPIO_PORTM_AMSEL_R            EQU  0x40063528
GPIO_PORTM_PCTL_R             EQU  0x4006352C
GPIO_PORTM                    EQU  2_000100000000000
	
; PORT K
GPIO_PORTK_DATA_BITS_R        EQU  0x40061000
GPIO_PORTK_DATA_R             EQU  0x400613FC
GPIO_PORTK_DIR_R              EQU  0x40061400
GPIO_PORTK_AFSEL_R            EQU  0x40061420
GPIO_PORTK_PUR_R              EQU  0x40061510
GPIO_PORTK_DEN_R              EQU  0x4006151C
GPIO_PORTK_LOCK_R             EQU  0x40061520
GPIO_PORTK_CR_R               EQU  0x40061524
GPIO_PORTK_AMSEL_R            EQU  0x40061528
GPIO_PORTK_PCTL_R             EQU  0x4006152C
GPIO_PORTK                    EQU  2_000001000000000
	
GPIO_PORTM_IM_R            	  EQU  0x40063410
GPIO_PORTM_IS_R            	  EQU  0x40063404
GPIO_PORTM_IBE_R              EQU  0x40063408
GPIO_PORTM_IEV_R              EQU  0x4006340C
GPIO_PORTM_ICR_R              EQU  0x4006341C


NVIC_EN0_R                EQU  0xE000E100
NVIC_EN1_R                EQU  0xE000E104
NVIC_EN2_R                EQU  0xE000E108
NVIC_EN3_R                EQU  0xE000E10C
NVIC_DIS0_R               EQU  0xE000E180
NVIC_DIS1_R               EQU  0xE000E184
NVIC_DIS2_R               EQU  0xE000E188
NVIC_DIS3_R               EQU  0xE000E18C
NVIC_PEND0_R              EQU  0xE000E200
NVIC_PEND1_R              EQU  0xE000E204
NVIC_PEND2_R              EQU  0xE000E208
NVIC_PEND3_R              EQU  0xE000E20C
NVIC_UNPEND0_R            EQU  0xE000E280
NVIC_UNPEND1_R            EQU  0xE000E284
NVIC_UNPEND2_R            EQU  0xE000E288
NVIC_UNPEND3_R            EQU  0xE000E28C
NVIC_ACTIVE0_R            EQU  0xE000E300
NVIC_ACTIVE1_R            EQU  0xE000E304
NVIC_ACTIVE2_R            EQU  0xE000E308
NVIC_ACTIVE3_R            EQU  0xE000E30C
NVIC_PRI0_R               EQU  0xE000E400
NVIC_PRI1_R               EQU  0xE000E404
NVIC_PRI2_R               EQU  0xE000E408
NVIC_PRI3_R               EQU  0xE000E40C
NVIC_PRI4_R               EQU  0xE000E410
NVIC_PRI6_R               EQU  0xE000E418
NVIC_PRI5_R               EQU  0xE000E414
NVIC_PRI7_R               EQU  0xE000E41C
NVIC_PRI8_R               EQU  0xE000E420
NVIC_PRI9_R               EQU  0xE000E424
NVIC_PRI10_R              EQU  0xE000E428
NVIC_PRI11_R              EQU  0xE000E42C
NVIC_PRI12_R              EQU  0xE000E430
NVIC_PRI13_R              EQU  0xE000E434
NVIC_PRI14_R              EQU  0xE000E438
NVIC_PRI15_R              EQU  0xE000E43C
NVIC_PRI16_R              EQU  0xE000E440
NVIC_PRI17_R              EQU  0xE000E444
NVIC_PRI18_R              EQU  0xE000E448
NVIC_PRI19_R              EQU  0xE000E44C
NVIC_PRI20_R              EQU  0xE000E450
NVIC_PRI21_R              EQU  0xE000E454
NVIC_PRI22_R              EQU  0xE000E458
NVIC_PRI23_R              EQU  0xE000E45C
NVIC_PRI24_R              EQU  0xE000E460
NVIC_PRI25_R              EQU  0xE000E464
NVIC_PRI26_R              EQU  0xE000E468
NVIC_PRI27_R              EQU  0xE000E46C
NVIC_PRI28_R              EQU  0xE000E470
; -------------------------------------------------------------------------------
; Área de Código - Tudo abaixo da diretiva a seguir será armazenado na memória de 
;                  código
        AREA    |.text|, CODE, READONLY, ALIGN=2

		; Se alguma função do arquivo for chamada em outro arquivo	
        EXPORT GPIO_Init            ; Permite chamar GPIO_Init de outro arquivo
		EXPORT PortN_Output			; Permite chamar PortN_Output de outro arquivo
		EXPORT GPIOPortM_Handler
		IMPORT EnableInterrupts
		IMPORT DisableInterrupts
		IMPORT SysTick_Wait1ms

;--------------------------------------------------------------------------------
; Função GPIO_Init
; Parâmetro de entrada: Não tem
; Parâmetro de saída: Não tem
GPIO_Init
;=====================
; 1. Ativar o clock para a porta setando o bit correspondente no registrador RCGCGPIO,
; após isso verificar no PRGPIO se a porta está pronta para uso.
; enable clock to GPIOF at clock gating register
            LDR     R0, =SYSCTL_RCGCGPIO_R  		;Carrega o endereço do registrador RCGCGPIO
			MOV		R1, #GPIO_PORTN                ;Seta o bit da porta N
			ORR 	R1, #GPIO_PORTM
			ORR     R1, #GPIO_PORTK					;Seta o bit da porta J, fazendo com OR
            STR     R1, [R0]						;Move para a memória os bits das portas no endereço do RCGCGPIO
 
            LDR     R0, =SYSCTL_PRGPIO_R			;Carrega o endereço do PRGPIO para esperar os GPIO ficarem prontos
EsperaGPIO  LDR     R1, [R0]						;Lê da memória o conteúdo do endereço do registrador
			MOV     R2, #GPIO_PORTN                 ;Seta os bits correspondentes às portas para fazer a comparação
			ORR     R2, #GPIO_PORTM                 ;Seta o bit da porta J, fazendo com OR
            ORR     R2, #GPIO_PORTK
			TST     R1, R2							;Testa o R1 com R2 fazendo R1 & R2
            BEQ     EsperaGPIO					    ;Se o flag Z=1, volta para o laço. Senão continua executando
 
; 2. Limpar o AMSEL para desabilitar a analógica
            MOV     R1, #0x00						;Colocar 0 no registrador para desabilitar a função analógica
            LDR     R0, =GPIO_PORTJ_AHB_AMSEL_R     ;Carrega o R0 com o endereço do AMSEL para a porta J
            STR     R1, [R0]						;Guarda no registrador AMSEL da porta J da memória
            LDR     R0, =GPIO_PORTN_AMSEL_R			;Carrega o R0 com o endereço do AMSEL para a porta N
            STR     R1, [R0]					    ;Guarda no registrador AMSEL da porta N da memória
 
; 3. Limpar PCTL para selecionar o GPIO
            MOV     R1, #0x00					    ;Colocar 0 no registrador para selecionar o modo GPIO
            LDR     R0, =GPIO_PORTJ_AHB_PCTL_R		;Carrega o R0 com o endereço do PCTL para a porta J
            STR     R1, [R0]                        ;Guarda no registrador PCTL da porta J da memória
            LDR     R0, =GPIO_PORTN_PCTL_R      	;Carrega o R0 com o endereço do PCTL para a porta N
            STR     R1, [R0]                        ;Guarda no registrador PCTL da porta N da memória
; 4. DIR para 0 se for entrada, 1 se for saída
            LDR     R0, =GPIO_PORTN_DIR_R			;Carrega o R0 com o endereço do DIR para a porta N
			MOV     R1, #2_0010						;PN1
            STR     R1, [R0]						;Guarda no registrador
			; O certo era verificar os outros bits da PJ para não transformar entradas em saídas desnecessárias
            LDR     R0, =GPIO_PORTJ_AHB_DIR_R		;Carrega o R0 com o endereço do DIR para a porta J
            MOV     R1, #0x00               		;Colocar 0 no registrador DIR para funcionar com saída
            STR     R1, [R0]						;Guarda no registrador PCTL da porta J da memória
; 5. Limpar os bits AFSEL para 0 para selecionar GPIO 
;    Sem função alternativa
            MOV     R1, #0x00						;Colocar o valor 0 para não setar função alternativa
            LDR     R0, =GPIO_PORTN_AFSEL_R			;Carrega o endereço do AFSEL da porta N
            STR     R1, [R0]						;Escreve na porta
            LDR     R0, =GPIO_PORTJ_AHB_AFSEL_R     ;Carrega o endereço do AFSEL da porta J
            STR     R1, [R0]                        ;Escreve na porta
; 6. Setar os bits de DEN para habilitar I/O digital
            LDR     R0, =GPIO_PORTN_DEN_R			    ;Carrega o endereço do DEN
            MOV     R1, #2_00000010                     ;N1
            STR     R1, [R0]							;Escreve no registrador da memória funcionalidade digital 
 
            LDR     R0, =GPIO_PORTJ_AHB_DEN_R			;Carrega o endereço do DEN
			MOV     R1, #2_00000001                     ;J0     
            STR     R1, [R0]                            ;Escreve no registrador da memória funcionalidade digital
			
; 7. Para habilitar resistor de pull-up interno, setar PUR para 1
			LDR     R0, =GPIO_PORTJ_AHB_PUR_R			;Carrega o endereço do PUR para a porta J
			MOV     R1, #2_1							;Habilitar funcionalidade digital de resistor de pull-up 
            STR     R1, [R0]							;Escreve no registrador da memória do resistor de pull-up
			
;Interrupções
; 8. Desabilitar a interrupção no registrador IM
			LDR 	R0, =GPIO_PORTM_IM_R
			MOV		R1, #2_00
			STR		R1, [R0]
			
; 9. Configuar o tipo de interrupção por borda no registrador IS
			LDR		R0, =GPIO_PORTM_IS_R
			MOV		R1, #2_00
			STR		R1, [R0]
			
; 10. Configurar borda única no registrador IBE
			LDR 	R0, =GPIO_PORTM_IBE_R
			MOV		R1, #2_00
			STR		R1, [R0]
			
; 11. Configurar borda de descida (botão pressionado) no registrador IEV
			LDR		R0, =GPIO_PORTM_IEV_R
			MOV		R1, #2_00							; Borda Única - se fosse subida seria 2_1
			STR		R1, [R0]
			
; 12. Habilitar a interrupção no registrador IM
			LDR 	R0, =GPIO_PORTM_IM_R
			MOV		R1, #2_01
			STR		R1, [R0]
			
;Interrupção número 72
; 13. Setar a prioridade no NVIC
			LDR		R0, =NVIC_PRI18_R
			MOV		R1, #3
			LSL		R1, R1, #5
			STR		R1, [R0]
; 14. Habilitar a interrupção no NVIC
			LDR 	R0, =NVIC_EN2_R
			MOV		R1, #1
			LSL		R1, #8
			STR		R1, [R0]
			
			
			BX LR
			
			
; -------------------------------------------------------------------------------
; Função PortN_Output
; Parâmetro de entrada: R0 --> se o BIT1 está ligado ou desligado
; Parâmetro de saída: Não tem
PortN_Output
	LDR	R1, =GPIO_PORTN_DATA_R		    ;Carrega o valor do offset do data register
	;Read-Modify-Write para escrita
	LDR R2, [R1]
	BIC R2, #2_00000010                     ;Primeiro limpamos os dois bits do lido da porta R2 = R2 & 11111101
	ORR R0, R0, R2                          ;Fazer o OR do lido pela porta com o parâmetro de entrada
	STR R0, [R1]                            ;Escreve na porta N o barramento de dados do pino N1
	BX LR									;Retorno


GPIOPortM_Handler
	LDR R1, =GPIO_PORTM_ICR_R
	MOV R0, #2_00000001
	STR R0, [R1]
	
	EOR R10, R10, #2_1
	
	BX LR
	
	

    ALIGN                           ; garante que o fim da seção está alinhada 
    END                             ; fim do arquivo