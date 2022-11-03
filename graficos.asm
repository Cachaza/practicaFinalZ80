Borde:
        PUSH BC
        OUT ($FE),A
        LD B, A 
        POP BC
        RET
pixelyxc:   
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
        LD A, colorSlots
        CALL pixelyxc
        inc C
        LD A , colorLineas
        DJNZ pintarConEspacios
        RET

        ; El espacio que creo increamentando C sin pintar nada es para la solucion
        ; Si lo hago en un bucle "slot" veces - 1, seria automatico


        ; 2 incs para 3 slots
lineaFinal:
        CALL pixelyxc
        inc C
        DJNZ lineaFinal
        RET
        