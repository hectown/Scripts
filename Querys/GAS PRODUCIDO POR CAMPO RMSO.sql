--TOTAL POR ACTIVO

SELECT round(TOTAL,2) as total
FROM
(
select d.fecha_contable AS FEC_PROD,'ABKATUN POOL CHUC' AS ACTIVO,SUM(d.valor_numerico) as TOTAL 

from 
(SELECT a.id_parametros, a.fecha_real, a.id_hora, a.plataforma, a.fecha_contable, a.valor_numerico
  FROM gas_parametros_valores a  
  where a.plataforma=275
  and a.id_parametros in (479,436,477,388,440,455,1398,1397,454,425,468,401,  414,409,415,373,418,417,773,801,411,407,412,374)
  AND a.fecha_real = TO_DATE(:FECHA, 'DD/MM/YYYY')+1
  and a.id_hora in (24,49,72)
  )d,
  (
    SELECT a.id_parametros, a.Id_campo, UPPER(b.CAMPO) as campo
      FROM
      (SELECT gcp.padre AS Id_campo, gcp.id_parametros
        FROM gas_c_parametros gcp
        WHERE gcp.id_parametros IN (479,436,477,388,440,455,1398,1397,454,425,468,401  )
       ) a,
       (SELECT gcp.descripcion AS CAMPO,gcp.id_parametros AS Id_campo FROM gas_c_parametros gcp
          WHERE gcp.id_parametros IN (414,409,415,373,418,417,773,801,411,407,412,374)
           ) b
          WHERE a.Id_campo = b.Id_campo
        )c                    
where c.id_parametros=d.id_parametros(+)
GROUP BY d.fecha_contable,'ABKATUN POOL CHUC' 

UNION ALL

SELECT DATE_STAMP AS  FEC_PROD,'LITORAL TABASCO' AS ACTIVO, SUM(round(A.GAS_ASOCIADO,2)) AS PROD_GAS        
FROM REP_HISTO_OIL_GAS_PROM2 A
WHERE  A.date_stamp = TO_DATE(:FECHA, 'DD/MM/YYYY')
AND a.campo not in 'Gran Total'
GROUP BY DATE_STAMP,'LITORAL TABASCO' 
)
WHERE ACTIVO IN (:ACTIVO)


















--PRODUCCION POR CAMPO


     SELECT FEC_PROD,ACTIVO,CAMPO,PROD_GAS FROM
(select d.fecha_contable AS FEC_PROD,'ABKATUN POOL CHUC' AS ACTIVO,c.campo AS CAMPO,d.valor_numerico as PROD_GAS from 
(SELECT a.id_parametros, a.fecha_real, a.id_hora, a.plataforma,
       a.fecha_contable, a.valor_numerico
  FROM gas_parametros_valores a  
  where a.plataforma=275
  and a.id_parametros in (479,436,477,388,440,455,1398,1397,454,425,468,401,    414,409,415,373,418,417,773,801,411,407,412,374)
   and a.fecha_real BETWEEN TO_DATE(:FECHA_INI, 'DD/MM/YYYY') AND TO_DATE(:FECHA_FIN, 'DD/MM/YYYY')
  and a.id_hora in (24,49,72))d,
  ((
    SELECT a.id_parametros, a.Id_campo, UPPER(b.CAMPO) as campo
      FROM
      (SELECT gcp.padre AS Id_campo, gcp.id_parametros
        FROM gas_c_parametros gcp
        WHERE gcp.id_parametros IN (479,436,477,388,440,455,1398,1397,454,425,468,401  )
       ) a,
       (SELECT gcp.descripcion AS CAMPO,gcp.id_parametros AS Id_campo FROM gas_c_parametros gcp
          WHERE gcp.id_parametros IN (414,409,415,373,418,417,773,801,411,407,412,374)
           ) b
          WHERE a.Id_campo = b.Id_campo
        ))c                    
where c.id_parametros=d.id_parametros(+)


UNION ALL

SELECT DATE_STAMP AS  FEC_PROD,'LITORAL TABASCO' AS ACTIVO, A.CAMPO AS CAMPO,round(A.GAS_ASOCIADO,1) AS PROD_GAS        
FROM REP_HISTO_OIL_GAS_PROM2 A
WHERE  A.date_stamp BETWEEN TO_DATE(:FECHA_INI, 'DD/MM/YYYY')-1 AND TO_DATE(:FECHA_FIN, 'DD/MM/YYYY')-1
AND a.campo not in 'Gran Total'
)
WHERE CAMPO IN ("+sCampo+@")


















--CAMPOS ABK
SELECT CAMPO,TEXTO 
FROM
(

select distinct '''' || c.campo || '''' AS campo, c.campo as texto,'ABKATUN POOL CHUC' AS ACTIVO 
from 
(SELECT a.id_parametros, a.fecha_real, a.id_hora, a.plataforma,
       a.fecha_contable, a.valor_numerico
  FROM gas_parametros_valores a  
  where a.plataforma=275
  and a.id_parametros in (479,436,477,388,440,455,1398,1397,454,425,468,401,    414,409,415,373,418,417,773,801,411,407,412,374)
  and to_char(a.fecha_real,'dd/mm/yyyy')='09/01/2012'
  and a.id_hora in (24,49,72))d,
  ((
    SELECT a.id_parametros, a.Id_campo, UPPER(b.CAMPO) as campo
      FROM
      (SELECT gcp.padre AS Id_campo, gcp.id_parametros
        FROM gas_c_parametros gcp
        WHERE gcp.id_parametros IN (479,436,477,388,440,455,1398,1397,454,425,468,401  )
       ) a,
       (SELECT gcp.descripcion AS CAMPO,gcp.id_parametros AS Id_campo FROM gas_c_parametros gcp
          WHERE gcp.id_parametros IN (414,409,415,373,418,417,773,801,411,407,412,374)
           ) b
          WHERE a.Id_campo = b.Id_campo
        ))c                    
where c.id_parametros=d.id_parametros(+)


UNION
--CAMPOS LITORAL

select distinct '''' || campo || '''' AS campo, campo as texto, 'LITORAL TABASCO' as activo
from REP_HISTO_OIL_GAS_PROM2
where date_stamp + 1 BETWEEN TO_DATE(:FECHA_INI, 'DD/MM/YYYY') AND TO_DATE(:FECHA_FIN, 'DD/MM/YYYY')
and campo not in 'Gran Total' 
order by 2)
where activo in (:ACTIVO)














--OBSERVACIONES



SELECT FECHA,VOL ||' '|| OBS AS OBS

FROM
(

SELECT '1',FECHA,'['||VOL||']' AS VOL,OBS,ACTIVO FROM

(SELECT TO_DATE(:FECHA,'DD/MM/YYYY') AS FECHA,
DECODE(MSO_ACE_VALOR_NUM(521,TO_CHAR(to_date(:FECHA, 'DD-MM-YYYY')+1, 'dd/MM/YYYY'),MA_ACEITE_ID_HORA(TO_CHAR(to_date(:FECHA, 'DD-MM-YYYY')+1, 'dd/MM/YYYY'), '05:00')  , 275,''),0,NULL,TO_CHAR(MSO_ACE_VALOR_NUM(521,TO_CHAR(to_date(:FECHA, 'DD-MM-YYYY')+1, 'dd/MM/YYYY'),MA_ACEITE_ID_HORA(TO_CHAR(to_date(:FECHA, 'DD-MM-YYYY')+1, 'dd/MM/YYYY'), '05:00') , 275,''),'999,999.99')||' MMCPD. ') AS VOL,MSO_ACE_VALOR_CAD(397,TO_CHAR(to_date(:FECHA, 'DD-MM-YYYY')+1, 'dd/MM/YYYY'),MA_ACEITE_ID_HORA(TO_CHAR(to_date(:FECHA, 'DD-MM-YYYY')+1, 'dd/MM/YYYY'), '05:00')  , 272,'') AS OBS
,'ABKATUN POOL CHUC' AS ACTIVO
FROM DUAL

UNION

SELECT TO_DATE(:FECHA,'DD/MM/YYYY') AS FECHA,
DECODE(MSO_ACE_VALOR_NUM(523,TO_CHAR(to_date(:FECHA, 'DD-MM-YYYY')+1, 'dd/MM/YYYY'),MA_ACEITE_ID_HORA(TO_CHAR(to_date(:FECHA, 'DD-MM-YYYY')+1, 'dd/MM/YYYY'), '05:00')  , 275,''),0,NULL,to_char(MSO_ACE_VALOR_NUM(523,TO_CHAR(to_date(:FECHA, 'DD-MM-YYYY')+1, 'dd/MM/YYYY'),MA_ACEITE_ID_HORA(TO_CHAR(to_date(:FECHA, 'DD-MM-YYYY')+1, 'dd/MM/YYYY'), '05:00')  , 275,''),'999,999.99')||' MMCPD. '),MSO_ACE_VALOR_CAD(400,TO_CHAR(to_date(:FECHA, 'DD-MM-YYYY')+1, 'dd/MM/YYYY'),MA_ACEITE_ID_HORA(TO_CHAR(to_date(:FECHA, 'DD-MM-YYYY')+1, 'dd/MM/YYYY'), '05:00')  , 272,'') AS OBS_CAAN
,'ABKATUN POOL CHUC' AS ACTIVO
FROM DUAL

UNION

SELECT TO_DATE(:FECHA,'DD/MM/YYYY') AS FECHA,
DECODE(MSO_ACE_VALOR_NUM(525,TO_CHAR(to_date(:FECHA, 'DD-MM-YYYY')+1, 'dd/MM/YYYY'),MA_ACEITE_ID_HORA(TO_CHAR(to_date(:FECHA, 'DD-MM-YYYY')+1, 'dd/MM/YYYY'), '05:00')  , 275,''),0,NULL,to_char(MSO_ACE_VALOR_NUM(525,TO_CHAR(to_date(:FECHA, 'DD-MM-YYYY')+1, 'dd/MM/YYYY'),MA_ACEITE_ID_HORA(TO_CHAR(to_date(:FECHA, 'DD-MM-YYYY')+1, 'dd/MM/YYYY'), '05:00')  , 275,''),'999,999.99')||' MMCPD. ') ,MSO_ACE_VALOR_CAD(402,TO_CHAR(to_date(:FECHA, 'DD-MM-YYYY')+1, 'dd/MM/YYYY'),MA_ACEITE_ID_HORA(TO_CHAR(to_date(:FECHA, 'DD-MM-YYYY')+1, 'dd/MM/YYYY'), '05:00') , 272,'') AS OBS_TARAT
,'ABKATUN POOL CHUC' AS ACTIVO
FROM DUAL

UNION

SELECT TO_DATE(:FECHA,'DD/MM/YYYY') AS FECHA,
DECODE(MSO_ACE_VALOR_NUM(527,TO_CHAR(to_date(:FECHA, 'DD-MM-YYYY')+1, 'dd/MM/YYYY'),MA_ACEITE_ID_HORA(TO_CHAR(to_date(:FECHA, 'DD-MM-YYYY')+1, 'dd/MM/YYYY'), '05:00')  , 275,''),0,NULL,to_char(MSO_ACE_VALOR_NUM(527,TO_CHAR(to_date(:FECHA, 'DD-MM-YYYY')+1, 'dd/MM/YYYY'),MA_ACEITE_ID_HORA(TO_CHAR(to_date(:FECHA, 'DD-MM-YYYY')+1, 'dd/MM/YYYY'), '05:00')  , 275,''),'999,999.99')|| ' MMCPD. ') ,MSO_ACE_VALOR_CAD(404,TO_CHAR(to_date(:FECHA, 'DD-MM-YYYY')+1, 'dd/MM/YYYY'),MA_ACEITE_ID_HORA(TO_CHAR(to_date(:FECHA, 'DD-MM-YYYY')+1, 'dd/MM/YYYY'), '05:00')  , 272,'') AS OBS_KANAAB
,'ABKATUN POOL CHUC' AS ACTIVO
FROM DUAL

UNION

SELECT TO_DATE(:FECHA,'DD/MM/YYYY') AS FECHA,
DECODE(MSO_ACE_VALOR_NUM(535,TO_CHAR(to_date(:FECHA, 'DD-MM-YYYY')+1, 'dd/MM/YYYY'),MA_ACEITE_ID_HORA(TO_CHAR(to_date(:FECHA, 'DD-MM-YYYY')+1, 'dd/MM/YYYY'), '05:00')  , 275,''),0,NULL,to_char(MSO_ACE_VALOR_NUM(535,TO_CHAR(to_date(:FECHA, 'DD-MM-YYYY')+1, 'dd/MM/YYYY'),MA_ACEITE_ID_HORA(TO_CHAR(to_date(:FECHA, 'DD-MM-YYYY')+1, 'dd/MM/YYYY'), '05:00')  , 275,''),'999,999.99')||' MMCPD. '),MSO_ACE_VALOR_CAD(406,TO_CHAR(to_date(:FECHA, 'DD-MM-YYYY')+1, 'dd/MM/YYYY'),MA_ACEITE_ID_HORA(TO_CHAR(to_date(:FECHA, 'DD-MM-YYYY')+1, 'dd/MM/YYYY'), '05:00')  , 272,'') AS OBS_IXTAL
,'ABKATUN POOL CHUC' AS ACTIVO
FROM DUAL

UNION

SELECT TO_DATE(:FECHA,'DD/MM/YYYY') AS FECHA,
DECODE(MSO_ACE_VALOR_NUM(537,TO_CHAR(to_date(:FECHA, 'DD-MM-YYYY')+1, 'dd/MM/YYYY'),MA_ACEITE_ID_HORA(TO_CHAR(to_date(:FECHA, 'DD-MM-YYYY')+1, 'dd/MM/YYYY'), '05:00')  , 275,''),0,NULL,to_char(MSO_ACE_VALOR_NUM(537,TO_CHAR(to_date(:FECHA, 'DD-MM-YYYY')+1, 'dd/MM/YYYY'),MA_ACEITE_ID_HORA(TO_CHAR(to_date(:FECHA, 'DD-MM-YYYY')+1, 'dd/MM/YYYY'), '05:00')  , 275,''),'999,999.99')||' MMCPD. '), MSO_ACE_VALOR_CAD(416,TO_CHAR(to_date(:FECHA, 'DD-MM-YYYY')+1, 'dd/MM/YYYY'),MA_ACEITE_ID_HORA(TO_CHAR(to_date(:FECHA, 'DD-MM-YYYY')+1, 'dd/MM/YYYY'), '05:00')  , 272,'') AS OBS_MANIK
,'ABKATUN POOL CHUC' AS ACTIVO
FROM DUAL

UNION

SELECT TO_DATE(:FECHA,'DD/MM/YYYY') AS FECHA,
DECODE(MSO_ACE_VALOR_NUM(529,TO_CHAR(to_date(:FECHA, 'DD-MM-YYYY')+1, 'dd/MM/YYYY'),MA_ACEITE_ID_HORA(TO_CHAR(to_date(:FECHA, 'DD-MM-YYYY')+1, 'dd/MM/YYYY'), '05:00')  , 275,''),0,NULL,to_char(MSO_ACE_VALOR_NUM(529,TO_CHAR(to_date(:FECHA, 'DD-MM-YYYY')+1, 'dd/MM/YYYY'),MA_ACEITE_ID_HORA(TO_CHAR(to_date(:FECHA, 'DD-MM-YYYY')+1, 'dd/MM/YYYY'), '05:00')  , 275,''),'999,999.99') ||'  MMCPD. ' ),MSO_ACE_VALOR_CAD(408,TO_CHAR(to_date(:FECHA, 'DD-MM-YYYY')+1, 'dd/MM/YYYY'),MA_ACEITE_ID_HORA(TO_CHAR(to_date(:FECHA, 'DD-MM-YYYY')+1, 'dd/MM/YYYY'), '05:00')  , 272,'') AS OBS_BATAB
,'ABKATUN POOL CHUC' AS ACTIVO
FROM DUAL

UNION

SELECT TO_DATE(:FECHA,'DD/MM/YYYY') AS FECHA,
decode(MSO_ACE_VALOR_NUM(531,TO_CHAR(to_date(:FECHA, 'DD-MM-YYYY')+1, 'dd/MM/YYYY'),MA_ACEITE_ID_HORA(TO_CHAR(to_date(:FECHA, 'DD-MM-YYYY')+1, 'dd/MM/YYYY'), '05:00')  , 275,''),0,null,to_char(MSO_ACE_VALOR_NUM(531,TO_CHAR(to_date(:FECHA, 'DD-MM-YYYY')+1, 'dd/MM/YYYY'),MA_ACEITE_ID_HORA(TO_CHAR(to_date(:FECHA, 'DD-MM-YYYY')+1, 'dd/MM/YYYY'), '05:00')  , 275,''),'999,999.99')|| ' MMCPD. ' ),MSO_ACE_VALOR_CAD(410,TO_CHAR(to_date(:FECHA, 'DD-MM-YYYY')+1, 'dd/MM/YYYY'),MA_ACEITE_ID_HORA(TO_CHAR(to_date(:FECHA, 'DD-MM-YYYY')+1, 'dd/MM/YYYY'), '05:00')  , 272,'') AS OBS_CHUC
,'ABKATUN POOL CHUC' AS ACTIVO
FROM DUAL

UNION

SELECT TO_DATE(:FECHA,'DD/MM/YYYY') AS FECHA,                                                                       
DECODE(MSO_ACE_VALOR_NUM(533,TO_CHAR(to_date(:FECHA, 'DD-MM-YYYY')+1, 'dd/MM/YYYY'),MA_ACEITE_ID_HORA(TO_CHAR(to_date(:FECHA, 'DD-MM-YYYY')+1, 'dd/MM/YYYY'), '05:00')  , 275,''),0,NULL,to_char(MSO_ACE_VALOR_NUM(533,TO_CHAR(to_date(:FECHA, 'DD-MM-YYYY')+1, 'dd/MM/YYYY'),MA_ACEITE_ID_HORA(TO_CHAR(to_date(:FECHA, 'DD-MM-YYYY')+1, 'dd/MM/YYYY'), '05:00')  , 275,''),'999,999.99') || ' MMCPD. ') ,MSO_ACE_VALOR_CAD(413,TO_CHAR(to_date(:FECHA, 'DD-MM-YYYY')+1, 'dd/MM/YYYY'),MA_ACEITE_ID_HORA(TO_CHAR(to_date(TO_DATE(:FECHA,'dd/MM/YYYY')+1, 'DD-MM-YYYY'), 'dd/MM/YYYY'), '05:00')  , 272,'') AS OBS_POL
,'ABKATUN POOL CHUC' AS ACTIVO
FROM DUAL

UNION

SELECT TO_DATE(:FECHA,'DD/MM/YYYY') AS FECHA,
DECODE(MSO_ACE_VALOR_NUM(539,TO_CHAR(to_date(:FECHA, 'DD-MM-YYYY')+1, 'dd/MM/YYYY'),MA_ACEITE_ID_HORA(TO_CHAR(to_date(:FECHA, 'DD-MM-YYYY')+1, 'dd/MM/YYYY'), '05:00')  , 275,''),0,NULL,to_char(MSO_ACE_VALOR_NUM(539,TO_CHAR(to_date(:FECHA, 'DD-MM-YYYY')+1, 'dd/MM/YYYY'),MA_ACEITE_ID_HORA(TO_CHAR(to_date(:FECHA, 'DD-MM-YYYY')+1, 'dd/MM/YYYY'), '05:00')  , 275,''),'999,999.99') || ' MMCPD. ') ,MSO_ACE_VALOR_CAD(419,TO_CHAR(to_date(:FECHA, 'DD-MM-YYYY')+1, 'dd/MM/YYYY'),MA_ACEITE_ID_HORA(TO_CHAR(to_date(:FECHA, 'DD-MM-YYYY')+1, 'dd/MM/YYYY'), '05:00')  , 272,'') AS OBS_HOMOL
,'ABKATUN POOL CHUC' AS ACTIVO
FROM DUAL

UNION

SELECT TO_DATE(:FECHA,'DD/MM/YYYY') AS FECHA,
DECODE(MSO_ACE_VALOR_NUM(1401,TO_CHAR(to_date(:FECHA, 'DD-MM-YYYY')+1, 'dd/MM/YYYY'),MA_ACEITE_ID_HORA(TO_CHAR(to_date(:FECHA, 'DD-MM-YYYY')+1, 'dd/MM/YYYY'), '05:00')  , 275,''),0,NULL,to_char(MSO_ACE_VALOR_NUM(1401,TO_CHAR(to_date(:FECHA, 'DD-MM-YYYY')+1, 'dd/MM/YYYY'),MA_ACEITE_ID_HORA(TO_CHAR(to_date(:FECHA, 'DD-MM-YYYY')+1, 'dd/MM/YYYY'), '05:00')  , 275,''),'999,999.99') || ' MMCPD. ') , MSO_ACE_VALOR_CAD(1403,TO_CHAR(to_date(:FECHA, 'DD-MM-YYYY')+1, 'dd/MM/YYYY'),MA_ACEITE_ID_HORA(TO_CHAR(to_date(:FECHA, 'DD-MM-YYYY')+1, 'dd/MM/YYYY'), '05:00')  , 272,'') AS OBS_CHE
,'ABKATUN POOL CHUC' AS ACTIVO
FROM DUAL

UNION

SELECT TO_DATE(:FECHA,'DD/MM/YYYY') AS FECHA, 
DECODE(MSO_ACE_VALOR_NUM(1402,TO_CHAR(to_date(:FECHA, 'DD-MM-YYYY')+1, 'dd/MM/YYYY'),MA_ACEITE_ID_HORA(TO_CHAR(to_date(:FECHA, 'DD-MM-YYYY')+1, 'dd/MM/YYYY'), '05:00')  , 275,''),0,NULL,to_char(MSO_ACE_VALOR_NUM(1402,TO_CHAR(to_date(:FECHA, 'DD-MM-YYYY')+1, 'dd/MM/YYYY'),MA_ACEITE_ID_HORA(TO_CHAR(to_date(:FECHA, 'DD-MM-YYYY')+1, 'dd/MM/YYYY'), '05:00')  , 275,''),'999,999.99') || ' MMCPD. ') , MSO_ACE_VALOR_CAD(1406,TO_CHAR(to_date(:FECHA, 'DD-MM-YYYY')+1, 'dd/MM/YYYY'),MA_ACEITE_ID_HORA(TO_CHAR(to_date(:FECHA, 'DD-MM-YYYY')+1, 'dd/MM/YYYY'), '05:00')  , 272,'') AS OBS_TUMUT
,'ABKATUN POOL CHUC' AS ACTIVO
FROM DUAL)
WHERE VOL IS NOT NULL


UNION
--litoral tabasco

SELECT ORDEN,FECHA,VOL, OBS,ACTIVO FROM
(
(SELECT '1' AS ORDEN,MAX(DATE_STAMP)FECHA,DECODE(ROUND(SUM(GASDIFFERENCE),2),NULL,NULL,'['||to_char(ROUND(SUM(GASDIFFERENCE),2),'999,999.99') ||' MMCPD.]') AS VOL, 'Variación de la producción por diferencias de medición de complejos' AS OBS, 'LITORAL TABASCO' AS ACTIVO  
FROM REP_DIST_TEMP_VAR_PROMSO   
WHERE DATE_STAMP = TO_DATE(:FECHA,'DD/MM/YYYY'))

UNION 

(SELECT '1' AS ORDEN,MAX(DATE_STAMP)FECHA,DECODE(ROUND(SUM(GASWATERDIFF),2),NULL,NULL,'['|| to_char(ROUND(SUM(GASWATERDIFF),2),'999,999.99') ||' MMCPD.]'), 'Variación de la producción por porcentaje de agua', 'LITORAL TABASCO' AS ACTIVO
FROM REP_DIST_TEMP_VAR_PROMSO   
WHERE DATE_STAMP = TO_DATE(:FECHA,'DD/MM/YYYY'))

UNION

(SELECT '1' AS ORDEN,MAX(DATE_STAMP)FECHA, DECODE(ROUND(SUM(GASPRESSDIFF),2),NULL,NULL,'['|| to_char(ROUND(SUM(GASPRESSDIFF),2),'999,999.99') ||' MMCPD.]'), 'Variación de la producción por presión en la cabeza', 'LITORAL TABASCO' AS ACTIVO
FROM REP_DIST_TEMP_VAR_PROMSO   
WHERE DATE_STAMP = TO_DATE(:FECHA,'DD/MM/YYYY'))

UNION

(SELECT '1' AS ORDEN,MAX(DATE_STAMP)FECHA, DECODE(ROUND(SUM(GASPOTENTIAL),2),NULL,NULL,'['|| to_char(ROUND(SUM(GASPOTENTIAL),2),'999,999.99')||' MMCPD.]'), 'Variación por producción 24 horas', 'LITORAL TABASCO' AS ACTIVO
FROM REP_DIST_TEMP_VAR_PROMSO   
WHERE DATE_STAMP = TO_DATE(:FECHA,'DD/MM/YYYY'))
)
WHERE VOL IS NOT NULL

UNION

SELECT '2' AS ORDEN,FECHA DATE_STAMP,DECODE(ROUND(GAS_MMSCF,1),null,null,'['|| ROUND(GAS_MMSCF,1) ||' MMCPD.]') as volumen,POZO||'     '|| CONCEPTO  as OBS, 'LITORAL TABASCO' AS ACTIVO
FROM planeacion_mov_PROMSO 
WHERE FECHA = TO_DATE(:FECHA,'DD/MM/YYYY')
ORDER BY 1

)
WHERE ACTIVO IN(:ACTIVO)








