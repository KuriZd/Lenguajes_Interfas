.MODEL SMALL
.STACK 100h

.DATA
    mensaje1 DB 13,10, "Escribe un numero decimal de dos digitos: $"
    mensaje2 DB 13,10, "Escribe otro numero decimal de dos digitos: $"

    ; Buffers para capturar entradas
    buffer1 DB 5, ?, 5 DUP(?)    ; Byte 0: tamaño, Byte 1: longitud real, Byte 2+: datos
    buffer2 DB 5, ?, 5 DUP(?)

.CODE
START:
    ; Inicializar segmento de datos
    MOV AX, @DATA
    MOV DS, AX

    ; Mostrar mensaje 1
    LEA DX, mensaje1
    MOV AH, 09h
    INT 21h

    ; Leer primer número
    LEA DX, buffer1
    MOV AH, 0Ah
    INT 21h

    ; Guardar primer carácter en [0700h]
    MOV SI, OFFSET buffer1
    MOV AL, [SI + 2]      ; Primer carácter ingresado
    MOV [0700h], AL

    ; Mostrar mensaje 2
    LEA DX, mensaje2
    MOV AH, 09h
    INT 21h

    ; Leer segundo número
    LEA DX, buffer2
    MOV AH, 0Ah
    INT 21h

    ; Guardar primer carácter en [0701h]
    MOV SI, OFFSET buffer2
    MOV AL, [SI + 2]      ; Primer carácter ingresado
    MOV [0701h], AL

    ; Terminar el programa
    MOV AH, 4Ch
    INT 21h
END START
