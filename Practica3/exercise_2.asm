MOV [200h], 48h     ; H
MOV [201h], 4Fh     ; O
MOV [202h], 4Ch     ; L
MOV [203h], 41h     ; A
MOV [204h], 24h     ; '$'

MOV DL, [200h]
MOV AH, 02h
INT 21h             ; Muestra 'H'

MOV DL, [201h]
INT 21h             ; Muestra 'O'

MOV DL, [202h]
INT 21h             ; Muestra 'L'

MOV DL, [203h]
INT 21h             ; Muestra 'A'

MOV DL, [204h]
INT 21h             ; Muestra '$'

INT 20h             ; Termina el programa