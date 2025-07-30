; ===============================
; Muestra números del 0 al 9 en un display de 7 segmentos
; para ATmega328P usando PD2–PD7 y PB0 (común cátodo)
; ===============================

.include "m328pdef.inc"
.org 0x0000
    rjmp start

; -------------------------
; Tabla de segmentos:
; PORTD: PD7–PD2 → g-f-e-d-c-b
; PORTB: PB0      → a
; Cada número ocupa 2 bytes: [PORTD], [PORTB]
segment_table:
    .db 0b11111100, 0b00000000 ; 0
    .db 0b00011000, 0b00000000 ; 1
    .db 0b01101100, 0b00000001 ; 2
    .db 0b00111100, 0b00000001 ; 3
    .db 0b10011000, 0b00000001 ; 4
    .db 0b10110100, 0b00000001 ; 5
    .db 0b11110100, 0b00000001 ; 6
    .db 0b00011100, 0b00000001 ; 7
    .db 0b11111100, 0b00000001 ; 8
    .db 0b10111100, 0b00000001 ; 9

; -------------------------
start:
    clr r1                   ; r1 = 0 (para ADC)

    ; Configurar PD2–PD7 como salida
    ldi r16, 0b11111100
    out DDRD, r16

    ; Configurar PB0 como salida
    ldi r16, 0b00000001
    out DDRB, r16

main_loop:
    ldi r20, 0               ; índice inicial

next_digit:
    ; Cargar dirección base de la tabla
    ldi ZH, high(segment_table << 1)
    ldi ZL, low(segment_table << 1)

    ; Ajustar Z para índice
    add ZL, r20
    adc ZH, r1

    ; Leer PORTD y PORTB desde la tabla
    lpm r18, Z+              ; r18 ← valor PORTD
    lpm r19, Z               ; r19 ← valor PORTB

    ; Mostrar en puertos
    out PORTD, r18
    out PORTB, r19

    ; Esperar 1 segundo
    rcall delay_1s

    ; Incrementar índice en 2 (2 bytes por dígito)
    inc r20
    inc r20
    cpi r20, 20              ; 10 dígitos x 2 bytes = 20
    brlt next_digit

    rjmp main_loop           ; Repetir ciclo

; -------------------------
; Retardo aproximado de 1 segundo
; Reloj de 16 MHz
; -------------------------
delay_1s:
    ldi r24, 255
delay1_loop1:
    ldi r23, 100
delay1_loop2:
    ldi r22, 255
delay1_loop3:
    dec r22
    brne delay1_loop3
    dec r23
    brne delay1_loop2
    dec r24
    brne delay1_loop1
    ret
