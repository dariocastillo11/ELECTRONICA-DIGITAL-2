; ** Encabezado **
    LIST P=16F887			
    #include "p16f887.inc"		

;** Configuraci�n General **	
    __CONFIG _CONFIG1, _FOSC_INTRC_NOCLKOUT & _WDTE_OFF & _MCLRE_ON & _LVP_OFF

	
;** Definicion de Variables **
;CONTADOR1 EQU 0x20
;CONTADOR2 EQU 0x21
    CBLOCK 0x20
    CONTADOR1
    CONTADOR2
    ENDC
    	
;** Inicio del Micro **
    ORG 0x00
    GOTO START
    ;ORG 0x04
    ;GOTO ISR
    ORG 0x05

START:
    
    BANKSEL TRISA
    BCF TRISA, 0
    BANKSEL PORTA
VUELVO:
    BSF PORTA, 0
    CALL DELAY
    BCF PORTA, 0
    CALL DELAY
    GOTO VUELVO

       
DELAY:
    MOVLW .255
    MOVWF CONTADOR1
L1:
    MOVLW .255
    MOVWF CONTADOR2
L2:	
    DECFSZ CONTADOR2, F
    GOTO L2
    DECFSZ CONTADOR1, F
    GOTO L1
    RETURN
    END
    