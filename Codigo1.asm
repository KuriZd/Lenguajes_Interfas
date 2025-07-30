; AssemblerApplication1.asm (Parpadeo Rápido)
;
; Comportamiento: Hace parpadear el LED del pin 13 rápidamente.
;
.include "m328pdef.inc"
.org 0

setup:
    ; Configurar el pin 13 (PB5) como salida
    ldi r16, 0b00100000
    out DDRB, r16

on:
    ldi r16, 0b00000000
    out portb, r16
    jmp wait_loop

off:
    ldi r16, 0x00
    out portb, r16
    jmp wait_loop

wait_loop:
    ldi r19, 0x05       ; (antes 0xAF)
    ldi r18, 0xC0       ; (antes 0xFF)
    ldi r17, 0xFF   
wait2:
    ldi r18, 0xFF
wait3:
    ldi r17, 0xFF
wait4:
    nop
    nop
    dec r17
    brne wait4
    dec r18
    brne wait3
    dec r19
    brne wait2

check_state:
    cpi r16, 0b00100000
    breq off
    jmp on