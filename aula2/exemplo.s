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
Start  
; Comece o c�digo aqui <======================================================

	MOV R0, #65
	MOV R1, #0x1B001B00
	LDR R2,=0x12345678
	LDR R3,=0x20000040 ; seta ponteiro em R3
	STR R0, [R3] ; seta o valor que est� no R0 em R3 usando ponteiro [ ] 
	
	LDR R4,=0x20000044 ; seta ponteiro em R4
	STR R1, [R4] ; seta o valor que est� no R1 em R4 usando ponteiro [ ] 
	
	LDR R5,=0x20000048 ; seta ponteiro em R5
	STR R2, [R5] ; seta o valor que est� no R2 em R5 usando ponteiro [ ] 
	
	LDR R6,=0x2000004C ; seta ponteiro em R6
	; exemplo.s(52): error: A1517E: Unexpected operator equal to or equivalent to =
	LDR R7,=0xF0001 ; seta o n�mero em R7
	STR R7, [R6] ; seta o valor que est� no R7 em R6 usando ponteiro [ ] 
	
	LDR R8,=0x20000046 ; seta ponteiro em R3
	MOV R9, #0xCD
	STRB R9, [R8] ; seta o valor que est� no R2 em R5 usando ponteiro [ ] 
	
	LDR R10, [R3] ; l� o conte�do de R3, a mem�ria 0x..040 e salva em R10
	
	LDR R11, [R5] ; l� o conte�do de R5, a mem�ria 0x..048 e salva em R11
	
	MOV R12, R10 ; Copia o conte�do de R10 para R12
	
	NOP
	
	
	
	

    ALIGN                           ; garante que o fim da se��o est� alinhada 
    END                             ; fim do arquivo
