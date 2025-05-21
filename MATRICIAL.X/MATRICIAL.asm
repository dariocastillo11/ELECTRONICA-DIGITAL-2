 LIST P=16F887
#include <p16f887.inc>

 __CONFIG _CONFIG1, _FOSC_INTRC_NOCLKOUT & _WDTE_OFF & _MCLRE_ON & _LVP_OFF


 ORG		0x0000
 GOTO		 START
; Variables
CONTADOR1	EQU		 0x20
CONTADOR2	EQU		 0x21
FILA		EQU		 0x22
COLUMNA		EQU		 0x23
KEY		EQU		 0x24	
; Tabla para display de 7 segmentos común cátodo
TABLA:
    ADDWF		PCL, F
    RETLW		b'00111111'	 ; 0
    RETLW		b'00000110'	 ; 1
    RETLW		b'01011011'	 ; 2
    RETLW		b'01001111'	 ; 3
    RETLW		b'01100110'	 ; 4
    RETLW		b'01101101'	 ; 5
    RETLW		b'01111101'	 ; 6
    RETLW		b'00000111'	 ; 7
    RETLW		b'01111111'	 ; 8
    RETLW		b'01101111'	 ; 9
    RETLW		b'01110111'	 ; A
    RETLW		b'01111100'	 ; b
    RETLW		b'00111001'	 ; C
    RETLW		b'01011110'	 ; d
    RETLW		b'01111001'	 ; E
    RETLW		b'01110001'	 ; F

START:
    ;---------------------------- Configuración inicial---------------
    BANKSEL		ANSEL
    CLRF		ANSEL
    CLRF		ANSELH
    
    BANKSEL		TRISA
    MOVLW		b'00001111'
    MOVWF		TRISB
    CLRF		TRISA
    
    BANKSEL		PORTA
    CLRF		PORTA
    CLRF		PORTB

MAIN_LOOP:
    CALL		ESCANEAR
    MOVF		KEY, W
    CALL		TABLA
    MOVWF		PORTA
    CALL		DELAY
    GOTO		MAIN_LOOP

ESCANEAR:
    CLRF		KEY

    ; Activar primera fila
    MOVLW		B'00010000'
    MOVWF		PORTB
    CALL		CHECKEAR_COLUMNAS
    BTFSC		STATUS, Z		; Si encontró una tecla, salir
    RETURN

    ; Activar segunda fila
    MOVLW		B'00100000'
    MOVWF		PORTB
    CALL		CHECKEAR_COLUMNAS
    BTFSC		STATUS, Z
    RETURN

    ; Activar tercera fila
    MOVLW		B'01000000'
    MOVWF		PORTB
    CALL		CHECKEAR_COLUMNAS
    BTFSC		STATUS, Z
    RETURN

    ; Activar cuarta fila
    MOVLW		B'10000000'
    MOVWF		PORTB
    CALL		CHECKEAR_COLUMNAS
    RETURN

CHECKEAR_COLUMNAS:
    BTFSS		PORTB, 0
    MOVLW		D'0'		; Tecla en columna 0
    MOVWF		KEY
    RETURN
    BTFSS		PORTB, 1
    MOVLW		D'1'		; Tecla en columna 1
    MOVWF		KEY
    RETURN
    BTFSS		PORTB, 2
    MOVLW		D'2'		 ; Tecla en columna 2
    MOVWF		KEY
    RETURN
    BTFSS		PORTB, 3
    MOVLW		D'3'		 ; Tecla en columna 3
    MOVWF		KEY
    RETURN

DELAY:
    MOVLW		.50
    MOVWF		CONTADOR1
L1:
    MOVLW		 .50
    MOVWF		 CONTADOR2
L2:	
    DECFSZ		 CONTADOR2, F
    GOTO		  L2
    DECFSZ		 CONTADOR1, F
    GOTO		   L1
    RETURN

END