; ** Encabezado **
    LIST P=16F887
    #include "p16f887.inc"		
    __CONFIG _CONFIG1, _FOSC_INTRC_NOCLKOUT & _WDTE_OFF & _MCLRE_ON & _LVP_OFF
    ;----------------------------VARIABLES------------------------------------------------
CONTADOR1	EQU		 0x20		    ;delay	
CONTADOR2	EQU		 0x21		    ;delay
ESTADO		EQU		 0X23
DOBLEV		EQU		 0X24

    ORG		0x00
    GOTO		START
    ORG		0X04
    GOTO		INTERRUPCION
    ORG		0x05
    
    GOTO START
START:
    BANKSEL		ANSEL
    CLRF		ANSELH
    MOVLW		B'00000001'
    MOVWF		ANSEL
    BANKSEL		TRISA
    ;----------------------------LEDS DE PEATON
    CLRF		TRISC		;UNICO QUE NO TIENE ENTRADA ANALOGICA
    BSF		TRISA,0		;ENTRADA ANALOGICA ANS0


    BANKSEL		INTCON		;BANCO 1
    BSF		INTCON,GIE	;HABILITO EL GIE
    ;-------------CONFIG PARA TIMER-------------
    BCF		INTCON,T0IF	    ;BORRO FLAG DE TIMER
    BSF		INTCON,T0IE	    ;HABILITO INTERRUPCION TIMER
    
   BANKSEL		OPTION_REG
    BCF		OPTION_REG,T0CS	 ;SELECCIONO TIMER POR CONTADOR DE INSTRUCCIONES
    ;-----CONGIGURO PRESCALER----
    BSF		OPTION_REG,PS0
    BSF		OPTION_REG,PS1
    BSF		OPTION_REG,PS2
    BCF		OPTION_REG, PSA   ; asignar prescaler al TIMER0
    BSF		OPTION_REG, INTEDG 
    BCF		OPTION_REG,T0SE	    ;CONFIGURO  TRANSICIONES DE BAJO A ALTO
    
    BANKSEL		ADCON0
    ;CONFIGURO FRECUENCIA
    BCF		ADCON0,7		   
    BSF		ADCON0,6
    ;CONFIGURO CANAL USO EL CANALE 7 AHORA 0 1 1 1  = 7
    BCF		ADCON0,5		   
    BCF		ADCON0,4
    BCF		ADCON0,3
    BCF		ADCON0,2
    ;CONFIGURO ADON ENCENDER ADC..--- 
   BSF		ADCON0,0
    
    BANKSEL		ADCON1
    ;JUSTIFICO
    BCF		ADCON1,7
    ;VOLTAJE
    BCF		ADCON1,5
    BCF		ADCON0,4
    
    BANKSEL		PORTC
    CLRF		PORTD
LOOP:
    
    GOTO LOOP
    
    
INTERRUPCION:
      ; ----------------------GUARDO CONTEXTO-------------------------
    MOVWF		DOBLEV
    SWAPF		STATUS,W
    MOVWF		ESTADO
    ;------------------------;ANTIREBOTE
    ;----LOGICA INTERRUPCION-----------
    CALL		CARGO_ADC
    CALL		CARGO_LEDS
    ;----------------CARGO CONTEXTO-----------
CONTEXTO:
   BCF		INTCON,T0IF	    ;BORRO FLAG DE TIMER
   
    SWAPF		ESTADO,W
    MOVWF		STATUS
    SWAPF		DOBLEV,1
    SWAPF		DOBLEV,0
    ;---------------.VUELVO------------------
    RETFIE
CARGO_LEDS:
    ;CLRF    PORTA            ; Limpia `PORTB` antes de asignar valores

    MOVLW		.32              
    SUBWF		ADRESH, W
    BTFSS		STATUS, C       
    GOTO		LED1

    MOVLW		 .64              
    SUBWF		ADRESH, W
    BTFSS		STATUS, C
    GOTO		LED2

    MOVLW		.96              
    SUBWF		ADRESH, W
    BTFSS		STATUS, C
    GOTO		 LED3

    MOVLW		.128              
    SUBWF		ADRESH, W
    BTFSS		STATUS, C
    GOTO		LED4

    MOVLW		.160              
    SUBWF		ADRESH, W
    BTFSS		STATUS, C
    GOTO		LED5

    MOVLW		.192              
    SUBWF		ADRESH, W
    BTFSS		STATUS, C
    GOTO		 LED6

    MOVLW		 .224              
    SUBWF		ADRESH, W
    BTFSS		STATUS, C
    GOTO		LED7

    MOVLW		 .255              
    SUBWF		ADRESH, W
    BTFSS		STATUS, C
    GOTO		 LED8

    RETURN                   

LED1:
    MOVLW		 b'00000001'      
    MOVWF		PORTC
    RETURN

LED2:
    MOVLW		b'00000011'
    MOVWF		PORTC
    RETURN

LED3:
    MOVLW		b'00000111'
    MOVWF		PORTC
    RETURN

LED4:
    MOVLW		b'00001111'
    MOVWF		PORTC
    RETURN

LED5:
    MOVLW		b'00011111'
    MOVWF		PORTC
    RETURN

LED6:
    MOVLW		b'00111111'
    MOVWF		PORTC
    RETURN

LED7:
    MOVLW		b'01111111'
    MOVWF		PORTC
    RETURN

LED8:
    MOVLW		b'11111111'
    MOVWF		PORTC
    RETURN

CARGO_ADC:
    BANKSEL		ADCON0
    BSF		ADCON0,GO		;HABILITO EL ADC INICIALIZA
    ;ESPERO QUE CONVIERTA
ESPERO:
    BTFSC		ADCON0, GO     
    GOTO		ESPERO
    BANKSEL		ADRESH		;OBTENGO  PARTE ALTA DE ADC
    MOVF		ADRESH, W     
    BANKSEL		PORTA
    RETURN
    

DELAY_20MS:
    MOVLW		.250      ; Carga 250 en CONTADOR1
    MOVWF		CONTADOR1 
L1:
    MOVLW		.250      ; Carga 250 en CONTADOR2
    MOVWF		CONTADOR2
L2:
    DECFSZ		CONTADOR2, F
    GOTO		L2
    DECFSZ		CONTADOR1, F
    GOTO		L1
    RETURN

    END
 