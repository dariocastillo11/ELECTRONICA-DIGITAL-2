    LIST P=16F887
    INCLUDE "P16f887.INC"
    
    __CONFIG _CONFIG1, _FOSC_INTRC_NOCLKOUT & _WDTE_OFF & _MCLRE_ON & _LVP_OFF
    


    CONT EQU 0x24
    ORG 0x00
    GOTO INICIO
    ORG 0x05
    
INICIO:
    MOVLW 0x20
    MOVWF FSR
    CLRF CONT
ATRAS:
    MOVF CONT,0
    MOVWF INDF
    INCF CONT,1
    INCF FSR,1
    MOVF FSR,0
    ANDLW 0x0F
    BTFSS STATUS, Z
    GOTO ATRAS
    
    END
   
    
    
    
  /*  
START:
    
    
    MOVLW .250
    MOVWF CONTADOR1
    MOVLW .249
    MOVWF CONTADOR2
    
ATRAS:
    CALL DELAY_1MS
    CALL DELAY_1MS
    CALL DELAY_1MS
    CALL DELAY_1MS
    DECFSZ CONTADOR2,1
    GOTO ATRAS
    
    
DELAY_1MS:
    NOP ;1
    DECFSZ CONTADOR1,1;1
    GOTO DELAY_1MS;2
    
    RETURN
    
    
    

   CBLOCK 0X21
    NUMERO1
    NUMERO2
    RESULTADO
    CARRIE
    ENDC
    
    ORG 0x00
    ;GOTO START
    ORG 0x05
    
START:
    MOVLW 5
    MOVWF NUMERO1
    MOVLW 2
    MOVWF NUMERO2
    ADDWF NUMERO1,W
    MOVWF RESULTADO
    BTFSS STATUS,C
    GOTO NOHAYCARRIE
    BSF RESULTADO,1
    
    
NOHAYCARRIE:
    BSF CARRIE,0
    BCF STATUS,C
    END
    */
