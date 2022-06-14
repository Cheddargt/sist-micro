; Exemplo.s
; Desenvolvido para a placa EK-TM4C1294XL
; Prof. Guilherme Peron
; 12/03/2018

; -------------------------------------------------------------------------------
        THUMB                        ; Instruções do tipo Thumb-2
; -------------------------------------------------------------------------------
; Declarações EQU - Defines
;<NOME>         EQU <VALOR>
vet_random EQU 0x20000400
vet_sort EQU 0x20000500
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
;{193;	63; 176; 127; 43; 13; 211; 3; 203; 5; 21; 7; 206; 245; 157; 237; 241;	105; 252; 19},
	LDR R1,=vet_random
	LDR R2,=vet_sort
	MOV R0,#193
	STRB R0,[R1],#4
	MOV R0,#63
	STRB R0,[R1],#4
	MOV R0,#176
	STRB R0,[R1],#4
	MOV R0,#127
	STRB R0,[R1],#4
	MOV R0,#43
	STRB R0,[R1],#4
	MOV R0,#13
	STRB R0,[R1],#4
	MOV R0,#211
	STRB R0,[R1],#4
	MOV R0,#3
	STRB R0,[R1],#4
	MOV R0,#203
	STRB R0,[R1],#4
	MOV R0,#5
	STRB R0,[R1],#4
	MOV R0,#21
	STRB R0,[R1],#4
	MOV R0,#7
	STRB R0,[R1],#4
	MOV R0,#206
	STRB R0,[R1],#4
	MOV R0,#245
	STRB R0,[R1],#4
	MOV R0,#157
	STRB R0,[R1],#4
	MOV R0,#237
	STRB R0,[R1],#4
	MOV R0,#241
	STRB R0,[R1],#4
	MOV R0,#105
	STRB R0,[R1],#4
	MOV R0,#252
	STRB R0,[R1],#4
	MOV R0,#19
	STRB R0,[R1],#4
	
	LDR R3,=vet_random
Proximo
	CMP R3,R1
	BEQ fimprimo
	LDRB R5,[R3],#4
	MOV R4,#1
Ehprimo
	ADD R4,#1
	CMP R4,R5
	BCC menor
	STRB R5,[R2],#4
menor
	UDIV R7,R5,R4
	MLS R7,R7,R4,R5
	CMP R7,#0
	BNE Ehprimo
	B Proximo
fimprimo
;193,127,43,13,211,3,5,7,151,241,19;
	SUB R2,#4;
	MOV R10,#1
loop	
	CMP R10,#1
	BNE ordenado
	MOV R10,#0
	LDR R11,=vet_sort
for
	CMP R11,R2
	BEQ fimfor
	MOV R12,R11
	ADD R12,#4
	LDRB R9,[R11]
	LDRB R8,[R12]
	CMP R9,R8
	BLS fim
	MOV R10,#1
	STRB R9,[R12]
	STRB R8,[R11]
fim
	MOV R11,R12
	B for
fimfor
	B loop
ordenado
	

	NOP
    ALIGN                           ; garante que o fim da seção está alinhada 
    END                             ; fim do arquivo
