.MODEL SMALL
.STACK 100h
.DATA
    mensaje1 DB 13,10, "Escribe un numero decimal de dos digitos: $"
    mensaje2 DB 13,10, "Escribe otro numero decimal de dos digitos: $"

.CODE
START:
    MOV AX, @DATA
    MOV DS, AX

    ; Mostrar el primer mensaje
    LEA DX, mensaje1
    MOV AH, 09h
    INT 21h

    ; Mostrar el segundo mensaje
    LEA DX, mensaje2
    MOV AH, 09h
    INT 21h

    ; Salir del programa
    MOV AH, 4Ch
    INT 21h
END START
