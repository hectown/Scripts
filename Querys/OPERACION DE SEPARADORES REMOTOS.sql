

SELECT ACTIVO, SECTOR, ID,DESC_LARGA  FROM GAS_PLATAFORMAS WHERE TIPO_INST='SEPARADOR' AND ID='202'




/*SEPARADORES*/

SELECT ACTIVO, SECTOR, ID, DESC_LARGA  FROM GAS_PLATAFORMAS WHERE TIPO_INST='SEPARADOR' AND 
ID IN (178,213,181,214,182,186,187,318,194,196,198,202,205,207,209,211,212,365,432,225,216,722,450,452,454)







/*GRAFICA CANTARELL*/


SELECT PARA.FECHA_CONTABLE AS FECHA_CONTABLE, PLATA.ID AS ID, PLATA.DESC_LARGA AS DESC_LARGA, PARA.Psep AS sep, 
PARA.QgasT AS gas, PARA.Pentrada as Pentrada, PARA.sal_ace as salace, PARA.sal_gas as salgas,PARA.nivel as nivel,
PARA.temp as temperatura, PARA.vol_aceite as volaceite, PRESION_BN_CA.PRESION AS presion_bn_ca, PARA.iny_bn as inyeccion_bn
FROM

(SELECT ACTIVO, SECTOR, ID, DESC_LARGA  FROM GAS_PLATAFORMAS WHERE TIPO_INST='SEPARADOR' AND 
ID = :ID_PLATAFORMA) PLATA,

(SELECT FECHA_CONTABLE,ROUND(SUM (CASE id_parametros WHEN 1166 THEN valor_numerico ELSE NULL END)
        / NVL(COUNT(CASE id_parametros WHEN 1166 THEN valor_numerico ELSE NULL END), 1), 5) AS Psep,
            ROUND(SUM (CASE id_parametros WHEN 1292 THEN
            RMN_PO_VOL_GAS_SEP(plataforma, TO_CHAR(fecha_real, 'DD/MM/YYYY'), id_hora) ELSE NULL END )
        / NVL(COUNT(CASE id_parametros WHEN 1292 THEN valor_cadena ELSE NULL END), 1), 5) AS QgasT,
            ROUND(SUM (CASE id_parametros WHEN 1165 THEN valor_numerico ELSE NULL END)
        / NVL(COUNT(CASE id_parametros WHEN 1165 THEN valor_numerico ELSE NULL END), 1), 5) as Pentrada,
      ROUND(SUM (CASE id_parametros WHEN 1167 THEN valor_numerico ELSE NULL END)
        / NVL(COUNT(CASE id_parametros WHEN 1167 THEN valor_numerico ELSE NULL END), 1), 5) AS sal_ace,
            ROUND(SUM (CASE id_parametros WHEN 1168 THEN valor_numerico ELSE NULL END)
        / NVL(COUNT(CASE id_parametros WHEN 1168 THEN valor_numerico ELSE NULL END), 1), 5) AS sal_gas,
        ROUND(SUM (CASE id_parametros WHEN 1169 THEN valor_numerico ELSE NULL END)
        / NVL(COUNT(CASE id_parametros WHEN 1169 THEN valor_numerico ELSE NULL END), 1), 5) AS nivel,
         ROUND(SUM (CASE id_parametros WHEN 1170 THEN valor_numerico ELSE NULL END)
        / NVL(COUNT(CASE id_parametros WHEN 1170 THEN valor_numerico ELSE NULL END), 1), 5) AS temp,
        ROUND(SUM (CASE id_parametros WHEN 1291 THEN
            RMN_PO_VOL_ACEITE_SEP(plataforma, TO_CHAR(fecha_real, 'DD/MM/YYYY'), id_hora) ELSE NULL END )
        / NVL(COUNT(CASE id_parametros WHEN 1291 THEN valor_cadena ELSE NULL END), 1), 5) AS vol_aceite,
        ROUND(SUM (CASE id_parametros WHEN 1187 THEN valor_numerico ELSE NULL END)
        / NVL(COUNT(CASE id_parametros WHEN 1187 THEN valor_numerico ELSE NULL END), 1), 5) as iny_bn  


FROM gas_parametros_valores
WHERE id_parametros IN (1166,1292,1165,1167,1168,1169,1170,1291,1186,1187)
    AND plataforma = :ID_PLATAFORMA
    AND fecha_contable BETWEEN TO_DATE(:FECHAINI,'DD/MM/YYYY')-1 AND TO_DATE(:FECHAFIN,'DD/MM/YYYY')-1
GROUP BY fecha_contable
ORDER BY 1) PARA,


(SELECT FECHA_CONTABLE, ROUND(AVG(VALOR_NUMERICO), 5) AS PRESION
FROM GAS_PARAMETROS_VALORES
WHERE ID_PARAMETROS = 1440
    AND FECHA_CONTABLE BETWEEN TO_DATE(:FECHAINI,'DD/MM/YYYY')-1 AND TO_DATE(:FECHAFIN,'DD/MM/YYYY')-1
    AND PLATAFORMA = (SELECT  ID
FROM GAS_PLATAFORMAS
WHERE TIPO_INST = 'DUCTO'
    AND PRESION_BN IN
       (SELECT PLATAFORMA  FROM GAS_PLATAFORMAS WHERE TIPO_INST='SEPARADOR' AND 
ID = :ID_PLATAFORMA))

GROUP BY FECHA_CONTABLE) PRESION_BN_CA

WHERE PRESION_BN_CA.FECHA_CONTABLE = PARA.FECHA_CONTABLE


    
    
/*GRAFICA KMZ*/

SELECT PARA.FECHA_CONTABLE AS FECHA_CONTABLE, PLATA.ID AS ID, PLATA.DESC_LARGA AS DESC_LARGA, PARA.Psep AS sep, 
PARA.QgasT AS gas, PARA.Pentrada as Pentrada, PARA.sal_ace as salace, PARA.sal_gas as salgas,PARA.nivel as nivel,
PARA.temp as temperatura, PARA.vol_aceite as volaceite, PARA.p_bn as presion_bn_kmz, PARA.iny_bn as inyeccion_bn
FROM

(SELECT ACTIVO, SECTOR, ID, DESC_LARGA  FROM GAS_PLATAFORMAS WHERE TIPO_INST='SEPARADOR' AND 
ID = :ID_PLATAFORMA) PLATA,

(SELECT FECHA_CONTABLE,ROUND(SUM (CASE id_parametros WHEN 1166 THEN valor_numerico ELSE NULL END)
        / NVL(COUNT(CASE id_parametros WHEN 1166 THEN valor_numerico ELSE NULL END), 1), 5) AS Psep,
            ROUND(SUM (CASE id_parametros WHEN 1292 THEN
            RMN_PO_VOL_GAS_SEP(plataforma, TO_CHAR(fecha_real, 'DD/MM/YYYY'), id_hora) ELSE NULL END )
        / NVL(COUNT(CASE id_parametros WHEN 1292 THEN valor_cadena ELSE NULL END), 1), 5) AS QgasT,
            ROUND(SUM (CASE id_parametros WHEN 1165 THEN valor_numerico ELSE NULL END)
        / NVL(COUNT(CASE id_parametros WHEN 1165 THEN valor_numerico ELSE NULL END), 1), 5) as Pentrada,
      ROUND(SUM (CASE id_parametros WHEN 1167 THEN valor_numerico ELSE NULL END)
        / NVL(COUNT(CASE id_parametros WHEN 1167 THEN valor_numerico ELSE NULL END), 1), 5) AS sal_ace,
            ROUND(SUM (CASE id_parametros WHEN 1168 THEN valor_numerico ELSE NULL END)
        / NVL(COUNT(CASE id_parametros WHEN 1168 THEN valor_numerico ELSE NULL END), 1), 5) AS sal_gas,
        ROUND(SUM (CASE id_parametros WHEN 1169 THEN valor_numerico ELSE NULL END)
        / NVL(COUNT(CASE id_parametros WHEN 1169 THEN valor_numerico ELSE NULL END), 1), 5) AS nivel,
         ROUND(SUM (CASE id_parametros WHEN 1170 THEN valor_numerico ELSE NULL END)
        / NVL(COUNT(CASE id_parametros WHEN 1170 THEN valor_numerico ELSE NULL END), 1), 5) AS temp,
        ROUND(SUM (CASE id_parametros WHEN 1291 THEN
            RMN_PO_VOL_ACEITE_SEP(plataforma, TO_CHAR(fecha_real, 'DD/MM/YYYY'), id_hora) ELSE NULL END )
        / NVL(COUNT(CASE id_parametros WHEN 1291 THEN valor_cadena ELSE NULL END), 1), 5) AS vol_aceite,
        ROUND(SUM (CASE id_parametros WHEN 1186 THEN valor_numerico ELSE NULL END)
        / NVL(COUNT(CASE id_parametros WHEN 1186 THEN valor_numerico ELSE NULL END), 1), 5) as p_bn,
        ROUND(SUM (CASE id_parametros WHEN 1187 THEN valor_numerico ELSE NULL END)
        / NVL(COUNT(CASE id_parametros WHEN 1187 THEN valor_numerico ELSE NULL END), 1), 5) as iny_bn  


FROM gas_parametros_valores
WHERE id_parametros IN (1166,1292,1165,1167,1168,1169,1170,1291,1186,1187)
    AND plataforma = :ID_PLATAFORMA
    AND fecha_contable BETWEEN TO_DATE(:FECHAINI,'DD/MM/YYYY')-1 AND TO_DATE(:FECHAFIN,'DD/MM/YYYY')-1
GROUP BY fecha_contable
ORDER BY 1) PARA


