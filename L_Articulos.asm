.MODEL SMALL
.STACK 100h
.DATA
    ; Mensajes para el usuario
    instrucciones DB 13,10,"Ingrese un articulo (A-F). Maximo 10 articulos. Presione 'S' para salir antes. $"
    lista         DB 13,10,"Articulos y precios: A=1.2, B=2.3, C=3.4, D=4.5, E=5.6, F=6.7$"
    prompt        DB 13,10,"Articulo: $"
    precioMsg     DB 13,10,"Precio del articulo: $"
    totalMsg      DB 13,10,"Total acumulado: $"
    stopMsg       DB 13,10,"Desea terminar? (S/N): $"
    mensajeFin    DB 13,10,"Gracias por usar el programa!$"
    errorMsg      DB 13,10,"Articulo invalido.$"

    ; Datos de articulos
    letras  DB 'A','B','C','D','E','F'
    precios DB 12,23,34,45,56,67    ; cada valor = precio * 10 (1.2?12, 2.3?23, …)

    maxItems DB 10
    contador DB 0
    total    DW 0

.CODE
MAIN PROC
    ; Inicializar segmento de datos
    MOV AX,@DATA
    MOV DS,AX

    ; Mostrar instrucciones y lista
    LEA DX,instrucciones
    MOV AH,09h
    INT 21h
    LEA DX,lista
    MOV AH,09h
    INT 21h

    ; Inicializar contador y total
    MOV BYTE PTR [contador],0
    MOV WORD PTR [total],0

INPUT_LOOP:
    ; Salir si ya llegamos al maximo
    MOV AL,[contador]
    CMP AL,[maxItems]
    JAE END_PROGRAM

    ; Solicita articulo
    LEA DX,prompt
    MOV AH,09h
    INT 21h
    MOV AH,01h       ; leer caracter
    INT 21h

    ; Si presionó 'S' o 's', termina
    CMP AL,'S'
    JE END_PROGRAM
    CMP AL,'s'
    JE END_PROGRAM

    ; Guardar caracter en DL para buscar
    MOV DL,AL

    ; Buscar en la tabla de letras
    MOV SI,OFFSET letras
    MOV DI,OFFSET precios
    MOV CX,6
FIND_LOOP:
    MOV AL,[SI]
    CMP AL,DL
    JE PRICE_FOUND
    INC SI
    INC DI
    DEC CX
    JNZ FIND_LOOP

    ; No encontrado: mensaje de error y repetir
    LEA DX,errorMsg
    MOV AH,09h
    INT 21h
    JMP INPUT_LOOP

PRICE_FOUND:
    ; --- ACTUALIZA TOTAL ---
    MOV AL,[DI]      ; AL = precio*10
    MOV AH,0
    MOV BX,AX        ; BX = precio*10
    MOV AX,[total]
    ADD AX,BX
    MOV [total],AX

    ; --- IMPRIME PRECIO DEL ARTICULO ---
    LEA DX,precioMsg
    MOV AH,09h
    INT 21h

    MOV AL,[DI]      ; AL = precio*10
    MOV AH,0
    MOV CL,10
    DIV CL           ; AX/10 ? AL=intPart, AH=decPart

    ; imprime dígito antes del punto
    ADD AL,'0'
    MOV DL,AL
    MOV AH,02h
    INT 21h
    ; imprime "."
    MOV DL,'.'
    MOV AH,02h
    INT 21h
    ; imprime dígito decimal
    MOV DL,AH
    ADD DL,'0'
    MOV AH,02h
    INT 21h
    ; CR+LF
    MOV DL,13
    MOV AH,02h
    INT 21h
    MOV DL,10
    MOV AH,02h
    INT 21h

    ; --- IMPRIME TOTAL ACUMULADO ---
    LEA DX,totalMsg
    MOV AH,09h
    INT 21h

    MOV AX,[total]
    MOV CL,10
    DIV CL           ; AL=intPartTotal, AH=decPartTotal
    MOV CH,AH        ; guardar parte decimal en CH

    ; separar integer total en decenas/unidades
    MOV AH,0
    MOV BL,10
    DIV BL           ; AX/10 ? AL=tens, AH=ones

    CMP AL,0
    JE PRINT_ONE_DIGIT
    ; si tens >0, imprime decena
    ADD AL,'0'
    MOV DL,AL
    MOV AH,02h
    INT 21h
    ; imprime unidad
    MOV DL,AH
    ADD DL,'0'
    MOV AH,02h
    INT 21h
    JMP PRINT_DEC_POINT

PRINT_ONE_DIGIT:
    ; solo unidad
    MOV DL,AH
    ADD DL,'0'
    MOV AH,02h
    INT 21h

PRINT_DEC_POINT:
    ; imprime punto y decimal
    MOV DL,'.'
    MOV AH,02h
    INT 21h
    MOV DL,CH
    ADD DL,'0'
    MOV AH,02h
    INT 21h
    ; CR+LF
    MOV DL,13
    MOV AH,02h
    INT 21h
    MOV DL,10
    MOV AH,02h
    INT 21h

    ; --- PREGUNTA SI DESEA TERMINAR ---
    LEA DX,stopMsg
    MOV AH,09h
    INT 21h
    MOV AH,01h
    INT 21h
    CMP AL,'S'
    JE END_PROGRAM
    CMP AL,'s'
    JE END_PROGRAM

    ; incrementar contador y repetir
    INC BYTE PTR [contador]
    JMP INPUT_LOOP

END_PROGRAM:
    ; Mensaje de despedida y salida
    LEA DX,mensajeFin
    MOV AH,09h
    INT 21h
    MOV AH,4Ch
    INT 21h

MAIN ENDP
END MAIN
