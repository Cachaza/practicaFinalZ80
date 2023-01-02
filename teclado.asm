bajarColor:
        PUSH AF
        LD A, (colorSlot)  ; saco el color del slot al registro A
        CP 1 
        JR Z, vuletaAbajo ; si es 1 que es el min, como estamos intentando bajar el color, volvemos a 8

        DEC A   ; reduzco el registro A ya que no lo puedo hacer directamente con la variable
        LD (colorSlot), A ; guardo el nuevo valor en el slot
        POP AF
        JP antesDeTeclado

vuletaAbajo:
        LD A, 8
        LD (colorSlot), A
        POP AF
        JP antesDeTeclado

subirColor:
        PUSH AF
        LD A, (colorSlot) ; saco el color del slot al registro A
        CP 8
        JR Z, vueltaArriba ; si es 8 que es el max, como estamos intentando subir el color, volvemos a 1

        INC A ; incremento el registro A ya que no lo puedo hacer directamente con la variable
        LD (colorSlot), A ; guardo el nuevo valor en el slot
        POP AF
        JP antesDeTeclado

vueltaArriba:
        LD A, 1
        LD (colorSlot), A
        POP AF
        JP antesDeTeclado

aceptarColor:
        PUSH AF
        PUSH HL
        PUSH DE

        LD A, (slot)
        CP slots - 1 ; como pito antes de nada el slot, si es igual a slots -1 es que es el ultimo
        JR Z, ultimoSlot ; es el ultimo slot

        LD HL, intentoJugador
buclePosicion:
        LD A , (HL)
        CP 255 ; si es que estaba vacio, metemos el color que hay en colorSlot
        JR Z, meterColor 
        INC HL
        JR buclePosicion

meterColor:
        LD A, (colorSlot)
        LD (HL), A ; intento de guardar el color en el array de inentoJugador

        LD A, (slot)
        INC A
        LD (slot), A
        JR finAceptarColor
ultimoSlot:

        LD HL, intentoJugador
buclePosicion2:
        LD A , (HL)
        CP 255 ; si es que estaba vacio, metemos el color que hay en colorSlot
        JR Z, meterColor2 
        INC HL
        JR buclePosicion2

meterColor2:
        LD A, (colorSlot)
        LD (HL), A ; intento de guardar el color en el array de inentoJugador


        LD A, 0
        LD (slot), A
        LD A, 1
        LD (colorSlot), A

        ;si hacemos aqui el incremento de intento, pintaremos la validacion  en la siguiente fila
        ;LD A, (intento)
        ;INC A
        ;LD (intento), A

        POP DE
        POP HL
        POP AF
        JP evaluacionIntento


        


finAceptarColor:
        PUSH DE
        POP HL
        POP AF
        JP antesDeTeclado

