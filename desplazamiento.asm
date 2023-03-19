.MODEL SMALL
.STACK
.DATA
    numero db 5
    divisor db 2
    binary db 00000001B
    ;----------------------------- [MENSAJES] -------------------------------------
    menu db 10,13,"Menu",10,13,"1. SHR",10,13,"2. SHL",10,13,"3. SAR",10,13,"4. SAL",10,13,"5. SALIR",10,13,"$"
    msgBinario db "Binario: $"
    msgCorridas db "Ingresa el numero de desplazamiento, MIN: 1, MAX: 6: $"
    msgSHR db "Desplazamiento a la derecha",10,13,"$"
    msgSHL db "Desplazamiento a la izquierda",10,13,"$"
    msgSAL db "Desplazamiento aritmetico a la izquierda",10,13,"$"
    msgSAR db "Desplazamiento aritmetico a la derecha",10,13,"$"
    msgSALIR db 10,13,"Haz salido del programa$"
    cf db "CF = $"
    salto db 10,13,"$"
    ;----------------------------- [VARIABLES] -------------------------------------
    corridas db ?
    opcion db ?
    numCopia db ?


.CODE
    PRINCIPAL PROC FAR
        MOV AX, @DATA
        MOV DS, AX
        ;LIMPIAR PANTALLA
        MOV AH, 0
        MOV AL, 3
        INT 10H

        MOV AL, [numero]                    ;COPIA EL VALOR DE [NUMERO] AL REGISTRO AL
        MOV [numCopia], AL                ;MUEVE EL VALOR DE A LA VARIABLE [numCopia]
        MOV BL, [numCopia]               ;MUEVE EL VALOR DE LA VARIABLE [numCopia] AL REGISTRO BASE BL

        ; CODIGO GENERADO EN CLASE CONVERSIÓN DEC - BIN]
        INICIO:
            MOV BH, "$"
            PUSH BX
            MOV AX, 0
            MOV AL, numero
            MOV SI, 0

        DIVISION: ;FOR1
            DIV divisor
            CMP AL, 0
            JE IMPRIMIR 
            PUSH AX
            MOV AH, 0
            INC SI
            JMP DIVISION

        IMPRIMIR:  ; SACAR
            PUSH AX

        MOV AH, 9
        MOV DX, OFFSET msgBinario   ;MENSAJE "Binario"
        INT 21H
        CEROS:
            CMP SI, 7
            JE IMPRIMIR_2
            MOV AX, 0
            MOV AL, 30H
            PUSH AX
            INC SI
            JMP CEROS

        IMPRIMIR_2: ;FOR2
            POP DX 
            CMP DH, "$"
            JE MEN
            MOV DL, DH
            ADD DL, 30H
            MOV AH, 2
            INT 21H
            JMP IMPRIMIR_2

        ;INICIO DEL MENU 
        MEN:
            ;IMPRIMIR MENSAJE 
            MOV AH, 9
            MOV DX, OFFSET menu 
            INT 21H
            ;LEER NUMERO
            MOV AH, 1
            INT 21H
            MOV opcion, AL                              ; MOVIMIENTO DE VALOR EN REGISTRO AL a VARIABLE [opcion]
            CMP opcion, 35H                           ; COMPARACIÓN OPCION 5. SALIR
            JE FIN
            MOV AH, 9
            MOV DX, OFFSET salto 
            INT 21H
            MOV AH, 9                                       
            MOV DX, OFFSET msgCorridas  ; MENSAJE SOBRE NUMERO DE DESPLAZAMIENTOS  
            INT 21h                                           
            MOV AH, 1                                       
            INT 21H                                           
            MOV AH, 9
            MOV DX, OFFSET salto
            INT 21H
            SUB  AL, 30H                                ; RESTA PARA CONVERTIR DE HEX - DEC
            MOV CL, AL
            ; --------[COMPARACIÓN DE NÚMERO INGRESADO]---------
            CMP opcion, 31H
            JE DSHR
            CMP opcion, 32H
            JE DSHL
            CMP opcion, 33H 
            JE DSAR
            CMP opcion, 34H 
            JE DSAL
            ; ---------------------------------------------------------------------------------
        ; CAMBIO DEL FIN PORQUE ESTABA FUERA DE RANGO JEJE :p
        FIN:
            MOV AH, 9
            MOV DX, OFFSET msgSALIR
            INT 21H
            MOV AH, 4CH
            INT 21H

        DSHR:
            MOV AH, 9
            MOV DX, OFFSET msgSHR
            INT 21H
            CMP BL, numero                      ; COMPARACIÓN SI EL NÚMERO ORIGINAL ES DIFERENTE AL GUARDADO
            JNE CAMBIAR1                       ; SI ES DIFERENTE, SE CAMBIARÁ AL NÚMERO ORIGINAL
            JMP DEZSHR                          ; SI NO, HARÁ EL DESPLAZAMIENTO CON NORMALIDAD
            CAMBIAR1:                               ; ETIQUETA PARA CAMBIAR EL NÚMERO AL ORIGINAL
                MOV numero, BL              
            DEZSHR:
                SHR numero, CL
                JMP CARFLG

        DSHL:
            MOV AH, 9
            MOV DX, OFFSET msgSHL
            INT 21H
            CMP BL, numero
            JNE CAMBIAR2
            JMP DEZSHL
            CAMBIAR2:
                MOV numero, BL
            DEZSHL:
                SHL numero, CL
                JMP CARFLG                      

        DSAL:
            MOV AH, 9
            MOV DX, OFFSET msgSAL
            INT 21H
            CMP BL, numero
            JNE CAMBIAR3
            JMP DEZSAL
            CAMBIAR3:
                MOV numero, BL
            DEZSAL:
                SAL numero, CL
                JMP CARFLG                      

        DSAR:
            MOV AH, 9
            MOV DX, OFFSET msgSAR
            INT 21H
            CMP BL, numero
            JNE CAMBIAR4
            JMP DEZSAR
            CAMBIAR4:
                MOV numero, BL
            DEZSAR:
                SAR numero, CL
                JMP CARFLG                      

        CARFLG:
            MOV DL, 0
            MOV AH, 9
            MOV DX, OFFSET cf
            INT 21H
            LAHF
            AND binary, AH
            MOV DL, binary
            ADD DL, 30H
            MOV AH, 2
            INT 21H
            MOV AH, 9
            MOV DX, OFFSET salto
            INT 21H
            JMP INICIO

        SALIR:
            MOV AH, 4CH
            INT 21H
    PRINCIPAL ENDP
END PRINCIPAL