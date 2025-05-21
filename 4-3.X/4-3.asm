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
				 
NUM				EQU		0X22
    ORG 0X00
    GOTO			START
    ORG			0X05
START:
    BANKSEL		ANSEL
    CLRF			ANSEL
    CLRF			ANSELH
    BANKSEL		TRISA
    BSF			TRISA,0
    CLRF			TRISB
    BANKSEL		PORTA
    CLRF			PORTB
    CLRF			PORTA
    MOVLW			.15
    MOVWF			NUM
MAIN:	    
    BTFSS			PORTA,4
    CALL			INCREMENTAR
    GOTO			MAIN
INCREMENTAR:
    INCF			PORTB
    CALL			DELAY
    DECFSZ			NUM,1
    RETURN
    MOVLW			.15
    MOVWF			NUM
    CLRF			PORTB
    RETURN
    
    ;################################################################################
DELAY:
    MOVLW			.200				; Ajustar COUNT1 para lograr 5ms
    MOVWF			COUNT1
D1:
    MOVLW			.200				; Ajustar COUNT2 para lograr 5ms
    MOVWF			COUNT2
D2:
    DECFSZ			COUNT2, F				 ; Reducir COUNT2 hasta cero
    GOTO			D2
    DECFSZ			COUNT1, F				 ; Reducir COUNT1 hasta cero
    GOTO			D1
    RETURN


    END