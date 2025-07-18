MOV [200h], 'O'
MOV [201h], 'S'
MOV [202h], 'C'
MOV [203h], 'A'
MOV [204h], 'R'
MOV [205h], ' '
MOV [206h], 'Z'
MOV [207h], 'A'
MOV [208h], 'M'
MOV [209h], 'U'
MOV [20Ah], 'D'
MOV [20Bh], 'I'
MOV [20Ch], 'O'
MOV [20Dh], ' '
MOV [20Eh], 'D'
MOV [20Fh], 'A'
MOV [210h], 'M'
MOV [211h], 'I'
MOV [212h], 'A'
MOV [213h], 'N'
MOV [214h], 24h     ; $ (fin de cadena para función 09h)
MOV AX, 0100h       ; Cargar el segmento donde está la cadena
MOV DS, AX          ; Establecer DS = 0100h (segmento de datos)
MOV DX, 200h        ; Offset donde empieza la cadena
MOV AH, 09h         ; Función de DOS para imprimir cadena que termina en '$'
INT 21h             ; Llamada a la interrupción del DOS
INT 20h             ; Terminar el programa