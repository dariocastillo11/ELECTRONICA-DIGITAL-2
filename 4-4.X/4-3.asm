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
    BANKSEL		ANSEL
    CLRF			ANSEL		;0 PARA DIGITAL
    CLRF			ANSELH
    BANKSEL		TRISA
    BSF			TRISA,4
    BSF			TRISB,0
    CLRF			TRISD
    BANKSEL		PORTA
    BCF			PORTA,4
    BCF			PORTB,0
    CLRF			PORTD
MAIN:		
    
    BTFSS			PORTA,4 
    GOTO			CEROS		;00   O  01
    GOTO			UNOS		;10   O   11
CEROS:
    BTFSS			PORTB,0
    GOTO			OO
    GOTO			OI
OO:
    MOVLW			b'10101010'	;00
    MOVWF			PORTD
    GOTO			MAIN
OI:
    MOVLW			b'01010101'	;01
    MOVWF			PORTD
    GOTO			MAIN
UNOS:
    BTFSS			PORTB,0
    GOTO			IO
    GOTO			II
IO:
    MOVLW			b'00001111'	;10
    MOVWF			PORTD
    GOTO			MAIN
II:
    MOVLW			b'11110000'	;11
    MOVWF			PORTD 
    GOTO			MAIN
    
    
	;################################################################################
DELAY:
    MOVLW			.200				; Ajustar COUNT1 para lograr 5ms
    MOVWF			COUNT1
D1:
    MOVLW			 .200				; Ajustar COUNT2 para lograr 5ms
    MOVWF			 COUNT2
D2:
    DECFSZ			COUNT2, F				 ; Reducir COUNT2 hasta cero
    GOTO			D2
    DECFSZ			COUNT1, F				 ; Reducir COUNT1 hasta cero
    GOTO			D1
    RETURN


    END