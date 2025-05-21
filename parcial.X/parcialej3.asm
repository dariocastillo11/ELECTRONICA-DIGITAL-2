; ** Encabezado **
    LIST P=16F887			
    #include "p16f887.inc"		

;** Configuración General **	
    __CONFIG _CONFIG1, _FOSC_INTRC_NOCLKOUT & _WDTE_OFF & _MCLRE_ON & _LVP_OFF


MAYOR  EQU 0x20
MENOR  EQU 0x21
   ; FINAL EQU 0x43
;** Inicio del Micro **
    ORG	0x00
 ;   GOTO START
    ;ORG 0x04
    ;GOTO ISR
    ORG 0x05
    
    
    
START:
    CLRF  MAYOR
    CLRF MENOR
   GOTO CARGO
   GOTO SIGO
    
    
    
    
 CARGO: 
    MOVLW 0x30
    MOVWF FSR
    MOVLW  8
    MOVWF INDF
    INCF FSR
    MOVLW 0X43
    SUBWF FSR,W
    BTFSS STATUS,2
    GOTO CARGO
 SIGO:;
    MOVLW 0x30
    MOVWF FSR
    SUBWF INDF, 64
    BTFSC STATUS,0
    INCF MAYOR
    BTFSS STATUS,0 
    INCF MENOR
    INCF FSR
    MOVLW 0X43
    SUBWF FSR,W
    BTFSS STATUS,2
    GOTO SIGO
    
    END