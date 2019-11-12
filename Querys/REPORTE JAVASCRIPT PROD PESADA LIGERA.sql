
SELECT fec.fecha, a.prod_can, a.prod_kmz
FROM (SELECT ROWNUM + TO_DATE(:FECHA_INI, 'DD/MM/YYYY') - 1 AS fecha
FROM DUAL
CONNECT BY ROWNUM <= TO_DATE(:FECHA_FIN, 'DD/MM/YYYY') - TO_DATE(:FECHA_INI, 'DD/MM/YYYY') + 1) fec,                
(SELECT fec_prod AS fecha,
SUM(CASE  WHEN proyecto IN ('CANTARELL','EK BALAM') THEN prod_ace ELSE 0 END) AS prod_can,
SUM(CASE proyecto WHEN 'KU MALOOB ZAAP' THEN prod_ace ELSE 0 END) AS prod_kmz
FROM hist_prod
WHERE fec_prod BETWEEN TO_DATE(:FECHA_INI, 'DD/MM/YYYY')AND TO_DATE(:FECHA_FIN, 'DD/MM/YYYY')AND tipo_prod in ('PESADO','LIGERO')
GROUP BY fec_prod) a
WHERE fec.fecha = a.fecha(+)




SELECT fec.fecha, a.prod_rmne
FROM (SELECT ROWNUM + TO_DATE(:FECHA_INI, 'DD/MM/YYYY') - 1 AS fecha
FROM DUAL
CONNECT BY ROWNUM <= TO_DATE(:FECHA_FIN, 'DD/MM/YYYY') - TO_DATE(:FECHA_INI, 'DD/MM/YYYY') + 1) fec,

(SELECT fec_prod AS fecha,
SUM(prod_ace) AS prod_rmne
FROM hist_prod
WHERE fec_prod BETWEEN TO_DATE(:FECHA_INI, 'DD/MM/YYYY')AND TO_DATE(:FECHA_FIN, 'DD/MM/YYYY')AND tipo_prod in ('PESADO','LIGERO')
GROUP BY fec_prod)a
WHERE fec.fecha = a.fecha(+)















SELECT fec.fecha, a.prod_can, a.prod_kmz, b.pom
FROM (SELECT ROWNUM + TO_DATE(:FECHA_INI, 'DD/MM/YYYY') - 1 AS fecha
FROM DUAL
CONNECT BY ROWNUM <= TO_DATE(:FECHA_FIN, 'DD/MM/YYYY') - TO_DATE(:FECHA_INI, 'DD/MM/YYYY') + 1) fec,
(SELECT fec_prod AS fecha,SUM(CASE  WHEN proyecto IN ('CANTARELL','EK BALAM') THEN prod_ace ELSE 0 END) AS prod_can,
SUM(CASE proyecto WHEN 'KU MALOOB ZAAP' THEN prod_ace ELSE 0 END) AS prod_kmz
FROM hist_prod WHERE fec_prod BETWEEN TO_DATE(:FECHA_INI, 'DD/MM/YYYY')
AND TO_DATE(:FECHA_FIN, 'DD/MM/YYYY') AND tipo_prod = 'PESADO'
 GROUP BY fec_prod) a,
 
 (SELECT dia, SUM(NVL(prod_pron, 0)) AS pom FROM pron_prod
WHERE dia BETWEEN TO_DATE(:FECHA_INI, 'DD/MM/YYYY') - 6
AND TO_DATE(:FECHA_FIN, 'DD/MM/YYYY')
AND tipo_prod = 'PESADO'
GROUP BY dia) b
WHERE fec.fecha = a.fecha(+)
AND fec.fecha = b.dia(+)
ORDER BY 1