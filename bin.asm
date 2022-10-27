.model small
.data
    erro db 10,'Erro$'
    resultado db 10,'Numero binario: $'
.code
    MAIN PROC
        MOV AX, @data
        MOV DS, AX



        CALL LEITURA
        CALL IMPRIME

        MOV AH,4Ch
        INT 21h
    ENDP MAIN

    LEITURA PROC
loop_leitura:
        MOV AH,02
        INT 21h

        CMP AL,13
        JE volta_l

        SHL BL,1

        CMP AL,30h
        JE loop_leitura
        CMP AL,31h
        JNE msg_erro
        INC BL
        JMP loop_leitura
msg_erro:
        MOV AH,09
        LEA DX, erro
        INT 21h
volta_l:
    RET

    ENDP LEITURA

    IMPRIME PROC
        MOV CX,8
imprimir:
        SAL BL,1
        JC um
um:

        LOOP imprimir
    ENDP IMPRIME

    END MAIN
