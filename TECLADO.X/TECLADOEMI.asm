    LIST P=16F887
    #INCLUDE "p16F887.inc"
    
    __CONFIG _CONFIG1, _FOSC_INTRC_NOCLKOUT & _WDTE_OFF & _MCLRE_ON & _LVP_OFF
    
;Defino los registros para la memoria
    CBLOCK 0x20
    UNI ;0X20
    DEC ;0X21
    CEN ;0X22
    COUNT1 ;PARA EL DELAY
    COUNT2 ;PARA EL DELAY
    COUNT3 ; LA POSICION DEL BOTON PRECIONADO
    COUNT4 ; LA POSICION DE GUARDADO DEL NUM INGRESADO
    ENCEN_DISPLAY
    ENDC
 
    ORG 0X00
    GOTO START 
    ;0X04
    ORG 0X05
    
START: ;Cofiguro los puertos PORTA , PORTB Y PORTE
    BANKSEL TRISA
    CLRF TRISE ;PORTE como SALIDA como deco
    CLRF TRISB ;PORTB como SALIDA de los display
    MOVLW 0X0F 
    MOVWF TRISA ;PORTA = SALIDA 7 AL 4 Y ENTRADA 3 AL 0
    BANKSEL ANSEL
    CLRF ANSEL
    BANKSEL PORTB
    
    CALL REINICIAR; SET encender el primer display
       
    ;Carga de los hexa que muestran los numeros que se encienden con 1 los led
    MOVLW 0X7E ;Apartir del 0x46 al 0x4F se cargan los datos PORQUE LO
    MOVWF UNI ;INICIALIZO con 0 cero los display A
    MOVWF DEC ;INICIALIZO con 0 cero los display B
    MOVWF CEN ;INICIALIZO con 0 cero los display C
    CLRF COUNT4
    INCF COUNT4
 
    ;De aqui en adelante corre el programa
    
;-----------------------------------------
;De aca corre el bucle que lee los valores del teclado
;Y lo muestra por los display 
PROGRAM:

    MOVLW 0X20
    MOVWF FSR
    MOVF INDF,W
    MOVWF PORTB
    CALL DELAY_20MS
    CALL MULTIPLEX
    INCF FSR
    
    MOVLW 0X21
    MOVWF FSR
    MOVF INDF,W
    MOVWF PORTB
    CALL DELAY_20MS
    CALL MULTIPLEX
    INCF FSR
    
    MOVLW 0X22
    MOVWF FSR
    MOVF INDF,W
    MOVWF PORTB
    CALL DELAY_20MS
    CALL MULTIPLEX
    
    

;Termino de mostrar los resultados de los display
;-------------------------------------------------------------
;Comienzo con el chequeo del boton
    MOVLW 0XF0
    MOVWF PORTA
    
    MOVF PORTA,W
    ANDLW 0X0F 
    BTFSS STATUS,Z ;pregunta si se presiono el boton
    GOTO DBA ;hace deboun
    GOTO PROGRAM
    
;-------------------------------------------------------------
DBA: ;deboun con espera de 20 MS
    CLRF COUNT3 ;Inicializo el conteo de la teclas no pulsadas
    
    CALL DELAY_20MS
    MOVF PORTA,W
    ANDLW 0X0F 
    
    BTFSS STATUS,Z ;pregunta si se presiono el boton
    CALL BUSCAR; ejecuto el programa porque si se preciono el boton 
LOOP2:
    CALL DELAY_20MS
    MOVF PORTA,W
    ANDLW 0X0F
    BTFSC STATUS,Z
    GOTO LOOP2
    GOTO PROGRAM
;------------------------------------------------------------------------------
    
BUSCAR:; Encuentro la fila y la columna que se preciono
    MOVLW .16
    MOVWF PORTA
    CALL CHEQUEO
    
    MOVLW .32
    MOVWF PORTA
    CALL CHEQUEO
    
    MOVLW .64
    MOVWF PORTA
    CALL CHEQUEO
    
    MOVLW .128
    MOVWF PORTA
    CALL CHEQUEO
    
    RETURN
   
CHEQUEO: ;Compruebo por fila
    INCF COUNT3
    BTFSC PORTA,0
    GOTO FIN
    
    INCF COUNT3
    BTFSC PORTA,1
    GOTO FIN
    
    INCF COUNT3
    BTFSC PORTA,2
    GOTO FIN
    
    INCF COUNT3
    BTFSC PORTA,3
    GOTO FIN
    
    RETURN
    
FIN:
    CALL LOOKUP_TABLE
    CALL CODIGO
    RETURN

;Aca termina el deboun y regresa al loop principal
;---------------------------------------------------
CODIGO:
    ;Codigo a ejecutar cuando ya se detecto el boton y esta cargado en W
    BTFSC COUNT4,0
    MOVWF UNI 
    BTFSC COUNT4,1
    MOVWF DEC
    BTFSC COUNT4,2
    MOVWF CEN
    
    BCF STATUS,0
    RLF COUNT4
    BTFSC COUNT4,3
    CALL REINICIAR2
    RETURN
;-------------------------------------------------------------------
;De aca para abajo esta DELAY, MULTIPLEX, REINICIAR, TABLA
MULTIPLEX:
    MOVF ENCEN_DISPLAY, W
    MOVWF PORTE
    BCF STATUS,0
    RLF ENCEN_DISPLAY
    BTFSC ENCEN_DISPLAY,3
    GOTO REINICIAR    
RETURN_MULT:
    RETURN
    
REINICIAR:
    MOVLW .01
    MOVWF ENCEN_DISPLAY
    GOTO RETURN_MULT
    
REINICIAR2:
    MOVLW .01
    MOVWF COUNT4
    RETURN
    
DELAY_20MS: ;Delay para mantener encendido el led
    MOVLW .235
    MOVWF COUNT1
    
L1:
    MOVLW .27
    MOVWF COUNT2

L2:
    DECFSZ COUNT2
    GOTO L2
    DECFSZ COUNT1
    GOTO L1
    RETURN

LOOKUP_TABLE:
    MOVF COUNT3,W
    ADDWF PCL,F
    RETLW 0X30 ;1
    RETLW 0X33 ;4
    RETLW 0X72 ;7
    RETLW 0X01 ;*
;---------------------------
    RETLW 0X6D ;2
    RETLW 0X5B ;5
    RETLW 0X7F ;8
    RETLW 0X7E ;0
;---------------------------
    RETLW 0X79 ;3
    RETLW 0X5F ;6
    RETLW 0X72 ;9
    RETLW 0X36 ;#
;---------------------------
    RETLW 0X77 ;A
    RETLW 0X1F ;B
    RETLW 0X4E ;C
    RETLW 0X3D ;D
    
    END