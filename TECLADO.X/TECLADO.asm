;################################################################
;# PROYECTO: Teclado Matricial y Displays Multiplexados
;# AUTOR: CASTILLO, DARÍO ALBERTO
;# PROCESADOR: PIC16F887
;################################################################
 LIST P=16F887
#INCLUDE "p16F887.inc"
 __CONFIG _CONFIG1, _FOSC_INTRC_NOCLKOUT & _WDTE_OFF & _MCLRE_ON & _LVP_OFF
; ------------------------------------------ VARIABLES --------------------------------------------
COLS            EQU 0x20     ; REGISTRO PARA LAS COLUMNAS DEL TECLADO
DISPLAY1        EQU 0x21     ; REGISTRO DEL DISPLAY IZQUIERDO (DECENAS)
DISPLAY2        EQU 0x22     ; REGISTRO DEL DISPLAY CENTRAL
DISPLAY3        EQU 0x23     ; REGISTRO DEL DISPLAY DERECHO (UNIDADES)
TECLA           EQU 0x24     ; REGISTRO PARA LA TECLA DETECTADA
TEMP            EQU 0x25     ; TEMPORAL PARA OPERACIONES
COUNT1          EQU 0x26     ; RETARDO DEL MULTIPLEXADO
COUNT2          EQU 0x27     ; RETARDO DEL MULTIPLEXADO



    ; --------------------------------------- INICIO DEL PROGRAMA -------------------------------------
    ORG 0x00
    GOTO START

; ------------------------------------ CONFIGURACIÓN DE PUERTOS -----------------------------------
START:
    BANKSEL ANSEL
    CLRF	ANSEL
    CLRF	ANSELH
    BANKSEL TRISA
    MOVLW 0x0F              ; Configurar RA0-RA3 como entradas (FILAS DEL TECLADO)
    MOVWF TRISA
    MOVLW b'00000000'
    MOVWF TRISB             ; Puerto B como salida (DISPLAYS)
    MOVLW b'11111000'
    MOVWF TRISC             ; RC0, RC1, RC2 como salidas (CONTROL DE DISPLAYS)
    BANKSEL PORTA
    CLRF PORTA              ; Limpia los puertos
    CLRF PORTB
    CLRF PORTC

    ; Inicialización de variables
    CLRF DISPLAY1
    CLRF DISPLAY2
    CLRF DISPLAY3
    
    GOTO MAIN


; ----------------------------------- FUNCIÓN PRINCIPAL -------------------------------------------
MAIN:
    CALL LEER_TECLADO       ; Leer el teclado
      CALL MULTIPLEXAR 
    BTFSC TECLA, 7          ; ¿Se detectó una tecla?
    GOTO ACTUALIZAR         ; Si se detectó, actualizar displays

    CALL MULTIPLEXAR ; Multiplexar displays
  
    GOTO MAIN

; -------------------------------- LÓGICA DE ACTUALIZACIÓN ----------------------------------------
ACTUALIZAR:
    MOVF DISPLAY2, W        ; Mueve el display central a la izquierda
    MOVWF DISPLAY1
    MOVF DISPLAY3, W        ; Mueve el display derecho al central
    MOVWF DISPLAY2
 MOVF TECLA, W
 CALL TABLA_BCD
 MOVWF DISPLAY3

    GOTO MAIN

; ----------------------------------- LECTURA DEL TECLADO -----------------------------------------
LEER_TECLADO:
    CLRF TECLA              ; Reiniciar registro de tecla
    MOVLW 0x01
    MOVWF COLS              ; Iniciar en la columna 1

LEER_FILAS:
    MOVWF PORTA             ; Enviar columna activa a RA0-RA3
    NOP                     ; Pequeño retardo
    MOVF PORTA, W           ; Leer las filas
    ANDLW 0x0F              ; Filtrar bits de filas
    BTFSC STATUS, Z         ; ¿Alguna fila activa?
    GOTO SIGUIENTE_COLUMNA

    ; Detectar cuál tecla fue presionada
    MOVF COLS, W            ; Combinar columna activa con fila activa
    MOVWF TEMP
    CALL DECODIFICAR_TECLA  ; Decodificar la tecla
    RETURN

SIGUIENTE_COLUMNA:
    RLF COLS, F             ; Cambiar a la siguiente columna
    MOVLW 0x08
    XORWF COLS, W           ; ¿Se terminó el recorrido?
    BTFSS STATUS, Z
    GOTO LEER_FILAS
    RETURN                  ; No se detectó ninguna tecla

DECODIFICAR_TECLA:
    ; Mapear combinaciones de fila/columna a un número
    MOVF TEMP, W
    ; Aquí deberías mapear las combinaciones específicas de tu teclado
    ; Por ejemplo:
    ; Columna 1 + Fila 1 -> '1', Columna 2 + Fila 1 -> '2', etc.
    ; Por simplicidad, asumiremos que ya es un número directo
    ANDLW 0x0F              ; Simulación directa del valor de tecla
    RETURN

; ---------------------------------- MULTIPLEXADO DE DISPLAYS -------------------------------------
MULTIPLEXAR:
    ; Mostrar DISPLAY1
    CLRF PORTB             ; Limpiar PORTB antes de actualizar
    MOVLW b'00000100'
    MOVWF PORTC
    MOVF DISPLAY1, W       ; Cargar valor de DISPLAY1
    MOVWF PORTB            ; Enviar a los segmentos
    CALL DELAY_5MS         ; Retardo para estabilizar
    CALL DELAY_5MS 
    CALL DELAY_5MS 
    CALL DELAY_5MS 
      CALL DELAY_5MS 
    CALL DELAY_5MS 
    CALL DELAY_5MS 
      CALL DELAY_5MS 
    CALL DELAY_5MS 
    CALL DELAY_5MS 

    ; Mostrar DISPLAY2
    CLRF PORTB             ; Limpiar PORTB antes de actualizar
    MOVLW b'00000010'
    MOVWF PORTC
    MOVF DISPLAY2, W       ; Cargar valor de DISPLAY2
    MOVWF PORTB            ; Enviar a los segmentos
    CALL DELAY_5MS         ; Retardo para estabilizar
    CALL DELAY_5MS 
    CALL DELAY_5MS 
    CALL DELAY_5MS 
      CALL DELAY_5MS 
    CALL DELAY_5MS 
    CALL DELAY_5MS 
      CALL DELAY_5MS 
    CALL DELAY_5MS 
    CALL DELAY_5MS 

    ; Mostrar DISPLAY3
    CLRF PORTB             ; Limpiar PORTB antes de actualizar
     MOVLW b'00000001'
    MOVWF PORTC
    MOVF DISPLAY3, W       ; Cargar valor de DISPLAY3
    MOVWF PORTB            ; Enviar a los segmentos
    CALL DELAY_5MS         ; Retardo para estabilizar
    CALL DELAY_5MS 
    CALL DELAY_5MS 
    CALL DELAY_5MS 
      CALL DELAY_5MS 
    CALL DELAY_5MS 
    CALL DELAY_5MS 
      CALL DELAY_5MS 
    CALL DELAY_5MS 
    CALL DELAY_5MS 

    RETURN

; ---------------------------------------- DELAY 5 MS --------------------------------------------
DELAY_5MS:
    MOVLW 0x12
    MOVWF COUNT1
D1:
    MOVLW 0x10
    MOVWF COUNT2
D2:
    DECFSZ COUNT2, F
    GOTO D2
    DECFSZ COUNT1, F
    GOTO D1
    RETURN
    
    ; ------------------------------------------ TABLA BCD -------------------------------------------
TABLA_BCD:
    ADDWF PCL, w           ; Salto según el valor en W
    RETLW 0x3F             ; '0'
    RETLW 0x06             ; '1'
    RETLW 0x5B             ; '2'
    RETLW 0x4F             ; '3'
    RETLW 0x66             ; '4'
    RETLW 0x6D             ; '5'
    RETLW 0x7D             ; '6'
    RETLW 0x07             ; '7'
    RETLW 0x7F             ; '8'
    RETLW 0x6F             ; '9'
    RETLW 0x77             ; 'A'
    RETLW 0x7C             ; 'B'
    RETLW 0x39             ; 'C'
    RETLW 0x5E             ; 'D'
    RETLW 0x79             ; 'E'
    RETLW 0x71             ; 'F'
    
    END