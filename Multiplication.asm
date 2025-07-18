.MODEL SMALL
.STACK 100h
.DATA
    MSG1 DB "Escribe un numero del 0-99: $"
    MSG2 DB 13, 10, "Escribe el segundo numero del 0-99: $"
    MSGR DB 13, 10, "El resultado es: $"

    DIGITOS DB 4 DUP(?) 

.CODE

MOV AX, @DATA
MOV DS, AX


MOV AH, 09h
LEA DX, MSG1
INT 21h

    
MOV AH, 01h
INT 21h
MOV [0202h], AL       
SUB AL, '0'
MOV BL, 10
MUL BL                
MOV BH, AL            


MOV AH, 01h
INT 21h
MOV [0203h], AL       
SUB AL, '0'
ADD BH, AL            
MOV CL, BH            

MOV AH, 09h
LEA DX, MSG2
INT 21h


MOV AH, 01h
INT 21h
MOV [0212h], AL       
SUB AL, '0'
MOV BL, 10
MUL BL
MOV BH, AL


MOV AH, 01h
INT 21h
MOV [0213h], AL       
SUB AL, '0'
ADD BH, AL
MOV CH, BH            
MOV AL, CL
MOV BL, CH
MUL BL                


MOV CX, 4             
LEA SI, DIGITOS + 3   
convertir:    

            XOR DX, DX
            MOV BX, 10
            DIV BX                
            ADD DL, '0'           
            MOV [SI], DL
            DEC SI   
    
LOOP convertir

LEA SI, DIGITOS
MOV DI, 0220h
MOV CX, 4
    
guardar_resultado:   

            MOV AL, [SI]
            MOV [DI], AL
            INC SI
            INC DI
            
LOOP guardar_resultado
    
MOV AH, 09h
LEA DX, MSGR
INT 21h
MOV SI, 0220h
MOV CX, 4
    
resultado:

            MOV DL, [SI]
            MOV AH, 02h
            INT 21h
            INC SI  
            
LOOP resultado

MOV AH, 4Ch
INT 21h