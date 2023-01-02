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

        INC D ; incrementamos el numero de aciertos
        LD (IY), 254 ; 255 por que es un numero que el usuario no puede introducir

saltoInsctrucciones2
        INC IY   ; incrementamos el indice de la clave primero para rotar por todos sus valores y compararlos todos con un digito del intento
        DJNZ evaluarBlanco2 ; mientras no se hayan evaluado todos los digitos del intento, seguimos evaluando
        LD B, slots
        INC IX  ; incrementamos el indice del intento una vez lo hemos comparado con todos los digitos de la clave
        LD IY, claveTemp

        DEC E ; decrementamos el numero de slots a evaluar
        JR NZ, evaluarBlanco2

        ld a, D  ; cargamos el numero de aciertos en A
        or A ; si no hay ningun acierto blanco, salimos
        jr z, acabamospintar
pintarBlanco2:        
        LD B, D ; cargamos el numero de aciertos en B que es el registro que usa el bucle para pintar los aciertos
        CALL validacionXY ; vemos donde tenemos que pintar los blancos
        POP DE
        LD A, C 
        ADD D ; teniamos que pintar los blancos despues de los rojos, por lo que tenemos que sumar el numero de rojos a la posicion X de los blancos 
        LD C, A 
        LD A, 7 ; 


buclePintarBlanco: ; pintar los blancos tantas veces como aciertos haya
        CALL pixelyxc
        INC C
        DJNZ buclePintarBlanco
  

acabamospintar:

        ; una vez pintado todo, incrementamos el intento
        LD A, (intento)
        INC A
        LD (intento), A


        CALL copiaDatosIntento ; reseteamos el intento del jugador con todo a 255 para que no se quede con los valores anteriores
        LD A, (numIntentos)
        DEC A ; decrementamos el numero de intentos restantes
        LD (numIntentos), A
        LD A, (numIntentos)
        OR A ; si no quedan intentos, perdiste
        JR Z, perdedor


        JP antesDeTeclado ; volvemos al principio para que el jugador pueda introducir otro intento


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
intentoJugadorBase: DB 255,255,255 ; base para resetear el intento del jugador

claveTemp: DB 0,0,0

; Coordenadas
; Razon para las formulas: https://stackoverflow.com/questions/27912979/center-rectangle-in-another-rectangle
coordenadaXInicial: EQU ((32- ((slots * 4) - (slots -2)) ) / 2); ; Coordenadas de donde empieza a dibujar, esta es la x
coordenadaYInicial: EQU ((24- ((filas * 2) + 1) ) / 2) ; Esta la y



;Funciones

        include "graficos.asm"
        include "logica.asm"
        include "teclado.asm"
