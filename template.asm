        DEVICE ZXSPECTRUM48
	SLDOPT COMMENT WPMEM, LOGPOINT, ASSERTION
        org $8000               ; Program is located from memory address $8000 = 32768


begin:          di              ; Disable Interrupts
                ld sp,0         ; Set stack pointer to top of ram (RAMTOP)
                ld hl,$5800 ; guardamos lh la dirreción de memoria del primer cuadradito de la pantalla.              
                call sacarlongitud
                ;ld d,5 ;longitud de x que quiero pintar
                 LD C,cordenadax; Coordenadas de donde empieza a dibujar, esta es la x
                 LD L, cordenaday ; Esta la y
                ld b,lineastotal
                ;ld b,5; cuantas lineas queremmos
;-------------------------------------------------------------------------------------------------
; Student Code

mainloop:
   
    call lineajuego
    DJNZ mainloop
    call lineasolid
    call pintar
    call evaluacionIntento


endofcode:      jr endofcode    ; Infinite loop
;-------------------------------------------------------------------------------------------------
evaluacionIntento:

    call copiadatos
    ld b, Slots -1
    call comparardatos
    

    ret
comparardatos:
    
    ldd d,0 ;contador
    ld iy,(clavetemporal)
    ld ix,(intentos)
    ld a,(iy)
    cp (ix);lo mismo que ld c(iy), cp c. es lo mismo.
    jr nz, salta
    inc d
    ld (iy),255

salta:
    inc ix
    inc iy
    djnz comparardatos
    ret
copiadatos:
    push bc
    push hl
    ld hl, clave
    ld de,clavetemporal
    ld bc, (Slots-1)
    ldir
    pop hl
    pop bc
    ret
;-------------------------------------------------------------------------------------------------
pintar:;funcion que se encarga de pintar
    ld b, (Slots -1);le pasamos cuantas vueltas tiene que dar, en funcion el nuemro de slots.
    call siguientelineadejuego
    ret
;funcion que lleva la cuenta de la poscion del slot de juego.
siguientelineadejuego:
    call slotyx
    ; suo uno a la variable slots
    PUSH AF 
    LD A, (slot) 
    INC A
    LD (slot), A
    POP AF
    DJNZ siguientelineadejuego
    PUSH AF
    LD A, 0         ; reinicio slots
    LD (slot), A    ; reinicio slots        
    CALL validacionXY
    ; sumo uno a la variable de intentos
    LD A, (intento)
    INC A
    LD (intento), A
    POP AF
    DEC E
    JR NZ, pintar
    ret
slotyx:
    PUSH AF
    LD A, (slot) ; cargo el valor del slot
    ADD A, A     ; multiplico por 2
    INC A        ; sumo 1
    ADD cordenadax ; le sumo el offset ya que esta centrado
    LD C, A                ; guardo el valor en C que es nuestra coordenada X
    POP AF
    PUSH AF
    LD A, (intento) ; cargo el valor del intento
    ADD A, A        ; multiplico por 2
    INC A           ; sumo 1
    ADD cordenaday ; le sumo el offset ya que esta centrado
    LD L, A         ; guardo el valor en L que es nuestra coordenada Y
    POP AF
    ret
validacionXY:
    PUSH AF
    LD A, (slots1) ; cargo el valor del slot
    ADD A, A     ; multiplico por 2
    INC A        ; sumo 1
    ADD cordenadax ; le sumo el offset ya que esta centrado
    LD C, A                ; guardo el valor en C que es nuestra coordenada X
    POP AF
    PUSH AF
    LD A, (intento) ; cargo el valor del intento
    ADD A, A        ; multiplico por 2
    INC A           ; sumo 1
    ADD cordenaday ; le sumo el offset ya que esta centrado
    LD L, A         ; guardo el valor en L que es nuestra coordenada Y
    POP AF
    ret
;-------------------------------------------------------------------------------------------------
lineajuego:;funcion que se encarga de dibujar las lienas del juego
    push af
    call lineasolid ;llamamos a la funcion linea
    call nextline
    ld a, 1 ;color
    push bc
    ld b,Slots
    call lineaslots
    pop bc
    call nextline
    pop af
    call sacarlongitud
    ret 
;------------------------------------------------
nextline:;se encarga de iniciar el puntero a la siguiente linea
    LD C,cordenadax ; Coordenadas de donde empieza a dibujar, esta es la x
    push af;lo siguiente es para sumar la posción de la cordenada y.
    ld a,l
    add a,1
    ld l,a
    pop af
    ret
;------------------------------------------------
lineasolid:;se encarga de pintar una linea solida en base a la cordenadas actuales
        push af
        push de
        push hl
        ld a, 1 ;color
        ;ld c,0 ;cordenada x inicial
        ;ld l,0 ;cordenada y inical
        call lineyxcs
        pop hl
        pop de
        pop af
        ret
;-------------------------------------------------------------------------------------------------
pixel:
;pinta un punto en la posicion c,l (x,y) con el color a.
    push af
    push de
    push hl
    ld l, l
    ld h, 0
    add hl, hl
    add hl, hl 
    add hl, hl
    add hl, hl
    add hl, hl
    ld e, c
    ld d, 0
    add hl,de
    ld de,$5800
    add hl,de
    add a
    add a
    add a 
    ld (hl),a
    pop hl
    pop de
    pop af
    ret
;-------------------------------------------------------------------------------------------------
lineyxcs:
; pinta una linea desde una posición (x,y) inicial,
; pero le aumento la x para darle longitud de linea. La longitud de x viene dada por d.
; c es la cordenada x que se va a recorrer una a una hasta llegar al tamaño de d que es la longitud de la linea.
    call pixel
    inc c
    dec d
    jr nz,lineyxcs
    ret
;-------------------------------------------------------------------------------------------------
lineaslots:;se encarga de pintar la linea de slots de juego
    call separador
    djnz lineaslots
    ld b,Slots ;volvemos a usar el registro de b para hacer un bucle para los huecos
    call dejarespacios
    call pixel
    ret
dejarespacios:;se encarga de dejar espacios al final de cada slot para ver la solución de las respuestas
    inc c
    djnz dejarespacios
    dec c 
    dec c
    ret
;separador:  se encarga de mover las cordenadas x e y para dejar los espacios deseados entre slot.
separador:
    call pixel
    inc c
    inc c
    dec d
    dec d
    ret

;-------------------------------------------------------------------------------------------------
sacarlongitud:
    push af
    push bc
    sub a,2
    ld b,Slots
    call sacarlongitud2
    ld d, a
    pop bc 
    pop af
    ret
sacarlongitud2:;cada slot aumenta el juego en 3.
    add 3
    djnz sacarlongitud2
    inc a
    ret
;------------------------------------------------------------

Slots: EQU 4; nuemro que quiero de slots -1(ejemplo queiro 4 slots,equu 5)
lineastotal: EQU 3; nuemro de lineas del juego

cordenaday: EQU ((24- ((lineastotal * 2) + 1) ) / 2); calculo de la cordenada y
cordenadax: EQU ((32- ((Slots * 4) - (Slots+2)) ) / 2) ; Coordenadas de donde empieza a dibujar, esta es la x

slot: DB 0
intento: DB 0
slots1: db Slots

clave: db 7,4,2,5
intentos: db 4,2,1,5
clavetemporal: db 0,0,0,0

contaciertos: db 0
;lo pirmero copiamos clave temporal.
;si coincide alguno, ponemos rojo, y el que ha coincido le ponemos a 255
;contador de rojos encontrados, en caso de ser igual a slots, has ganado
;colores con brillo 9,10,11,12,13,14,15
