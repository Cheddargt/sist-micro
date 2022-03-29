; Exemplo.s
; Desenvolvido para a placa EK-TM4C1294XL
; Prof. Guilherme Peron
; 12/03/2018

; -------------------------------------------------------------------------------
        THUMB                        ; Instruções do tipo Thumb-2
; -------------------------------------------------------------------------------
; Declarações EQU - Defines
;<NOME>         EQU <VALOR>
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

; -------------------------------------------------------------------------------
; Função main()

; Variáveis que salvam o endereço de memória RAM 
; números aleatórios
ALEATORIO EQU 0x20000A00
; números ordenados
ORDENADO EQU 0x20000B00

Start  
; Comece o código aqui <======================================================

	;tamanho do vetor aleatório
	MOV R12, #4 

	;salva no R0 o começo do vetor aleatório
	LDR R0, =ALEATORIO
	
	;adicionando números na memória
	MOV R1, #3
	STRB R1, [R0], #8 	;grava R1 no [R0] e soma +8 pra ir pro
						;próximo endereço

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
	
	LDR R0, =ALEATORIO ;Começo do vetor de números aleatórios
	LDR R1, =ORDENADO ;Começo do vetor de números primos salvos
	
	MOV R2, #0 	;Tamanho do 'vetor' de números primos (vetor ordenado)
	MOV R7, #0	;Incremento do while externo (pra saber quando terminou de varrer
				;o vetor de números aleatórios

loop			;while externo - começa com 2 e vai até o número
	MOV R3, #2
	
primo
	
	;Resetar o carry
	MOV R8, #1
	CMP R8, #2
	
	LDRB R4, [R0]	;Le da memoria o R0 e salva em R4
	CMP R3, R4		;Compara R3 com R4 (R3-R4) ->
					;R3: identador // R4: valor a definir se é primo
	
	ITTE CC						;if R3 < R4
		UDIVCC R5, R4, R3		;Divide R4 por R3
		MLSCC R6, R3, R5, R4 	;R6 é o resto da divisão
		BCS caboprimo			;se R3 >= R4 então chegou no R4
								;então é primo
								
	CMP R6, #0				;compara o resto com 0
	ITT NE 					;se resto != 0, pode ser primo	
		ADDNE R3, R3, #1	;se for diferente, incrementa R3 
		BNE primo			;volta pro loop de teste de primo
	BEQ cabonaoprimo		;se o resto = 0 então não é primo
	
caboprimo				;se for primo
	
	ADD R2, R2, #1 		;Incrementa o tamanho do vetor ordenado de primos
	STRB R4, [R1], #8	;Salva o R4 em R1 e soma 8 em R1 pra ir pro próximo slot de memória
	ADD R0, R0, #8		;Soma 8 no R0 p/ ir pro próx num do vetor aleatório
	
	ADD R7, R7, #1		;Incrementa R7 pra avançar 1 no while
	CMP R7, R12			;Compara R7 com o vetor aleatório p/ saber se acabou de varrer o vetor
	
	BCC loop				;se for menor, volta pro loop
	BCS comecaordenacao		;se for maior ou igual, vai pra ordenação

cabonaoprimo				;se não for primo
	ADD R0, R0, #8			;incrementa o R0 pra ir pro próximo número do vetor aleatório
	
	ADD R7, R7, #1			;incrementa R7 pra avançar 1 no while
	CMP R7, R12				;compara R7 com o vetor aleatório p/ saber se acabou de varrer o vetor
	
	BCC loop				;se não acabou, volta pro loop
	BCS comecaordenacao		;se acabou, vai pro começa a ordenação

comecaordenacao

	NOP

    ALIGN                           ; garante que o fim da seção está alinhada 
    END                             ; fim do arquivo
