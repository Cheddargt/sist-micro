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
	MOV R0,#65
	MOV R1,#0x1B001B00
	MOV R2,#0x5678
	MOVT R2,#0x1234
	LDR R3,=0x20000040
	STR R0,[R3]
	STR R1,[R3,#4]
	STR R2,[R3,#8]
	MOV R4,#0x0001
	MOVT R4,#0xF
	STR R4,[R3,#12]
	MOV R4,#0xCD
	STR R4,[R3,#6]
	LDR R7,[R3]
	LDR R8,[R3,#8]
	NOP
    ALIGN                           ; garante que o fim da se��o est� alinhada 
    END                             ; fim do arquivo
