01: MOV [200h], 48h     ; H
02: MOV [201h], 4Fh     ; O
03: MOV [202h], 4Ch     ; L
04: MOV [203h], 41h     ; A

06: MOV DX, 200h        ; Dirección de inicio de la cadena ("HOLA$")
07: MOV AH, 09h         ; Función 09h: Mostrar cadena que termina en '$'
08: INT 21h             ; Llamada a la interrupción del DOS
09: INT 20h             ; Terminar programa