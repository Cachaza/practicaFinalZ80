Borde:
        PUSH BC
        OUT ($FE),A
        LD B, A 
        POP BC
        RET

pixelyxc:   ; funcion que pinta un pixel en la posicion x,y Autor Daniel Leon
        push AF
        push DE
        push HL
        ld L,L
        ld H,0
        add HL, HL
        add HL, HL
        add HL, HL
        add HL, HL
        add HL, HL
        ld E,C
        ld D,0
        add HL,DE
        ld DE,$5800
        add HL,DE
        SLA A
        SLA A
        SLA A
        ld (HL),A
        pop HL
        pop DE
        pop AF
        ret

pintarLineaRecta:
        CALL pixelyxc
        inc C
        DJNZ pintarLineaRecta ; este pinta una linea horizontal y ya
        RET

pintarConEspacios:       ; pinta una linea cada dos pixeles, es decir para casa slot
        CALL pixelyxc
        inc C
        inc C              ; incrementa dos veces para saltarnos un pixel que sera el slot

        DJNZ pintarConEspacios
        RET

