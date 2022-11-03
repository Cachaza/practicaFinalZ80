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