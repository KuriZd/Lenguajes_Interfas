01: MOV [200h], 48h     ; H
02: MOV [201h], 4Fh     ; O
03: MOV [202h], 4Ch     ; L
04: MOV [203h], 41h     ; A
05: MOV [204h], 24h     ; $ (fin de cadena para función 09h)
06: MOV AX, 0100h       ; Cargar el segmento donde está la cadena
07: MOV DS, AX          ; Establecer DS = 0100h (segmento de datos)
08: MOV DX, 200h        ; Offset donde empieza la cadena
09: MOV AH, 09h         ; Función de DOS para imprimir cadena que termina en '$'
10: INT 21h             ; Llamada a la interrupción del DOS
11: INT 20h             ; Terminar el programa