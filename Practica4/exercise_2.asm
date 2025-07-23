.MODEL SMALL
.STACK 100h

.DATA
    mensaje1 DB 13,10, "Escribe un numero decimal de dos digitos: $"
    mensaje2 DB 13,10, "Escribe otro numero decimal de dos digitos: $"

    ; Buffers para la entrada de teclado (formato para INT 21h, función 0Ah)
    ; Byte 0: tamaño máximo a leer (sin contar los bytes de control)
    ; Byte 1: número de caracteres realmente ingresados (se llena al usar INT 21h)
    ; Byte 2-n: caracteres ingresados
    buffer1 DB 5, ?, 5 DUP(?)
    buffer2 DB 5, ?, 5 DUP(?)

.CODE
START:
    ; Inicializar segmento de datos
    MOV AX, @DATA
    MOV DS, AX

    ; Mostrar primer mensaje
    LEA DX, mensaje1
    MOV AH, 09h
    INT 21h

    ; Leer primer número
    LEA DX, buffer1
    MOV AH, 0Ah
    INT 21h

    ; Mostrar segundo mensaje
    LEA DX, mensaje2
    MOV AH, 09h
    INT 21h

    ; Leer segundo número
    LEA DX, buffer2
    MOV AH, 0Ah
    INT 21h

    ; Salir del programa
    MOV AH, 4Ch
    INT 21h
END START
