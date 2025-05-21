; ** Encabezado **
    LIST P=16F887			
    #include "p16f887.inc"		
    __CONFIG _CONFIG1, _FOSC_INTRC_NOCLKOUT & _WDTE_OFF & _MCLRE_ON & _LVP_OFF
    ;----------------------------VARIABLES------------------------------------------------
    CONTADOR1	EQU		 0x20
    CONTADOR2	EQU		 0x21
    NUM_C		EQU		 0x22
    ORG		0x00
    GOTO		START
    ORG		 0x05
START:
    ;---------------------------CONFIGURACION DE PINES --------------------------
    BANKSEL		ANSEL
    CLRF		ANSEL		;0 PARA PINES DIGITAL
    CLRF		 ANSELH
    BANKSEL		TRISA
    CLRF		TRISA		 ; 0 PARA PORTA COMO  SALIDA
    BSF		TRISD,0		 ;1 PARA PORTB COMO  ENTRADA
    BANKSEL		PORTA
    
    ;----------------------------
    MOVLW		 0X70		  ;DESDE 70h ESTAN REFLEJADAS EN LOS 4 BANCOS
    MOVWF		 FSR 
    
    MOVLW		.10		   
    MOVWF		NUM_C		   

 
    ;----------------------------CARGO NUMEROS AL DESDE 70h A 79h CON EL IINDF----------------------------
   MOVLW		0x7E		;0
   MOVWF		INDF
   INCF		 FSR
    MOVLW		 0x30		 ; 1
    MOVWF		 INDF
    INCF		 FSR
    MOVLW		 0x6D		 ; 2
    MOVWF		 INDF
    INCF		 FSR
    MOVLW		 0x79		; 3
    MOVWF		 INDF
    INCF		 FSR
    MOVLW		 0x33		; 4
    MOVWF		 INDF
    INCF		 FSR
    MOVLW		 0x5B		; 5
    MOVWF		 INDF
    INCF		 FSR
    MOVLW		 0x5F		 ; 6
    MOVWF		 INDF
    INCF		 FSR
    MOVLW		 0x70		 ; 7
    MOVWF		 INDF
    INCF		 FSR
    MOVLW		 0x7F		 ; 8
    MOVWF		 INDF
    INCF		 FSR
    MOVLW		 0x73		 ; 9
    MOVWF		 INDF
    
    MOVLW		 0X70		 ; LO VUELVO INICIALIZAR EN 70h
    MOVWF		 FSR
    ;.............................RUTINA DE POLLING---------------------------------------
LOOP
     BTFSC		PORTD,0		 ; SI PIN 0 DE PORTB ES 0 ==>CONTINUA A DEBOUNCE
     CALL		ANTIREBOTE
     GOTO		LOOP
;-------------------------------ANTIREBOTE---------------------------------
ANTIREBOTE:
    CALL		DELAY
    BTFSS		PORTD,0       	    ;
    RETURN
    CALL		CARGAR
    RETURN
CARGAR:
    BSF		PORTD,0
    MOVF		INDF,W		    ;INDF CONTIENE EL NUMERO 0. PORQUE FSR APUNTA AL 70h
    MOVWF		PORTA		    ;CARGA DE NUMEROS
    INCF		 FSR
    BTFSC		 PORTD,0		    ;POLING PREGUNTANDO SI SIGUE EN 0 LA LLAVE
    GOTO		 $-1
    DECFSZ		 NUM_C		    ;DISMUNUYO LA CUENTA DE NUEMEROS A CARGAR
    RETURN
    ;----------------------------SI LOS NUMEROS YA LLEGARON A 9:  ---------------------------
    MOVLW		0x70		    ;SETEO LA DIRECCION DE NUEVO EN 70h
    MOVWF		FSR
    MOVLW		 .10		    ;SETEO DE NUEVO EL CONTADOR 
    MOVWF		NUM_C
    RETURN
DELAY:
    MOVLW		.255
    MOVWF		CONTADOR1
L1:
    MOVLW		 .255
    MOVWF		 CONTADOR2
L2:	
    DECFSZ		 CONTADOR2, F
    GOTO		  L2
    DECFSZ		 CONTADOR1, F
    GOTO		   L1
    RETURN
	
    END
