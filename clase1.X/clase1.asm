; * Encabezado *
    LIST P=16F887			
    #include "p16f887.inc"		

;* Configuración General *	
    __CONFIG _CONFIG1, _FOSC_INTRC_NOCLKOUT & _WDTE_OFF & _MCLRE_ON & _LVP_OFF
    
    CBLOCK 0x20
    CONTADOR1
    CONTADOR2
    ENDC

;* Inicio del Micro *
    ORG 0x00
    GOTO START

START:
    BANKSEL TRISA    
    CLRF TRISA        
    BANKSEL PORTA     

LED:
    BSF PORTA, 0      
    CALL DELAY
    BCF PORTA, 0      
    CALL DELAY
    GOTO LED

DELAY:
    MOVLW 0xFF
    MOVWF CONTADOR1
L1:
    MOVLW 0xFF
    MOVWF CONTADOR2
L2:	
    DECFSZ CONTADOR2, F
    GOTO L2
    DECFSZ CONTADOR1, F
    GOTO L1
    RETURN

END
