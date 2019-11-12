
/*jose*/

SELECT id_concepto, tipo, num_reg,
    MAX(CASE fecha_cont WHEN TO_DATE(:FECHA_INI, 'DD/MM/YYYY') THEN pozo END) AS pozo_1,
    MAX(CASE fecha_cont WHEN TO_DATE(:FECHA_INI, 'DD/MM/YYYY') THEN volumen END) AS vol_1,
    MAX(CASE fecha_cont WHEN TO_DATE(:FECHA_INI, 'DD/MM/YYYY') + 1 THEN pozo END) AS pozo_2,
    MAX(CASE fecha_cont WHEN TO_DATE(:FECHA_INI, 'DD/MM/YYYY') + 1 THEN volumen END) AS vol_2,
    MAX(CASE fecha_cont WHEN TO_DATE(:FECHA_INI, 'DD/MM/YYYY') + 2 THEN pozo END) AS pozo_3,
    MAX(CASE fecha_cont WHEN TO_DATE(:FECHA_INI, 'DD/MM/YYYY') + 2 THEN volumen END) AS vol_3,
    MAX(CASE fecha_cont WHEN TO_DATE(:FECHA_INI, 'DD/MM/YYYY') + 3 THEN pozo END) AS pozo_4,
    MAX(CASE fecha_cont WHEN TO_DATE(:FECHA_INI, 'DD/MM/YYYY') + 3 THEN volumen END) AS vol_4,
    MAX(CASE fecha_cont WHEN TO_DATE(:FECHA_INI, 'DD/MM/YYYY') + 4 THEN pozo END) AS pozo_5,
    MAX(CASE fecha_cont WHEN TO_DATE(:FECHA_INI, 'DD/MM/YYYY') + 4 THEN volumen END) AS vol_5,
    MAX(CASE fecha_cont WHEN TO_DATE(:FECHA_INI, 'DD/MM/YYYY') + 5 THEN pozo END) AS pozo_6,
    MAX(CASE fecha_cont WHEN TO_DATE(:FECHA_INI, 'DD/MM/YYYY') + 5 THEN volumen END) AS vol_6,
    MAX(CASE fecha_cont WHEN TO_DATE(:FECHA_INI, 'DD/MM/YYYY') + 6 THEN pozo END) AS pozo_7,
    MAX(CASE fecha_cont WHEN TO_DATE(:FECHA_INI, 'DD/MM/YYYY') + 6 THEN volumen END) AS vol_7,
    MIN(contador_pozos) As CONTADOR
FROM
    (
    SELECT a.fecha_cont, a.id_concepto, a.tipo, val.num_reg,
        SUBSTR(val.pozo, 1, LENGTH(val.pozo) - 1 ) AS pozo,
        val.volumen, cont.contador_pozos
    FROM
        (
        SELECT fec_id.fecha_cont, fec_id.id_concepto, fec_id.tipo,
            regs.num_reg
        FROM 
            (
            SELECT *
            FROM
                (
                SELECT
                    ROWNUM + TO_DATE(:FECHA_INI, 'DD/MM/YYYY') - 1 AS fecha_cont        
                FROM DUAL
                CONNECT BY ROWNUM <= 7
                ) fechas,    
                (
                SELECT ROWNUM + 58 AS id_concepto
                FROM DUAL
                CONNECT BY ROWNUM <= 4
                ) ids,
                (
                SELECT 'P' AS tipo FROM DUAL
                UNION ALL
                SELECT 'R' AS tipo FROM DUAL
                ) tipos
            ) fec_id,
            (        
            SELECT just1.id_justificacion AS id, just1.proyecto, just1.fecha_contable + 1 AS fecha_contable,
                just1.id_det_concepto,
                sum(1) over(PARTITION By just1.fecha_contable, just1.id_det_concepto order by just1.fecha_contable, just1.id_det_concepto, just1.id_justificacion) AS num_reg, 'R' AS tipo
            FROM pron_just just1, pron_movs movs1
            WHERE just1.id_justificacion = movs1.id_justificacion
                AND just1.fecha_contable + 1 BETWEEN 
                    TO_DATE(:FECHA_INI, 'DD/MM/YYYY') AND TO_DATE(:FECHA_FIN, 'DD/MM/YYYY')
                AND just1.id_det_concepto IN (59,60,61,62)
                AND movs1.cve_tipo = 'P'
                AND just1.proyecto IN (:ACTIVO)
            GROUP BY just1.id_justificacion, just1.proyecto, just1.fecha_contable,
                just1.id_det_concepto, just1.consec2
                
            UNION ALL
            
            SELECT just1.id_just_pos AS id, just1.proyecto, just1.fecha_contable + 1 AS fecha_contable,
            just1.id_det_concepto, 
            sum(1) over(PARTITION By just1.fecha_contable, just1.id_det_concepto order by just1.fecha_contable, just1.id_det_concepto, just1.id_just_pos) AS num_reg, 'P' AS tipo 
            from datawarezm.mne_ace_just_pos just1, datawarezm.mne_ace_movs_pos movs1
            WHERE just1.id_just_pos = movs1.id_just_pos
            AND just1.fecha_contable + 1 BETWEEN 
                    TO_DATE(:FECHA_INI, 'DD/MM/YYYY') AND TO_DATE(:FECHA_FIN, 'DD/MM/YYYY')
            AND just1.id_det_concepto IN (59,60,61,62)
            AND movs1.cve_tipo = 'P'
            AND just1.proyecto IN (:ACTIVO)
            GROUP BY just1.id_just_pos, just1.proyecto, just1.fecha_contable,
            just1.id_det_concepto, just1.consec2

            ) regs
        WHERE fec_id.id_concepto = regs.id_det_concepto(+)
            AND fec_id.fecha_cont = regs.fecha_contable(+)
            AND fec_id.tipo = regs.tipo(+)
        ) a,
        
        (----real
        SELECT just.id_justificacion AS id, just.proyecto, just.fecha_contable + 1 AS fecha_contable,
            volumen, just.id_det_concepto, 
            COUNT(DISTINCT MOVS.DESC_INSTALACION) As CONTADOR,
            TRIM(RTRIM( EXTRACT( XMLAGG( XMLELEMENT("VALS",
                CASE WHEN movs.desc_instalacion IS NOT NULL THEN
                        CASE WHEN (SELECT COUNT(*) FROM pron_just just2, pron_movs movs2 WHERE just2.id_justificacion = movs2.id_justificacion And just2.fecha_contable between TO_DATE(:FECHA_INI, 'DD/MM/YYYY') - 15 And TO_DATE(:FECHA_INI, 'DD/MM/YYYY') - 2 And just2.id_det_concepto = just.id_det_concepto And just2.proyecto = just.proyecto And movs2.cve_tipo = 'P' And movs2.id_instalacion = movs.id_instalacion) > 0 THEN
                            '* '
                        WHEN (SELECT COUNT(*) FROM datawarezm.mne_ace_just_pos just2, datawarezm.mne_ace_movs_pos movs2 WHERE just2.id_just_pos = movs2.id_just_pos And just2.fecha_contable between TO_DATE(:FECHA_INI, 'DD/MM/YYYY') - 1 And TO_DATE(:FECHA_FIN, 'DD/MM/YYYY') - 1 And just2.id_det_concepto = just.id_det_concepto And movs2.cve_tipo = 'P' And movs2.id_instalacion = movs.id_instalacion) = 0 THEN
                            '** '
                        ELSE NULL 
                    END ||  movs.desc_instalacion
                || CHR(13) END)
                ORDER BY movs.desc_instalacion),
                '//text()'),',')) AS pozo,
            'R' AS tipo, sum(1) over(PARTITION By just.fecha_contable, just.id_det_concepto order by just.fecha_contable, just.id_det_concepto, just.id_justificacion) as num_reg
        FROM pron_just just, pron_movs movs
        WHERE just.id_justificacion = movs.id_justificacion
            AND just.fecha_contable + 1 BETWEEN 
                    TO_DATE(:FECHA_INI, 'DD/MM/YYYY') AND TO_DATE(:FECHA_FIN, 'DD/MM/YYYY')
            AND just.id_det_concepto IN (59,60,61,62)
            AND movs.cve_tipo = 'P'
            AND just.proyecto IN (:ACTIVO)
        GROUP BY just.id_justificacion, just.proyecto, just.fecha_contable,
            volumen, just.id_det_concepto, just.consec1
            
        UNION ALL
        
         ---Programado      
        SELECT just.id_just_pos AS id, just.proyecto, just.fecha_contable + 1 AS fecha_contable,volumen, just.id_det_concepto,
        COUNT(DISTINCT MOVS.DESC_INSTALACION) As CONTADOR, 
        TRIM(RTRIM( EXTRACT( XMLAGG( XMLELEMENT("VALS",
        CASE WHEN movs.desc_instalacion IS NOT NULL THEN
        CASE WHEN (SELECT COUNT(*) FROM pron_just just2, pron_movs movs2 WHERE just2.id_justificacion = movs2.id_justificacion And just2.fecha_contable between TO_DATE(:FECHA_INI, 'DD/MM/YYYY') - 8 And TO_DATE(:FECHA_INI, 'DD/MM/YYYY') - 2 And just2.id_det_concepto = just.id_det_concepto And movs2.cve_tipo = 'P' And movs2.id_instalacion = movs.id_instalacion) > 0 THEN
                            ' * '
                       WHEN (SELECT COUNT(*) FROM datawarezm.mne_ace_just_pos just2, datawarezm.mne_ace_movs_pos movs2 WHERE just2.id_just_pos = movs2.id_just_pos And just2.fecha_contable between TO_DATE(:FECHA_INI, 'DD/MM/YYYY') - 1 And TO_DATE(:FECHA_FIN, 'DD/MM/YYYY') - 1 And just2.id_det_concepto = just.id_det_concepto And movs2.cve_tipo = 'P' And movs2.id_instalacion = movs.id_instalacion  And just2.realizado='R') > 0 THEN
                       ' * '
                       WHEN (SELECT COUNT(*) FROM datawarezm.mne_ace_just_pos just2, datawarezm.mne_ace_movs_pos movs2 WHERE just2.id_just_pos = movs2.id_just_pos And just2.fecha_contable between TO_DATE(:FECHA_INI, 'DD/MM/YYYY') - 1 And TO_DATE(:FECHA_FIN, 'DD/MM/YYYY') - 1 And just2.id_det_concepto = just.id_det_concepto And just2.proyecto = just.proyecto And movs2.cve_tipo = 'P' And movs2.id_instalacion = movs.id_instalacion) = 0 THEN
                        ''
                       ELSE NULL 
                    END ||  movs.desc_instalacion
                || CHR(13) END)
                ORDER BY movs.desc_instalacion),
                '//text()'),',')) AS pozo,
            'P' AS tipo, sum(1) over(PARTITION By just.fecha_contable, just.id_det_concepto order by just.fecha_contable, just.id_det_concepto, just.id_just_pos) as num_reg  
        FROM datawarezm.mne_ace_just_pos just,     datawarezm.mne_ace_movs_pos movs
        WHERE just.id_just_pos = movs.id_just_pos
            AND just.fecha_contable + 1 BETWEEN 
                    TO_DATE(:FECHA_INI, 'DD/MM/YYYY') AND TO_DATE(:FECHA_FIN, 'DD/MM/YYYY')
            AND just.id_det_concepto IN (59,60,61,62)
            AND movs.cve_tipo = 'P'
            AND just.proyecto IN (:ACTIVO)
    GROUP BY just.id_just_pos, just.proyecto, just.fecha_contable,
            volumen, just.id_det_concepto, just.consec1  
            
        ) val,
        (SELECT just.id_det_concepto, 
            COUNT(DISTINCT MOVS.ID_INSTALACION) As contador_pozos,
            'R' AS tipo, 1 AS num_reg
        FROM pron_just just, pron_movs movs
        WHERE just.id_justificacion = movs.id_justificacion
            AND just.fecha_contable + 1 BETWEEN 
                    TO_DATE(:FECHA_INI, 'DD/MM/YYYY') AND TO_DATE(:FECHA_FIN, 'DD/MM/YYYY')
            AND just.id_det_concepto IN (59,60,61,62)
            AND movs.cve_tipo = 'P'
            AND just.proyecto IN (:ACTIVO)
            AND NOT EXISTS(SELECT 'x' FROM pron_just just2, pron_movs movs2 WHERE just2.id_justificacion = movs2.id_justificacion And just2.fecha_contable between TO_DATE(:FECHA_INI, 'DD/MM/YYYY') - 8 And TO_DATE(:FECHA_INI, 'DD/MM/YYYY') - 2 And just2.id_det_concepto = just.id_det_concepto And just2.proyecto = just.proyecto And movs2.cve_tipo = 'P' And movs2.id_instalacion = movs.id_instalacion)      
        GROUP BY just.id_det_concepto
            
        UNION ALL
        
        SELECT just.id_det_concepto, 
        COUNT(DISTINCT MOVS.ID_INSTALACION) As contador_pozos,
        'P' AS tipo, 1 AS num_reg
        FROM datawarezm.mne_ace_just_pos just, datawarezm.mne_ace_movs_pos movs
        WHERE just.id_just_pos = movs.id_just_pos
        AND just.fecha_contable + 1 BETWEEN 
                    TO_DATE(:FECHA_INI, 'DD/MM/YYYY') AND TO_DATE(:FECHA_FIN, 'DD/MM/YYYY')
        AND just.id_det_concepto IN (59,60,61,62)
        AND movs.cve_tipo = 'P'
        AND just.proyecto IN (:ACTIVO)
          AND NOT EXISTS(SELECT 'x' FROM pron_just just2, pron_movs movs2 WHERE just2.id_justificacion = movs2.id_justificacion And just2.fecha_contable between TO_DATE(:FECHA_INI, 'DD/MM/YYYY') - 8 And TO_DATE(:FECHA_INI, 'DD/MM/YYYY') - 2 And just2.id_det_concepto = just.id_det_concepto And just2.proyecto = just.proyecto And movs2.cve_tipo = 'P' And movs2.id_instalacion = movs.id_instalacion)      
         AND NOT EXISTS (SELECT 'x' FROM datawarezm.mne_ace_just_pos just2, datawarezm.mne_ace_movs_pos movs2 WHERE just2.id_just_pos = movs2.id_just_pos And just2.fecha_contable between TO_DATE(:FECHA_INI, 'DD/MM/YYYY') - 1 And TO_DATE(:FECHA_FIN, 'DD/MM/YYYY') - 1 And just2.id_det_concepto = just.id_det_concepto And movs2.cve_tipo = 'P' And movs2.id_instalacion = movs.id_instalacion  And just2.realizado='R')
        GROUP BY just.id_det_concepto) cont
    
    WHERE a.id_concepto = val.id_det_concepto(+)
      AND a.num_reg=val.num_reg(+)
        AND a.fecha_cont = val.fecha_contable(+)
        AND a.tipo = val.tipo(+)
        AND a.id_concepto = cont.id_det_concepto(+)
        AND a.num_reg = cont.num_reg(+)
        AND a.tipo = cont.tipo(+)
    )
    
GROUP BY id_concepto, tipo, num_reg
ORDER BY 1, 2, 3






/*YO*/


SELECT id_concepto, tipo, num_reg,
    MAX(CASE fecha_cont WHEN TO_DATE(:FECHA_INI, 'DD/MM/YYYY') THEN pozo END) AS pozo_1,
    MAX(CASE fecha_cont WHEN TO_DATE(:FECHA_INI, 'DD/MM/YYYY') THEN volumen END) AS vol_1,
    MAX(CASE fecha_cont WHEN TO_DATE(:FECHA_INI, 'DD/MM/YYYY') + 1 THEN pozo END) AS pozo_2,
    MAX(CASE fecha_cont WHEN TO_DATE(:FECHA_INI, 'DD/MM/YYYY') + 1 THEN volumen END) AS vol_2,
    MAX(CASE fecha_cont WHEN TO_DATE(:FECHA_INI, 'DD/MM/YYYY') + 2 THEN pozo END) AS pozo_3,
    MAX(CASE fecha_cont WHEN TO_DATE(:FECHA_INI, 'DD/MM/YYYY') + 2 THEN volumen END) AS vol_3,
    MAX(CASE fecha_cont WHEN TO_DATE(:FECHA_INI, 'DD/MM/YYYY') + 3 THEN pozo END) AS pozo_4,
    MAX(CASE fecha_cont WHEN TO_DATE(:FECHA_INI, 'DD/MM/YYYY') + 3 THEN volumen END) AS vol_4,
    MAX(CASE fecha_cont WHEN TO_DATE(:FECHA_INI, 'DD/MM/YYYY') + 4 THEN pozo END) AS pozo_5,
    MAX(CASE fecha_cont WHEN TO_DATE(:FECHA_INI, 'DD/MM/YYYY') + 4 THEN volumen END) AS vol_5,
    MAX(CASE fecha_cont WHEN TO_DATE(:FECHA_INI, 'DD/MM/YYYY') + 5 THEN pozo END) AS pozo_6,
    MAX(CASE fecha_cont WHEN TO_DATE(:FECHA_INI, 'DD/MM/YYYY') + 5 THEN volumen END) AS vol_6,
    MAX(CASE fecha_cont WHEN TO_DATE(:FECHA_INI, 'DD/MM/YYYY') + 6 THEN pozo END) AS pozo_7,
    MAX(CASE fecha_cont WHEN TO_DATE(:FECHA_INI, 'DD/MM/YYYY') + 6 THEN volumen END) AS vol_7,
    MIN(contador_pozos) As CONTADOR
FROM
    (
    SELECT a.fecha_cont, a.id_concepto, a.tipo, a.num_reg,
        SUBSTR(val.pozo, 1, LENGTH(val.pozo) - 1 ) AS pozo,
        val.volumen, cont.contador_pozos
    FROM
        (
        SELECT fec_id.fecha_cont, fec_id.id_concepto, fec_id.tipo,
            regs.num_reg
        FROM 
            (
            SELECT *
            FROM
                (
                SELECT
                    ROWNUM + TO_DATE(:FECHA_INI, 'DD/MM/YYYY') - 1 AS fecha_cont        
                FROM DUAL
                CONNECT BY ROWNUM <= 7
                ) fechas,    
                (
                SELECT ROWNUM + 58 AS id_concepto
                FROM DUAL
                CONNECT BY ROWNUM <= 4
                ) ids,
                (
                SELECT 'P' AS tipo FROM DUAL
                UNION ALL
                SELECT 'R' AS tipo FROM DUAL
                ) tipos
            ) fec_id,
            (        
            SELECT just1.id_justificacion AS id, just1.proyecto, just1.fecha_contable + 1 AS fecha_contable,
                just1.id_det_concepto, just1.consec1 AS num_reg, 'R' AS tipo
            FROM pron_just just1, pron_movs movs1
            WHERE just1.id_justificacion = movs1.id_justificacion
                AND just1.fecha_contable + 1 BETWEEN 
                    TO_DATE(:FECHA_INI, 'DD/MM/YYYY') AND TO_DATE(:FECHA_FIN, 'DD/MM/YYYY')
                AND just1.id_det_concepto IN (59,60,61,62)
                AND movs1.cve_tipo = 'P'
                AND just1.proyecto IN (:ACTIVO)
            GROUP BY just1.id_justificacion, just1.proyecto, just1.fecha_contable,
                just1.id_det_concepto, just1.consec1
                
            UNION ALL
            
            SELECT just1.id_just_pos AS id, just1.proyecto, just1.fecha_contable + 1 AS fecha_contable,
            just1.id_det_concepto, just1.consec1 AS num_reg, 'P' AS tipo 
            from datawarezm.mne_ace_just_pos just1, datawarezm.mne_ace_movs_pos movs1
            WHERE just1.id_just_pos = movs1.id_just_pos
            AND just1.fecha_contable + 1 BETWEEN 
                    TO_DATE(:FECHA_INI, 'DD/MM/YYYY') AND TO_DATE(:FECHA_FIN, 'DD/MM/YYYY')
            AND just1.id_det_concepto IN (59,60,61,62)
            AND movs1.cve_tipo = 'P'
            AND just1.proyecto IN (:ACTIVO)
            GROUP BY just1.id_just_pos, just1.proyecto, just1.fecha_contable,
            just1.id_det_concepto, just1.consec1
                
                
            ) regs
        WHERE fec_id.id_concepto = regs.id_det_concepto(+)
            AND fec_id.fecha_cont = regs.fecha_contable(+)
            AND fec_id.tipo = regs.tipo(+)
        ) a,
        
        (----real
        SELECT just.id_justificacion AS id, just.proyecto, just.fecha_contable + 1 AS fecha_contable,
            volumen, just.id_det_concepto, 
            COUNT(DISTINCT MOVS.DESC_INSTALACION) As CONTADOR,
            TRIM(RTRIM( EXTRACT( XMLAGG( XMLELEMENT("VALS",
                CASE WHEN movs.desc_instalacion IS NOT NULL THEN
                        CASE WHEN (SELECT COUNT(*) FROM pron_just just2, pron_movs movs2 WHERE just2.id_justificacion = movs2.id_justificacion And just2.fecha_contable between TO_DATE(:FECHA_INI, 'DD/MM/YYYY') - 15 And TO_DATE(:FECHA_INI, 'DD/MM/YYYY') - 2 And just2.id_det_concepto = just.id_det_concepto And just2.proyecto = just.proyecto And movs2.cve_tipo = 'P' And movs2.id_instalacion = movs.id_instalacion) > 0 THEN
                            '* '
                        WHEN (SELECT COUNT(*) FROM datawarezm.mne_ace_just_pos just2, datawarezm.mne_ace_movs_pos movs2 WHERE just2.id_just_pos = movs2.id_just_pos And just2.fecha_contable between TO_DATE(:FECHA_INI, 'DD/MM/YYYY') - 1 And TO_DATE(:FECHA_FIN, 'DD/MM/YYYY') - 1 And just2.id_det_concepto = just.id_det_concepto And movs2.cve_tipo = 'P' And movs2.id_instalacion = movs.id_instalacion) = 0 THEN
                            '** '
                        ELSE NULL 
                    END ||  movs.desc_instalacion
                || CHR(13) END)
                ORDER BY movs.desc_instalacion),
                '//text()'),',')) AS pozo,
            'R' AS tipo, just.consec1 AS num_reg 
        FROM pron_just just, pron_movs movs
        WHERE just.id_justificacion = movs.id_justificacion
            AND just.fecha_contable + 1 BETWEEN 
                    TO_DATE(:FECHA_INI, 'DD/MM/YYYY') AND TO_DATE(:FECHA_FIN, 'DD/MM/YYYY')
            AND just.id_det_concepto IN (59,60,61,62)
            AND movs.cve_tipo = 'P'
            AND just.proyecto IN (:ACTIVO)
        GROUP BY just.id_justificacion, just.proyecto, just.fecha_contable,
            volumen, just.id_det_concepto, just.consec1
            
        UNION ALL
        
         ---Programado      
        SELECT just.id_just_pos AS id, just.proyecto, just.fecha_contable + 1 AS fecha_contable,volumen, just.id_det_concepto,
        COUNT(DISTINCT MOVS.DESC_INSTALACION) As CONTADOR, 
        TRIM(RTRIM( EXTRACT( XMLAGG( XMLELEMENT("VALS",
        CASE WHEN movs.desc_instalacion IS NOT NULL THEN
        CASE WHEN (SELECT COUNT(*) FROM pron_just just2, pron_movs movs2 WHERE just2.id_justificacion = movs2.id_justificacion And just2.fecha_contable between TO_DATE(:FECHA_INI, 'DD/MM/YYYY') - 8 And TO_DATE(:FECHA_INI, 'DD/MM/YYYY') - 2 And just2.id_det_concepto = just.id_det_concepto And movs2.cve_tipo = 'P' And movs2.id_instalacion = movs.id_instalacion) > 0 THEN
                            ' * '
                       WHEN (SELECT COUNT(*) FROM datawarezm.mne_ace_just_pos just2, datawarezm.mne_ace_movs_pos movs2 WHERE just2.id_just_pos = movs2.id_just_pos And just2.fecha_contable between TO_DATE(:FECHA_INI, 'DD/MM/YYYY') - 1 And TO_DATE(:FECHA_FIN, 'DD/MM/YYYY') - 1 And just2.id_det_concepto = just.id_det_concepto And movs2.cve_tipo = 'P' And movs2.id_instalacion = movs.id_instalacion  And just2.realizado='R') > 0 THEN
                       ' * '
                       WHEN (SELECT COUNT(*) FROM datawarezm.mne_ace_just_pos just2, datawarezm.mne_ace_movs_pos movs2 WHERE just2.id_just_pos = movs2.id_just_pos And just2.fecha_contable between TO_DATE(:FECHA_INI, 'DD/MM/YYYY') - 1 And TO_DATE(:FECHA_FIN, 'DD/MM/YYYY') - 1 And just2.id_det_concepto = just.id_det_concepto And just2.proyecto = just.proyecto And movs2.cve_tipo = 'P' And movs2.id_instalacion = movs.id_instalacion) = 0 THEN
                        ''
                       ELSE NULL 
                    END ||  movs.desc_instalacion
                || CHR(13) END)
                ORDER BY movs.desc_instalacion),
                '//text()'),',')) AS pozo,
            'P' AS tipo, just.consec1 AS num_reg   
        FROM datawarezm.mne_ace_just_pos just,     datawarezm.mne_ace_movs_pos movs
        WHERE just.id_just_pos = movs.id_just_pos
            AND just.fecha_contable + 1 BETWEEN 
                    TO_DATE(:FECHA_INI, 'DD/MM/YYYY') AND TO_DATE(:FECHA_FIN, 'DD/MM/YYYY')
            AND just.id_det_concepto IN (59,60,61,62)
            AND movs.cve_tipo = 'P'
            AND just.proyecto IN (:ACTIVO)
    GROUP BY just.id_just_pos, just.proyecto, just.fecha_contable,
            volumen, just.id_det_concepto, just.consec1  
            
        ) val,
       
    
    
     (
        


SELECT RENGLON.NUM_REG,CONT.ID_DET_CONCEPTO,CONT.CONTADOR_POZOS,CONT.TIPO

FROM
(SELECT just.id_det_concepto, 
            COUNT(DISTINCT MOVS.ID_INSTALACION) As contador_pozos,
            'R' AS tipo, 1 AS num_reg
        FROM pron_just just, pron_movs movs
        WHERE just.id_justificacion = movs.id_justificacion
            AND just.fecha_contable + 1 BETWEEN 
                    TO_DATE(:FECHA_INI, 'DD/MM/YYYY') AND TO_DATE(:FECHA_FIN, 'DD/MM/YYYY')
            AND just.id_det_concepto IN (59,61,60,62)
            AND movs.cve_tipo = 'P'
            AND just.proyecto IN (:ACTIVO)
            AND NOT EXISTS(SELECT 'x' FROM pron_just just2, pron_movs movs2 WHERE just2.id_justificacion = movs2.id_justificacion And just2.fecha_contable between TO_DATE(:FECHA_INI, 'DD/MM/YYYY') - 8 And TO_DATE(:FECHA_INI, 'DD/MM/YYYY') - 2 And just2.id_det_concepto = just.id_det_concepto And just2.proyecto = just.proyecto And movs2.cve_tipo = 'P' And movs2.id_instalacion = movs.id_instalacion)      
        GROUP BY just.id_det_concepto
            
        UNION ALL
        
        SELECT just.id_det_concepto,
        COUNT(DISTINCT MOVS.ID_INSTALACION) As contador_pozos,
        'P' AS tipo, 1 AS num_reg
        FROM datawarezm.mne_ace_just_pos just, datawarezm.mne_ace_movs_pos movs
        WHERE just.id_just_pos = movs.id_just_pos
        AND just.fecha_contable + 1 BETWEEN 
                    TO_DATE(:FECHA_INI, 'DD/MM/YYYY') AND TO_DATE(:FECHA_FIN, 'DD/MM/YYYY')
        AND just.id_det_concepto IN (59,61,60,62)
        AND movs.cve_tipo = 'P'
        AND just.proyecto IN (:ACTIVO)
          AND NOT EXISTS(SELECT 'x' FROM pron_just just2, pron_movs movs2 WHERE just2.id_justificacion = movs2.id_justificacion And just2.fecha_contable between TO_DATE(:FECHA_INI, 'DD/MM/YYYY') - 8 And TO_DATE(:FECHA_INI, 'DD/MM/YYYY') - 2 And just2.id_det_concepto = just.id_det_concepto And just2.proyecto = just.proyecto And movs2.cve_tipo = 'P' And movs2.id_instalacion = movs.id_instalacion)      
         AND NOT EXISTS (SELECT 'x' FROM datawarezm.mne_ace_just_pos just2, datawarezm.mne_ace_movs_pos movs2 WHERE just2.id_just_pos = movs2.id_just_pos And just2.fecha_contable between TO_DATE(:FECHA_INI, 'DD/MM/YYYY') - 1 And TO_DATE(:FECHA_FIN, 'DD/MM/YYYY') - 1 And just2.id_det_concepto = just.id_det_concepto And movs2.cve_tipo = 'P' And movs2.id_instalacion = movs.id_instalacion  And just2.realizado='R')
        GROUP BY just.id_det_concepto) CONT,


(SELECT 
CASE 
        WHEN ID_DET_CONCEPTO=59 AND TIPO='R' THEN MIN(NUM_REG)
        WHEN ID_DET_CONCEPTO=59 AND TIPO='P' THEN MIN(NUM_REG)
        WHEN ID_DET_CONCEPTO=61 AND TIPO='R' THEN MIN(NUM_REG)
        WHEN ID_DET_CONCEPTO=61 AND TIPO='P' THEN MIN(NUM_REG) 
        WHEN ID_DET_CONCEPTO=60 AND TIPO='R' THEN MIN(NUM_REG)
        WHEN ID_DET_CONCEPTO=60 AND TIPO='P' THEN MIN(NUM_REG)
        WHEN ID_DET_CONCEPTO=62 AND TIPO='R' THEN MIN(NUM_REG)
        WHEN ID_DET_CONCEPTO=62 AND TIPO='P' THEN MIN(NUM_REG)
        ELSE NULL
END AS NUM_REG,ID_DET_CONCEPTO,TIPO

FROM

 (----real
        SELECT just.id_det_concepto, 
           
            'R' AS tipo, just.consec1 AS num_reg
        FROM pron_just just, pron_movs movs
        WHERE just.id_justificacion = movs.id_justificacion
            AND just.fecha_contable + 1 BETWEEN 
                    TO_DATE(:FECHA_INI, 'DD/MM/YYYY') AND TO_DATE(:FECHA_FIN, 'DD/MM/YYYY')
            AND just.id_det_concepto IN (59,60,61,62)
            AND movs.cve_tipo = 'P'
            AND just.proyecto IN (:ACTIVO)
        GROUP BY just.id_justificacion, just.proyecto, just.fecha_contable,
            volumen, just.id_det_concepto, just.consec1
            
        UNION ALL
        
         ---Programado      
        SELECT just.id_det_concepto,
           'P' AS tipo, just.consec1 AS num_reg       
        FROM datawarezm.mne_ace_just_pos just,     datawarezm.mne_ace_movs_pos movs
        WHERE just.id_just_pos = movs.id_just_pos
            AND just.fecha_contable + 1 BETWEEN 
                    TO_DATE(:FECHA_INI, 'DD/MM/YYYY') AND TO_DATE(:FECHA_FIN, 'DD/MM/YYYY')
            AND just.id_det_concepto IN (59,60,61,62)
            AND movs.cve_tipo = 'P'
            AND just.proyecto IN (:ACTIVO)
    GROUP BY just.id_just_pos, just.proyecto, just.fecha_contable,
            volumen, just.id_det_concepto, just.consec1  
            
        ) 

GROUP BY ID_DET_CONCEPTO,TIPO)RENGLON

WHERE CONT.ID_DET_CONCEPTO=RENGLON.ID_DET_CONCEPTO(+)
AND CONT.TIPO=RENGLON.TIPO(+)

 
        
        
        ) cont
    
    WHERE a.id_concepto = val.id_det_concepto(+)
      AND a.num_reg=val.num_reg(+)
       AND a.num_reg=cont.num_reg(+)
        AND a.fecha_cont = val.fecha_contable(+)
        AND a.tipo = val.tipo(+)
        AND a.id_concepto = cont.id_det_concepto(+)
        AND a.num_reg = cont.num_reg(+)
        AND a.tipo = cont.tipo(+)
    )
    
GROUP BY id_concepto, tipo, num_reg
ORDER BY 1, 2, 3






/*etiqueta PROGRAMADO*/




SELECT ACTIVO,SUM(CONTADOR_POZOS) AS POZOS, SUM(VOLUMEN) AS VOLUMEN
FROM

(SELECT
            val.activo, val.id_det_concepto, val.volumen,
            val.tipo,
            cont.contador_pozos
    FROM
        (
       SELECT DECODE(just.proyecto, 'EK BALAM', 'CANTARELL', just.proyecto) As activo,
            SUM(just.volumen) As volumen, just.id_det_concepto,
            'R' AS tipo
        FROM pron_just just
        WHERE 
                  just.fecha_contable + 1 BETWEEN 
                    TO_DATE(:FECHA_INI, 'DD/MM/YYYY') AND TO_DATE(:FECHA_FIN, 'DD/MM/YYYY')
            AND just.id_det_concepto IN (59,60,61,62)
            AND just.proyecto IN ('CANTARELL', 'EK BALAM', 'KU MALOOB ZAAP')
            
        GROUP BY DECODE(just.proyecto, 'EK BALAM', 'CANTARELL', just.proyecto), just.id_det_concepto
            
        UNION ALL
              
        
        
        SELECT PROYECTO,SUM(VOLUMEN) AS VOLUMEN,ID_DET_CONCEPTO,'P' AS TIPO
        FROM
        
        (SELECT just.id_just_pos AS id, just.proyecto AS PROYECTO, just.fecha_contable + 1 AS fecha_contable,volumen, just.id_det_concepto,
        COUNT(DISTINCT MOVS.DESC_INSTALACION) As CONTADOR, 
        TRIM(RTRIM( EXTRACT( XMLAGG( XMLELEMENT("VALS",
        CASE WHEN movs.desc_instalacion IS NOT NULL THEN
        CASE WHEN (SELECT COUNT(*) FROM pron_just just2, pron_movs movs2 WHERE just2.id_justificacion = movs2.id_justificacion And just2.fecha_contable between TO_DATE(:FECHA_INI, 'DD/MM/YYYY') - 8 And TO_DATE(:FECHA_INI, 'DD/MM/YYYY') - 2 And just2.id_det_concepto = just.id_det_concepto And movs2.cve_tipo = 'P' And movs2.id_instalacion = movs.id_instalacion) > 0 THEN
                            ' * '
                       WHEN (SELECT COUNT(*) FROM datawarezm.mne_ace_just_pos just2, datawarezm.mne_ace_movs_pos movs2 WHERE just2.id_just_pos = movs2.id_just_pos And just2.fecha_contable between TO_DATE(:FECHA_INI, 'DD/MM/YYYY') - 1 And TO_DATE(:FECHA_FIN, 'DD/MM/YYYY') - 1 And just2.id_det_concepto = just.id_det_concepto And movs2.cve_tipo = 'P' And movs2.id_instalacion = movs.id_instalacion  And just2.realizado='R') > 0 THEN
                       ' * '
                       WHEN (SELECT COUNT(*) FROM datawarezm.mne_ace_just_pos just2, datawarezm.mne_ace_movs_pos movs2 WHERE just2.id_just_pos = movs2.id_just_pos And just2.fecha_contable between TO_DATE(:FECHA_INI, 'DD/MM/YYYY') - 1 And TO_DATE(:FECHA_FIN, 'DD/MM/YYYY') - 1 And just2.id_det_concepto = just.id_det_concepto And just2.proyecto = just.proyecto And movs2.cve_tipo = 'P' And movs2.id_instalacion = movs.id_instalacion) = 0 THEN
                        ''
                       ELSE NULL 
                    END ||  movs.desc_instalacion
                || CHR(13) END)
                ORDER BY movs.desc_instalacion),
                '//text()'),',')) AS pozo,
            'P' AS tipo, just.consec2 AS num_reg       
        FROM datawarezm.mne_ace_just_pos just,     datawarezm.mne_ace_movs_pos movs
        WHERE just.id_just_pos = movs.id_just_pos
            AND just.fecha_contable + 1 BETWEEN 
                    TO_DATE(:FECHA_INI, 'DD/MM/YYYY') AND TO_DATE(:FECHA_FIN, 'DD/MM/YYYY')
            AND just.id_det_concepto IN (59,60,61,62)
            AND movs.cve_tipo = 'P'
            AND just.proyecto IN (:ACTIVO)
    GROUP BY just.id_just_pos, just.proyecto, just.fecha_contable,
            volumen, just.id_det_concepto, just.consec2 ) 
            GROUP BY PROYECTO,ID_DET_CONCEPTO
    
    
    
        
       
        ) val,
        (SELECT
            DECODE(just.proyecto, 'EK BALAM', 'CANTARELL', just.proyecto) As activo,
           just.id_det_concepto, 
            COUNT(DISTINCT MOVS.ID_INSTALACION) As contador_pozos,
            'R' AS tipo
        FROM pron_just just, pron_movs movs
        WHERE just.id_justificacion = movs.id_justificacion
            AND just.fecha_contable + 1 BETWEEN 
                    TO_DATE(:FECHA_INI, 'DD/MM/YYYY') AND TO_DATE(:FECHA_FIN, 'DD/MM/YYYY')
            AND just.id_det_concepto IN (59,60,61,62)
            AND movs.cve_tipo = 'P'
            AND just.proyecto IN (:ACTIVO)
          AND NOT EXISTS(SELECT 'x' FROM pron_just just2, pron_movs movs2 WHERE just2.id_justificacion = movs2.id_justificacion And just2.fecha_contable between TO_DATE(:FECHA_INI, 'DD/MM/YYYY') - 8 And TO_DATE(:FECHA_INI, 'DD/MM/YYYY') - 2 And just2.id_det_concepto = just.id_det_concepto And just2.proyecto = just.proyecto And movs2.cve_tipo = 'P' And movs2.id_instalacion = movs.id_instalacion)      
         GROUP BY DECODE(just.proyecto, 'EK BALAM', 'CANTARELL', just.proyecto), just.id_det_concepto
            
        UNION ALL
        
        SELECT
            DECODE(just.proyecto, 'EK BALAM', 'CANTARELL', just.proyecto) As activo,
            just.id_det_concepto, 
            COUNT(DISTINCT MOVS.ID_INSTALACION) As contador_pozos,
            'P' AS tipo
        FROM datawarezm.mne_ace_just_pos just, datawarezm.mne_ace_movs_pos movs
        WHERE just.id_just_pos = movs.id_just_pos
        AND just.fecha_contable + 1 BETWEEN 
                    TO_DATE(:FECHA_INI, 'DD/MM/YYYY') AND TO_DATE(:FECHA_FIN, 'DD/MM/YYYY')
        AND just.id_det_concepto IN (59,60,61,62)
        AND movs.cve_tipo = 'P'
        AND just.proyecto IN  (:ACTIVO)
        AND NOT EXISTS(SELECT 'x' FROM pron_just just2, pron_movs movs2 WHERE just2.id_justificacion = movs2.id_justificacion And just2.fecha_contable between TO_DATE(:FECHA_INI, 'DD/MM/YYYY') - 8 And TO_DATE(:FECHA_INI, 'DD/MM/YYYY') - 2 And just2.id_det_concepto = just.id_det_concepto And just2.proyecto = just.proyecto And movs2.cve_tipo = 'P' And movs2.id_instalacion = movs.id_instalacion)      
       AND NOT EXISTS (SELECT 'x' FROM datawarezm.mne_ace_just_pos just2, datawarezm.mne_ace_movs_pos movs2 WHERE just2.id_just_pos = movs2.id_just_pos And just2.fecha_contable between TO_DATE(:FECHA_INI, 'DD/MM/YYYY') - 1 And TO_DATE(:FECHA_FIN, 'DD/MM/YYYY') - 1 And just2.id_det_concepto = just.id_det_concepto And movs2.cve_tipo = 'P' And movs2.id_instalacion = movs.id_instalacion  And just2.realizado='R')
        GROUP BY DECODE(just.proyecto, 'EK BALAM', 'CANTARELL', just.proyecto), just.id_det_concepto) cont
    
    WHERE
               val.activo = cont.activo(+)
        AND val.tipo = cont.tipo(+)
        AND val.id_det_concepto = cont.id_det_concepto(+))
        WHERE TIPO='P'
        GROUP BY ACTIVO