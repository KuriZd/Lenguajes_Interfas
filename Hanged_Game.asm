.MODEL SMALL
.STACK 100h

.DATA
    palabra         DB "GATO$"              ; Palabra a adivinar
    longitud        DB 4                    ; Longitud de la palabra
    oculta          DB "_", "_", "_", "_", "$" ; Estado visible
    intentos        DB 5                    ; Intentos restantes

    mensajeInicio   DB 13,10,"Adivina la palabra: $"
    mensajeInput    DB 13,10,"Ingresa una letra: $"
    mensajeGana     DB 13,10,"¡Ganaste!$"
    mensajePierde   DB 13,10,"Perdiste. La palabra era: $"
    mensajeIntentos DB 13,10,"Intentos restantes: $"
    saltoLinea      DB 13,10,"$"

.CODE
START:
    MOV AX, @DATA
    MOV DS, AX

; ----------- INICIO DEL JUEGO -----------
InicioJuego:
    LEA DX, mensajeInicio
    MOV AH, 09h
    INT 21h

    LEA DX, oculta
    MOV AH, 09h
    INT 21h

BucleJuego:
    ; Mostrar intentos restantes
    LEA DX, mensajeIntentos
    MOV AH, 09h
    INT 21h

    MOV DL, intentos
    ADD DL, '0'
    MOV AH, 02h
    INT 21h

    ; Solicitar letra
    LEA DX, mensajeInput
    MOV AH, 09h
    INT 21h

    MOV AH, 01h
    INT 21h
    MOV BL, AL         ; Guardar letra ingresada

    ; Convertir minúsculas a mayúsculas si aplica
    CMP BL, 'a'
    JL SaltaMayus
    CMP BL, 'z'
    JG SaltaMayus
    SUB BL, 32
SaltaMayus:

    ; Buscar letra en la palabra
    MOV SI, 0
    MOV AL, longitud
    MOV AH, 0
    MOV CX, AX         ; CX = longitud
    MOV DL, 0          ; DL como bandera de acierto

BuscarLetra:
    MOV AH, palabra[SI]
    CMP AH, BL
    JNE NoCoincide
    MOV oculta[SI], BL
    INC DL
NoCoincide:
    INC SI
    LOOP BuscarLetra

    CMP DL, 0
    JNE MostrarEstado

    ; Si no acertó, restar intento
    DEC intentos

MostrarEstado:
    LEA DX, saltoLinea
    MOV AH, 09h
    INT 21h

    LEA DX, oculta
    MOV AH, 09h
    INT 21h

    ; Verificar si ganó
    MOV SI, 0
    MOV AL, longitud
    MOV AH, 0
    MOV CX, AX

ComprobarGana:
    MOV AL, oculta[SI]
    CMP AL, palabra[SI]
    JNE NoGano
    INC SI
    LOOP ComprobarGana

    ; Si terminó el bucle, ganó
    LEA DX, mensajeGana
    MOV AH, 09h
    INT 21h
    JMP Fin

NoGano:
    CMP intentos, 0
    JG BucleJuego

    ; Si perdió
    LEA DX, mensajePierde
    MOV AH, 09h
    INT 21h

    LEA DX, palabra
    MOV AH, 09h
    INT 21h

Fin:
    MOV AH, 4Ch
    INT 21h
END START
