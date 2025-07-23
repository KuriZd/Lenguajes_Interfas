.MODEL SMALL
.STACK 100h

.DATA
    mensaje1 DB 13,10, "Escribe un numero decimal de dos digitos: $"
    mensaje2 DB 13,10, "Escribe otro numero decimal de dos digitos: $"
    mensajeResultado DB 13,10, "Resultado de la suma: $"

    buffer1 DB 5, ?, 5 DUP(?)   ; Entrada numero 1
    buffer2 DB 5, ?, 5 DUP(?)   ; Entrada numero 2

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

    
    MOV SI, OFFSET buffer1
    MOV AL, [SI + 2]
    MOV [0700h], AL         ; 1er digito
    MOV AL, [SI + 3]
    MOV [0701h], AL         ; 2do digito

    ; ============================
    ; Entrada del segundo numero
    ; ============================
    LEA DX, mensaje2
    MOV AH, 09h
    INT 21h

    LEA DX, buffer2
    MOV AH, 0Ah
    INT 21h

    MOV SI, OFFSET buffer2
    MOV AL, [SI + 2]
    MOV [0702h], AL         ; 1er digito
    MOV AL, [SI + 3]
    MOV [0703h], AL         ; 2do digito

    ; ============================
    ; Convertir primer numero
    ; ============================
    MOV AL, [0700h]
    SUB AL, '0'
    MOV BL, AL              ; Decena
    MOV AL, 10
    MUL BL                  ; AX = decena * 10
    MOV BL, AL              ; BL = decena * 10

    MOV AL, [0701h]
    SUB AL, '0'
    ADD AL, BL              ; AL = número 1
    MOV [0710h], AL

    ; ============================
    ; Convertir segundo numero
    ; ============================
    MOV AL, [0702h]
    SUB AL, '0'
    MOV BL, AL              ; Decena
    MOV AL, 10
    MUL BL
    MOV BL, AL

    MOV AL, [0703h]
    SUB AL, '0'
    ADD AL, BL              ; AL = número 2
    MOV [0711h], AL

    ; ============================
    ; Sumar números
    ; ============================
    MOV AL, [0710h]
    ADD AL, [0711h]
    MOV [0715h], AL         ; Resultado de la suma

    ; ============================
    ; Separar en centenas, decenas y unidades
    ; ============================
    MOV AL, [0715h]
    MOV AH, 0
    MOV BL, 100
    DIV BL                  ; AL = centenas, AH = resto
    MOV [070Ah], AL         ; Centenas
    MOV AL, AH              ; AL = resto
    MOV AH, 0
    MOV BL, 10
    DIV BL                  ; AL = decenas, AH = unidades
    MOV [070Bh], AL         ; Decenas
    MOV [070Ch], AH         ; Unidades

    ; ============================
    ; Imprimir resultado final
    ; ============================
    MOV AH, 09h
    LEA DX, mensajeResultado
    INT 21h

    ; Mostrar centenas (si no es 0)
    MOV AL, [070Ah]
    CMP AL, 0
    JE mostrar_decena
    ADD AL, '0'
    MOV DL, AL
    MOV AH, 02h
    INT 21h

mostrar_decena:
    MOV AL, [070Bh]
    ADD AL, '0'
    MOV DL, AL
    MOV AH, 02h
    INT 21h

    MOV AL, [070Ch]
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
