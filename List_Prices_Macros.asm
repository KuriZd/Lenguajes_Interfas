.MODEL SMALL
.STACK 100h

.DATA
    ; — Tabla de precios (décimos: 1.2 ? 12, 2.3 ? 23, …, 6.7 ? 67)
    precios    DB 12,23,34,45,56,67

    ; — Punteros a los nombres ($-terminados)
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

    ; — Mensajes sin acentos
    instrucciones DB 13,10,"*** 4.- PRECIOS DE ARTICULOS ***",13,10
                   DB "Maximo 10 articulos (A-F). Presione 'S' para salir.",13,10,"$"
    lista         DB 13,10,"Articulos y precios (N.N):",13,10
                   DB "A=1.2  B=2.3  C=3.4",13,10
                   DB "D=4.5  E=5.6  F=6.7",13,10,"$"
    prompt        DB 13,10,"Articulo: $"
    nombreMsg     DB 13,10,"Nombre del articulo: $"
    precioMsg     DB 13,10,"Precio del articulo: $"
    totalMsg      DB 13,10,"Total acumulado: $"
    terminarMsg   DB 13,10,"Desea terminar? (S/N): $"
    mensajeFin    DB 13,10,"Gracias por usar el programa.$"
    errorMsg      DB 13,10,"Articulo invalido.$"

    ; — Variables de estado
    priceVal    DB 0       ; último precio (décimos)
    countVar    DB 0       ; contador de artículos
    totalVar    DW 0       ; total acumulado (décimos)

.CODE

;========================================
; Macros con etiquetas locales
;========================================
PRINT_STR MACRO ptr
    MOV DX, OFFSET ptr
    MOV AH, 09h
    INT 21h
ENDM

READ_CHAR MACRO reg
    MOV AH, 01h
    INT 21h
    MOV reg, AL
ENDM

TO_UPPER MACRO r
    LOCAL _done
    CMP r, 'a'
    JB _done
    CMP r, 'z'
    JA _done
    SUB r, 20h
_done:
ENDM

;========================================
; PROC principal
;========================================
MAIN PROC
    ; Inicializa DS
    MOV AX, @DATA
    MOV DS, AX

    ; Imprime instrucciones y lista
    PRINT_STR instrucciones
    PRINT_STR lista

READ_LOOP:
    ; Verifica límite de 10 artículos
    MOV AL, [countVar]
    CMP AL, 10
    JAE EXIT_PROGRAM

    ; Pide y lee letra
    PRINT_STR prompt
    READ_CHAR AL
    TO_UPPER AL

    ; ¿Salir?
    CMP AL, 'S'
    JE EXIT_PROGRAM

    ; Valida A–F
    CMP AL, 'A'
    JB INVALID
    CMP AL, 'F'
    JA INVALID

    ; Calcula índice 0..5
    SUB AL, 'A'
    MOV AH, 0
    MOV CX, AX

    ; Imprime nombre del artículo
    PRINT_STR nombreMsg
    MOV SI, OFFSET namePtrs
    MOV BX, CX
    SHL BX, 1
    ADD SI, BX
    MOV DX, [SI]
    MOV AH, 09h
    INT 21h

    ; Carga y guarda precio
    MOV SI, OFFSET precios
    MOV BX, CX
    MOV AL, [SI + BX]
    MOV [priceVal], AL

    ; Imprime precio y suma al total
    PRINT_STR precioMsg
    MOV AH, 0
    MOV AL, [priceVal]
    CALL PRINT_TOTAL

    MOV AL, [priceVal]
    MOV AH, 0
    MOV BX, [totalVar]
    ADD BX, AX
    MOV [totalVar], BX

    INC BYTE PTR [countVar]

    ; Imprime total acumulado
    PRINT_STR totalMsg
    MOV AX, [totalVar]
    CALL PRINT_TOTAL

    ; Pregunta fin
    PRINT_STR terminarMsg
    READ_CHAR AL
    TO_UPPER AL
    CMP AL, 'S'
    JE EXIT_PROGRAM
    JMP READ_LOOP

INVALID:
    PRINT_STR errorMsg
    JMP READ_LOOP

EXIT_PROGRAM:
    PRINT_STR mensajeFin
    MOV AH, 4Ch
    INT 21h
MAIN ENDP

;========================================
; PROC auxiliar: imprime AX como N.N
;========================================
PRINT_TOTAL PROC
    XOR DX, DX
    MOV CX, 10
    DIV CX            ; AX = parte entera, DX = decimal
    MOV CL, DL        ; CL = dígito decimal

    CMP AX, 10
    JB one_digit

    ; Dos dígitos
    MOV BX, AX
    XOR DX, DX
    MOV AX, BX
    MOV BX, 10
    DIV BX            ; AX = decenas, DX = unidades
    MOV CH, DL        ; CH = unidad

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
    ; Imprime un solo dígito
    ADD AL, '0'
    MOV DL, AL
    MOV AH, 02h
    INT 21h

print_point:
    ; Imprime punto decimal y dígito
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
