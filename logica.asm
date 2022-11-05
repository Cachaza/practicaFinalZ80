slotyx:
        PUSH AF
        LD A, (slot) ; cargo el valor del slot
        ADD A, A     ; multiplico por 2
        INC A        ; sumo 1
        ADD coordenadaXInicial ; le sumo el offset ya que esta centrado
        LD C, A                ; guardo el valor en C que es nuestra coordenada X
        POP AF


        PUSH AF
        LD A, (intento) ; cargo el valor del intento
        ADD A, A        ; multiplico por 2
        INC A           ; sumo 1
        ADD coordenadaYInicial ; le sumo el offset ya que esta centrado
        LD L, A         ; guardo el valor en L que es nuestra coordenada Y
        POP AF





        ;LD A, 2         ; color qeu pintar el slot
        ;CALL pixelyxc   ; pinto el slot
        RET 

validacionXY:
        PUSH AF
        LD A, (slots1) ; cargo el valor del slot
        ADD A, A     ; multiplico por 2
        INC A        ; sumo 1
        ADD coordenadaXInicial ; le sumo el offset ya que esta centrado
        LD C, A                ; guardo el valor en C que es nuestra coordenada X
        POP AF


        PUSH AF
        LD A, (intento) ; cargo el valor del intento
        ADD A, A        ; multiplico por 2
        INC A           ; sumo 1
        ADD coordenadaYInicial ; le sumo el offset ya que esta centrado
        LD L, A         ; guardo el valor en L que es nuestra coordenada Y
        POP AF





        ;LD A, 2         ; color qeu pintar el slot
        ;CALL pixelyxc   ; pinto el slot
        RET 