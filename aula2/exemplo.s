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
Start  
; Comece o código aqui <======================================================

	MOV R0, #65
	MOV R1, #0x1B001B00
	LDR R2,=0x12345678
	LDR R3,=0x20000040 ; seta ponteiro em R3
	STR R0, [R3] ; seta o valor que está no R0 em R3 usando ponteiro [ ] 
	
	LDR R4,=0x20000044 ; seta ponteiro em R4
	STR R1, [R4] ; seta o valor que está no R1 em R4 usando ponteiro [ ] 
	
	LDR R5,=0x20000048 ; seta ponteiro em R5
	STR R2, [R5] ; seta o valor que está no R2 em R5 usando ponteiro [ ] 
	
	LDR R6,=0x2000004C ; seta ponteiro em R6
	; exemplo.s(52): error: A1517E: Unexpected operator equal to or equivalent to =
	LDR R7,=0xF0001 ; seta o número em R7
	STR R7, [R6] ; seta o valor que está no R7 em R6 usando ponteiro [ ] 
	
	LDR R8,=0x20000046 ; seta ponteiro em R3
	MOV R9, #0xCD
	STRB R9, [R8] ; seta o valor que está no R2 em R5 usando ponteiro [ ] 
	
	LDR R10, [R3] ; lê o conteúdo de R3, a memória 0x..040 e salva em R10
	
	LDR R11, [R5] ; lê o conteúdo de R5, a memória 0x..048 e salva em R11
	
	MOV R12, R10 ; Copia o conteúdo de R10 para R12
	
	NOP
	
	
	
	

    ALIGN                           ; garante que o fim da seção está alinhada 
    END                             ; fim do arquivo
