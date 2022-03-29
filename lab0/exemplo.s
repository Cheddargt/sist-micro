; Exemplo.s
; Desenvolvido para a placa EK-TM4C1294XL
; Prof. Guilherme Peron
; 12/03/2018

; -------------------------------------------------------------------------------
        THUMB                        ; Instru��es do tipo Thumb-2
; -------------------------------------------------------------------------------
; Declara��es EQU - Defines
;<NOME>         EQU <VALOR>
; -------------------------------------------------------------------------------
; �rea de Dados - Declara��es de vari�veis
		AREA  DATA, ALIGN=2
		; Se alguma vari�vel for chamada em outro arquivo
		;EXPORT  <var> [DATA,SIZE=<tam>]   ; Permite chamar a vari�vel <var> a 
		                                   ; partir de outro arquivo
;<var>	SPACE <tam>                        ; Declara uma vari�vel de nome <var>
                                           ; de <tam> bytes a partir da primeira 
                                           ; posi��o da RAM		

; -------------------------------------------------------------------------------
; �rea de C�digo - Tudo abaixo da diretiva a seguir ser� armazenado na mem�ria de 
;                  c�digo
        AREA    |.text|, CODE, READONLY, ALIGN=2

		; Se alguma fun��o do arquivo for chamada em outro arquivo	
        EXPORT Start                ; Permite chamar a fun��o Start a partir de 
			                        ; outro arquivo. No caso startup.s
									
		; Se chamar alguma fun��o externa	
        ;IMPORT <func>              ; Permite chamar dentro deste arquivo uma 
									; fun��o <func>

; -------------------------------------------------------------------------------
; Fun��o main()

; Vari�veis que salvam o endere�o de mem�ria RAM 
; n�meros aleat�rios
ALEATORIO EQU 0x20000A00
; n�meros ordenados
ORDENADO EQU 0x20000B00

Start  
; Comece o c�digo aqui <======================================================

	;tamanho do vetor aleat�rio
	MOV R12, #4 

	;salva no R0 o come�o do vetor aleat�rio
	LDR R0, =ALEATORIO
	
	;adicionando n�meros na mem�ria
	MOV R1, #3
	STRB R1, [R0], #8 	;grava R1 no [R0] e soma +8 pra ir pro
						;pr�ximo endere�o

	MOV R1, #4
	STRB R1, [R0], #8
	
	MOV R1, #7
	STRB R1, [R0], #8
	
	MOV R1, #8
	STRB R1, [R0], #8
	
	;MOV R1, #43
	;STRB R1, [R0], #8
	
	;MOV R1, #13
	;STRB R1, [R0], #8
	
	;MOV R1, #211
	;STRB R1, [R0], #8
	
	;MOV R1, #3
	;STRB R1, [R0], #8
	
	;MOV R1, #203
	;STRB R1, [R0], #8
	
	;MOV R1, #5
	;STRB R1, [R0], #8
	
	;MOV R1, #21
	;STRB R1, [R0], #8
	
	;MOV R1, #7
	;STRB R1, [R0], #8
	
	;MOV R1, #206
	;STRB R1, [R0], #8
	
	;MOV R1, #245
	;STRB R1, [R0], #8
	
	;MOV R1, #157
	;STRB R1, [R0], #8
	
	;MOV R1, #237
	;STRB R1, [R0], #8
	
	;MOV R1, #241
	;STRB R1, [R0], #8
	
	;MOV R1, #105
	;STRB R1, [R0], #8
	
	;MOV R1, #252
	;STRB R1, [R0], #8
	
	;MOV R1, #19
	;STRB R1, [R0], #8
	
	LDR R0, =ALEATORIO ;Come�o do vetor de n�meros aleat�rios
	LDR R1, =ORDENADO ;Come�o do vetor de n�meros primos salvos
	
	MOV R2, #0 	;Tamanho do 'vetor' de n�meros primos (vetor ordenado)
	MOV R7, #0	;Incremento do while externo (pra saber quando terminou de varrer
				;o vetor de n�meros aleat�rios

loop			;while externo - come�a com 2 e vai at� o n�mero
	MOV R3, #2
	
primo
	
	;Resetar o carry
	MOV R8, #1
	CMP R8, #2
	
	LDRB R4, [R0]	;Le da memoria o R0 e salva em R4
	CMP R3, R4		;Compara R3 com R4 (R3-R4) ->
					;R3: identador // R4: valor a definir se � primo
	
	ITTE CC						;if R3 < R4
		UDIVCC R5, R4, R3		;Divide R4 por R3
		MLSCC R6, R3, R5, R4 	;R6 � o resto da divis�o
		BCS caboprimo			;se R3 >= R4 ent�o chegou no R4
								;ent�o � primo
								
	CMP R6, #0				;compara o resto com 0
	ITT NE 					;se resto != 0, pode ser primo	
		ADDNE R3, R3, #1	;se for diferente, incrementa R3 
		BNE primo			;volta pro loop de teste de primo
	BEQ cabonaoprimo		;se o resto = 0 ent�o n�o � primo
	
caboprimo				;se for primo
	
	ADD R2, R2, #1 		;Incrementa o tamanho do vetor ordenado de primos
	STRB R4, [R1], #8	;Salva o R4 em R1 e soma 8 em R1 pra ir pro pr�ximo slot de mem�ria
	ADD R0, R0, #8		;Soma 8 no R0 p/ ir pro pr�x num do vetor aleat�rio
	
	ADD R7, R7, #1		;Incrementa R7 pra avan�ar 1 no while
	CMP R7, R12			;Compara R7 com o vetor aleat�rio p/ saber se acabou de varrer o vetor
	
	BCC loop				;se for menor, volta pro loop
	BCS comecaordenacao		;se for maior ou igual, vai pra ordena��o

cabonaoprimo				;se n�o for primo
	ADD R0, R0, #8			;incrementa o R0 pra ir pro pr�ximo n�mero do vetor aleat�rio
	
	ADD R7, R7, #1			;incrementa R7 pra avan�ar 1 no while
	CMP R7, R12				;compara R7 com o vetor aleat�rio p/ saber se acabou de varrer o vetor
	
	BCC loop				;se n�o acabou, volta pro loop
	BCS comecaordenacao		;se acabou, vai pro come�a a ordena��o

comecaordenacao

	NOP

    ALIGN                           ; garante que o fim da se��o est� alinhada 
    END                             ; fim do arquivo
