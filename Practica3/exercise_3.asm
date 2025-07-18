01: MOV [200h], 48h     ; H
02: MOV [201h], 4Fh     ; O
03: MOV [202h], 4Ch     ; L
04: MOV [203h], 41h     ; A
05: MOV [204h], 24h     ; $ (indicador de fin de cadena para función 09h)
06: MOV DX, 200h        ; Dirección de inicio de la cadena ("HOLA$")
07: MOV AH, 09h         ; Función 09h: Mostrar cadena que termina en '$'
08: INT 21h             ; Llamada a la interrupción del DOS
09: INT 20h             ; Terminar programa

CICLO:
    INT 21h        ; Muestra el carácter en DL (DL = 83h → 'ó' en ASCII extendido)

    AND BX, 0      ; BX = BX AND 0 → BX = 0
    AND BX, 1      ; BX = 0 AND 1 → BX sigue siendo 0

    LOOPZ CICLO    ; Si ZF=1 y CX ≠ 0 → salta a CICLO. Como BX=0, ZF=1
                   ; Entonces este ciclo se ejecutará 3 veces

MOV AH, 4Ch        ; Terminar programa
INT 21h