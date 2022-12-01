
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
  

