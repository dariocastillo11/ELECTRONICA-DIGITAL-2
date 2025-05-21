    LIST P=16F887
    #INCLUDE "p16F887.inc"
    
    __CONFIG _CONFIG1, _FOSC_INTRC_NOCLKOUT & _WDTE_OFF & _MCLRE_ON & _LVP_OFF
    
;Defino los registros para la memoria
    CBLOCK 0x20
    DATOS
    W_TEMP
    STATUS_TEMP
    ENDC
 
    ORG 0X00
    GOTO START
    ORG 0X04
    GOTO ISR
    ORG 0X05

START:
    BANKSEL TRISA
    BSF TRISB,0 ;PORTB,0 como entrada
    BCF TRISB,1 ;RB1 SALIDA
    BCF TRISB,2 ;RB2 SALIDA
    BCF TRISB,3 ;RB3 SALIDA
    BCF TRISB,4 ;SETEO COMO SALIDA POR LAS DUDAS
    
    BANKSEL ANSEL
    CLRF ANSEL
    CLRF ANSELH
    
    ;Configuro PIR1 y PIR2 -Son las izq del pdf ,no lo uso, no es necesario-
    BCF INTCON,0 ; Limpio el flag del puerto B
        
    BANKSEL IOCB
    BSF IOCB,0 ;Configuro solo el pin 0 como interrupcion
    
    BANKSEL PORTA; Regreso al Bank 0
    
    ;Configuro PIE1 y PIE2 -Son las izq del pdf ,no lo uso, no es necesario-

    BSF INTCON,3 ;Habilito la RBIE 
    ;BSF INTCOIN,6 PEIE -Son las izq del pdf ,no lo uso, no es necesario-
    BSF INTCON,7 ;Habilito la GIE -general-
    
    ;De aqui en adelante se corre el programa 
    CLRF DATOS
    CLRF PORTB
    
    GOTO $
    
ISR:
    MOVWF W_TEMP
    SWAPF STATUS,W
    MOVWF STATUS_TEMP
    
    BCF INTCON,0 ; Limpio el flag del puerto B
    
    ;LOGICA DEL PROGRAMA
    
LOOP:
    BTFSS PORTB,0
    GOTO FIN
    
    BTFSS DATOS,0
    GOTO RET 
    RLF PORTB
    BCF PORTB,1

    BTFSC PORTB,4
    GOTO SETEO

FIN:
    SWAPF STATUS_TEMP,W
    MOVWF STATUS
    SWAPF W_TEMP,F
    SWAPF W_TEMP,W
    
    RETFIE
    
RET:
    INCF DATOS
SETEO:
    MOVLW b'00000010'
    MOVWF PORTB
    GOTO FIN
    
    END