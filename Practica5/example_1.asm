;------------------------------------------------------------
; PRÁCTICA 5 – LENGUAJES DE INTERFAZ (EMU8086)
; Versión corregida: carga ES para que CMPSB compare correctamente
; Lectura manual de 8 dígitos con INT 21h/AH=01
; Números de control: 22120729, 22120728, 22120727
;------------------------------------------------------------
.MODEL SMALL
.STACK 100h
.DATA
    ; Base de datos de 3 alumnos
    st1Data     DB '09120129 Jose Felipe Escobedo Magallan',0Dh,0Ah,'$'
    st2Data     DB '22120729 Oscar Kuricaveri Zamudio Damian',0Dh,0Ah,'$'
    st3Data     DB '22120727 Maria Garcia Lopez',0Dh,0Ah,'$'

    ; Mensajes
    titleMsg    DB 'Lenguajes de interfaz',0Dh,0Ah,'$'
    msgPrompt   DB 'Escribe el numero de control: $'
    msgFound    DB 0Dh,0Ah,'Alumno encontrado:',0Dh,0Ah,'$'
    msgNotFound DB 0Dh,0Ah,'El alumno no existe',0Dh,0Ah,'$'

    ; Controles a comparar (8 dígitos cada uno)
    ctrl1       DB '09120129'
    ctrl2       DB '22120729'
    ctrl3       DB '22120727'

    ; Buffer para almacenar los 8 dígitos tecleados
    inputCtrl   DB 8 DUP(?)
.CODE
MAIN PROC
    mov ax,@DATA
    mov ds,ax
    mov es,ax            ; ? necesario para que CMPSB compare DS:SI vs ES:DI

    ; 1) Imprime la base de datos
    lea dx,st1Data
    mov ah,09h
    int 21h
    lea dx,st2Data
    mov ah,09h
    int 21h
    lea dx,st3Data
    mov ah,09h
    int 21h

    ; 2) Muestra título
    lea dx,titleMsg
    mov ah,09h
    int 21h

INPUT_LOOP:
    ; Prompt
    lea dx,msgPrompt
    mov ah,09h
    int 21h

    ; --- Leer 8 dígitos uno a uno ---
    lea di,inputCtrl    ; DI ? dirección de buffer
    mov cx,8            ; leerás 8 caracteres

READ_DIGIT:
    mov ah,01h          ; INT21h/AH=01: leer carácter con eco
    int 21h             ; AL = código ASCII tecleado
    mov [di],al         ; guarda en buffer
    inc di
    loop READ_DIGIT

    ; Consumir y descartar el <Enter>
    mov ah,01h
    int 21h

    ; Salto de línea (CR+LF)
    mov dl,0Dh
    mov ah,02h
    int 21h
    mov dl,0Ah
    mov ah,02h
    int 21h

    ; 3–5) Comparar inputCtrl contra cada ctrlN
    mov si,OFFSET inputCtrl
    mov di,OFFSET ctrl1
    mov cx,8
    repe cmpsb
    je  DO_FOUND1

    mov si,OFFSET inputCtrl
    mov di,OFFSET ctrl2
    mov cx,8
    repe cmpsb
    je  DO_FOUND2

    mov si,OFFSET inputCtrl
    mov di,OFFSET ctrl3
    mov cx,8
    repe cmpsb
    je  DO_FOUND3

    ; --- No coincide ninguno (punto 4/5) ---
    lea dx,msgNotFound
    mov ah,09h
    int 21h
    jmp END_PROG

DO_FOUND1:
    lea dx,msgFound
    mov ah,09h
    int 21h
    lea dx,st1Data
    mov ah,09h
    int 21h
    jmp INPUT_LOOP

DO_FOUND2:
    lea dx,msgFound
    mov ah,09h
    int 21h
    lea dx,st2Data
    mov ah,09h
    int 21h
    jmp INPUT_LOOP

DO_FOUND3:
    lea dx,msgFound
    mov ah,09h
    int 21h
    lea dx,st3Data
    mov ah,09h
    int 21h
    jmp INPUT_LOOP

END_PROG:
    mov ah,4Ch          ; terminar programa
    int 21h
MAIN ENDP
END MAIN
