;################################################################
;#PROYECTO:  MULTIPLEXACION CON  DISPLAY DE  SEGMENTOS
; AUTOR    : CASTILLO, DARÍO ALBERTO
; E-MAIL: DARIO.CASTILLO@MI.UNC.EDU.AR
;################################################################
LIST P=16F887
#INCLUDE "p16F887.inc"
__CONFIG _CONFIG1, _FOSC_INTRC_NOCLKOUT & _WDTE_OFF & _MCLRE_ON & _LVP_OFF
    ; -----------------------------------------------VARIABLES----------------------------------------------------------------------
    
COUNT1		EQU		0x20		;CONT 1  Y 2 DE LOS DELAY
COUNT2		EQU		0x21
NUMERO		EQU		0X22
ORG		0X00
GOTO		START
ORG		 0x05
	
    ;  ########################################################################################
START:
    ;-----------------------------------------------CONFIGURACION DE PUERTOS------------------------------------------
    BANKSEL		ANSEL
    CLRF		ANSEL		; DESACTIVAR ENTRADAS ANALOGICAS
    CLRF		ANSELH
    BANKSEL		TRISA
    BCF		TRISC,0		 ; PORTE COMO SALIDA
    BCF		TRISC,1
    BCF		TRISC,2
    BCF		TRISC,3
    BCF		TRISC,4
    CLRF		TRISA	
    BANKSEL		PORTA
    CLRF		PORTA
    CLRF		PORTC
;------------------------------------TABLA DE NUMEROS BCD A PARTIR DEL REGISTRO 0x46   --------------------------------------------
    MOVLW		0x2B		;POSICION INICIAL
    MOVWF		FSR
    MOVLW		0x7E		; NUMERO ' 0'  EN BCD
    MOVWF		INDF
    INCF		FSR,1
    MOVLW		0x30		; NUMERO  ' 1'  EN BCD
    MOVWF		INDF
    INCF		FSR,1
    MOVLW		0x6D		 ; NUMERO  ' 2'  EN BCD
    MOVWF		INDF
    INCF		FSR,1
    MOVLW		0x79		; NUMERO  ' 3'  EN BCD
    MOVWF		INDF
    INCF		FSR,1
    MOVLW		0x33		; NUMERO  '4'  EN BCD
    MOVWF		INDF
    INCF		FSR,1
    MOVLW		0x5B		 ; NUMERO  '5'  EN BCD
    MOVWF		INDF
    INCF		FSR,1
    MOVLW		0x5F		 ; NUMERO  '6'  EN BCD
    MOVWF		INDF
    INCF		FSR,1
    MOVLW		0x72		 ; NUMERO  '7'  EN BCD
    MOVWF		INDF
    INCF		FSR,1
    MOVLW		0x7F		 ; NUMERO  '8'  EN BCD
    MOVWF		INDF
    INCF		FSR,1
    MOVLW		0x73		; NUMERO  '9'  EN BCD
    MOVWF		INDF
    ;---------------------------------------------INICIALIZO  FSR EN POSICION INICIAL----------------------------------------------
    MOVLW		0x2B
    MOVWF		FSR

    MOVF		INDF
    MOVWF		NUMERO

    CALL		MULTIPLEXADO
    GOTO $-1
	; #######################################################################
	;##########################     FUNCION PRINCIPAL   ##########################
	;########################################################################

; ######################################
; MULTIPLEXADO
; ######################################
MULTIPLEXADO:
    MOVLW		b'00011110'       
    MOVWF		PORTC
    MOVF        CENTENAS, W       
    MOVWF       PORTA
    CALL        DELAY_20MS

    MOVLW       b'00011101'         
    MOVWF       PORTC
    MOVF        DECENAS, W          
    MOVWF       PORTA
    CALL        DELAY_20MS
    
    
    MOVLW       b'00011011'        
    MOVWF       PORTC
    MOVF        UNIDAD, W       
    MOVWF       PORTA
    CALL        DELAY_20MS

    MOVLW       b'00010111'       
    MOVWF       PORTC
    MOVF        UNIDAD, W        
    MOVWF       PORTA
    CALL        DELAY_20MS
    
    MOVLW       b'00001111'         
    MOVWF       PORTC
    MOVF        UNIDAD, W         
    MOVWF       PORTA
    CALL        DELAY_20MS
    RETURN

DELAY_20MS:
	MOVLW			.4			; Ajustar COUNT1 para lograr 20 ms
	MOVWF			COUNT1
P1:
	MOVLW			.50				; COUNT2 sigue en 50
	MOVWF			COUNT2
P2:
	DECFSZ			COUNT2, F				; Reducir COUNT2 hasta cero
	GOTO			P2
	DECFSZ			COUNT1, F				; Reducir COUNT1 hasta cero
	GOTO			P1
	RETURN

    
	END