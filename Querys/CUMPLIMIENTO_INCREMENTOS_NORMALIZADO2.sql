SELECT /*+ ALL_ROWS */

NUM_SEMANA,FEC_INI_SEMANA, FEC_FIN_SEMANA,
   100 * CASE
      WHEN NVL( SUM(CASE WHEN PROYECTO IN('CANTARELL', 'EK BALAM') AND TIPO='R' THEN CONTADOR_POZOS ELSE NULL END), 0) = 0 AND NVL(SUM(CASE WHEN PROYECTO IN('CANTARELL', 'EK BALAM') AND TIPO='P' THEN CONTADOR_POZOS ELSE NULL END), 0) = 0 THEN
          1
       WHEN  NVL( SUM(CASE WHEN PROYECTO IN('CANTARELL', 'EK BALAM') AND TIPO='P' THEN CONTADOR_POZOS ELSE NULL END), 0) = 0 THEN
          0.5
       ELSE
           ROUND(SUM(CASE WHEN PROYECTO IN('CANTARELL', 'EK BALAM') AND TIPO='R' THEN CONTADOR_POZOS ELSE NULL END) /  SUM(CASE WHEN PROYECTO IN('CANTARELL', 'EK BALAM') AND TIPO='P' THEN CONTADOR_POZOS ELSE NULL END), 2)
    END As CUMP_CANTARELL,
  
     100 * CASE
      WHEN NVL( SUM(CASE WHEN PROYECTO IN('KU MALOOB ZAAP') AND TIPO='R' THEN CONTADOR_POZOS ELSE NULL END), 0) = 0 AND NVL(SUM(CASE WHEN PROYECTO IN('KU MALOOB ZAAP') AND TIPO='P' THEN CONTADOR_POZOS ELSE NULL END), 0) = 0 THEN
          1
       WHEN  NVL(SUM(CASE WHEN PROYECTO IN('KU MALOOB ZAAP') AND TIPO='P' THEN CONTADOR_POZOS ELSE NULL END), 0) = 0 THEN
          0.5
       ELSE
           ROUND( SUM(CASE WHEN PROYECTO IN('KU MALOOB ZAAP') AND TIPO='R' THEN CONTADOR_POZOS ELSE NULL END) / SUM(CASE WHEN PROYECTO IN('KU MALOOB ZAAP') AND TIPO='P' THEN CONTADOR_POZOS ELSE NULL END), 2)
    END As CUMP_KMZ

FROM
     
(  

SELECT 
SEMANA.NUM_SEMANA,SEMANA.FEC_INI_SEMANA,SEMANA.FEC_FIN_SEMANA,SEMANA.PROYECTO,COUNT(SEMANA.DESC_INSTALACION) as contador_pozos,SEMANA.TIPO
FROM

(SELECT /*+ ALL_ROWS */  distinct FECHAS.NUM_SEMANA,FECHAS.FEC_INI_SEMANA,FECHAS.FEC_FIN_SEMANA,JUST.PROYECTO,just.id_det_concepto, MOVS.DESC_INSTALACION,MOVS.ID_INSTALACION,
            'R' AS tipo,MOVS.CVE_TIPO
        FROM pron_just just, pron_movs movs,
         (/* CONSULTA PARA GENERAR TODAS LAS SEMANAS ENTRE 2 FECHAS */
            
            SELECT

            ROWNUM As NUM_SEMANA,

            TO_DATE(:FEC_INI_RESUMEN, 'DD/MM/YYYY') + (ROWNUM-1) * 7 As FEC_INI_SEMANA,

            TO_DATE(:FEC_INI_RESUMEN, 'DD/MM/YYYY') + (ROWNUM-1) * 7 + 6 As FEC_FIN_SEMANA

            FROM DUAL

            CONNECT By ROWNUM <= (TO_DATE(:FEC_FIN_RESUMEN, 'DD/MM/YYYY') - TO_DATE(:FEC_INI_RESUMEN, 'DD/MM/YYYY')) / 7

         )FECHAS 
             
        WHERE just.id_justificacion = movs.id_justificacion
            AND just.fecha_contable + 1 BETWEEN FECHAS.FEC_INI_SEMANA AND FECHAS.FEC_FIN_SEMANA
            AND just.proyecto IN( 'CANTARELL','EK BALAM','KU MALOOB ZAAP' )
            AND just.id_det_concepto IN (59,60,61,62)
            AND movs.cve_tipo = 'P') semana
         
               
            where NOT EXISTS
            (
                SELECT 'x' FROM pron_just just2, pron_movs movs2
                 WHERE just2.id_justificacion = movs2.id_justificacion 
                 And just2.fecha_contable+1 between semana.FEC_INI_SEMANA-14 AND semana.FEC_FIN_SEMANA-7
                 And just2.proyecto = semana.proyecto 
                 And just2.id_det_concepto = semana.id_det_concepto 
                 and movs2.id_instalacion=semana.id_instalacion
                 And movs2.desc_instalacion = semana.desc_instalacion
                 AND MOVS2.CVE_TIPO=SEMANA.CVE_TIPO
              )   
              
           
        GROUP BY SEMANA.NUM_SEMANA,SEMANA.FEC_INI_SEMANA,SEMANA.FEC_FIN_SEMANA,SEMANA.PROYECTO,SEMANA.TIPO
     
   

UNION ALL

   
        
 SELECT SEMANA.NUM_SEMANA,SEMANA.FEC_INI_SEMANA,SEMANA.FEC_FIN_SEMANA,SEMANA.PROYECTO,COUNT(SEMANA.DESC_INSTALACION) as contador_pozos,SEMANA.TIPO
FROM       
        
   (SELECT  /*+ ALL_ROWS */ distinct FECHAS.NUM_SEMANA,FECHAS.FEC_INI_SEMANA,FECHAS.FEC_FIN_SEMANA,JUST.PROYECTO,just.id_det_concepto, MOVS.DESC_INSTALACION,MOVS.ID_INSTALACION,
        'P' AS tipo, MOVS.CVE_TIPO
        FROM datawarezm.mne_ace_just_pos just, datawarezm.mne_ace_movs_pos movs,
         (/* CONSULTA PARA GENERAR TODAS LAS SEMANAS ENTRE 2 FECHAS */
            
            SELECT

            ROWNUM As NUM_SEMANA,

            TO_DATE(:FEC_INI_RESUMEN, 'DD/MM/YYYY') + (ROWNUM-1) * 7 As FEC_INI_SEMANA,

            TO_DATE(:FEC_INI_RESUMEN, 'DD/MM/YYYY') + (ROWNUM-1) * 7 + 6 As FEC_FIN_SEMANA

            FROM DUAL

            CONNECT By ROWNUM <= (TO_DATE(:FEC_FIN_RESUMEN, 'DD/MM/YYYY') - TO_DATE(:FEC_INI_RESUMEN, 'DD/MM/YYYY')) / 7

         )FECHAS 
       
        WHERE just.id_just_pos = movs.id_just_pos
        AND just.fecha_contable + 1 BETWEEN FECHAS.FEC_INI_SEMANA AND FECHAS.FEC_FIN_SEMANA
        AND just.proyecto IN( 'CANTARELL','EK BALAM','KU MALOOB ZAAP' )       
        AND just.id_det_concepto IN (59,60,61,62)
        AND movs.cve_tipo = 'P')semana
        
         WHERE NOT EXISTS(
          
          SELECT 'x' FROM pron_just just2, pron_movs movs2 
          WHERE just2.id_justificacion = movs2.id_justificacion 
          And just2.fecha_contable+1 BETWEEN semana.FEC_INI_SEMANA-7 AND semana.FEC_FIN_SEMANA-7
           And just2.proyecto = semana.proyecto
          And just2.id_det_concepto = semana.id_det_concepto 
            And movs2.id_instalacion = semana.id_instalacion
            And movs2.desc_instalacion = semana.desc_instalacion
            AND MOVS2.CVE_TIPO=SEMANA.CVE_TIPO)   
              
         AND NOT EXISTS (
         SELECT 'x' FROM datawarezm.mne_ace_just_pos just2, datawarezm.mne_ace_movs_pos movs2 
         WHERE just2.id_just_pos = movs2.id_just_pos 
         And just2.fecha_contable+1 BETWEEN semana.FEC_INI_SEMANA AND semana.FEC_FIN_SEMANA
          And just2.id_det_concepto = semana.id_det_concepto
           And movs2.id_instalacion = semana.id_instalacion 
           And movs2.desc_instalacion = semana.desc_instalacion
           AND MOVS2.CVE_TIPO=SEMANA.CVE_TIPO
           And just2.realizado='R')
           
       GROUP BY SEMANA.NUM_SEMANA,SEMANA.FEC_INI_SEMANA,SEMANA.FEC_FIN_SEMANA,SEMANA.PROYECTO,SEMANA.TIPO     
           
   
     )

GROUP BY NUM_SEMANA,FEC_INI_SEMANA, FEC_FIN_SEMANA 
















 SELECT NUM_SEMANA,FEC_INI_SEMANA, FEC_FIN_SEMANA,
          SUM(CASE WHEN PROYECTO IN('CANTARELL', 'EK BALAM') AND TIPO='R' THEN CONTADOR_POZOS ELSE NULL END) As REAL_POZOS_CA,
         SUM(CASE WHEN PROYECTO IN('KU MALOOB ZAAP') AND TIPO='R' THEN CONTADOR_POZOS ELSE NULL END) As REAL_POZOS_KU,
          SUM(CASE WHEN PROYECTO IN('CANTARELL', 'EK BALAM') AND TIPO='P' THEN CONTADOR_POZOS ELSE NULL END) As PROG_POZOS_CA,
         SUM(CASE WHEN PROYECTO IN('KU MALOOB ZAAP') AND TIPO='P' THEN CONTADOR_POZOS ELSE NULL END) As PROG_POZOS_KU
     FROM  
 
     
(









SELECT

NUM_SEMANA,FEC_INI_SEMANA,FEC_FIN_SEMANA,

 SUM(CASE WHEN PROYECTO IN('CANTARELL', 'EK BALAM') AND TIPO='R' THEN CONTADOR_POZOS ELSE NULL END) As REAL_POZOS_CA,
 SUM(CASE WHEN PROYECTO IN('KU MALOOB ZAAP') AND TIPO='R' THEN CONTADOR_POZOS ELSE NULL END) As REAL_POZOS_KU

FROM


(



SELECT SEMANA.NUM_SEMANA,SEMANA.FEC_INI_SEMANA,SEMANA.FEC_FIN_SEMANA,SEMANA.PROYECTO,COUNT(SEMANA.DESC_INSTALACION) as contador_pozos,SEMANA.TIPO
FROM

(SELECT distinct FECHAS.NUM_SEMANA,FECHAS.FEC_INI_SEMANA,FECHAS.FEC_FIN_SEMANA,JUST.PROYECTO,just.id_det_concepto, MOVS.DESC_INSTALACION,MOVS.ID_INSTALACION,
            'R' AS tipo
        FROM pron_just just, pron_movs movs,
         (/* CONSULTA PARA GENERAR TODAS LAS SEMANAS ENTRE 2 FECHAS */
            
            SELECT

            ROWNUM As NUM_SEMANA,

            TO_DATE(:FEC_INI_RESUMEN, 'DD/MM/YYYY') + (ROWNUM-1) * 7 As FEC_INI_SEMANA,

            TO_DATE(:FEC_INI_RESUMEN, 'DD/MM/YYYY') + (ROWNUM-1) * 7 + 6 As FEC_FIN_SEMANA

            FROM DUAL

            CONNECT By ROWNUM <= (TO_DATE(:FEC_FIN_RESUMEN, 'DD/MM/YYYY') - TO_DATE(:FEC_INI_RESUMEN, 'DD/MM/YYYY')) / 7

         )FECHAS 
             
        WHERE just.id_justificacion = movs.id_justificacion
            AND just.fecha_contable + 1 BETWEEN FECHAS.FEC_INI_SEMANA AND FECHAS.FEC_FIN_SEMANA
            AND just.proyecto IN( 'CANTARELL','EK BALAM','KU MALOOB ZAAP' )
            AND just.id_det_concepto IN (59,60,61,62)
            AND movs.cve_tipo = 'P') semana
         
               
            where NOT EXISTS
            (
                SELECT 'x' FROM pron_just just2, pron_movs movs2
                 WHERE just2.id_justificacion = movs2.id_justificacion 
                 And just2.fecha_contable+1 between semana.FEC_INI_SEMANA-14 AND semana.FEC_FIN_SEMANA-7
                 And just2.proyecto = semana.proyecto 
                 And just2.id_det_concepto = semana.id_det_concepto 
                 and movs2.id_instalacion=semana.id_instalacion
                 And movs2.desc_instalacion = semana.desc_instalacion
                 
              )   
              
           
        GROUP BY SEMANA.NUM_SEMANA,SEMANA.FEC_INI_SEMANA,SEMANA.FEC_FIN_SEMANA,SEMANA.PROYECTO,SEMANA.TIPO
        
        )
        
        GROUP BY NUM_SEMANA,FEC_INI_SEMANA,FEC_FIN_SEMANA
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
 SELECT SEMANA.NUM_SEMANA,SEMANA.FEC_INI_SEMANA,SEMANA.FEC_FIN_SEMANA,SEMANA.PROYECTO,COUNT(SEMANA.DESC_INSTALACION) as contador_pozos,SEMANA.TIPO
FROM       
        
   (SELECT distinct FECHAS.NUM_SEMANA,FECHAS.FEC_INI_SEMANA,FECHAS.FEC_FIN_SEMANA,JUST.PROYECTO,just.id_det_concepto, MOVS.DESC_INSTALACION,MOVS.ID_INSTALACION,
        'P' AS tipo, 1 AS num_reg
        FROM datawarezm.mne_ace_just_pos just, datawarezm.mne_ace_movs_pos movs,
         (/* CONSULTA PARA GENERAR TODAS LAS SEMANAS ENTRE 2 FECHAS */
            
            SELECT

            ROWNUM As NUM_SEMANA,

            TO_DATE(:FEC_INI_RESUMEN, 'DD/MM/YYYY') + (ROWNUM-1) * 7 As FEC_INI_SEMANA,

            TO_DATE(:FEC_INI_RESUMEN, 'DD/MM/YYYY') + (ROWNUM-1) * 7 + 6 As FEC_FIN_SEMANA

            FROM DUAL

            CONNECT By ROWNUM <= (TO_DATE(:FEC_FIN_RESUMEN, 'DD/MM/YYYY') - TO_DATE(:FEC_INI_RESUMEN, 'DD/MM/YYYY')) / 7

         )FECHAS 
       
        WHERE just.id_just_pos = movs.id_just_pos
        AND just.fecha_contable + 1 BETWEEN FECHAS.FEC_INI_SEMANA AND FECHAS.FEC_FIN_SEMANA
        AND just.proyecto IN( 'CANTARELL','EK BALAM','KU MALOOB ZAAP' )       
        AND just.id_det_concepto IN (59,60,61,62)
        AND movs.cve_tipo = 'P')semana
        
         WHERE NOT EXISTS(
          
          SELECT 'x' FROM pron_just just2, pron_movs movs2 
          WHERE just2.id_justificacion = movs2.id_justificacion 
          And just2.fecha_contable+1 BETWEEN semana.FEC_INI_SEMANA-7 AND semana.FEC_FIN_SEMANA-7
           And just2.proyecto = semana.proyecto
          And just2.id_det_concepto = semana.id_det_concepto 
            And movs2.id_instalacion = semana.id_instalacion
            And movs2.desc_instalacion = semana.desc_instalacion)   
              
         AND NOT EXISTS (
         SELECT 'x' FROM datawarezm.mne_ace_just_pos just2, datawarezm.mne_ace_movs_pos movs2 
         WHERE just2.id_just_pos = movs2.id_just_pos 
         And just2.fecha_contable+1 BETWEEN semana.FEC_INI_SEMANA AND semana.FEC_FIN_SEMANA
          And just2.id_det_concepto = semana.id_det_concepto
           And movs2.id_instalacion = semana.id_instalacion 
           And movs2.desc_instalacion = semana.desc_instalacion
           And just2.realizado='R')
           
       GROUP BY SEMANA.NUM_SEMANA,SEMANA.FEC_INI_SEMANA,SEMANA.FEC_FIN_SEMANA,SEMANA.PROYECTO,SEMANA.TIPO     
           
           
           
