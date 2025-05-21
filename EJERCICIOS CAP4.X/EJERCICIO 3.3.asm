    LIST P=16F887
    #INCLUDE <P16F887.INC>

    __CONGIG ;palabras de configuracion
    ORG 0x00  ; origen del programa
    GOTO 0x05 ;
    ;----------------------------------
    0x21 EQU SUM1
    0x22 EQU SUM2
    0x23 EQU RES1
    0x23 EQU RES2
 ;---------------------------------
 ;OTRA OPCION DE DEFINIR VARIABLES
    ;CBLOCK 0x20
    ;SUM1
    ;SUM2
    ;RES1
    ;RES2
    ;ENDC
  ;---------------------------------
    movf SUM1,W 
    ADDWF SUM2,0
    movwf RES1
    btfss status,0
    GOTO ACARREO
    GOTO END
 
ACARREO
 BSF RES2, 0
 BCF STATUS,0 
    incf  res2,1;si hay carrie
    ; si no hay carrie
    GOTO FIN
    
END