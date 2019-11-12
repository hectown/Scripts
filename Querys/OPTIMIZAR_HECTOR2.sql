WITH datos AS (
SELECT 
            just2.id_justificacion,
            just2.proyecto,
            just2.fecha_contable,
            SEMANA.FEC_INI_SEMANA AS ini_semana,
            TO_CHAR( SEMANA.FEC_INI_SEMANA, 'YYYYWW') AS semana,
            TO_CHAR( SEMANA.FEC_INI_SEMANA - 14, 'YYYYWW') AS semana_ant1,
            TO_CHAR( SEMANA.FEC_INI_SEMANA - 6, 'YYYYWW') AS semana_ant2,
            just2.id_det_concepto,
            movs2.id_instalacion,
            movs2.desc_instalacion, 'R' AS tipo       
      FROM pron_just just2, pron_movs movs2,
    (/* CONSULTA PARA GENERAR TODAS LAS SEMANAS ENTRE 2 FECHAS */
            
            SELECT

            ROWNUM As NUM_SEMANA,

            TO_DATE(:FEC_INI_RESUMEN, 'DD/MM/YYYY') + (ROWNUM-1) * 7-14 As FEC_INI_SEMANA,

            TO_DATE(:FEC_INI_RESUMEN, 'DD/MM/YYYY') + (ROWNUM-1) * 7 + 6-14 As FEC_FIN_SEMANA

            FROM DUAL

            CONNECT By ROWNUM <= (TO_DATE(:FEC_FIN_RESUMEN, 'DD/MM/YYYY') - TO_DATE(:FEC_INI_RESUMEN, 'DD/MM/YYYY')) / 7

         )SEMANA
      WHERE 
          just2.id_justificacion = movs2.id_justificacion
            AND just2.fecha_contable+1 BETWEEN SEMANA.FEC_INI_SEMANA AND SEMANA.FEC_FIN_SEMANA
            AND just2.id_det_concepto IN (59,60,61,62)
            AND movs2.cve_tipo = 'P'
      ORDER BY 3

	)



/*SELECT SEMANA,
          SUM(CASE WHEN PROYECTO IN('CANTARELL', 'EK BALAM') AND TIPO='R' THEN CONTADOR_POZOS ELSE NULL END) As REAL_POZOS_CA,
         SUM(CASE WHEN PROYECTO IN('KU MALOOB ZAAP') AND TIPO='R' THEN CONTADOR_POZOS ELSE NULL END) As REAL_POZOS_KU
FROM

(SELECT PROYECTO,TIPO,SEMANA,COUNT(DESC_INSTALACION) AS CONTADOR_POZOS
FROM
		(
    */    
                          
        SELECT DISTINCT a.proyecto, a.id_det_concepto,a.semana,a.id_instalacion, a.desc_instalacion, a.tipo
		FROM
			(
			SELECT *
			FROM datos
			) a
			
		 WHERE NOT EXISTS
            (
                SELECT 'x' FROM (
                                SELECT *
                                FROM datos
                    			) b
                 WHERE a.id_justificacion=b.id_justificacion
                 And (a.semana = b.semana_ant1 AND a.semana=b.semana_ant2)
                 And a.proyecto = b.proyecto 
                 And a.id_det_concepto = b.id_det_concepto 
                 and a.id_instalacion=b.id_instalacion
              
                
            )order by 3
  /* )
       
GROUP BY PROYECTO,TIPO,SEMANA)
GROUP BY SEMANA
*/







