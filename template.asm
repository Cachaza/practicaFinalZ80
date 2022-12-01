        DEVICE ZXSPECTRUM48
	SLDOPT COMMENT WPMEM, LOGPOINT, ASSERTION
        org $8000               ; Program is located from memory address $8000 = 32768

begin:          di              ; Disable Interrupts
                ld sp,0   
                ld a,0      ; Set stack pointer to top of ram (RAMTOP)
        
;-------------------------------------------------------------------------------------------------
; Student Code
        LD A, negro; CARGO NEGRO EN A PARA PINTAR EL BODE DE NEGRO
        CALL Borde;

        LD A, colorLineas
        
        LD C, coordenadaXInicial  ; coordenada X
        LD L, coordenadaYInicial  ; coordenada Y

        LD B, (slots * 4) - (slots -2) ; anteriormente era ((slots * 2)*2) - 1 que viene de (slots * 2) + 7 (tiene sentido no tocarlo, que funciona para todo)
        LD H, filas


pintarTablero:       
        CALL pintarLineaRecta ; Pinto la primera linea

        LD C, coordenadaXInicial ; reinicio coordenada X
        INC L                    ; incremento coordenada Y , es decir bajo uno
        LD B, slots + 1 ; el + 1 es para pintar la ultima linea

        CALL pintarConEspacios ; Pinto las lineas con slots

        ; espacio necesalio para pintar luego el punto final en la linea de slots
        PUSH AF
        LD A, slots -1
        ADD C
        LD C,A 
        POP AF

        ; punto final en la linea de slots
        CALL pixelyxc

        LD C, coordenadaXInicial  ; reinicio coordenada X
        INC L
        LD B, (slots * 4) - (slots -2)
        DEC H
        JR NZ, pintarTablero ; mientras no llegue a la ultima linea, vuelvo a pintar

        CALL pintarLineaRecta ; Pinto la ultima linea

        LD E, filas ; cargo el numero de filas del tablero




        CALL copiaDatos

        ; Preparacion del bucle
        LD D,0
        LD B, slots
        LD IX, intentoJugador
        LD IY, claveTemp
        ; Bucle contador de aciertos
bucleRojo:
        LD A, (IY)
        CP (IX)
        JR NZ, saltoInsctrucciones

        INC D
        LD (IY), 255 ; 255 por que es un numero que el usuario no puede introducir
saltoInsctrucciones:
        INC IX
        INC IY
        DJNZ bucleRojo
        
        ; ningun acierto
        LD A, D
        OR A
        JR Z, evaluarBlanco

        ; prepentacion de pintar los rojos
        LD B, D
        CALL validacionXY
        LD A, 10 ; 10 = rojo brillante
        ; Pintar evaluacion de los rojos
buclePintarRojo:
        CALL pixelyxc
        INC C
        DJNZ buclePintarRojo
        ; comprobar si ha ganado
        LD A , D
        CP slots
        JR Z, ganador



evaluarBlanco:
        PUSH DE
        LD D,0
        LD B, slots
        LD E, slots
        LD A, slots
        LD IX, intentoJugador
        LD IY, claveTemp
evaluarBlanco2:

        LD A, (IY)
        CP (IX)
        JR NZ, saltoInsctrucciones2

        INC D
        LD (IY), 254 ; 255 por que es un numero que el usuario no puede introducir

saltoInsctrucciones2
        INC IY
        DJNZ evaluarBlanco2
        LD B, slots
        INC IX
        LD IY, claveTemp


        
      
        DEC E
        JR NZ, evaluarBlanco2


pintarBlanco2:        
        LD B, D
        CALL validacionXY
        POP DE
        LD A, C 
        ADD D 
        LD C, A
        LD A, 7 ; 


buclePintarBlanco:
        CALL pixelyxc
        INC C
        DJNZ buclePintarBlanco
  






;-------------------------------------------------------------------------------------------------
endofcode:      jr endofcode    ; Infinite loop
ganador:
        LD a, 4
        out ($FE), A
        jr endofcode
; Contantes
colorLineas: EQU 1
negro: EQU 8

slots: EQU 4
filas: EQU 10

;Variables
intento: DB 0
slot: DB 0

slots1: DB slots


clave: DB 4,5,3,1
intentoJugador: DB 4,5,3,2
claveTemp: DB 0,0,0,0

contadorAciertos: DB slots


; Razon para las formulas: https://stackoverflow.com/questions/27912979/center-rectangle-in-another-rectangle
coordenadaXInicial: EQU ((32- ((slots * 4) - (slots -2)) ) / 2); ; Coordenadas de donde empieza a dibujar, esta es la x
coordenadaYInicial: EQU ((24- ((filas * 2) + 1) ) / 2) ; Esta la y



;Funciones

        include "graficos.asm"
        include "logica.asm"





copiaDatos:
        PUSH AF
        PUSH BC
        PUSH DE
        PUSH HL
        LD HL, clave
        LD DE, claveTemp
        LD BC, slots
        LDIR  ;cargamos la clave en claveTemp
        POP HL
        POP DE
        POP BC
        POP AF
        RET
