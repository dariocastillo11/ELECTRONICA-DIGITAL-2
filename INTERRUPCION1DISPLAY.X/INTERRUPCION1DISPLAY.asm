; ** Encabezado **
    LIST P=16F887			
    #include "p16f887.inc"		
    __CONFIG _CONFIG1, _FOSC_INTRC_NOCLKOUT & _WDTE_OFF & _MCLRE_ON & _LVP_OFF
    ;----------------------------VARIABLES------------------------------------------------
    CONTADOR1	EQU		 0x20
    CONTADOR2	EQU		 0x21
    NUM_C		EQU		 0x22
    ESTADO		EQU		 0X23
    DOBLEV		EQU		 0X24
    ORG		0x00
    GOTO		START
    ORG		0X04
    GOTO		INTERRUPCION
    ORG		0x05
    GOTO START
    
START:
    ;CONFIGURO PUERTOS
    BANKSEL	ANSEL
    CLRF		ANSEL		;0 PARA PINES DIGITAL
    CLRF		ANSELH
    BANKSEL	TRISA
 	;ENTRADA LLAVE PIN 7 DE PORTB
    BSF		TRISB,7
    CLRF		TRISA
    BANKSEL	PORTA
    CLRF		PORTA
    
    ;----------------------------
    MOVLW		 0X70		  ;DESDE 70h ESTAN REFLEJADAS EN LOS 4 BANCOS
    MOVWF		 FSR 
    
    MOVLW		.10		   
    MOVWF		NUM_C		   
;---------------------CONFIGURO INT-------------------------
    
    BCF		INTCON,RBIF
    
    BANKSEL	IOCB
    BSF		IOCB,7
    
    BSF		INTCON,3
     BSF		INTCON,7
    
    BANKSEL	PORTA
    
    
    
 
    ;----------------------------CARGO NUMEROS AL DESDE 70h A 79h CON EL IINDF----------------------------
   MOVLW		0x7E		;0
   MOVWF		INDF
   INCF		 FSR,1
    MOVLW		 0x30		 ; 1
    MOVWF		 INDF
    INCF		 FSR,1
    MOVLW		 0x6D		 ; 2
    MOVWF		 INDF
    INCF		 FSR,1
    MOVLW		 0x79		; 3
    MOVWF		 INDF
    INCF		 FSR,1
    MOVLW		 0x33		; 4
    MOVWF		 INDF
    INCF		 FSR,1
    MOVLW		 0x5B		; 5
    MOVWF		 INDF
    INCF		 FSR,1
    MOVLW		 0x5F		 ; 6
    MOVWF		 INDF
    INCF		 FSR,1
    MOVLW		 0x70		 ; 7
    MOVWF		 INDF
    INCF		 FSR,1
    MOVLW		 0x7F		 ; 8
    MOVWF		 INDF
    INCF		 FSR,1
    MOVLW		 0x73		 ; 9
    MOVWF		 INDF
    
    MOVLW		 0X70		 ; RESETEO EL FSR
    MOVWF		 FSR
    
    ;................ PONGO EL PORTB CON UN  NUMERO INICIAL
    MOVF		INDF,W
    MOVWF		PORTA		;PORTB TIENE EL NUMERO CERO
    
    
    ;.............................PROGRAMA PRINCIPAL ., VERIFICA SI HAY INTERRUPCION ---------------------------------------
    GOTO		$
    

INTERRUPCION:	

    BCF		INTCON,RBIF	;LIMPIO FLAF
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
    CALL		DELAY
    BTFSS		PORTB,7       	    ;
    RETURN	
    
    CALL		CARGAR
    RETURN
    
CARGAR:
    MOVF		INDF,W		    ;INDF CONTIENE EL NUMERO 0. PORQUE FSR APUNTA AL 70h
    MOVWF		PORTA		    ;CARGA DE NUMEROS
    INCF		 FSR,1
    
    DECFSZ		 NUM_C		    ;DISMUNUYO LA CUENTA DE NUEMEROS A CARGAR
    RETURN
    ;----------------------------SI LOS NUMEROS YA LLEGARON A 9:  ---------------------------
    MOVLW		0x70		    ;SETEO LA DIRECCION DE NUEVO EN 70h
    MOVWF		FSR
    MOVLW		 .10		    ;SETEO DE NUEVO EL CONTADOR 
    MOVWF		NUM_C
    RETURN		
DELAY:
    MOVLW		.250
    MOVWF		CONTADOR1
L1:
    MOVLW		 .250
    MOVWF		 CONTADOR2
L2:	
    DECFSZ		 CONTADOR2, F
    GOTO		  L2
    DECFSZ		 CONTADOR1, F
    GOTO		   L1
    RETURN
	
    
    
    
    END
 