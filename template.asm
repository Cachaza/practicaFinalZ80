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


; Pintar los slots
        LD HL, $5800
        LD BC, $FBFE

antesDeTeclado:

        CALL slotyx
        LD A, (colorSlot)
        CALL pixelyxc
        
waitnokey:
        LD BC, $FBFE
        IN A, (C)
        AND $1F
        CP $1F
        JR NZ, waitnokey


waitKey:        
        LD BC, $FBFE
        IN A, (C)
        BIT 0, A ; letra Q
        JP Z, bajarColor
        BIT 1, A ; letra W
        JP Z, subirColor
        BIT 4, A ; letra T
        JP Z, aceptarColor
        JR waitKey
                
            




; Evalucion de un intento
evaluacionIntento:
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
        JP Z, ganador



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

        ld a, D
        or A
        jr z, acabamospintar
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
  

acabamospintar:

        ; una vez pintado todo, incrementamos el intento
        LD A, (intento)
        INC A
        LD (intento), A


        CALL copiaDatosIntento
        LD A, (numIntentos)
        DEC A
        LD (numIntentos), A
        LD A, (numIntentos)
        OR A
        JR Z, perdedor


        JP antesDeTeclado


;-------------------------------------------------------------------------------------------------
endofcode:      jr endofcode    ; Infinite loop

; Contantes
colorLineas: EQU 1
negro: EQU 8

slots: EQU 3
filas: EQU 5

;Variables
intento: DB 0
slot: DB 0
numIntentos: DB filas

slots1: DB slots

colorSlot: DB 1


clave: DB 3,2,1; lo que hay que adivinar
intentoJugador: DB 255,255,255 ; lo que introduce el jugador
intentoJugadorBase: DB 255,255,255

claveTemp: DB 0,0,0

contadorAciertos: DB slots ; no esta en uso


; Razon para las formulas: https://stackoverflow.com/questions/27912979/center-rectangle-in-another-rectangle
coordenadaXInicial: EQU ((32- ((slots * 4) - (slots -2)) ) / 2); ; Coordenadas de donde empieza a dibujar, esta es la x
coordenadaYInicial: EQU ((24- ((filas * 2) + 1) ) / 2) ; Esta la y



;Funciones

        include "graficos.asm"
        include "logica.asm"
        include "teclado.asm"
