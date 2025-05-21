; ** Encabezado **
    LIST P=16F887
    #include "p16f887.inc"

;** Configuración General **
    __CONFIG _CONFIG1, _FOSC_INTRC_NOCLKOUT & _WDTE_OFF & _MCLRE_ON & _LVP_OFF

;** Definicion de Variables **
    CBLOCK 0x70
    COUNTER1
    COUNTER2
    ENDC

;** Inicio del Micro **
    ORG     0x00
    GOTO    START
    ;ORG    0x04
    ;GOTO   ISR
    ORG     0x05

START:
    BANKSEL ANSEL
    CLRF    ANSEL
    CLRF    ANSELH

    BANKSEL TRISA
    CLRF    PORTB           ; RB[3:0] out
    CLRF    PORTA
    BSF     PORTA, RA4      ; RA[4] in

    BANKSEL PORTA
    CLRF    PORTB           ; LEDs off

LOOP:
    BTFSS   PORTA, RA4      ; Is button pressed? (RA4 = 0?)
    GOTO    DEBOUNCE        ;   => Checks for noise
    GOTO    LOOP            ; Ask again

DEBOUNCE:
    CALL    DELAY_20MS      ; wait for bounce stabilization
    BTFSC   PORTA, RA4      ; Button still pressed?
    GOTO    LOOP            ; NO, go back to loop
    INCF    PORTB           ; YES, increment counter
    BTFSS   PORTA, RA4      ; Button still pressed?
    GOTO    $-1             ; YES, wait for release
    GOTO    LOOP

DELAY_20MS:
    ; 2+2+(2+3*26+2*1+3)*234+(2+3*26+2+2)*1+2 = 19,98 [ms]
    MOVLW .235
    MOVWF COUNTER1
L1:
    MOVLW .27
    MOVWF COUNTER2
L2:
    DECFSZ COUNTER2, F
    GOTO L2
    DECFSZ COUNTER1, F
    GOTO L1
    RETURN

    END