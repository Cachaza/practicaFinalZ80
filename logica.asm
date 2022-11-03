
esperarQ:
        IN A, (C)
        BIT 0, A
        JR NZ, esperaEspacio 
        RET


        

esperarNOq:
        IN A, (C)
        BIT 0, A
        JR Z, esperaNOespacio
        RET


