;################################################################
;#PROYECTO:  MULTIPLEXACION CON  DISPLAY DE  SEGMENTOS
; AUTOR    : CASTILLO, DARÍO ALBERTO
; E-MAIL: DARIO.CASTILLO@MI.UNC.EDU.AR
;################################################################
    LIST P=16F887
    #INCLUDE "p16F887.inc"
    __CONFIG _CONFIG1, _FOSC_INTRC_NOCLKOUT & _WDTE_OFF & _MCLRE_ON & _LVP_OFF
; -----------------------------------------------
COUNT1				 EQU		0x20
COUNT2				 EQU		0x21   
    ORG 0X00
    GOTO			START
    ORG			0X05
START:
    BANKSEL			ANSEL
    CLRF			ANSEL		;0 PARA DIGITAL
    CLRF			ANSELH
    BANKSEL		TRISA
    BSF			TRISA,4		;1 PARA ENTRADAS
    BSF			TRISB,0		;DE PULSADORES
    BCF			TRISB,2		;0 PARA SALIDAS
    BCF			TRISB,3		 ;DE LOS LEDS
    BANKSEL			PORTA
    CLRF			PORTA
    CLRF			PORTB
MAIN:
    
    BTFSC			PORTA,4	
    BSF			PORTB,2
    CALL			CERO1
    CALL DELAY
    BTFSC			PORTB,0
    BSF			PORTB,3;
    CALL CERO2
    CALL DELAY
    GOTO MAIN
    CERO1:
    BCF			PORTB,2
    RETURN
    CERO2:
    BCF			PORTB,3
    RETURN
    
	;################################################################################
DELAY:
    MOVLW			.100				; Ajustar COUNT1 para lograr 5ms
    MOVWF			COUNT1
D1:
    MOVLW			 .100				; Ajustar COUNT2 para lograr 5ms
    MOVWF			 COUNT2
D2:
    DECFSZ			COUNT2, F				 ; Reducir COUNT2 hasta cero
    GOTO			D2
    DECFSZ			COUNT1, F				 ; Reducir COUNT1 hasta cero
    GOTO			D1
    RETURN


    END