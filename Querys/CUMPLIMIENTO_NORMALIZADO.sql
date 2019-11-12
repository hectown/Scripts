WITH datos AS (
SELECT 
         
            just2.id_justificacion,
            just2.proyecto,
            just2.fecha_contable,
            SEMANA.FEC_INI_SEMANA AS ini_semana,
            TO_CHAR( SEMANA.FEC_INI_SEMANA, 'YYYYWW') AS semana,
            TO_CHAR( SEMANA.FEC_INI_SEMANA + 14, 'YYYYWW') AS semana_ant1,
            TO_CHAR( SEMANA.FEC_INI_SEMANA + 6, 'YYYYWW') AS semana_ant2,
            just2.id_det_concepto,
            movs2.id_instalacion,
            movs2.desc_instalacion, 
            '' as realizado,
            'R' AS tipo       
      FROM pron_just just2, pron_movs movs2,
    (/* CONSULTA PARA GENERAR TODAS LAS SEMANAS ENTRE 2 FECHAS */
            
            SELECT

            ROWNUM As NUM_SEMANA,

            TO_DATE(:FEC_INI_RESUMEN, 'DD/MM/YYYY') + (ROWNUM-1) * 7-14 As FEC_INI_SEMANA,

            TO_DATE(:FEC_INI_RESUMEN, 'DD/MM/YYYY') + (ROWNUM-1) * 7 + 6-14 As FEC_FIN_SEMANA

            FROM DUAL

            CONNECT By ROWNUM <= (TO_DATE(:FEC_FIN_RESUMEN, 'DD/MM/YYYY')+14 - TO_DATE(:FEC_INI_RESUMEN, 'DD/MM/YYYY')) / 7

         )SEMANA
      WHERE 
          just2.id_justificacion = movs2.id_justificacion
            AND just2.fecha_contable+1 BETWEEN SEMANA.FEC_INI_SEMANA AND SEMANA.FEC_FIN_SEMANA
            AND just2.id_det_concepto IN (59,60,61,62)
            AND movs2.cve_tipo = 'P'
   
    
    UNION ALL
    
    
   SELECT 
  
            just2.id_just_pos,
            just2.proyecto,
            just2.fecha_contable,
            SEMANA.FEC_INI_SEMANA AS ini_semana,
            TO_CHAR( SEMANA.FEC_INI_SEMANA, 'YYYYWW') AS semana,
            TO_CHAR( SEMANA.FEC_INI_SEMANA + 14, 'YYYYWW') AS semana_ant1,
            TO_CHAR( SEMANA.FEC_INI_SEMANA + 6, 'YYYYWW') AS semana_ant2,
            just2.id_det_concepto,
            movs2.id_instalacion,
            movs2.desc_instalacion,
            just2.realizado,
            'P' AS tipo       
      FROM datawarezm.mne_ace_just_pos just2, datawarezm.mne_ace_movs_pos movs2,
    (/* CONSULTA PARA GENERAR TODAS LAS SEMANAS ENTRE 2 FECHAS */
            
            SELECT

            ROWNUM As NUM_SEMANA,

            TO_DATE(:FEC_INI_RESUMEN, 'DD/MM/YYYY') + (ROWNUM-1) * 7 As FEC_INI_SEMANA,

            TO_DATE(:FEC_INI_RESUMEN, 'DD/MM/YYYY') + (ROWNUM-1) * 7 + 6 As FEC_FIN_SEMANA

            FROM DUAL

            CONNECT By ROWNUM <= (TO_DATE(:FEC_FIN_RESUMEN, 'DD/MM/YYYY') - TO_DATE(:FEC_INI_RESUMEN, 'DD/MM/YYYY')) / 7

         )SEMANA
      WHERE 
           just2.id_just_pos = movs2.id_just_pos
            AND just2.fecha_contable+1 BETWEEN SEMANA.FEC_INI_SEMANA AND SEMANA.FEC_FIN_SEMANA
            AND just2.id_det_concepto IN (59,60,61,62)
            AND movs2.cve_tipo = 'P'
      ORDER BY 3
    
    )
    

SELECT
ROWNUM AS NUM_SEMANA,SEMANA as FEC_INI_SEMANA,
   100 * CASE
      WHEN NVL(REAL_POZOS_CA, 0) = 0 AND NVL(PROG_POZOS_CA, 0) = 0 THEN
          1
       WHEN  NVL(PROG_POZOS_CA, 0) = 0 THEN
          0.5
       ELSE
           ROUND(REAL_POZOS_CA / PROG_POZOS_CA, 2)
    END As CUMP_CANTARELL,
  
     100 * CASE
      WHEN NVL(REAL_POZOS_KU, 0) = 0 AND NVL(PROG_POZOS_KU, 0) = 0 THEN
          1
       WHEN  NVL(PROG_POZOS_KU, 0) = 0 THEN
          0.5
       ELSE
           ROUND(REAL_POZOS_KU / PROG_POZOS_KU, 2)
    END As CUMP_KMZ

FROM


(SELECT SEMANA,
           SUM(CASE WHEN PROYECTO IN('CANTARELL', 'EK BALAM') AND TIPO='R' THEN CONTADOR_POZOS ELSE NULL END) As REAL_POZOS_CA,
           SUM(CASE WHEN PROYECTO IN('KU MALOOB ZAAP') AND TIPO='R' THEN CONTADOR_POZOS ELSE NULL END) As REAL_POZOS_KU,
           SUM(CASE WHEN PROYECTO IN('CANTARELL', 'EK BALAM') AND TIPO='P' THEN CONTADOR_POZOS ELSE NULL END) As PROG_POZOS_CA,
           SUM(CASE WHEN PROYECTO IN('KU MALOOB ZAAP') AND TIPO='P' THEN CONTADOR_POZOS ELSE NULL END) As PROG_POZOS_KU
            
FROM

(

SELECT PROYECTO,TIPO,SEMANA,COUNT(DESC_INSTALACION) AS CONTADOR_POZOS
FROM
        (

SELECT DISTINCT semana, proyecto, id_det_concepto,desc_instalacion, TIPO
FROM datos
WHERE (proyecto, id_det_concepto, semana, id_det_concepto,desc_instalacion,id_instalacion) NOT IN
        (
        SELECT a.proyecto, a.id_det_concepto, a.semana,a.id_det_concepto, a.desc_instalacion,a.id_instalacion
        FROM
            (
            SELECT *
            FROM datos where tipo='R'
            ) a,
            (
            SELECT *
            FROM datos where tipo='R'
            
            ) b
        WHERE a.proyecto = b.proyecto
            AND (a.semana = b.semana_ant1 OR a.semana = b.semana_ant2)
            AND a.id_det_concepto = b.id_det_concepto
            and a.id_instalacion=b.id_instalacion
            AND a.desc_instalacion = b.desc_instalacion    
        )
    AND fecha_contable >= TO_DATE(:FEC_INI_RESUMEN,'DD/MM/YYYY')
AND TIPO='R'

ORDER BY 1)
GROUP BY PROYECTO,TIPO,SEMANA

UNION ALL

SELECT PROYECTO,TIPO,SEMANA,COUNT(DESC_INSTALACION) AS CONTADOR_POZOS
FROM
        (

SELECT DISTINCT semana, proyecto, id_det_concepto,desc_instalacion, TIPO
FROM datos
WHERE (proyecto, id_det_concepto, semana, id_det_concepto,desc_instalacion,id_instalacion) NOT IN
        (
        SELECT a.proyecto, a.id_det_concepto, a.semana,a.id_det_concepto, a.desc_instalacion,a.id_instalacion
        FROM
            (
            SELECT *
            FROM datos WHERE tipo='P'
            ) a,
            (
            SELECT *
            FROM datos where tipo='R'
            
            ) b
        WHERE a.proyecto = b.proyecto
            AND a.semana = b.semana_ant2
            AND a.id_det_concepto = b.id_det_concepto
            and a.id_instalacion=b.id_instalacion
            AND a.desc_instalacion = b.desc_instalacion    
        )
        
       AND (proyecto, id_det_concepto, semana, id_det_concepto,desc_instalacion,id_instalacion) NOT IN
        (
        SELECT a.proyecto, a.id_det_concepto, a.semana,a.id_det_concepto, a.desc_instalacion,a.id_instalacion
        FROM
            (
            SELECT *
            FROM datos WHERE tipo='P'
            ) a,
            (
            SELECT *
            FROM datos where tipo='P'
            
            ) b
        WHERE a.proyecto = b.proyecto
            AND a.semana = b.semana
            AND a.id_det_concepto = b.id_det_concepto
            and a.id_instalacion=b.id_instalacion
            AND a.desc_instalacion = b.desc_instalacion    
            AND a.realizado = 'R'
        )
        
    AND fecha_contable >= TO_DATE(:FEC_INI_RESUMEN,'DD/MM/YYYY')
  AND TIPO='P'

ORDER BY 1)
GROUP BY PROYECTO,TIPO,SEMANA)


GROUP BY SEMANA)
