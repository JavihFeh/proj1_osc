TITLE 22896419_joao

.model small
.data
    num1 db 'Entre com um numero: $'
    num2 db 10,'Entre com outro numero: $'
    ope db 10,'Escolha a operacao:',10,'1-Adicao',10,'2-Subtracao',10,'3-Multiplicacao',10,'4-Divisao',10,'$'
    res db 10,'Resultado: $'
    div_zero db 10,'Nao ha divisao por zero$'
.code
    MAIN PROC
    MOV AX,@DATA    ; Iniciar segmento de dados
    MOV DS,AX       ;

    MOV AH,09       ;
    LEA DX,num1     ; Escreve a mesangem de entrada do primeiro numero
    INT 21h         ;

    MOV AH,01       ;
    INT 21h         ; Entrada do primeiro numero
    MOV CH,AL       ; Armazena o primeiro numero em CH
    AND CH,0Fh      ; Transforma o caracter do numero no numero

    MOV AH,09       ;
    LEA DX,num2     ; Escreve a mensaagem de entrada do segundo numero
    INT 21h         ;

    MOV AH,01       ;
    INT 21h         ; Entrada do segundo numero
    MOV CL,AL       ; Armazena o segundo numero em CL
    AND CL,0Fh      ; Transforma o caracter do numero no numero

    MOV AH,09       ;
    LEA DX,ope      ; Escreve a mensagem das operações
    INT 21h         ;

    MOV AH,01       ; 
    INT 21h         ; Recebe o numero referente a operação
    
    CMP AL,31h      ;
    JE soma         ;
                    ;
    CMP AL,32h      ;
    JE subtra       ;
                    ; Compara o numero da operação para destinar a operação pedida
    CMP AL,33h      ;
    JE multi        ;
                    ;
    JMP divisao     ; *por erro de jump out of range, caso o usuario não escreva nenhum numero da operação ele irá executar a divisão

soma:               ; label da soma
    ADD CL, CH      ; Soma CL com CH
    CMP CL, 0Ah     ; Compara se CL é um numero de 2 digitos
    JAE soma_of     ; Se for um numero pula para a label soma_of

    ADD CL, 30h     ; Caso não, soma 30h para transformar o numero em caractere

    MOV AH,09       ;
    LEA DX,res      ; Imprime a mensagem de resultado
    INT 21h         ;

    MOV AH, 02      ;
    MOV DL, CL      ; Move CL para o operador de impressão
    INT 21h         ; Imprime o resultado (CL)

    JMP fim         ; Vai para o fim do programa

soma_of:            ; label soma "overflow"
    XOR CH, CH      ;
    MOV AX, CX      ;
    MOV BL, 10      ; Separa o dois digitos por meio de uma divisão
    DIV BL          ; 
    MOV CX, AX      ; Move o resultado da divisão para os dois registradores de CX

    MOV AH,09       ;
    LEA DX,res      ; Imprime a mensagem de resultado
    INT 21h         ;


    MOV AH, 02h     ;
    ADD CL, 30h     ; Transforma o primeiro digito em caracter
    MOV DL,CL       ; Move CL para o registrador de impressão
    INT 21h         ; Imprime

    MOV DL,CH       ; Move CH (segundo digito) para o registrador de impressão
    ADD DL, 30h     ; Transforma o digito em caracter
    INT 21h         ; Imprime

    JMP fim         ; Vai para o fim do programa

subtra:
    CMP CH,CL           ; Compara se CH é maior de CL
    JNG sub_ch_menor    ; Pula se CH for menor que CL

    SUB CH, CL          ; Subtrai CL de CH
    ADD CH, 30h         ; Transforma CH em caracter

    MOV AH,09           ;
    LEA DX, res         ; Imprime a mensagem de resultado
    INT 21h             ;

    MOV AH, 02          ;
    MOV DL, CH          ; Escreve o resultado
    INT 21h             ;

    JMP fim             ; Vai para o fim do programa

sub_ch_menor:           ; label de subtracao negativa
    XCHG CH,CL          ; Troca o valor de CH com o de CL

    SUB CH, CL          ; Subtrai o resultado de CH com CL
    ADD CH, 30h         ; Transforma CH em numero

    MOV AH,09           ;
    LEA DX, res         ; Imprime a mensagem de resultado
    INT 21h             ;

    MOV AH,02           ;
    MOV DL,45           ; Imprime um caracter "-"
    INT 21h             ;

    MOV DL, CH          ;
    INT 21h             ; Imprime o resultado

    JMP fim             ; Vai para o fim do programa

multi:
    CMP CL,00h          ; Compara se CL é igual a 0
    JE res_multi        ; Se for pula para o res_multi

    MOV BH,CL           ; Caso não, move CL para BH para a verificação do primeiro digito
    AND CL,01h         ; Compara se o primeiro digito do CL é 1
    MOV CL,BH           ; Move o valor anterior de CL nomvamente
    JNZ add_multi       ; Se a comparação não for zero pula para a label add_multi

    SHR CL,1            ; Se for zero, desloca CL para a direita uma vez
    SHL CH,1            ; E CH para a esquerda uma vez

    JMP multi           ; Volta para a label multi

add_multi:              ; Caso o primeiro digito de CL for 1
    ADD BL,CH           ; Adiciona em BL o valor de CH
    SHR CL,1            ; Desloca para direita CL uma vez
    SHL CH,1            ; Descola CH para a esquerda uma vez

    JMP multi           ; Volta para o começo da operação

res_multi:              ; Se CL for 0
    CMP BL,9            ; Compara se o resultado (BL) é maior que 9
    JA ov_multi         ; Se for pula para o caso de "overflow"

    MOV AH,09           ; Caso não,
    LEA DX, res         ; Imprime a mensagem de resultado
    INT 21h             ;

    MOV AH, 02          ;
    ADD BL, 30h         ; Transforma o resultado (BL) em caracter
    MOV DL, BL          ; Adiciona resultado (BL) em DL
    INT 21h             ; E imprime

    JMP fim             ; Vai para o fim do programa

ov_multi:               ; caso a multiplicacao tenha resultado de 2 digitos
    XOR CX,CX           ; Esvazia CX
    MOV CL,BL           ; Armazera BL em CL
    MOV AX, CX          ;
    MOV BL, 10          ; Faz a divisao para separar os digitos
    DIV BL              ;
    MOV CX, AX          ; Move o resultado de AX para CX

    MOV AH,09           ;
    LEA DX,res          ; Imprime a mensagem de resultado
    INT 21h             ;

    ADD CL, 30h         ; Transforma o primeiro digito em caracter
    MOV DL,CL           ; Armazena no registrador de impressõo

    MOV AH, 02h         ;
    INT 21h             ; Imprime

    MOV DL,CH           ; Armazena o segunto digito no registrador de impressão
    ADD DL,30h          ; Transforma em caracter
    INT 21h             ; Imrpime

    JMP fim         ; Vai para o fim do programa

divisao:
    XOR AL, AL
    MOV BH, CL      ; Armazena em BH o valor inicial do divisor

    CMP CL,00h      ; Compara se o divisor é zero
    JE erro_div     ; Caso for pula para a mensagem de erro

    CMP CH, CL      ; Compara se CH inicia maior que CL
    JB res_div      ; Caso sim, não há divisão e passa direto para o resultado

achar_maior_divisor:
    CMP CH,CL                   ; Compara se CH é maior que CL
    JB sair                     ; Se CL se tornar maior que CH ele sai do loop

    SHL CL,1                    ;
    JMP achar_maior_divisor     ; Descola CL para a esquerda até ele ser maior que CH
sair:
    SHR CL,1        ; Move CL para direita para ser o maior divisor de CH

dividir:
    SUB CH, CL      ; Diminui o valor de CL de CH
    ADD BL,1        ; Adiciona 1 no quociente

comparacao_div:
    CMP CH, CL      ; Compara se CH ainda é maior ou igual a CL
    JAE dividir     ; Se for ele subitrai mais uma vez
    CMP CH, 00h     ; Compara se o resto é zero
    JE res_div      ; Se for, pula para o resultado
    CMP CL, BH      ; Compara se CL(divisor) é menor ou igual ao seu valor inicial
    JBE res_div     ; Se for pula para o resultado

    SHR CL,1            ; Caso nenhuma das anteriores, desloca CL para a direita
    SHL BL,1            ; E descola BL(Quociente) para a esquerda

    JMP comparacao_div  ; Compara novamente

res_div:            ; resultado de divisao
    MOV AH,09       ;
    LEA DX,res      ; Imprime a mensagem de resultado
    INT 21h         ;

    MOV AH,02       ;
    MOV DL,BL       ; Armazena o resultado da divisão no registrador de impressão
    ADD DL,30h      ; Transforma o resultado em caractrer
    INT 21h         ; Imprime o resultado da divisão

    XOR AX,AX       ; Zera AX para fazer as operações
    MOV BL,BH       ; Coloca o divisor dado pelo ususario em BL para efetuar a divisão
    MOV AX,100      ; Move 100 para AX para ter uma presão de 2 digitos
    DIV BL          ; Divide AX por BL(divisor)

    MUL CH          ; Multiplica o resultado pelo resto
    MOV BL,10       ; 
    DIV BL          ; Separa o resto em dois digitos

    MOV BX,AX       ; Move todo o resultado para BX
    ADD BH,30h      ;
    ADD BL,30h      ; Transforma ambos os numeros em letras

    MOV AH,02       ; Função de impressão
    MOV DL,2Ch      ;
    INT 21h         ; Imprime uma virgula

    MOV DL,BL       ; 
    INT 21h         ;Imprime o primeiro digito

    MOV DL,BH       ;
    INT 21h         ;Imprime o segundo digito
    

    JMP fim         ; Vai para o fim do programa

erro_div:
    MOV AH,09       ;
    LEA DX,div_zero ; Imprime a mensagem de erro de divisao por zero
    INT 21h         ;
    
fim:
    MOV AH,4Ch      ;
    INT 21h         ; Encerra o programa

    ENDP MAIN
    END MAIN
