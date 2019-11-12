SELECT

NUM_SEMANA,FEC_INI_SEMANA, FEC_FIN_SEMANA,
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
     
(   SELECT NUM_SEMANA,FEC_INI_SEMANA, FEC_FIN_SEMANA,
          SUM(CASE WHEN PROYECTO IN('CANTARELL', 'EK BALAM') AND TIPO='R' THEN CONTADOR_POZOS ELSE NULL END) As REAL_POZOS_CA,
         SUM(CASE WHEN PROYECTO IN('KU MALOOB ZAAP') AND TIPO='R' THEN CONTADOR_POZOS ELSE NULL END) As REAL_POZOS_KU,
          SUM(CASE WHEN PROYECTO IN('CANTARELL', 'EK BALAM') AND TIPO='P' THEN CONTADOR_POZOS ELSE NULL END) As PROG_POZOS_CA,
         SUM(CASE WHEN PROYECTO IN('KU MALOOB ZAAP') AND TIPO='P' THEN CONTADOR_POZOS ELSE NULL END) As PROG_POZOS_KU
     FROM  
 
     
(SELECT FECHAS.NUM_SEMANA,FECHAS.FEC_INI_SEMANA,FECHAS.FEC_FIN_SEMANA,JUST.PROYECTO,just.id_det_concepto, 
            COUNT(DISTINCT MOVS.DESC_INSTALACION) As contador_pozos,
            'R' AS tipo, 1 AS num_reg
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
            AND just.id_det_concepto IN (59,60,61,62)
            AND movs.cve_tipo = 'P'
            AND just.proyecto IN( 'CANTARELL','EK BALAM','KU MALOOB ZAAP' )
            AND NOT EXISTS
            (
                SELECT 'x' FROM pron_just just2, pron_movs movs2
                 WHERE just2.id_justificacion = movs2.id_justificacion 
                 And just2.fecha_contable+1 between FECHAS.FEC_INI_SEMANA-14 AND FECHAS.FEC_FIN_SEMANA-7
                 And just2.id_det_concepto = just.id_det_concepto And just2.proyecto = just.proyecto
                    and movs2.id_instalacion=movs.id_instalacion
                 And movs2.desc_instalacion = movs.desc_instalacion
                 
              )      
        GROUP BY FECHAS.NUM_SEMANA,FECHAS.FEC_INI_SEMANA,FECHAS.FEC_FIN_SEMANA,just.id_det_concepto,JUST.PROYECTO
     
   

UNION ALL


  
        SELECT  FECHAS.NUM_SEMANA,FECHAS.FEC_INI_SEMANA, FECHAS.FEC_FIN_SEMANA,JUST.PROYECTO,just.id_det_concepto, 
        COUNT(DISTINCT MOVS.ID_INSTALACION) As contador_pozos,
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
        AND just.id_det_concepto IN (59,60,61,62)
        AND movs.cve_tipo = 'P'
        AND just.proyecto IN( 'CANTARELL','EK BALAM','KU MALOOB ZAAP' )
          AND NOT EXISTS(
          
          SELECT 'x' FROM pron_just just2, pron_movs movs2 
          WHERE just2.id_justificacion = movs2.id_justificacion 
          And just2.fecha_contable+1 BETWEEN FECHAS.FEC_INI_SEMANA-7 AND FECHAS.FEC_FIN_SEMANA-7
          And just2.id_det_concepto = just.id_det_concepto 
          And just2.proyecto = just.proyecto
           And movs2.id_instalacion = movs.id_instalacion
            And movs2.desc_instalacion = movs.desc_instalacion)   
              
         AND NOT EXISTS (
         SELECT 'x' FROM datawarezm.mne_ace_just_pos just2, datawarezm.mne_ace_movs_pos movs2 
         WHERE just2.id_just_pos = movs2.id_just_pos 
         And just2.fecha_contable+1 BETWEEN FECHAS.FEC_INI_SEMANA AND FECHAS.FEC_FIN_SEMANA
          And just2.id_det_concepto = just.id_det_concepto
          And movs2.id_instalacion = movs.id_instalacion 
           And movs2.desc_instalacion = movs.desc_instalacion
           And just2.realizado='R')
     GROUP BY  FECHAS.NUM_SEMANA,FECHAS.FEC_INI_SEMANA, FECHAS.FEC_FIN_SEMANA,JUST.PROYECTO,just.id_det_concepto
     
     
     )

GROUP BY NUM_SEMANA,FEC_INI_SEMANA, FEC_FIN_SEMANA)

















