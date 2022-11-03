mainloop:
pintarLineaRecta:
        CALL pixelyxc
        inc C
        DJNZ pintarLineaRecta ; este pinta una linea horizontal y ya


        LD C, ((32- ((slots * 4) - (slots -2)) ) / 2) ;
        INC L 
        LD B, slots + 1 ; el + 1 es para pintar la ultima linea
        

pintarConEspacios:       ; pinta una linea cada dos pixeles, es decir para casa slot
        CALL pixelyxc
        inc C
        LD A, colorSlots
        CALL pixelyxc
        inc C
        LD A , colorLineas
        DJNZ pintarConEspacios

        ; El espacio que creo increamentando C sin pintar nada es para la solucion
        ; Si lo hago en un bucle "slot" veces - 1, seria automatico


        ; 2 incs para 3 slots
        PUSH AF
        LD A, slots -1
        ADD C
        LD C,A 
        POP AF

        LD A, colorLineas

        CALL pixelyxc

        LD C, ((32- ((slots * 4) - (slots -2)) ) / 2) ;
        INC L
        LD B, (slots * 4) - (slots -2)

        DEC H
        JR NZ, mainloop
lineaFinal:
        CALL pixelyxc
        inc C
        DJNZ lineaFinal