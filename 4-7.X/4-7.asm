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
    CLRF		TRISD		 ; 0 PARA PORTA COMO  SALIDA
    BSF		TRISB,0		 ;1 PARA PORTB COMO  ENTRADA
    BANKSEL		PORTA
    
    ;----------------------------
    MOVLW		 0X70		  ;DESDE 70h ESTAN REFLEJADAS EN LOS 4 BANCOS
    MOVWF		 FSR 
    
    MOVLW		.10		   
    MOVWF		NUM_C		   

 
    ;----------------------------CARGO NUMEROS AL DESDE 70h A 79h CON EL IINDF----------------------------
   MOVLW		b'11111101'		;0
   MOVWF		INDF
   INCF		 FSR
    MOVLW		 b'01100001'		 ; 1
    MOVWF		 INDF
    INCF		 FSR
    MOVLW		 b'11011011'		 ; 2
    MOVWF		 INDF
    INCF		 FSR
    MOVLW		 b'11110011'		; 3
    MOVWF		 INDF
    INCF		 FSR
    MOVLW		 b'01100111'		; 4
    MOVWF		 INDF
    INCF		 FSR
    MOVLW		 b'10110111'		; 5
    MOVWF		 INDF
    INCF		 FSR
    MOVLW		 b'10111111'		 ; 6
    MOVWF		 INDF
    INCF		 FSR
    MOVLW		 b'11100001'		 ; 7
    MOVWF		 INDF
    INCF		 FSR
    MOVLW		 b'11111111'		 ; 8
    MOVWF		 INDF
    INCF		 FSR
    MOVLW		 b'11110111'		 ; 9
    MOVWF		 INDF
    
    MOVLW		 0X70		 ; LO VUELVO INICIALIZAR EN 70h
    MOVWF		 FSR
    CLRF    PORTD
    ;.............................RUTINA DE POLLING---------------------------------------
LOOP
     CALL DELAY
     CALL CARGAR_NUMS
     BTFSS  PORTB,0
     CALL PAUSA
    
     GOTO		LOOP
CARGAR_NUMS:
    MOVF		INDF,W		    ;INDF CONTIENE EL NUMERO 0. PORQUE FSR APUNTA AL 70h
    MOVWF		PORTD		    ;CARGA DE NUMEROS
    INCF		 FSR
    DECFSZ		 NUM_C		    ;DISMUNUYO LA CUENTA DE NUEMEROS A CARGAR
    RETURN
    CALL	RESET
    ;----------------------------SI LOS NUMEROS YA LLEGARON A 9:  ---------------------------
RESET:
    MOVLW		0x70		    ;SETEO LA DIRECCION DE NUEVO EN 70h
    MOVWF		FSR
    MOVLW		 .10		    ;SETEO DE NUEVO EL CONTADOR 
    MOVWF		NUM_C
    RETURN
PAUSA:
    CALL DELAY
    MOVF INDF,W
    MOVWF PORTD
    BTFSS		PORTB,0
    GOTO		$-4
   btfsc		PORTB,0
   GOTO $-1
    RETURN
  
DELAY:
    MOVLW		.200
    MOVWF		CONTADOR1
L1:
    MOVLW		 .200
    MOVWF		 CONTADOR2
L2:	
    DECFSZ		 CONTADOR2, F
    GOTO		  L2
    DECFSZ		 CONTADOR1, F
    GOTO		   L1
    RETURN
    
    
DEL:
    MOVLW		.50
    MOVWF		CONTADOR1
P1:
    MOVLW		 .50
    MOVWF		 CONTADOR2
P2:	
    DECFSZ		 CONTADOR2, F
    GOTO		  L2
    DECFSZ		 CONTADOR1, F
    GOTO		   L1
    RETURN
	
    END
