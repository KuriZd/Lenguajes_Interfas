.MODEL SMALL
.STACK 100h

.DATA
    mensaje1 DB 13,10, "Escribe un numero decimal de dos digitos: $"
    mensaje2 DB 13,10, "Escribe otro numero decimal de dos digitos: $"
    mensajeResultado DB 13,10, "Resultado de la suma: $"

    buffer1 DB 5 DUP("$")   ; Entrada número 1
    buffer2 DB 5 DUP("$")   ; Entrada número 2

.CODE
START:
    MOV AX, @DATA
    MOV DS, AX

    ; ============================
    ; Entrada del primer número
    ; ============================
    LEA DX, mensaje1
    MOV AH, 09h
    INT 21h

    LEA DX, buffer1
    MOV AH, 0Ah
    INT 21h

    ; Guardar dígitos en 700h y 701h
    MOV SI, OFFSET buffer1
    MOV AL, [SI + 2]
    MOV [0700h], AL      ; D11
    MOV AL, [SI + 3]
    MOV [0701h], AL      ; D12

    ; ============================
    ; Entrada del segundo número
    ; ============================
    LEA DX, mensaje2
    MOV AH, 09h
    INT 21h

    LEA DX, buffer2
    MOV AH, 0Ah
    INT 21h

    ; Guardar dígitos en 702h y 703h
    MOV SI, OFFSET buffer2
    MOV AL, [SI + 2]
    MOV [0702h], AL      ; D21
    MOV AL, [SI + 3]
    MOV [0703h], AL      ; D22

    ; ============================
    ; Convertir número 1
    ; ============================
    MOV AL, [0700h]
    SUB AL, '0'
    MOV BL, AL            ; decena
    MOV AL, 10
    MUL BL                ; AX = decena * 10
    MOV BL, AL

    MOV AL, [0701h]
    SUB AL, '0'
    ADD AL, BL            ; AL = número 1

    MOV BH, AL            ; Guardar número 1 en BH

    ; ============================
    ; Convertir número 2
    ; ============================
    MOV AL, [0702h]
    SUB AL, '0'
    MOV BL, AL
    MOV AL, 10
    MUL BL
    MOV BL, AL

    MOV AL, [0703h]
    SUB AL, '0'
    ADD AL, BL            ; AL = número 2

    ; ============================
    ; Sumar número 1 (BH) + número 2 (AL)
    ; ============================
    ADD AL, BH
    MOV [0704h], AL       ; Resultado binario

    ; ============================
    ; Separar centenas, decenas y unidades
    ; Guardar en 720h, 721h, 722h
    ; ============================
    MOV AH, 0
    MOV BL, 100
    DIV BL                ; AL = centenas, AH = resto
    MOV [0720h], AL       ; Centenas

    MOV AL, AH
    MOV AH, 0
    MOV BL, 10
    DIV BL                ; AL = decenas, AH = unidades
    MOV [0721h], AL       ; Decenas
    MOV [0722h], AH       ; Unidades

    ; ============================
    ; Imprimir resultado (como texto)
    ; ============================
    MOV AH, 09h
    LEA DX, mensajeResultado
    INT 21h

    ; Mostrar centenas si es diferente de 0
    MOV AL, [0720h]
    CMP AL, 0
    JE imprimir_decena
    ADD AL, '0'
    MOV DL, AL
    MOV AH, 02h
    INT 21h

imprimir_decena:
    MOV AL, [0721h]
    ADD AL, '0'
    MOV DL, AL
    MOV AH, 02h
    INT 21h

    MOV AL, [0722h]
    ADD AL, '0'
    MOV DL, AL
    MOV AH, 02h
    INT 21h

    ; ============================
    ; Fin del programa
    ; ============================
    MOV AH, 4Ch
    INT 21h
END START
