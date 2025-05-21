    LIST P=16F887
    #INCLUDE <P16F887.INC>

    __CONGIG ;palabras de configuracion
    ORG 0x00  ; origen del programa
    GOTO 0x05 ;
    ;----------------------------------
    0x20 EQU A
    0x22 EQU B
    0x23 EQU RES
 ;---------------------------------
 ;OTRA OPCION DE DEFINIR VARIABLES
    ;CBLOCK 0x20
    ;SUM1
    ;SUM2
    ;RES1
    ;RES2
    ;ENDC
  ;---------------------------------
  MOVF B,W
  SUBWF A,W ;A-B
  BTFSC STATUS,Z
  BSF RES,0;SI Z=1 SON IGUALES. RES=0
 ;SI Z NO ES 1 . NO SON IGUALES
  BTFSC STATUS,C 
  MOVWF RES ;SI TENGO CARRIE ES PORQUE A>B.
 ;LA RESTA SE GUARDA EN RES
  BSF W;SI NO TENGO CARRIE ES PORQUE A<B
  MOVF B,W
  ADDWF A,RES
  
  END