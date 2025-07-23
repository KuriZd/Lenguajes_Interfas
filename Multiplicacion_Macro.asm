.MODEL SMALL
.STACK 100h
.DATA
    ; Mensajes
    MSG1    DB "Escribe un numero del 0-99: $"
    MSG2    DB 13,10, "Escribe el segundo numero del 0-99: $"
    MSGR    DB 13,10, "El resultado es: $"
    ; Buffer para 4 dígitos ASCII
    DIGITOS DB 4 DUP(?)
    ; Variables para los dos números
    NUM1    DB ?
    NUM2    DB ?
.CODE

; -----------------------------
; Macro para imprimir cadena DOS
; -----------------------------
PRINT_MSG MACRO etiqueta
    mov ah, 09h
    mov dx, OFFSET etiqueta
    int 21h
ENDM

; -----------------------------
; Macro para leer un número 0–99
; -----------------------------
READ_NUM MACRO varDestino
    mov ah, 01h
    int 21h
    sub al, '0'
    mov bl, 10
    mul bl            ; AL*10 ? AX
    mov bh, al
    mov ah, 01h
    int 21h
    sub al, '0'
    add bh, al
    mov varDestino, bh
ENDM

START:
    mov ax, @DATA
    mov ds, ax

    ; Leer primer número
    PRINT_MSG MSG1
    READ_NUM NUM1

    ; Leer segundo número
    PRINT_MSG MSG2
    READ_NUM NUM2

    ; Multiplicación: AX = NUM1 * NUM2
    mov al, NUM1
    mul NUM2

    ; Convertir AX ? 4 dígitos ASCII en DIGITOS[]
    call ConvResult

    ; Imprimir resultado
    call PrintResult

    ; Terminar
    mov ah, 4Ch
    int 21h

; -----------------------------
; ConvResult PROC
; Convierte AX(0–9801) a 4 dígitos ASCII
; -----------------------------
ConvResult PROC
    push ax
    push bx
    push cx
    push dx
    push si

    mov cx, 4
    ; Cargar dirección base + 3
    mov si, OFFSET DIGITOS
    add si, 3
conv_loop:
    xor dx, dx
    mov bx, 10
    div bx            ; AX÷10 ? AX cociente, DX resto
    add dl, '0'
    mov [si], dl
    dec si
    loop conv_loop

    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
ConvResult ENDP

; -----------------------------
; PrintResult 
; Imprime MSGR + los 4 dígitos
; -----------------------------
PrintResult PROC
    push si
    push cx
    push dx

    PRINT_MSG MSGR

    mov si, OFFSET DIGITOS
    mov cx, 4
print_loop:
    mov dl, [si]
    mov ah, 02h
    int 21h
    inc si
    loop print_loop

    pop dx
    pop cx
    pop si
    ret
PrintResult ENDP

END START
