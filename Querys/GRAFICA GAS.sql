


/*CONSULTA BUENA GRAFICA VALRES REALES*/
SELECT FECHA_REAL, VALOR_NUMERICO FROM GAS_PARAMETROS_VALORES 
WHERE 
    ID_PARAMETROS='1872' AND PLATAFORMA='371' AND
    FECHA_CONTABLE BETWEEN (SELECT TO_DATE(TRUNC(TO_DATE('18/FEB/2011','DD/MM/YYYY'),'YEAR')-365)FROM DUAL) AND
                            (SELECT TO_DATE('18/FEB/2011','DD/MM/YYYY') FROM DUAL)




SELECT POM,POT1, DIA FROM RDP2.PROGRAMAS_GAS_RMNE WHERE PRODUCTO='ZONA DE TRANSICION'
AND DIA BETWEEN (SELECT TO_DATE(TRUNC(TO_DATE('18/FEB/2011','DD/MM/YYYY'),'YEAR')-365)FROM DUAL) AND
                            (SELECT TO_DATE(TRUNC(TO_DATE('18/FEB/2011','DD/MM/YYYY'),'YEAR')+365)FROM DUAL)

 




/*MANEJO DE FECHAS*/

SELECT TO_DATE(TRUNC(TO_DATE('18/FEB/2011','DD/MM/YYYY'),'YEAR')-365)FROM DUAL


FECHA_CONTABLE BETWEEN (SELECT TO_DATE(TRUNC(TO_DATE('18/FEB/2011','DD/MM/YYYY'),'YEAR')-365)FROM DUAL) AND
(SELECT TO_DATE('18/FEB/2011','DD/MM/YYYY') FROM DUAL) 










