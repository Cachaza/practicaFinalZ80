Borde:
        PUSH BC
        OUT ($FE),A
        LD B, A 
        POP BC
        RET