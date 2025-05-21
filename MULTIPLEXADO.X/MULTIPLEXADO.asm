	;################################################################
	;#PROYECTO:  MULTIPLEXACION CON  DISPLAY DE  SEGMENTOS
	; AUTOR    : CASTILLO, DARÍO ALBERTO
	; E-MAIL: DARIO.CASTILLO@MI.UNC.EDU.AR
	;################################################################
	LIST P=16F887
	#INCLUDE "p16F887.inc"
	__CONFIG _CONFIG1, _FOSC_INTRC_NOCLKOUT & _WDTE_OFF & _MCLRE_ON & _LVP_OFF
    ; -----------------------------------------------VARIABLES----------------------------------------------------------------------
CONT_UNIDAD		EQU		0x20		;PARA VER SI CONTO HASTA 10 LA UNIDAD Y LUEGO PASAR A DECENA
CONT_DECENAS		EQU		0x21		;PARA VER SI CONTO HASTA 10 LA DECENA Y LUEGO PASAR A CENTENA
CONT_CENTENAS		EQU		0x22

COUNT1			EQU		0x23		;CONT 1  Y 2 DE LOS DELAY
COUNT2			EQU		0x24

UNIDAD			EQU		0x25		 ;REGISTRO QUE CONTIENE EL NUMERO BCD  DE LA UNIDAD
DECENAS			EQU		0x26		;REGISTRO QUE CONTIENE EL NUMERO BCD  DE LA DECENA
CENTENAS			EQU		0x27
		;REGISTRO QUE CONTIENE EL NUMERO BCD  DE LA CENTENA
CUENTADEC		EQU		0x28		;LLEVAR LA CUENTA DE QUE NUMERO DE DECENA VA
CUENTACEN		EQU		0x29		;;LLEVAR LA CUENTA DE QUE NUMERO DE CENTENA VA
    ; ------------------------------------------------------------------------------------------------------------------------------------
	ORG			 0x05. 
	GOTO			 START
    ;  ########################################################################################
START:
	;-----------------------------------------------CONFIGURACION DE PUERTOS------------------------------------------
	BANKSEL			ANSEL
	CLRF			ANSEL				; DESACTIVAR ENTRADAS ANALOGICAS
	CLRF			ANSELH
	BANKSEL			TRISD
	CLRF			TRISE				 ; PORTE COMO SALIDA
	CLRF			TRISB	
	BSF			TRISD,0				  ;PIN 0 PORTD COMO ENTRADA
	
	BANKSEL			PORTB
	CLRF			PORTB
	CLRF			PORTD
	CLRF			PORTE
	;------------------------------------------- --INICIALIZACION DE REGISTROS---------------------------------------
	CLRF			CONT_UNIDAD
	CLRF			CONT_DECENAS
	CLRF			CONT_CENTENAS
	MOVLW			b'00001010'	
	MOVWF			CONT_UNIDAD			;PARA VER SI CONTO HASTA 10 EL BUCLE DE UNIDADES
	MOVWF			CONT_DECENAS
	MOVWF			CONT_CENTENAS
	;--------------------------------------------------------------------------------------------------------------------------
	CLRF			UNIDAD				;LIMPIO REGISTROS QUE CONTENDRAN NUMERO BCD
	CLRF			DECENAS
	CLRF			CENTENAS
	;--------------------------------------------------------------------------------------------------------------------------
	MOVLW			b'00000000'			 ;INICIALIZO EN  0 LA CUENTA NUMERO DE DECENAS Y CENTENAS
	MOVWF			CUENTADEC
	MOVWF			CUENTACEN	
;------------------------------------TABLA DE NUMEROS BCD A PARTIR DEL REGISTRO 0x46   --------------------------------------------
	MOVLW			0x2B				;POSICION INICIAL
	MOVWF			FSR
	MOVLW			0x7E				; NUMERO ' 0'  EN BCD
	MOVWF			INDF
	INCF			FSR,1
	MOVLW			0x30				; NUMERO  ' 1'  EN BCD
	MOVWF			INDF
	INCF			FSR,1
	MOVLW			0x6D				 ; NUMERO  ' 2'  EN BCD
	MOVWF			INDF
	INCF			FSR,1
	MOVLW			0x79				; NUMERO  ' 3'  EN BCD
	MOVWF			INDF
	INCF			FSR,1
	MOVLW			0x33				; NUMERO  '4'  EN BCD
	MOVWF			INDF
	INCF			FSR,1
	MOVLW			0x5B				 ; NUMERO  '5'  EN BCD
	MOVWF			INDF
	INCF			FSR,1
	MOVLW			0x5F				 ; NUMERO  '6'  EN BCD
	MOVWF			INDF
	INCF			FSR,1
	MOVLW			0x72				 ; NUMERO  '7'  EN BCD
	MOVWF			INDF
	INCF			FSR,1
	MOVLW			0x7F				 ; NUMERO  '8'  EN BCD
	MOVWF			INDF
	INCF			FSR,1
	MOVLW			0x73				; NUMERO  '9'  EN BCD
	MOVWF			INDF
	;---------------------------------------------INICIALIZO  FSR EN POSICION INICIAL----------------------------------------------
	MOVLW			0x2A
	MOVWF			FSR
	MOVF			INDF,W
	
	
	; #######################################################################
	;##########################     FUNCION PRINCIPAL   ##########################
	;########################################################################
ANTIREBOTE:;
	CALL			DELAY_20MS
	BTFSC			PORTD,0		    
	GOTO 
	CALL			INCREMENTAR
	RETURN
MAIN:
    ; Verificar si el botón está presionado
    	GOTO			MULTIPLEXADO;MULTIPLEXADO VUELVE AL MAIN
	BTFSC			PORTD, 0				 ; Verifica estado del pin RB7
	GOTO			ANTIREBOTE
	GOTO			MULTIPLEXADO;MULTIPLEXADO VUELVE AL MAIN
	
	
	GOTO			MAIN
; ######################################
; MULTIPLEXADO
; ######################################
MULTIPLEXADO:
    ; ---------------------------------MOSTRAR CENTENAS-----------------------------------
               ; Limpiar PORTB antes de actualizar
	CLRF			PORTE				; Limpiar PORTE antes de seleccionar display
	CLRF			PORTB
	MOVF			CENTENAS, W			 ; Cargar valor de CENTENAS en W
	MOVWF			PORTB				 ; Enviar valor de CENTENAS a los segmentos
	BSF			PORTE,2
	CALL			DELAY_20MS			; Retardo para asegurar visualizació
    ; --------------------------------MOSTRAR DECENAS-------------------------------------
	CLRF			PORTE
	CLRF			PORTB				; Limpiar PORTB antes de actualizar
	MOVF			DECENAS, W			; Cargar valor de DECENAS en W
	MOVWF			PORTB				; Enviar valor de DECENAS a los segmentos
	BSF			PORTE,1
	CALL			DELAY_20MS			; Retardo para asegurar visualización
	; --------------------------------MOSTRAR UNIDAD--------------------------------------
	CLRF			PORTE
	CLRF			PORTB				; Limpiar PORTB antes de actualizar
	MOVF			UNIDAD, W			; Cargar valor de UNIDAD en W
	MOVWF			PORTB				; Enviar valor de UNIDAD a los segmentos
	BSF			PORTE,0
	CALL			DELAY_20MS			 ; Retardo para asegurar visualización
	; Regresar a MAIN
	GOTO MAIN

	;################################################################################

INCREMENTAR:
; ---------------------------------------INCREMENTAR UNIDAD----------------------------
	CLRF			UNIDAD
	CLRF			DECENAS
	CLRF			CENTENAS
    
	INCF			FSR,1
	;CLRF			UNIDAD				; LIMPIAR REGISTRO UNIDAD
	MOVF			INDF,W
	MOVWF			UNIDAD				;CARGO DATO EN UNIDAD
	DECFSZ			CONT_UNIDAD, 1
	RETURN							; Si CONT_UNIDAD  ES 0 , TERMINAR
	GOTO			AUMENTAR_DECENAS
AUMENTAR_DECENAS:
	CLRF			DECENAS
	CLRF			UNIDAD
	;CLRF			DECENAS				; LIMPIAR REGISTRO DECENA
	MOVLW			b'00001010'				    
	MOVWF			CONT_UNIDAD			 ;INICIALIZO BUCLE DE UNIDAD
	INCF			CUENTADEC,1			 ;AUMENTO DECENA +1
	MOVLW			0x2A	
	MOVWF			FSR
	MOVF			INDF,W
	MOVWF			UNIDAD				 ;INICIALIZO DISPLAY DE UNIDAD CON EL 0
	MOVF			FSR,W
	ADDWF			CUENTADEC			 ;LA DIRECCION DE FSR + CUENTADEC
	MOVWF			FSR				;ES EL NUMERO QUE TIENE QUE TENER LA DECENA
	MOVF			INDF,W
	MOVWF			DECENAS				 ;CARGO DATO EN DECENAS
	MOVLW			0x2A				 ;VUELVO A INICIALIZAR FSR
	MOVWF			FSR
	DECFSZ			CONT_DECENAS, 1
		RETURN						  ; Si CONT_DECENAS ES 0  , TERMINAR
	GOTO			AUMENTAR_CENTENAS
AUMENTAR_CENTENAS:
	CLRF			DECENAS
	CLRF			UNIDAD
	CLRF			CENTENAS
	;CLRF			CENTENAS				 ; LIMPIAR REGISTRO DECENA
	MOVLW			b'00001010'	
	MOVWF			CONT_DECENAS			;INICIALIZO BUCLE DE DECENAS
	MOVWF			CONT_UNIDAD			   ;INICIALIZO BUCLE DE UNIDAD
	MOVLW			b'00000000'	
	MOVWF			CUENTADEC
	INCF			CUENTACEN,1			 ;AUMENTO CENTENA +1
	MOVLW			0x2A
	MOVWF			FSR
	MOVF			INDF,W
	MOVWF			DECENAS				  ;INICIALIZO DISPLAY DE DECENAS CON EL 0
	MOVF			FSR,W
	ADDWF			CUENTACEN			 ;LA DIRECCION DE FSR + CUENTACEN
	MOVWF			FSR				 ;ES EL NUMERO QUE TIENE QUE TENER LA CENTENA
	MOVF			INDF,W
	MOVWF			CENTENAS				   ;CARGO DATO EN CENTENAS
	DECFSZ			CONT_CENTENAS, 1
	RETURN							 ; Si CONT_CENTENAS  ES 0  , TERMINAR
	;################################################################################
DELAY_5MS:
	MOVLW			.50				; Ajustar COUNT1 para lograr 5ms
	MOVWF			COUNT1
D1:
	MOVLW			 .50				; Ajustar COUNT2 para lograr 5ms
	MOVWF			 COUNT2
D2:
	DECFSZ			COUNT2, F				 ; Reducir COUNT2 hasta cero
	GOTO			D2
	DECFSZ			COUNT1, F				 ; Reducir COUNT1 hasta cero
	GOTO			D1
	RETURN
DELAY_20MS:
	MOVLW			.200				; Ajustar COUNT1 para lograr 20 ms
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
