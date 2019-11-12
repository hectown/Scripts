SELECT ROWNUM As RENGLON,
   A.*
FROM (
SELECT
   REAL.FEC_INI_SEMANA,
   REAL.FEC_FIN_SEMANA,
   REAL.VOL_CA As REAL_VOL_CA,
   PROY.VOL_CA As PROY_VOL_CA,
  100 * CASE
      WHEN NVL(REAL.VOL_CA, 0) = 0 AND NVL(PROY.VOL_CA, 0) = 0 THEN
          1
       WHEN  NVL(PROY.VOL_CA, 0) = 0 THEN
          0.5
       ELSE
           ROUND(REAL.VOL_CA / PROY.VOL_CA, 3)
    END As VOL_CA_PORC,
   REAL.VOL_KU As REAL_VOL_KU,
   PROY.VOL_KU As PROY_VOL_KU,
   100 * CASE
      WHEN NVL(REAL.VOL_KU, 0) = 0 AND NVL(PROY.VOL_KU, 0) = 0 THEN
          1
       WHEN  NVL(PROY.VOL_KU, 0) = 0 THEN
          0.5
       ELSE
           ROUND(REAL.VOL_KU / PROY.VOL_KU, 3)
    END As VOL_KU_PORC,
   REAL.NUM_CA As REAL_NUM_CA,
   PROY.NUM_CA As PROY_NUM_CA,
   100 * CASE
      WHEN NVL(REAL.NUM_CA, 0) = 0 AND NVL(PROY.NUM_CA, 0) = 0 THEN
          1
       WHEN  NVL(PROY.NUM_CA, 0) = 0 THEN
          0.5
       ELSE
           ROUND(REAL.NUM_CA / PROY.NUM_CA, 3)
    END As NUM_CA_PORC,
   REAL.NUM_KU As REAL_NUM_KU,
   PROY.NUM_KU As PROY_NUM_KU,
   100 * CASE
      WHEN NVL(REAL.NUM_KU, 0) = 0 AND NVL(PROY.NUM_KU, 0) = 0 THEN
          1
       WHEN  NVL(PROY.NUM_KU, 0) = 0 THEN
          0.5
       ELSE
           ROUND(REAL.NUM_KU / PROY.NUM_KU, 3)
    END As NUM_KU_PORC
FROM
    (SELECT
         SEMANAS.FEC_INI_SEMANA, SEMANAS.FEC_FIN_SEMANA,
         SUM(CASE WHEN PROYECTO IN('CANTARELL', 'EK BALAM') THEN VOLUMEN ELSE NULL END) As VOL_CA,
         SUM(CASE WHEN PROYECTO IN('KU MALOOB ZAAP') THEN VOLUMEN ELSE NULL END) As VOL_KU,
         COUNT(CASE WHEN PROYECTO IN('CANTARELL', 'EK BALAM') THEN VOLUMEN ELSE NULL END) As NUM_CA,
         COUNT(CASE WHEN PROYECTO IN('KU MALOOB ZAAP') THEN VOLUMEN ELSE NULL END) As NUM_KU
     FROM datawarezm.MNE_ACE_JUST_POS POS,
            (/* CONSULTA PARA GENERAR TODAS LAS SEMANAS ENTRE 2 FECHAS */
             SELECT
                ROWNUM As NUM_SEMANA,
                TO_DATE(:FEC_INI_RESUMEN, 'DD/MM/YYYY') + (ROWNUM-1) * 7 As FEC_INI_SEMANA,
                TO_DATE(:FEC_INI_RESUMEN, 'DD/MM/YYYY') + (ROWNUM-1) * 7 + 6 As FEC_FIN_SEMANA
             FROM DUAL
             CONNECT By ROWNUM <= (TO_DATE(:FEC_FIN_RESUMEN, 'DD/MM/YYYY') - TO_DATE(:FEC_INI_RESUMEN, 'DD/MM/YYYY')) / 7) SEMANAS
     WHERE POS.FECHA_CONTABLE BETWEEN SEMANAS.FEC_INI_SEMANA AND SEMANAS.FEC_FIN_SEMANA
         AND POS.PROYECTO IN( 'CANTARELL', 'EK BALAM', 'KU MALOOB ZAAP' )
         AND POS.ID_DET_CONCEPTO BETWEEN 59 AND 62
     GROUP By SEMANAS.FEC_INI_SEMANA, SEMANAS.FEC_FIN_SEMANA) PROY,
     (SELECT
         SEMANAS.FEC_INI_SEMANA, SEMANAS.FEC_FIN_SEMANA,
         SUM(CASE WHEN PROYECTO IN('CANTARELL', 'EK BALAM') THEN VOLUMEN ELSE NULL END) As VOL_CA,
         SUM(CASE WHEN PROYECTO IN('KU MALOOB ZAAP') THEN VOLUMEN ELSE NULL END) As VOL_KU,
         COUNT(CASE WHEN PROYECTO IN('CANTARELL', 'EK BALAM') THEN VOLUMEN ELSE NULL END) As NUM_CA,
         COUNT(CASE WHEN PROYECTO IN('KU MALOOB ZAAP') THEN VOLUMEN ELSE NULL END) As NUM_KU
     FROM RDP2.PRON_JUST POS,
            (/* CONSULTA PARA GENERAR TODAS LAS SEMANAS ENTRE 2 FECHAS */
             SELECT
                ROWNUM As NUM_SEMANA,
                TO_DATE(:FEC_INI_RESUMEN, 'DD/MM/YYYY') + (ROWNUM-1) * 7 As FEC_INI_SEMANA,
                TO_DATE(:FEC_INI_RESUMEN, 'DD/MM/YYYY') + (ROWNUM-1) * 7 + 6 As FEC_FIN_SEMANA
             FROM DUAL
             CONNECT By ROWNUM <= (TO_DATE(:FEC_FIN_RESUMEN, 'DD/MM/YYYY') - TO_DATE(:FEC_INI_RESUMEN, 'DD/MM/YYYY')) / 7) SEMANAS
     WHERE POS.FECHA_CONTABLE BETWEEN SEMANAS.FEC_INI_SEMANA AND SEMANAS.FEC_FIN_SEMANA
         AND POS.PROYECTO IN( 'CANTARELL', 'EK BALAM', 'KU MALOOB ZAAP' )
         AND POS.ID_DET_CONCEPTO BETWEEN 59 AND 62
     GROUP By SEMANAS.FEC_INI_SEMANA, SEMANAS.FEC_FIN_SEMANA) REAL
  WHERE
            REAL.FEC_INI_SEMANA = PROY.FEC_INI_SEMANA(+)
     AND REAL.FEC_FIN_SEMANA = PROY.FEC_FIN_SEMANA(+)
  ORDER By REAL.FEC_INI_SEMANA) A
                       
                       
                       
                    
      
      
      
      
  
  
  
    SELECT
         SEMANAS.NUM_SEMANA,SEMANAS.FEC_INI_SEMANA, SEMANAS.FEC_FIN_SEMANA,
         SUM(CASE WHEN PROYECTO IN('CANTARELL', 'EK BALAM') THEN VOLUMEN ELSE NULL END) As VOL_CA,
         SUM(CASE WHEN PROYECTO IN('KU MALOOB ZAAP') THEN VOLUMEN ELSE NULL END) As VOL_KU,
         COUNT(CASE WHEN PROYECTO IN('CANTARELL', 'EK BALAM') THEN VOLUMEN ELSE NULL END) As NUM_CA,
         COUNT(CASE WHEN PROYECTO IN('KU MALOOB ZAAP') THEN VOLUMEN ELSE NULL END) As NUM_KU
     FROM RDP2.PRON_JUST POS,
            (/* CONSULTA PARA GENERAR TODAS LAS SEMANAS ENTRE 2 FECHAS */
             SELECT
                ROWNUM As NUM_SEMANA,
                TO_DATE(:FEC_INI_RESUMEN, 'DD/MM/YYYY') + (ROWNUM-1) * 7 As FEC_INI_SEMANA,
                TO_DATE(:FEC_INI_RESUMEN, 'DD/MM/YYYY') + (ROWNUM-1) * 7 + 6 As FEC_FIN_SEMANA
             FROM DUAL
             CONNECT By ROWNUM <= (TO_DATE(:FEC_FIN_RESUMEN, 'DD/MM/YYYY') - TO_DATE(:FEC_INI_RESUMEN, 'DD/MM/YYYY')) / 7) SEMANAS
     WHERE POS.FECHA_CONTABLE BETWEEN SEMANAS.FEC_INI_SEMANA AND SEMANAS.FEC_FIN_SEMANA
         AND POS.PROYECTO IN( 'CANTARELL', 'EK BALAM', 'KU MALOOB ZAAP' )
         AND POS.ID_DET_CONCEPTO BETWEEN 59 AND 62
     GROUP By  SEMANAS.NUM_SEMANA,SEMANAS.FEC_INI_SEMANA, SEMANAS.FEC_FIN_SEMANA
   
     
     
     
     
     
     
     
     
SELECT NUM_SEMANA,FEC_INI_SEMANA, FEC_FIN_SEMANA,
          SUM(CASE WHEN PROYECTO IN('CANTARELL', 'EK BALAM') THEN CONTADOR_POZOS ELSE NULL END) As VOL_CA,
         SUM(CASE WHEN PROYECTO IN('KU MALOOB ZAAP') THEN CONTADOR_POZOS ELSE NULL END) As VOL_KU
     FROM
(SELECT NUM_SEMANA,FEC_INI_SEMANA, FEC_FIN_SEMANA, JUST.PROYECTO,just.id_det_concepto, 
            COUNT(DISTINCT MOVS.DESC_INSTALACION) As contador_pozos,MOVS.DESC_INSTALACION,
            'R' AS tipo, 1 AS num_reg
        FROM pron_just just, pron_movs movs,
          (/* CONSULTA PARA GENERAR TODAS LAS SEMANAS ENTRE 2 FECHAS */
            
            SELECT

            ROWNUM As NUM_SEMANA,

            TO_DATE(:FEC_INI_RESUMEN, 'DD/MM/YYYY') + (ROWNUM-1) * 7 As FEC_INI_SEMANA,

            TO_DATE(:FEC_INI_RESUMEN, 'DD/MM/YYYY') + (ROWNUM-1) * 7 + 6 As FEC_FIN_SEMANA

            FROM DUAL

            CONNECT By ROWNUM <= ( (ADD_MONTHS(TRUNC((TO_DATE(:FEC_INI_RESUMEN, 'DD/MM/YYYY') + 7), 'YEAR'), 12) - 1) - TO_DATE(:FEC_INI_RESUMEN, 'DD/MM/YYYY')) / 7

         ) SEMANAS
        WHERE just.id_justificacion = movs.id_justificacion
            AND just.fecha_contable + 1 BETWEEN SEMANAS.FEC_INI_SEMANA AND SEMANAS.FEC_FIN_SEMANA
            AND just.id_det_concepto IN (59,60,61,62)
            AND movs.cve_tipo = 'P'
            AND just.proyecto IN( 'CANTARELL','EK BALAM','KU MALOOB ZAAP' )
            AND NOT EXISTS
            (SELECT 'x' FROM pron_just just2, pron_movs movs2,
                 (/* CONSULTA PARA GENERAR TODAS LAS SEMANAS ENTRE 2 FECHAS */
                
                SELECT

               ROWNUM NUM_SEMANA,

                TO_DATE(:FEC_INI_RESUMEN, 'DD/MM/YYYY')-14 + (((ROWNUM-1) * 7)*2)-7 As FEC_INI_SEMANA,

                TO_DATE(:FEC_INI_RESUMEN, 'DD/MM/YYYY')-14 + ((ROWNUM-1) * 7)*2 + 6 As FEC_FIN_SEMANA

                FROM DUAL

                CONNECT By ROWNUM <= ( (ADD_MONTHS(TRUNC((TO_DATE(:FEC_INI_RESUMEN, 'DD/MM/YYYY') + 7), 'YEAR'), 12) - 1) - TO_DATE(:FEC_INI_RESUMEN, 'DD/MM/YYYY')) / 7

                 ) SEMANAS2
             WHERE just2.id_justificacion = movs2.id_justificacion 
             And just2.fecha_contable between SEMANAS2.FEC_INI_SEMANA AND SEMANAS2.FEC_FIN_SEMANA
             AND just.fecha_contable between SEMANAS2.FEC_INI_SEMANA AND SEMANAS2.FEC_FIN_SEMANA
             And just2.id_det_concepto = just.id_det_concepto And just2.proyecto = just.proyecto
              And movs2.cve_tipo = 'P' And movs2.desc_instalacion = movs.desc_instalacion
             AND SEMANAS.NUM_SEMANA=SEMANAS2.NUM_SEMANA
             
              )      
        GROUP BY NUM_SEMANA,FEC_INI_SEMANA, FEC_FIN_SEMANA,just.id_det_concepto,JUST.PROYECTO,MOVS.DESC_INSTALACION)
     
     GROUP BY NUM_SEMANA,FEC_INI_SEMANA, FEC_FIN_SEMANA
     
     
     

     
     
     
     
     
SELECT 'x' FROM pron_just just2, pron_movs movs2 
WHERE just2.id_justificacion = movs2.id_justificacion 
And just2.fecha_contable between TO_DATE(:FECHA_INI, 'DD/MM/YYYY') - 15 And TO_DATE(:FECHA_INI, 'DD/MM/YYYY') - 2 
And just2.id_det_concepto = just.id_det_concepto 
And just2.proyecto = just.proyecto 
And movs2.cve_tipo = 'P' And movs2.id_instalacion = movs.id_instalacion)      

     
     
     
     
     
     
     
     
 


        
        /*contador*/
    SELECT NUM_SEMANA,FEC_INI_SEMANA, FEC_FIN_SEMANA,
         SUM(CASE WHEN ACTIVO IN('CANTARELL', 'EK BALAM') THEN POZOS ELSE NULL END) As VOL_CA,
         SUM(CASE WHEN ACTIVO IN('KU MALOOB ZAAP') THEN POZOS ELSE NULL END) As VOL_KU
         FROM
     
(select NUM_SEMANA,FEC_INI_SEMANA, FEC_FIN_SEMANA,ACTIVO,COUNT(DISTINCT DESC_INSTALACION) AS POZOS 
        from
     (
     SELECT SEMANAS.NUM_SEMANA,
            SEMANAS.FEC_INI_SEMANA, SEMANAS.FEC_FIN_SEMANA,
            just.proyecto As activo,
           movs.desc_instalacion,JUST.ID_DET_CONCEPTO,JUST.ID_JUSTIFICACION,CVE_TIPO           
            
        FROM pron_just just, pron_movs movs,
         (/* CONSULTA PARA GENERAR TODAS LAS SEMANAS ENTRE 2 FECHAS */
            
            SELECT

            ROWNUM As NUM_SEMANA,

            TO_DATE(:FEC_INI_RESUMEN, 'DD/MM/YYYY') + (ROWNUM-1) * 7 As FEC_INI_SEMANA,

            TO_DATE(:FEC_INI_RESUMEN, 'DD/MM/YYYY') + (ROWNUM-1) * 7 + 6 As FEC_FIN_SEMANA

            FROM DUAL

            CONNECT By ROWNUM <= ( (ADD_MONTHS(TRUNC((TO_DATE(:FEC_INI_RESUMEN, 'DD/MM/YYYY') + 7), 'YEAR'), 12) - 1) - TO_DATE(:FEC_INI_RESUMEN, 'DD/MM/YYYY')) / 7

         ) SEMANAS
        WHERE just.id_justificacion = movs.id_justificacion
            AND just.fecha_contable + 1 BETWEEN SEMANAS.FEC_INI_SEMANA AND SEMANAS.FEC_FIN_SEMANA
            AND just.id_det_concepto IN (59,60,61,62)
            AND movs.cve_tipo = 'P'
            AND just.proyecto IN( 'CANTARELL', 'EK BALAM', 'KU MALOOB ZAAP' )
                            
         GROUP BY SEMANAS.NUM_SEMANA,SEMANAS.FEC_INI_SEMANA, SEMANAS.FEC_FIN_SEMANA,just.proyecto,movs.desc_instalacion,JUST.ID_DET_CONCEPTO,JUST.ID_JUSTIFICACION,CVE_TIPO   
         
         )REALES
             
     WHERE NOT EXISTS(
     
     
     SELECT '*' FROM
     
      (
     
       SELECT SEMANAS.NUM_SEMANA,
            SEMANAS.FEC_INI_SEMANA, SEMANAS.FEC_FIN_SEMANA,
           just.proyecto As activo,
           movs.desc_instalacion,JUST.ID_DET_CONCEPTO,JUST.ID_JUSTIFICACION,movs.cve_tipo  
            
        FROM pron_just just, pron_movs movs,
         (/* CONSULTA PARA GENERAR TODAS LAS SEMANAS ENTRE 2 FECHAS */
            
            SELECT

            ROWNUM As NUM_SEMANA,

            TO_DATE(:FEC_INI_RESUMEN, 'DD/MM/YYYY')-14 + (ROWNUM-1) * 7 As FEC_INI_SEMANA,

            TO_DATE(:FEC_INI_RESUMEN, 'DD/MM/YYYY')-14 + (ROWNUM-1) * 7 + 6 As FEC_FIN_SEMANA

            FROM DUAL

            CONNECT By ROWNUM <= ( (ADD_MONTHS(TRUNC((TO_DATE(:FEC_INI_RESUMEN, 'DD/MM/YYYY') + 7), 'YEAR'), 12) - 1) - TO_DATE(:FEC_INI_RESUMEN, 'DD/MM/YYYY')) / 7

         ) SEMANAS
        WHERE just.id_justificacion = movs.id_justificacion
            AND just.fecha_contable BETWEEN SEMANAS.FEC_INI_SEMANA AND SEMANAS.FEC_FIN_SEMANA
            AND just.id_det_concepto IN (59,60,61,62)
            AND movs.cve_tipo = 'P'
            AND just.proyecto IN( 'CANTARELL', 'EK BALAM', 'KU MALOOB ZAAP' )
           
         GROUP BY SEMANAS.NUM_SEMANA,SEMANAS.FEC_INI_SEMANA, SEMANAS.FEC_FIN_SEMANA,just.proyecto,movs.desc_instalacion,JUST.ID_DET_CONCEPTO,JUST.ID_JUSTIFICACION,movs.cve_tipo       
      
  
         )ATRAS
         
          WHERE  
            
  
  
  ATRAS.ID_JUSTIFICACION=REALES.ID_JUSTIFICACION
         AND ATRAS.NUM_SEMANA = REALES.NUM_SEMANA
         AND ATRAS.ID_DET_CONCEPTO=REALES.ID_DET_CONCEPTO
         AND ATRAS.ACTIVO=REALES.ACTIVO 
         AND ATRAS.DESC_INSTALACION=REALES.DESC_INSTALACION        

  
  
     ) 
       GROUP BY NUM_SEMANA,FEC_INI_SEMANA, FEC_FIN_SEMANA, ACTIVO)
  
  GROUP BY NUM_SEMANA,FEC_INI_SEMANA, FEC_FIN_SEMANA
  
  
  
  
  
  
  
  
  
  
  
  
  SELECT FECHA,
        DECODE(MOD(ROW_NUMBER() OVER(ORDER BY FECHA),7),0,
            TRUNC(ROW_NUMBER() OVER(ORDER BY FECHA)/7,0) -1,
            TRUNC(ROW_NUMBER() OVER(ORDER BY FECHA)/7, 0)) SEMANA
      FROM (
      SELECT MIN_FECHA + (LEVEL - 1) FECHA
        FROM (
        SELECT TRUNC(TO_DATE(:FECHA_INI,'DD/MM/YYYY'),'year')-5 MIN_FECHA FROM DUAL
             )CONNECT BY LEVEL <= 365
           )      
      







SELECT

ROWNUM As NUM_SEMANA,

TO_DATE(:FEC_INI_RESUMEN, 'DD/MM/YYYY')-14 + (ROWNUM-1) * 7 As FEC_INI_SEMANA,

TO_DATE(:FEC_INI_RESUMEN, 'DD/MM/YYYY')-14 + (ROWNUM-1) * 7 + 6 As FEC_FIN_SEMANA

FROM DUAL

CONNECT By ROWNUM <= ( (ADD_MONTHS(TRUNC((TO_DATE(:FEC_INI_RESUMEN, 'DD/MM/YYYY') + 7), 'YEAR'), 12) - 1) - TO_DATE(:FEC_INI_RESUMEN, 'DD/MM/YYYY')) / 7















/*volumenes*/


  SELECT 
  SEMANAS.FEC_INI_SEMANA, SEMANAS.FEC_FIN_SEMANA,
         SUM(CASE WHEN just.PROYECTO IN('CANTARELL', 'EK BALAM') THEN VOLUMEN ELSE NULL END) As VOL_CA,
         SUM(CASE WHEN just.PROYECTO IN('KU MALOOB ZAAP') THEN VOLUMEN ELSE NULL END) As VOL_KU
            
           
        FROM pron_just just, pron_movs movs,
        (/* CONSULTA PARA GENERAR TODAS LAS SEMANAS ENTRE 2 FECHAS */
             SELECT
                ROWNUM As NUM_SEMANA,
                TO_DATE(:FEC_INI_RESUMEN, 'DD/MM/YYYY') + (ROWNUM-1) * 7 As FEC_INI_SEMANA,
                TO_DATE(:FEC_INI_RESUMEN, 'DD/MM/YYYY') + (ROWNUM-1) * 7 + 6 As FEC_FIN_SEMANA
             FROM DUAL
             CONNECT By ROWNUM <= (TO_DATE(:FEC_FIN_RESUMEN, 'DD/MM/YYYY') - TO_DATE(:FEC_INI_RESUMEN, 'DD/MM/YYYY')) / 7) SEMANAS
        WHERE just.id_justificacion = movs.id_justificacion
            AND just.fecha_contable + 1 BETWEEN SEMANAS.FEC_INI_SEMANA AND SEMANAS.FEC_FIN_SEMANA
            AND just.id_det_concepto IN (59,60,61,62)
            AND movs.cve_tipo = 'P'
            AND just.proyecto IN  ( 'CANTARELL', 'EK BALAM', 'KU MALOOB ZAAP' )
       
  
   GROUP BY  SEMANAS.FEC_INI_SEMANA, SEMANAS.FEC_FIN_SEMANA