.MODEL SMALL
.STACK 100h

.DATA
    ; — Tabla de precios (décimos: 1.2?12, 2.3?23, …, 6.7?67) —
    precios    DB 12,23,34,45,56,67

    ; — Punteros a los nombres ($-terminados) —
    namePtrs   DW OFFSET namePan
               DW OFFSET nameLeche
               DW OFFSET nameJugo
               DW OFFSET nameHuevo
               DW OFFSET nameQueso
               DW OFFSET nameCafe

    namePan    DB "Pan",13,10,"$"
    nameLeche  DB "Leche",13,10,"$"
    nameJugo   DB "Jugo",13,10,"$"
    nameHuevo  DB "Huevo",13,10,"$"
    nameQueso  DB "Queso",13,10,"$"
    nameCafe   DB "Cafe",13,10,"$"

    ; — Nuevo mensaje de seccion sin acentos —
    nombreMsg   DB 13,10,"Nombre del articulo: $"

    ; — Variables de estado —
    priceVal    DB 0        ; ultimo precio (décimos)
    countVar    DB 0        ; contador de articulos
    totalVar    DW 0        ; total acumulado (décimos)

    ; — Mensajes de pantalla (sin acentos) —
    instrucciones DB 13,10,"*** 4.- PRECIOS DE ARTICULOS ***",13,10
                   DB "Maximo 10 articulos (A-F). Presione 'S' para salir.",13,10,"$"
    lista          DB 13,10,"Articulos y precios (N.N):",13,10
                   DB "A=1.2  B=2.3  C=3.4",13,10
                   DB "D=4.5  E=5.6  F=6.7",13,10,"$"
    prompt         DB 13,10,"Articulo: $"
    precioMsg      DB 13,10,"Precio del articulo: $"
    totalMsg       DB 13,10,"Total acumulado: $"
    terminarMsg    DB 13,10,"Desea terminar? (S/N): $"
    mensajeFin     DB 13,10,"Gracias por usar el programa.$"
    errorMsg       DB 13,10,"Articulo invalido.$"

.CODE
MAIN PROC
    ; Inicializa DS
    MOV AX, @DATA
    MOV DS, AX

    ; Imprime instrucciones
    MOV DX, OFFSET instrucciones
    MOV AH, 09h
    INT 21h

    ; Imprime lista
    MOV DX, OFFSET lista
    MOV AH, 09h
    INT 21h

READ_LOOP:
    ; Verifica limite de 10 articulos
    MOV AL, [countVar]
    CMP AL, 10
    JAE EXIT_PROGRAM

    ; Pide articulo
    MOV DX, OFFSET prompt
    MOV AH, 09h
    INT 21h

    ; Lee caracter
    MOV AH, 01h
    INT 21h        ; AL = tecla

    ; Convierte minuscula a mayuscula
    CMP AL, 'a'
    JB  SKIP_UP
    CMP AL, 'f'
    JA  SKIP_UP
    SUB AL, 20h
SKIP_UP:
    ; Sale si es 'S'
    CMP AL, 'S'
    JE EXIT_PROGRAM

    ; Valida A–F
    CMP AL, 'A'
    JB  INVALID
    CMP AL, 'F'
    JA  INVALID

    ; Calcula indice 0..5 y guarda en CX
    SUB AL, 'A'
    MOV AH, 0
    MOV CX, AX

    ; — Seccion "Nombre del articulo:" —
    MOV DX, OFFSET nombreMsg
    MOV AH, 09h
    INT 21h

    ; — Imprime nombre real —
    MOV SI, OFFSET namePtrs
    MOV BX, CX
    SHL BX, 1
    ADD SI, BX
    MOV DX, [SI]
    MOV AH, 09h
    INT 21h

    ; — Carga precio y guarda —
    MOV SI, OFFSET precios
    MOV BX, CX
    MOV AL, [SI + BX]
    MOV [priceVal], AL

    ; Imprime precio
    MOV DX, OFFSET precioMsg
    MOV AH, 09h
    INT 21h

    MOV AH, 0
    MOV AL, [priceVal]
    CALL PRINT_TOTAL

    ; Suma al total acumulado
    MOV AL, [priceVal]
    MOV AH, 0
    MOV BX, [totalVar]
    ADD BX, AX
    MOV [totalVar], BX

    ; Incrementa contador
    INC BYTE PTR [countVar]

    ; Imprime total acumulado
    MOV DX, OFFSET totalMsg
    MOV AH, 09h
    INT 21h

    MOV AX, [totalVar]
    CALL PRINT_TOTAL

    ; Pregunta si termina
    MOV DX, OFFSET terminarMsg
    MOV AH, 09h
    INT 21h

    MOV AH, 01h
    INT 21h        ; AL = respuesta
    CMP AL, 'a'
    JB  SK2
    CMP AL, 'z'
    JA  SK2
    SUB AL, 20h
SK2:
    CMP AL, 'S'
    JE EXIT_PROGRAM
    JMP READ_LOOP

INVALID:
    MOV DX, OFFSET errorMsg
    MOV AH, 09h
    INT 21h
    JMP READ_LOOP

EXIT_PROGRAM:
    MOV DX, OFFSET mensajeFin
    MOV AH, 09h
    INT 21h

    MOV AH, 4Ch
    INT 21h
MAIN ENDP

;----------------------------------------------------------
PRINT_TOTAL PROC
    XOR DX, DX
    MOV CX, 10
    DIV CX           ; AX = parte entera, DX = decimal
    MOV CL, DL       ; CL = digito decimal

    CMP AX, 10
    JB  one_digit

    ; Dos digitos en parte entera
    MOV BX, AX
    XOR DX, DX
    MOV AX, BX
    MOV BX, 10
    DIV BX           ; AX = decenas, DX = unidades
    MOV CH, DL       ; CH = digito unidad

    ; Imprime decena
    ADD AL, '0'
    MOV DL, AL
    MOV AH, 02h
    INT 21h

    ; Imprime unidad
    MOV AL, CH
    ADD AL, '0'
    MOV DL, AL
    MOV AH, 02h
    INT 21h

    JMP print_point

one_digit:
    ; Un digito en parte entera
    ADD AL, '0'
    MOV DL, AL
    MOV AH, 02h
    INT 21h

print_point:
    ; Imprime "." y digito decimal
    MOV DL, '.'
    MOV AH, 02h
    INT 21h

    MOV AL, CL
    ADD AL, '0'
    MOV DL, AL
    MOV AH, 02h
    INT 21h

    RET
PRINT_TOTAL ENDP

END MAIN
