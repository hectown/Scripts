


/*VOLUMENES*/



SELECT MNE_ACE_C_CONCEPTOS.MACROCONCEPTO,
MNE_ACE_C_DET_CONCEPTOS.DESCRIPCION||' ('|| MNE_ACE_MOVS_POS.DESC_INSTALACION ||') ('|| MNE_ACE_JUST_POS.FECHA_CONTABLE  ||') '|| '' AS OBSERVACION,
MNE_ACE_JUST_POS.VOLUMEN, MNE_ACE_JUST_POS.FECHA_CONTABLE
FROM MNE_ACE_C_CONCEPTOS INNER JOIN
MNE_ACE_C_DET_CONCEPTOS ON MNE_ACE_C_CONCEPTOS.ID_CONCEPTO=MNE_ACE_C_DET_CONCEPTOS.ID_CONCEPTO INNER JOIN
MNE_ACE_JUST_POS ON MNE_ACE_JUST_POS.ID_DET_CONCEPTO=MNE_ACE_C_DET_CONCEPTOS.ID_DET_CONCEPTO LEFT JOIN
MNE_ACE_MOVS_POS ON MNE_ACE_MOVS_POS.ID_JUST_POS=MNE_ACE_JUST_POS.ID_JUST_POS AND MNE_ACE_MOVS_POS.CVE_TIPO LIKE 'P'
WHERE 
    MNE_ACE_JUST_POS.FECHA_CONTABLE IN (SELECT
    TO_DATE(TO_CHAR(TO_DATE('03/DEC/2010','DD/MM/YYYY') + (1-TO_CHAR(TO_DATE('03/DEC/2010','DD/MM/YYYY'),'D')), 'DD/MM/YYYY'),'DD/MM/YYYY') + ROWNUM +5 INICIO_SEMANA
    FROM DUAL
    CONNECT By ROWNUM <= 7)
AND MNE_ACE_JUST_POS.PROYECTO IN ('CANTARELL','EK BALAM')
ORDER BY MNE_ACE_JUST_POS.FECHA_CONTABLE
 

/*PRODUCCION REAL */


SELECT PRON_PROD.PROD_REAL   AS PRODUCCION, PRON_PROD.PROYECTO, PRON_PROD.DIA
FROM RDP2.PRON_PROD

WHERE

PRON_PROD.DIA+1 =
(SELECT
  TO_DATE(TO_CHAR(TO_DATE('03/DEC/2010','DD/MM/YYYY') + (1-TO_CHAR(TO_DATE('03/DEC/2010','DD/MM/YYYY'),'D')), 'DD/MM/YYYY'),'DD/MM/YYYY') + ROWNUM +5 FIN_SEMANA
FROM DUAL
CONNECT By ROWNUM <= 1)

AND PRON_PROD.PROYECTO IN ('CANTARELL','EK BALAM') 




/*MANEJO DE FECHAS*/



   where a.fecha_contable+1 IN (SELECT
  TO_DATE(TO_CHAR(TO_DATE(:FECHA,'DD/MM/YYYY') + (1-TO_CHAR(TO_DATE(:FECHA,'DD/MM/YYYY'),'D')), 'DD/MM/YYYY'),'DD/MM/YYYY') + ROWNUM -1 INICIO_SEMANA
FROM DUAL
CONNECT By ROWNUM <= 7)

/*
09:02 a.m.Heredia Chulines Yolanda Del Carmeno mas bien si lo que deseas es el ultimo dia seria
*/

where a.fecha_contable+1 =
(SELECT
  TO_DATE(TO_CHAR(TO_DATE(:FECHA,'DD/MM/YYYY') + (1-TO_CHAR(TO_DATE(:FECHA,'DD/MM/YYYY'),'D')), 'DD/MM/YYYY'),'DD/MM/YYYY') + ROWNUM +5 FIN_SEMANA
FROM DUAL
CONNECT By ROWNUM <= 1)




SELECT A.INICIO_SEMANA, B.FIN_SEMANA FROM 

(SELECT
  TO_DATE(TO_CHAR(TO_DATE('08/02/2011','DD/MM/YYYY')+1 + (1-TO_CHAR(TO_DATE('08/02/2011','DD/MM/YYYY'),'D')), 'DD/MM/YYYY'),'DD/MM/YYYY') + ROWNUM -1 INICIO_SEMANA
FROM DUAL
CONNECT By ROWNUM <= 1) A,
(SELECT
  TO_DATE(TO_CHAR(TO_DATE('08/02/2011','DD/MM/YYYY')+1 + (1-TO_CHAR(TO_DATE('08/02/2011','DD/MM/YYYY'),'D')), 'DD/MM/YYYY'),'DD/MM/YYYY') + ROWNUM +5 FIN_SEMANA
FROM DUAL
CONNECT By ROWNUM <= 1)B


 
 

 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
     