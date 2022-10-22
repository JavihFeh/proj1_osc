TITLE 22896419_joao

.model small
.data
    num1 db 'Entre com um numero: $'
    num2 db 10,'Entre com outro numero: $'
    ope db 10,'Escolha a operacao:',10,'1-Adicao',10,'2-Subtracao',10,'3-Multiplicacao',10,'4-Divisao',10,'$'
    res db 10,'Resultado: $'
.code
    MAIN PROC
    MOV AX,@DATA
    MOV DS,AX

    MOV AH,09
    LEA DX,num1
    INT 21h

    MOV AH,01
    INT 21h
    MOV CH,AL
    AND CH,0Fh

    MOV AH,09
    LEA DX,num2
    INT 21h

    MOV AH,01
    INT 21h
    MOV CL,AL
    AND CL,0Fh

    MOV AH,09
    LEA DX,ope
    INT 21h

    MOV AH,01
    INT 21h
    

    CMP AL,31h
    JE soma

    CMP AL,32h
    JE subtra

    CMP AL,33h
    JE multi

soma:
    ADD CL, CH
    CMP CL, 0Ah
    JAE soma_of

    ADD CL, 30h

    MOV AH,09
    LEA DX,res
    INT 21h

    MOV AH, 02
    MOV DL, CH
    INT 21h

    JMP fim

soma_of:
    XOR CH, CH
    MOV AX, CX
    MOV BL, 10
    DIV BL
    MOV CX, AX

    MOV AH,09
    LEA DX,res
    INT 21h

    ADD CL, 30h
    MOV DL,CL

    MOV AH, 02h
    INT 21h

    MOV DL,CH
    ADD DL, 30h
    INT 21h

    JMP fim

subtra:
    CMP CH,CL
    JNG sub_bh_menor

    SUB CH, CL
    ADD CH, 30h

    MOV AH,09
    LEA DX, res
    INT 21h

    MOV AH, 02
    MOV DL, CH
    INT 21h

    JMP fim

sub_bh_menor:
    XCHG CH,CL

    SUB CH, CL
    ADD CH, 30h

    MOV AH,09
    LEA DX, res
    INT 21h

    MOV AH,02
    MOV DL,45
    INT 21h

    MOV DL, CH
    INT 21h

    JMP fim

multi:
    CMP CL,00h
    JE res_multi

    MOV BH,CL
    AND CL,01h
    MOV CL,BH
    JNZ add_multi

    SHR CL,1
    SHL CH,1

    JMP multi

add_multi:
    ADD BL,Ch
    SHR CL,1
    SHL CH,1

    JMP multi

res_multi:
    CMP BL,9
    JA ov_multi
    MOV AH,09
    LEA DX, res
    INT 21h

    MOV AH, 02
    ADD BL, 30h
    MOV DL, BL
    INT 21h

    JMP fim
ov_multi:
    XOR CX,CX
    MOV CL,BL
    MOV AX, CX
    MOV BL, 10
    DIV BL
    MOV CX, AX

    MOV AH,09
    LEA DX,res
    INT 21h

    ADD CL, 30h
    MOV DL,CL

    MOV AH, 02h
    INT 21h

    MOV DL,CH
    ADD DL,30h
    INT 21h

    JMP fim
fim:
    MOV AH,4Ch
    INT 21h
    ENDP MAIN
    END MAIN
