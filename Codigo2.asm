.include "m328pdef.inc"
.org 0x00
rjmp reset

; --------- RETARDO DE 1 SEGUNDO ---------
delay1s:
    ldi r20, 100
d1:
    ldi r21, 255
d2:
    ldi r22, 255
d3:
    dec r22
    brne d3
    dec r21
    brne d2
    dec r20
    brne d1
    ret

; --------- TABLA DE DÍGITOS ----------
; A–F → bits 2–7 (ya desplazados)
; G   → bit 0  (PB0)
digitos:
    ;      A B C D E F | G
    .db 0b11111100, 0b00000000 ; 0
    .db 0b01100000, 0b00000000 ; 1
    .db 0b11011000, 0b00000001 ; 2
    .db 0b11110000, 0b00000001 ; 3
    .db 0b01100100, 0b00000001 ; 4
    .db 0b10110100, 0b00000001 ; 5
    .db 0b10111100, 0b00000001 ; 6
    .db 0b11100000, 0b00000000 ; 7
    .db 0b11111100, 0b00000001 ; 8
    .db 0b11110100, 0b00000001 ; 9

; --------- PROGRAMA PRINCIPAL ---------
reset:
    clr r1

    ; Configurar PD2–PD7 como salida (A–F)
    ldi r16, 0b11111100
    out DDRD, r16

    ; Configurar PB0 como salida (G)
    ldi r17, 0b00000001
    out DDRB, r17

    ldi r18, 0              ; índice de dígito (0–9)

next_digit:
    ; Calcular dirección de dígito: 2 bytes por número
    ldi ZH, high(digitos << 1)
    ldi ZL, low(digitos << 1)
    lsl r18                  ; multiplicar por 2 (cada dígito son 2 bytes)
    add ZL, r18
    adc ZH, r1
    lsr r18                  ; restaurar r18 (deshace el lsl temporal)
    
    ; Leer datos
    lpm r19, Z+
    lpm r20, Z

    ; Mostrar en puertos
    out PORTD, r19
    out PORTB, r20

    rcall delay1s

    inc r18
    cpi r18, 10
    brlt next_digit

    rjmp reset
