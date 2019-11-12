SELECT * FROM PROGRAMAS_GAS_RMNE



SELECT T1.FECHA_REAL, T1.FECHA_CONTABLE, T2.DIA, SUM(T1.VALOR_NUMERICO),T2.POM
FROM GASRMN.GAS_PARAMETROS_VALORES T1 ,PROGRAMAS_GAS_RMNE T2
WHERE ID_PARAMETROS='1872' AND PLATAFORMA='371' AND PRODUCTO='ZONA DE TRANSICION'
AND FECHA_REAL BETWEEN (SELECT TRUNC(TO_DATE('18/FEB/2011','DD/MM/YYYY'),'YEAR')-365 FROM DUAL) AND
                            (SELECT TRUNC(TO_DATE('18/FEB/2011','DD/MM/YYYY'),'YEAR')+365 FROM DUAL) AND
              (SELECT TRUNC(TO_DATE(T1.FECHA_CONTABLE,'DD/MM/YYYY'),'MONTH') FROM DUAL) = (SELECT TRUNC(TO_DATE(T2.DIA,'DD/MM/YYYY'),'MONTH')FROM DUAL)
              AND             
 (SELECT TRUNC(TO_DATE('18/FEB/2011','DD/MM/YYYY'),'MONTH') FROM DUAL) =1

              
              
                GROUP BY T1.FECHA_REAL, T1.FECHA_CONTABLE, T2.DIA,T2.POM                    
                            





 /*GRAFICA DE DOA A�OS*/
  
SELECT FECHA_CONTABLE, T1.VALOR_NUMERICO, T2.POM AS METAINTERNA, T2.POT1, TO_CHAR(FECHA_CONTABLE, 'YYYY')

FROM 
GASRMN.GAS_PARAMETROS_VALORES T1, PROGRAMAS_GAS_RMNE T2   
WHERE 
 FECHA_REAL BETWEEN (SELECT TRUNC(TO_DATE('18/FEB/2011','DD/MM/YYYY'),'YEAR')-365 FROM DUAL) AND
                            (SELECT TRUNC(TO_DATE('18/FEB/2011','DD/MM/YYYY'),'YEAR')+365 FROM DUAL)
                             AND (T1.ID_PARAMETROS='1872' AND T1.PLATAFORMA='371' AND T2.PRODUCTO='ZONA DE TRANSICION') 
                             AND (SELECT TRUNC(TO_DATE(T1.FECHA_CONTABLE,'DD/MM/YYYY'),'MONTH') FROM DUAL) = (SELECT TRUNC(TO_DATE(T2.DIA,'DD/MM/YYYY'),'MONTH')FROM DUAL)
                       
 
 
 
 select max(fecha_contable) from  
 
 
SELECT TO_NUMBER( (SELECT TRUNC(TO_DATE('18/FEB/2011','DD/MM/YYYY'),'YEAR')-1 FROM DUAL) - (SELECT TRUNC(TO_DATE('12/DEC/2010','DD/MM/YYYY'),'YEAR')-365 FROM DUAL)) FROM DUAL
 
 
 
 
 SELECT TRUNC(TO_DATE('01/JAN/2009','DD/MM/YYYY')-1+ROWNUM) FECHA_CONTABLE,0 AS "REAL",0 AS "META INTERNA",0 AS "POT 1",TO_CHAR(TRUNC(TO_DATE('01/JAN/2009','DD/MM/YYYY')-1+ROWNUM),'YYYY') ANIO 
FROM DUAL 

CONNECT BY ROWNUM < (SELECT TO_NUMBER( (SELECT TO_DATE('31/DEC/2009','DD/MM/YYYY') FROM DUAL) - (
SELECT TRUNC(TO_DATE('12/DEC/2010','DD/MM/YYYY'),'YEAR')-365 FROM DUAL)) FROM DUAL)+2
 
 
 
 UNION
 
 
 
SELECT FECHA_CONTABLE AS FECHA, T1.VALOR_NUMERICO, T2.POM AS METAINTERNA, T2.POT1, TO_CHAR(FECHA_CONTABLE, 'YYYY') AS ANIO

FROM 
GASRMN.GAS_PARAMETROS_VALORES T1, PROGRAMAS_GAS_RMNE T2   
WHERE 
 FECHA_REAL BETWEEN (SELECT TRUNC(TO_DATE('18/FEB/2011','DD/MM/YYYY'),'YEAR')-365 FROM DUAL) AND
                            (SELECT TRUNC(TO_DATE('18/FEB/2011','DD/MM/YYYY'),'YEAR')+365 FROM DUAL)
                             AND (T1.ID_PARAMETROS='1872' AND T1.PLATAFORMA='371' AND T2.PRODUCTO='ZONA DE TRANSICION') 
                             AND (SELECT TRUNC(TO_DATE(T1.FECHA_CONTABLE,'DD/MM/YYYY'),'MONTH') FROM DUAL) = (SELECT TRUNC(TO_DATE(T2.DIA,'DD/MM/YYYY'),'MONTH')FROM DUAL)
                       
 UNION
 
 
  
SELECT TRUNC(SYSDATE-1+ROWNUM) DT,0,0,0,TO_CHAR(TRUNC(SYSDATE-1+ROWNUM),'YYYY') 
FROM DUAL 

CONNECT BY ROWNUM < (SELECT TO_NUMBER((TO_DATE(TRUNC(TO_DATE('18/FEB/2011','DD/MM/YYYY'),'YEAR')-1)+365) - SYSDATE) 
FROM DUAL)+2
 
ORDER BY ANIO








SELECT TRUNC(TO_DATE('18/FEB/2011','DD/MM/YYYY'),'YEAR')-1+365 FROM DUAL



SELECT T1.FECHA_CONTABLE, T1.VALOR_NUMERICO, T2.POM,TO_CHAR (T1.FECHA_CONTABLE,'MONTH')


FROM 
GASRMN.GAS_PARAMETROS_VALORES T1, PROGRAMAS_GAS_RMNE T2  ,DUAL
WHERE 
 FECHA_REAL BETWEEN (SELECT TRUNC(TO_DATE('18/FEB/2011','DD/MM/YYYY'),'YEAR')+1 FROM DUAL) AND
                            (SELECT TRUNC(TO_DATE('18/FEB/2011','DD/MM/YYYY'),'YEAR')+365 FROM DUAL)
                             AND (T1.ID_PARAMETROS='1872' AND T1.PLATAFORMA='371' AND T2.PRODUCTO='ZONA DE TRANSICION') 
                             AND (SELECT TRUNC(TO_DATE(T1.FECHA_CONTABLE,'DD/MM/YYYY'),'MONTH') FROM DUAL) = (SELECT TRUNC(TO_DATE(T2.DIA,'DD/MM/YYYY'),'MONTH')FROM DUAL)
                      

UNION

  
SELECT TRUNC(SYSDATE-1+ROWNUM) DT,0,0,TO_CHAR(TRUNC(SYSDATE-1+ROWNUM),'MONTH') 
FROM DUAL 

CONNECT BY ROWNUM < (SELECT TO_NUMBER((TO_DATE(TRUNC(TO_DATE('18/FEB/2011','DD/MM/YYYY'),'YEAR')-1)+365) - SYSDATE) 
FROM DUAL)+2
 
ORDER BY FECHA_CONTABLE






SELECT FECHA_CONTABLE, T1.VALOR_NUMERICO, T2.POM AS METAINTERNA, T2.POT1, TO_CHAR(FECHA_CONTABLE, 'YYYY')

FROM 
GASRMN.GAS_PARAMETROS_VALORES T1, PROGRAMAS_GAS_RMNE T2   
WHERE 
 FECHA_REAL BETWEEN (SELECT TRUNC(TO_DATE(:FECHA,'DD/MM/YYYY'),'YEAR')-365 FROM DUAL) AND
                            (SELECT TRUNC(TO_DATE(:FECHA,'DD/MM/YYYY'),'YEAR')+365 FROM DUAL)
                             AND (T1.ID_PARAMETROS='1872' AND T1.PLATAFORMA='371' AND T2.PRODUCTO='ZONA DE TRANSICION') 
                             AND (SELECT TRUNC(TO_DATE(T1.FECHA_CONTABLE,'DD/MM/YYYY'),'MONTH') FROM DUAL) = (SELECT TRUNC(TO_DATE(T2.DIA,'DD/MM/YYYY'),'MONTH')FROM DUAL)
                       
 UNION
 
 
  
SELECT TRUNC (SYSDATE+ROWNUM) DT,0,0,0,TO_CHAR(TRUNC(SYSDATE+ROWNUM),'YYYY') 
FROM DUAL 

CONNECT BY ROWNUM < (SELECT TO_NUMBER((TO_DATE(TRUNC(TO_DATE(:FECHA,'DD/MM/YYYY'),'YEAR')-1)+365) - (TO_DATE(:FECHA,'DD/MM/YYYY') ) 
)
FROM DUAL)+2
 
ORDER BY FECHA_CONTABLE






















SELECT TRUNC (TO_DATE('03/03/2011','DD/MM/YYYY')+ROWNUM) DT 
FROM DUAL 

CONNECT BY ROWNUM < (SELECT TO_NUMBER((TO_DATE(TRUNC(TO_DATE('18/FEB/2011','DD/MM/YYYY'),'YEAR')-1)+365) - (TO_DATE('04/03/2011','DD/MM/YYYY') ) 
)
FROM DUAL)+2




SELECT TO_CHAR (T1.FECHA_CONTABLE,'YYYY'),TO_CHAR (T1.FECHA_CONTABLE,'MON'),FECHA_CONTABLE, T1.VALOR_NUMERICO, T2.POM AS METAINTERNA, T2.POT1

FROM 
GASRMN.GAS_PARAMETROS_VALORES T1, PROGRAMAS_GAS_RMNE T2  
WHERE 
 FECHA_REAL BETWEEN (SELECT TRUNC(TO_DATE('18/FEB/2011','DD/MM/YYYY'),'YEAR')-365 FROM DUAL) AND
                            (SELECT TRUNC(TO_DATE('18/FEB/2011','DD/MM/YYYY'),'YEAR')+365 FROM DUAL)
                             AND (T1.ID_PARAMETROS='1872' AND T1.PLATAFORMA='371' AND T2.PRODUCTO='ZONA DE TRANSICION') 
                             AND (SELECT TRUNC(TO_DATE(T1.FECHA_CONTABLE,'DD/MM/YYYY'),'MONTH') FROM DUAL) = (SELECT TRUNC(TO_DATE(T2.DIA,'DD/MM/YYYY'),'MONTH')FROM DUAL)
AND (SELECT ROWNUM FROM DUAL CONNECT BY LEVEL <= (SELECT TO_NUMBER((TO_DATE(TRUNC(TO_DATE('18/FEB/2011','DD/MM/YYYY'),'YEAR')-1)+365) - (TO_DATE(TRUNC(TO_DATE('18/FEB/2011','DD/MM/YYYY'),'YEAR')-365))) from dual )+1
)







 
 
 
 
 
 
SELECT FECHA_CONTABLE, T2.POM AS METAINTERNA, T2.POT1, T1.VALOR_NUMERICO, TO_CHAR (T1.FECHA_CONTABLE,'YYYY'),TO_CHAR (T1.FECHA_CONTABLE,'MON')

FROM PROGRAMAS_GAS_RMNE T2 LEFT JOIN 
GASRMN.GAS_PARAMETROS_VALORES T1 ON( (SELECT TRUNC(TO_DATE(T1.FECHA_CONTABLE,'DD/MM/YYYY'),'MONTH') FROM DUAL) = (SELECT TRUNC(TO_DATE(T2.DIA,'DD/MM/YYYY'),'MONTH')FROM DUAL) )
WHERE (T1.ID_PARAMETROS='1872' AND T1.PLATAFORMA='371' AND T2.PRODUCTO='ZONA DE TRANSICION')




 
 
SELECT FECHA_CONTABLE + ROWNUM AS FECHA, T2.POM AS METAINTERNA, T2.POT1, T1.VALOR_NUMERICO, TO_CHAR (T1.FECHA_CONTABLE+ROWNUM,'YYYY'),TO_CHAR (T1.FECHA_CONTABLE+ROWNUM,'MON')

FROM PROGRAMAS_GAS_RMNE T2 LEFT JOIN 
GASRMN.GAS_PARAMETROS_VALORES T1 ON (SELECT TRUNC(TO_DATE(T1.FECHA_CONTABLE,'DD/MM/YYYY'),'MONTH') FROM DUAL) = (SELECT TRUNC(TO_DATE(T2.DIA,'DD/MM/YYYY'),'MONTH')FROM DUAL) 

 WHERE (T1.ID_PARAMETROS='1872' AND T1.PLATAFORMA='371' AND T2.PRODUCTO='ZONA DE TRANSICION') AND
ROWNUM<= 
(SELECT TO_NUMBER((SELECT TO_DATE(TRUNC(TO_DATE('18/FEB/2011','DD/MM/YYYY'),'YEAR')-1)+365 MES2 FROM DUAL) -
   (SELECT TO_DATE(TRUNC(TO_DATE('18/FEB/2011','DD/MM/YYYY'),'YEAR')-365)MES1 FROM DUAL)
  ) FROM DUAL)

order by fecha








/*PROMEDIO ANUAL A�O PASADO*/


SELECT ROUND(SUM(VALOR_NUMERICO)/COUNT(VALOR_NUMERICO)) AS PROMEDIO FROM GASRMN.GAS_PARAMETROS_VALORES
WHERE
ID_PARAMETROS='1872' AND PLATAFORMA='371' AND
   FECHA_REAL BETWEEN (SELECT TRUNC(TO_DATE('18/FEB/2011','DD/MM/YYYY'),'YEAR')-365 FROM DUAL) AND
                             (SELECT TRUNC(TO_DATE('18/FEB/2011','DD/MM/YYYY'),'YEAR')-1 FROM DUAL)
                             
          
   /*PROMEDIO DEL MES REAL*/
   
   
SELECT ROUND(SUM(VALOR_NUMERICO)/COUNT(VALOR_NUMERICO)), ROUND(SUM(POM)/COUNT(POM)), 1 AS PRIMERDIA, DIA
FROM GASRMN.GAS_PARAMETROS_VALORES T1, PROGRAMAS_GAS_RMNE T2
WHERE
FECHA_CONTABLE BETWEEN (SELECT TRUNC(TO_DATE('20/FEB/2011','DD/MM/YYYY'),'MONTH') FROM DUAL) AND
                            (SELECT TRUNC(LAST_DAY(TO_DATE('02/FEB/2011','DD/MM/YYYY'))) FROM DUAL)
                             AND (T1.ID_PARAMETROS='1872' AND T1.PLATAFORMA='371' AND T2.PRODUCTO='ZONA DE TRANSICION') 
                             AND (SELECT TRUNC(TO_DATE(T1.FECHA_CONTABLE,'DD/MM/YYYY'),'MONTH') FROM DUAL) = (SELECT TRUNC(TO_DATE(T2.DIA,'DD/MM/YYYY'),'MONTH')FROM DUAL)
                             
                   GROUP BY  DIA       
                             
      
      
  
 
      
      
      
      /*PROMEDIO DEL MES PRORGAMADO*/                       
                             
           SELECT POM,  FROM PROGRAMAS_GAS_RMNE, 
WHERE
PRODUCTO='ZONA DE TRANSICION' AND
   DIA BETWEEN (SELECT TRUNC(TO_DATE('18/FEB/2011','DD/MM/YYYY'),'MONTH') FROM DUAL) AND
                             (SELECT TRUNC(LAST_DAY(TO_DATE('18/FEB/2011','DD/MM/YYYY'))) FROM DUAL)
              


        


/*ROLLBACK*/

  
SELECT TO_CHAR (T1.FECHA_REAL,'MONTH'),T1.FECHA_REAL, DECODE(TO_CHAR (T1.FECHA_REAL,'DD'),2,1,0  ) AS BOTON, T1.VALOR_NUMERICO, T2.POM


FROM 
GASRMN.GAS_PARAMETROS_VALORES T1, PROGRAMAS_GAS_RMNE T2  ,DUAL
WHERE 
 FECHA_REAL BETWEEN (SELECT TRUNC(TO_DATE('18/FEB/2011','DD/MM/YYYY'),'YEAR')+1 FROM DUAL) AND
                            (SELECT TRUNC(TO_DATE('18/FEB/2011','DD/MM/YYYY'),'YEAR')+365 FROM DUAL)
                             AND (T1.ID_PARAMETROS='1872' AND T1.PLATAFORMA='371' AND T2.PRODUCTO='ZONA DE TRANSICION') 
                             AND (SELECT TRUNC(TO_DATE(T1.FECHA_CONTABLE,'DD/MM/YYYY'),'MONTH') FROM DUAL) = (SELECT TRUNC(TO_DATE(T2.DIA,'DD/MM/YYYY'),'MONTH')FROM DUAL)
                     
 
 
 ORDER BY T1.FECHA_REAL
 
 
 
 
 
 SELECT TO_CHAR (T1.FECHA_REAL,'MONTH'), T1.FECHA_REAL,DECODE( TO_DATE('02/02/2011','DD/MM/YYYY')(TO_CHAR (T1.FECHA_REAL),'DD'),2,1,0  ) AS BOTON, T1.VALOR_NUMERICO, T2.POM


FROM 
GASRMN.GAS_PARAMETROS_VALORES T1, PROGRAMAS_GAS_RMNE T2  ,DUAL
WHERE 
 FECHA_REAL BETWEEN (SELECT TRUNC(TO_DATE('18/01/2011','DD/MM/YYYY'),'YEAR')+1 FROM DUAL) AND
                            (SELECT TRUNC(TO_DATE('18/01/2011','DD/MM/YYYY'),'YEAR')+365 FROM DUAL)
                             AND (T1.ID_PARAMETROS='1872' AND T1.PLATAFORMA='371' AND T2.PRODUCTO='ZONA DE TRANSICION') 
                             AND (SELECT TRUNC(TO_DATE(T1.FECHA_CONTABLE,'DD/MM/YYYY'),'MONTH') FROM DUAL) = (SELECT TRUNC(TO_DATE(T2.DIA,'DD/MM/YYYY'),'MONTH')FROM DUAL)
ORDER BY T1.FECHA_REAL                      
 
 
 
 
 
                           
                             
    /*MESES A�O PASADO*/                         
 SELECT A.MES1, B.MES2 FROM 
 (SELECT TO_DATE(TRUNC(TO_DATE('18/FEB/2011','DD/MM/YYYY'),'YEAR')-365)MES1 FROM DUAL)A, 
 
 (SELECT TO_DATE(TRUNC(TO_DATE('18/FEB/2011','DD/MM/YYYY'),'YEAR')-1)+365MES2 FROM DUAL)B 

 
 
 
 
SELECT ( (TRUNC(TO_DATE('18/FEB/2011','DD/MM/YYYY'),'YEAR'))-365+(rownum-1) ) AS FECHA,TO_CHAR ((TRUNC(TO_DATE('18/FEB/2011','DD/MM/YYYY'),'YEAR'))-365+(rownum-1),'YYYY') AS A�O, T1.VALOR_NUMERICO, T2.POM AS METAINTERNA, T2.POT1

FROM 
GASRMN.GAS_PARAMETROS_VALORES T1 RIGHT JOIN
PROGRAMAS_GAS_RMNE T2  ON (SELECT TRUNC(TO_DATE(T1.FECHA_CONTABLE,'DD/MM/YYYY'),'MONTH') FROM DUAL) = (SELECT TRUNC(TO_DATE(T2.DIA,'DD/MM/YYYY'),'MONTH')FROM DUAL)
WHERE 
                       (T1.ID_PARAMETROS='1872' AND T1.PLATAFORMA='371' AND T2.PRODUCTO='ZONA DE TRANSICION') 
                        
                        
                        AND ROWNUM <= (SELECT TO_NUMBER((TO_DATE(TRUNC(TO_DATE('18/FEB/2011','DD/MM/YYYY'),'YEAR')-1)+365) - (TO_DATE(TRUNC(TO_DATE('18/FEB/2011','DD/MM/YYYY'),'YEAR')-365))) from dual )
 


SELECT ( (TRUNC(TO_DATE('18/FEB/2011','DD/MM/YYYY'),'YEAR'))-365)+rownum  AS FECHA
from dual
where
ROWNUM <= (SELECT TO_NUMBER((TO_DATE(TRUNC(TO_DATE('18/FEB/2011','DD/MM/YYYY'),'YEAR')-1)+365) - (TO_DATE(TRUNC(TO_DATE('18/FEB/2011','DD/MM/YYYY'),'YEAR')-365))) from dual )+1
 







SELECT TRUNC(TO_DATE('01/01/2010','DD/MM/YYYY'))+RN-1

FROM (SELECT ROWNUM RN FROM DUAL CONNECT BY LEVEL <= (SELECT TO_NUMBER((TO_DATE(TRUNC(TO_DATE('18/FEB/2011','DD/MM/YYYY'),'YEAR')-1)+365) - (TO_DATE(TRUNC(TO_DATE('18/FEB/2011','DD/MM/YYYY'),'YEAR')-365))) from dual )+1


)





SELECT TO_DATE('01/jan/2011','DD/MM/YYYY')+rownum-1 AS FECHA
FROM 
DUAL where

ROWNUM <= 
(SELECT TO_NUMBER((TO_DATE(TRUNC(TO_DATE('18/FEB/2011','DD/MM/YYYY'),'YEAR')-1)+365) - (TO_DATE(TRUNC(TO_DATE('18/FEB/2011','DD/MM/YYYY'),'YEAR')-365))) from dual )
 



SELECT 
* FROM DUAL
 


SELECT * FROM PRON_FPROG



SELECT TO_CHAR (FECHA_REAL,'MONTH'),FECHA_CONTABLE,FECHA_REAL, AVG(VALOR_NUMERICO) 
FROM GASRMN.GAS_PARAMETROS_VALORES WHERE ID_PARAMETROS='1872' AND PLATAFORMA='371' 
AND FECHA_REAL BETWEEN TO_DATE('01/03/2011','DD/MM/YYYY') AND TO_DATE('08/03/2011','DD/MM/YYYY')
GROUP BY FECHA_CONTABLE,FECHA_REAL