.MODEL SMALL
.STACK 100h
.DATA
    instrucciones DB 13,10, "Ingrese un articulo (A-F). Max 10 veces. Presione 'S' para salir. $"
    lista        DB 13,10, "Articulos: A=Pan=1.2, B=Leche=2.3, C=Jugo=3.4, D=Huevo=4.5, E=Queso=5.6, F=Cafe=6.7$"
    prompt       DB 13,10, "Articulo: $"
    precioMsg    DB 13,10, "Precio de $"
    totalMsg     DB 13,10, "Total acumulado: $"
    errorMsg     DB 13,10, "Articulo invalido.$"
    mensajeFin   DB 13,10, "Gracias por usar el programa.$"

    precios      DB 12, 23, 34, 45, 56, 67
    letras       DB 'A','B','C','D','E','F'

    ; Punteros a nombres
    nombrePtrs   DW offset nombreA, offset nombreB, offset nombreC, offset nombreD, offset nombreE, offset nombreF
    nombreA      DB "Pan$", 0
    nombreB      DB "Leche$", 0
    nombreC      DB "Jugo$", 0
    nombreD      DB "Huevo$", 0
    nombreE      DB "Queso$", 0
    nombreF      DB "Cafe$", 0

    contador     DB 0
    total        DW 0

.CODE
START:
    MOV AX, @DATA
    MOV DS, AX

    LEA DX, instrucciones
    MOV AH, 09h
    INT 21h

    LEA DX, lista
    MOV AH, 09h
    INT 21h

BUCLE:
    MOV AL, contador
    CMP AL, 10
    JGE FIN

    LEA DX, prompt
    MOV AH, 09h
    INT 21h

    MOV AH, 01h
    INT 21h

    CMP AL, 'a'
    JB NO_MAYUS
    CMP AL, 'z'
    JA NO_MAYUS
    SUB AL, 32
NO_MAYUS:

    CMP AL, 'S'
    JE FIN

    MOV SI, 0
BUSCAR:
    CMP AL, letras[SI]
    JE ENCONTRADO
    INC SI
    CMP SI, 6
    JL BUSCAR

    LEA DX, errorMsg
    MOV AH, 09h
    INT 21h
    JMP BUCLE

ENCONTRADO:
    ; Mostrar mensaje 'Precio de '
    LEA DX, precioMsg
    MOV AH, 09h
    INT 21h

    ; Mostrar nombre del producto
    MOV BX, SI
    SHL BX, 1
    MOV DX, nombrePtrs[BX]
    MOV AH, 09h
    INT 21h

    ; Mostrar precio
    MOV AL, precios[SI]
    XOR AH, AH
    CALL IMPRIMIR_DECIMAL

    ; Acumular al total
    MOV AL, precios[SI]
    XOR AH, AH
    ADD AX, total
    MOV total, AX

    ; Mostrar total acumulado
    LEA DX, totalMsg
    MOV AH, 09h
    INT 21h

    MOV AX, total
    CALL IMPRIMIR_DECIMAL

    INC contador
    JMP BUCLE

FIN:
    LEA DX, mensajeFin
    MOV AH, 09h
    INT 21h

    MOV AH, 4Ch
    INT 21h

IMPRIMIR_DECIMAL:
    PUSH AX
    MOV DX, 0
    MOV BX, 10
    DIV BX

    ADD AL, '0'
    MOV DL, AL
    MOV AH, 02h
    INT 21h

    MOV DL, '.'
    INT 21h

    MOV AL, AH
    ADD AL, '0'
    MOV DL, AL
    INT 21h

    POP AX
    RET

END START
