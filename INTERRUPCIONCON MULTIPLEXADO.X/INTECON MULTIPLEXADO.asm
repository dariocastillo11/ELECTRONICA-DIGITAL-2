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
ESTADO			EQU		0x40
DOBLEV			EQU		0X41

	ORG			0X00
	GOTO			START
	ORG			0X04
	GOTO			INTERRUPCION
	
	ORG			 0x05
	
    ;  ########################################################################################
START:
	;-----------------------------------------------CONFIGURACION DE PUERTOS------------------------------------------
	BANKSEL			ANSEL
	CLRF			ANSEL				; DESACTIVAR ENTRADAS ANALOGICAS
	CLRF			ANSELH
	BANKSEL			TRISC
	BCF			TRISE,0				 ; PORTE COMO SALIDA
	BCF			TRISE,1
	BCF			TRISE,2
	CLRF			TRISA	
	BSF			TRISB,0				  ;PIN 0 PORTD COMO ENTRADA
	
	;---------------------CONFIGURO INT-------------------------
    
	BANKSEL	OPTION_REG     
	BCF		OPTION_REG, INTEDG	 ;SELEECION EL FLANCO. INTERRUPCION POR FLANCO DESCENDENTE CON O
						 ;CUANDO PULSO PULSADOR  SE VA A TIERRA
	BANKSEL    	PORTA
	BCF		INTCON,INTF	    ;BORRA FLAG INTERRUPCION DEL RBO  DE FLANCO
	BSF		INTCON,7		    ;SETEA     GIE  GLOBAL5
	BSF		INTCON,INTE		    ;SETEA INTE PARA INTERRUOCION DEL RBO POR FLANCO DESCENDENTE}
	;-----------------------------------------------------------------
	BANKSEL			PORTA
	CLRF			PORTA
	CLRF			PORTE
	;------------------------------------------- --INICIALIZACION DE REGISTROS---------------------------------------
	CLRF			CONT_UNIDAD ;20
	CLRF			CONT_DECENAS;21
	CLRF			CONT_CENTENAS;22
	MOVLW			b'00001010'	
	MOVWF			CONT_UNIDAD			;PARA VER SI CONTO HASTA 10 EL BUCLE DE UNIDADES
	MOVWF			CONT_DECENAS
	MOVWF			CONT_CENTENAS
	;--------------------------------------------------------------------------------------------------------------------------
	CLRF			UNIDAD		;40		;LIMPIO REGISTROS QUE CONTENDRAN NUMERO BCD
	CLRF			DECENAS;44;
	CLRF			CENTENAS;42
	
	;--------------------------------------------------------------------------------------------------------------------------
				 ;INICIALIZO EN  0 LA CUENTA NUMERO DE DECENAS Y CENTENAS
	CLRF			CUENTADEC;28
	CLRF			CUENTACEN	;29
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
	MOVLW			0x2B
	MOVWF			FSR
	
	
	
	CALL			MULTIPLEXADO
	GOTO $-1
	; #######################################################################
	;##########################     FUNCION PRINCIPAL   ##########################
	;########################################################################

; ######################################
; MULTIPLEXADO
; ######################################
MULTIPLEXADO:
    ; Mostrar CENTENAS
    MOVLW       b'00000011'         ; Activar display de centenas
    MOVWF       PORTE
    ;CLRF        PORTB
    MOVF        CENTENAS, W         ; Cargar valor de CENTENAS en W
    MOVWF       PORTA
    CALL        DELAY_20MS

    ; Mostrar UNIDAD
    MOVLW       b'00000101'         ; Activar display de unidad
    MOVWF       PORTE
   ; CLRF        PORTB
    MOVF        DECENAS, W           ; Cargar valor de UNIDAD en W
    MOVWF       PORTA
    CALL        DELAY_20MS
    
    ; Mostrar DECENAS
    MOVLW       b'00000110'         ; Activar display de decenas
    MOVWF       PORTE
    ;CLRF        PORTB
    MOVF        UNIDAD, W          ; Cargar valor de DECENAS en W
    MOVWF       PORTA
    CALL        DELAY_20MS

    RETURN

	;################################################################################

INCREMENTAR:
; ---------------------------------------INCREMENTAR UNIDAD----------------------------

	INCF			FSR,1
	CLRF			UNIDAD				; LIMPIAR REGISTRO UNIDAD
	MOVF			INDF,W
	MOVWF			UNIDAD				;CARGO DATO EN UNIDAD
	DECFSZ			CONT_UNIDAD, 1
	RETURN							; Si CONT_UNIDAD  ES 0 , TERMINAR
	GOTO			AUMENTAR_DECENAS
AUMENTAR_DECENAS:
	
    CLRF DECENAS ;44

					; LIMPIAR REGISTRO DECENA
	MOVLW			.10				    
	MOVWF			CONT_UNIDAD			 ;INICIALIZO BUCLE DE UNIDAD
	INCF			CUENTADEC,1			 ;AUMENTO DECENA +1
	MOVLW			0x2B	
	MOVWF			FSR
	MOVF			INDF,W
	MOVWF			UNIDAD				 ;INICIALIZO DISPLAY DE UNIDAD CON EL 0
	MOVF			FSR,W
	ADDWF			CUENTADEC,0			 ;LA DIRECCION DE FSR + CUENTADEC -- NO FUNCIONO EN DEBUG
	MOVWF			FSR				;ES EL NUMERO QUE TIENE QUE TENER LA DECENA
	MOVF			INDF,W
	MOVWF			DECENAS				 ;CARGO DATO EN DECENAS
	MOVLW			0x2B				 ;VUELVO A INICIALIZAR FSR
	MOVWF			FSR
	DECFSZ			CONT_DECENAS, 1
	RETURN						  ; Si CONT_DECENAS ES 0  , TERMINAR
	GOTO			AUMENTAR_CENTENAS
AUMENTAR_CENTENAS:
	
    
	CLRF			CENTENAS				 ; LIMPIAR REGISTRO DECENA
	MOVLW			.10	
	MOVWF			CONT_DECENAS			;INICIALIZO BUCLE DE DECENAS
	MOVWF			CONT_UNIDAD			   ;INICIALIZO BUCLE DE UNIDAD
	CLRF			CUENTADEC	
	INCF			CUENTACEN,1			 ;AUMENTO CENTENA +1
	MOVLW			0x2B
	MOVWF			FSR
	MOVF			INDF,W
	MOVWF			UNIDAD
	MOVWF			DECENAS				  ;INICIALIZO DISPLAY DE DECENAS CON EL 0
	MOVF			FSR,W
	ADDWF			CUENTACEN,0			 ;LA DIRECCION DE FSR + CUENTACEN
	MOVWF			FSR				 ;ES EL NUMERO QUE TIENE QUE TENER LA CENTENA
	MOVF			INDF,W
	MOVWF			CENTENAS				   ;CARGO DATO EN CENTENAS
	DECFSZ			CONT_CENTENAS, 1
	RETURN							 ; Si CONT_CENTENAS  ES 0  , TERMINAR
	MOVLW  .10
	MOVWF			CONT_DECENAS			;INICIALIZO BUCLE DE DECENAS
	MOVWF			CONT_UNIDAD
	MOVWF			CONT_CENTENAS
	CLRF			CUENTACEN
	GOTO INCREMENTAR
	;################################################################################

	
	
INTERRUPCION:
   BCF		INTCON,INTF	;LIMPIO FLAG. ESTE ES DE INTERRUPCION DEL RB0 POR FLANCO DESCENDENTE
    ; ----------------------GUARDO CONTEXTO-------------------------
    MOVWF		DOBLEV
    SWAPF		STATUS,W
    MOVWF		ESTADO
    ;------------------------;ANTIREBOTE
  
    ;----LOGICA INTERRUPCION-----------

    CALL		ANTIREBOTE
    
    ;----------------CARGO CONTEXTO-----------
CONTEXTO:
    SWAPF		ESTADO,W
    MOVWF		STATUS
    SWAPF		DOBLEV,1
    SWAPF		DOBLEV,0
    
    ;---------------.VUELVO------------------
    RETFIE
ANTIREBOTE:
    CALL		DELAY_50MS
    BTFSC		PORTB,0      	    ;
    RETURN	
    
    CALL		INCREMENTAR
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
	
	
DELAY_50MS:   
    MOVLW       .250            ; Ajustar COUNT1 para lograr 1 segundo
    MOVWF       COUNT1          ; Carga COUNT1 con el valor inicial
D1:
    MOVLW       .250            ; Ajustar COUNT2, controla ciclos internos
    MOVWF       COUNT2          ; Carga COUNT2 con el valor inicial
D2:
    DECFSZ      COUNT2, F       ; Reducir COUNT2 hasta cero
    GOTO        D2
    DECFSZ      COUNT1, F       ; Reducir COUNT1 hasta cero
    GOTO        D1
    RETURN
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
	END