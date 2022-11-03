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
        
        ; Razon para las formulas: https://stackoverflow.com/questions/27912979/center-rectangle-in-another-rectangle
        LD C, ((32- ((slots * 4) - (slots -2)) ) / 2) ; Coordenadas de donde empieza a dibujar, esta es la x
        LD L, ((24- ((filas * 2) + 1) ) / 2) ; Esta la y

        ; Si son 4 slots, "-2", si son 3, -1    , si son 5, -3"
        LD B, (slots * 4) - (slots -2) ; anteriormente era ((slots * 2)*2) - 1 que viene de (slots * 2) + 7 (tiene sentido no tocarlo, que funciona para todo)
        LD H, filas
        


mainloop:
        CALL pixelyxc
        inc C
        DJNZ mainloop ; este pinta una linea horizontal y ya


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



;-------------------------------------------------------------------------------------------------
endofcode:      jr endofcode    ; Infinite loop

; Contantes
colorLineas: EQU 1
negro: EQU 8
colorSlots: EQU 8

slots: EQU 8
filas: EQU 8






;Funciones
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

Borde:
        PUSH BC
        OUT ($FE),A
        LD B, A 
        POP BC
        RET
