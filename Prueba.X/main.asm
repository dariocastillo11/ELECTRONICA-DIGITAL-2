; ** Encabezado **9
    LIST P=16F887			
    #include "p16f887.inc"		

;** Configuración General **	
    __CONFIG _CONFIG1, _FOSC_INTRC_NOCLKOUT & _WDTE_OFF & _MCLRE_ON & _LVP_OFF

;** Definicion de Variables **
    CBLOCK 0x20
    CONTADOR1
    CONTADOR2
    ENDC
    
;** Inicio del Micro **
    ORG	0x00
    GOTO START
    ;ORG 0x04
    ;GOTO ISR
    ORG 0x05
    
START:
    BANKSEL ANSEL
    CLRF ANSEL
    BANKSEL TRISA
    CLRF TRISA	; PortA as output

    ; Stores 10 numbers, from 0xA0 to 0xA7, indirect addressing
    MOVLW 0XA0
    MOVWF FSR
    MOVLW 0x11
    MOVWF INDF
    INCF FSR
    MOVLW 0x22
    MOVWF INDF
    INCF FSR
    MOVLW 0x44
    MOVWF INDF
    INCF FSR
    MOVLW 0x88
    MOVWF INDF
    INCF FSR
    MOVLW 0xAA
    MOVWF INDF
    INCF FSR
    MOVLW 0xCC
    MOVWF INDF
    INCF FSR
    MOVLW 0xEE
    MOVWF INDF
    INCF FSR
    MOVLW 0xFF
    MOVWF INDF
    INCF FSR
    
    
LOOP:
    ; Loads stored numbers from 0xA0 to 0xA7 into PortA, direct addressing
    BANKSEL 0x80
    MOVF 0xA0, W
    BANKSEL PORTA
    MOVWF PORTA
    CALL DELAY
    BANKSEL 0x80
    MOVF 0xA1, W
    BANKSEL PORTA
    MOVWF PORTA
    CALL DELAY
    BANKSEL 0x80
    MOVF 0xA2, W
    BANKSEL PORTA
    MOVWF PORTA
    CALL DELAY
    BANKSEL 0x80
    MOVF 0xA3, W
    BANKSEL PORTA
    MOVWF PORTA
    CALL DELAY
    BANKSEL 0x80
    MOVF 0xA4, W
    BANKSEL PORTA
    MOVWF PORTA
    CALL DELAY
    BANKSEL 0x80
    MOVF 0xA5, W
    BANKSEL PORTA
    MOVWF PORTA
    CALL DELAY
    BANKSEL 0x80
    MOVF 0xA6, W
    BANKSEL PORTA
    MOVWF PORTA
    CALL DELAY
    BANKSEL 0x80
    MOVF 0xA7, W
    BANKSEL PORTA
    MOVWF PORTA
    CALL DELAY
    GOTO LOOP
    
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
/*
    ; Stores 10 numbers, from 0xA0 to 0xA7, direct addressing
    MOVLW 0x11
    MOVWF 0xA0
    MOVLW 0x22
    MOVWF 0xA1
    MOVLW 0x44
    MOVWF 0xA2
    MOVLW 0x88
    MOVWF 0xA3
    MOVLW 0xAA
    MOVWF 0xA4
    MOVLW 0xCC
    MOVWF 0xA5
    MOVLW 0xEE
    MOVWF 0xA6
    MOVLW 0xFF
    MOVWF 0xA7
*/
    
/*
    ; Stores 10 numbers, from 0xA0 to 0xA7, indirect addressing
    MOVLW 0XA0
    MOVWF FSR
    MOVLW 0x11
    MOVWF INDF
    INCF FSR
    MOVLW 0x22
    MOVWF INDF
    INCF FSR
    MOVLW 0x44
    MOVWF INDF
    INCF FSR
    MOVLW 0x88
    MOVWF INDF
    INCF FSR
    MOVLW 0xAA
    MOVWF INDF
    INCF FSR
    MOVLW 0xCC
    MOVWF INDF
    INCF FSR
    MOVLW 0xEE
    MOVWF INDF
    INCF FSR
    MOVLW 0xFF
    MOVWF INDF
*/
    
/*
    ; Loads stored numbers from 0xA0 to 0xA7 into PortA, direct addressing
    BANKSEL 0x80
    MOVF 0xA0, W
    BANKSEL PORTA
    MOVWF PORTA
    CALL DELAY
    BANKSEL 0x80
    MOVF 0xA1, W
    BANKSEL PORTA
    MOVWF PORTA
    CALL DELAY
    BANKSEL 0x80
    MOVF 0xA2, W
    BANKSEL PORTA
    MOVWF PORTA
    CALL DELAY
    BANKSEL 0x80
    MOVF 0xA3, W
    BANKSEL PORTA
    MOVWF PORTA
    CALL DELAY
    BANKSEL 0x80
    MOVF 0xA4, W
    BANKSEL PORTA
    MOVWF PORTA
    CALL DELAY
    BANKSEL 0x80
    MOVF 0xA5, W
    BANKSEL PORTA
    MOVWF PORTA
    CALL DELAY
    BANKSEL 0x80
    MOVF 0xA6, W
    BANKSEL PORTA
    MOVWF PORTA
    CALL DELAY
    BANKSEL 0x80
    MOVF 0xA7, W
    BANKSEL PORTA
    MOVWF PORTA
    CALL DELAY
    GOTO LOOP    
*/
    
/*
    ; Loads stored numbers from 0xA0 to 0xA7 into PortA, indirect addressing
    BANKSEL PORTA
LOOP:
    ; Loads stored numbers from 0xA0 to 0xA7 into PortA, direct addressing
    MOVLW 0XA0
    MOVWF FSR
LOAD:
    MOVF INDF, W
    MOVWF PORTA
    CALL DELAY
    INCF FSR, F
    BTFSS FSR, 3
    GOTO LOAD
    GOTO LOOP  
*/