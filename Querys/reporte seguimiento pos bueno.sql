
SELECT PRON_JUST.FECHA_CONTABLE,
       POZOS.ACTIVO,
       POZOS.SECTOR,
       POZOS.ESTADO,
       PRON_JUST.CONCEPTO,
       PRON_JUST.DET_CONCEPTO,
       PRON_JUST.VOLUMEN,
       PRON_MOVS.DESC_PLATAFORMA,
       PRON_MOVS.DESC_INSTALACION,TO_CHAR(PRON_JUST.FECHA_CONTABLE,'MON') AS MESES
  FROM
  (SELECT b.activo,
       b.sector,
       b.proyecto,
       b.campo,
       b.c_proceso,
       b.bateria,
       b.plataforma,
       b.ID,
       b.poz_desc_corta,
       b.poz_desc_larga,
       b.orden,
       a.fecha_contable,
       a.tipo_pozo,
       a.estado,
       a.tipo_crudo
  FROM ( SELECT       val.id_parametros,
                                val.plataforma As ID,
                                val.fecha_contable,
                                pozormne.rmn_po_valor_cad (1124,
                                    TO_CHAR (
                                        CASE WHEN MAX(HR.HORA) <= 5 THEN val.fecha_contable + 1 ELSE val.fecha_contable END,
                                     'DD/MM/YYYY'),
                                    pozormne.DEVUELVEIDHORA(TO_CHAR (
                                        CASE WHEN MAX(HR.HORA) <= 5 THEN val.fecha_contable + 1 ELSE val.fecha_contable END,
                                     'DD/MM/YYYY'), MAX (hr.hora_desc)),
                                    val.plataforma,
                                 '') As estado,
                                 pozormne.rmn_po_valor_cad (1126,
                                    TO_CHAR (
                                        CASE WHEN MAX(HR.HORA) <= 5 THEN val.fecha_contable + 1 ELSE val.fecha_contable END,
                                     'DD/MM/YYYY'),
                                    pozormne.DEVUELVEIDHORA(TO_CHAR (
                                        CASE WHEN MAX(HR.HORA) <= 5 THEN val.fecha_contable + 1 ELSE val.fecha_contable END,
                                     'DD/MM/YYYY'), MAX (hr.hora_desc)),
                                    val.plataforma,
                                 '') As tipo_pozo,
                                 pozormne.rmn_po_valor_cad (1135,
                                    TO_CHAR (
                                        CASE WHEN MAX(HR.HORA) <= 5 THEN val.fecha_contable + 1 ELSE val.fecha_contable END,
                                     'DD/MM/YYYY'),
                                    pozormne.DEVUELVEIDHORA(TO_CHAR (
                                        CASE WHEN MAX(HR.HORA) <= 5 THEN val.fecha_contable + 1 ELSE val.fecha_contable END,
                                     'DD/MM/YYYY'), MAX (hr.hora_desc)),
                                    val.plataforma,
                                 '') As tipo_crudo
                           FROM pozormne.gas_parametros_valores val,
                                pozormne.gas_plataformas pla,
                                pozormne.gas_c_horas hr
                          WHERE     val.id_parametros = 1126
                                AND val.fecha_contable = TO_DATE(:FECHA, 'DD/MM/YYYY')
                                AND val.plataforma = pla.ID
                                AND val.id_hora = hr.id_hora
                                AND pla.tipo_inst = 'POZO'
                                AND pla.proyecto IN ('CANTARELL', 'EK-BALAM')
                       GROUP BY val.plataforma,
                                val.id_parametros,
                                val.fecha_contable) a,
       (SELECT ID,
               activo,
               sector,
               proyecto,
               c_proceso,
               bateria,
               plataforma,
               campo,
               desc_corta AS poz_desc_corta,
               desc_larga AS poz_desc_larga,
               orden,
               'POZORMNE' AS esquema_bd
          FROM pozormne.gas_plataformas
         WHERE     tipo_inst = 'POZO'
               AND proyecto IN ('CANTARELL', 'EK-BALAM')
               AND (baja > TO_DATE(:FECHA, 'DD/MM/YYYY') OR baja IS NULL)) b
 WHERE a.ID(+) = b.ID) POZOS
       INNER JOIN RDP2.PRON_JUST
          ON 1 = 1
       INNER JOIN RDP2.PRON_MOVS
          ON PRON_JUST.ID_JUSTIFICACION = PRON_MOVS.ID_JUSTIFICACION
 WHERE PRON_JUST.FECHA_CONTABLE BETWEEN TO_DATE (TRUNC (TO_DATE (:FECHA,'DD/MM/YYYY'),'YEAR'))
                                                 AND TO_DATE (:FECHA,'DD/MM/YYYY')
       AND PRON_JUST.PROYECTO IN ('CANTARELL', 'EK BALAM')
       AND PRON_MOVS.ID_INSTALACION = POZOS.ID












SELECT PRON_JUST.FECHA_CONTABLE,
       POZOS.ACTIVO,
       POZOS.SECTOR,
       POZOS.ESTADO,
       PRON_JUST.CONCEPTO,
       PRON_JUST.DET_CONCEPTO,
       PRON_JUST.VOLUMEN,
       PRON_MOVS.DESC_PLATAFORMA,
       PRON_MOVS.DESC_INSTALACION
  FROM
  (SELECT b.activo,
       b.sector,
       b.proyecto,
       b.campo,
       b.c_proceso,
       b.bateria,
       b.plataforma,
       b.ID,
       b.poz_desc_corta,
       b.poz_desc_larga,
       b.orden,
       a.fecha_contable,
       a.tipo_pozo,
       a.estado,
       a.tipo_crudo
  FROM ( SELECT         val.id_parametros,
                                val.plataforma As ID,
                                val.fecha_contable,
                                pozormne.rmn_po_valor_cad (1124,
                                    TO_CHAR (
                                        CASE WHEN MAX(HR.HORA) <= 5 THEN val.fecha_contable + 1 ELSE val.fecha_contable END,
                                     'DD/MM/YYYY'),
                                    pozormne.DEVUELVEIDHORA(TO_CHAR (
                                        CASE WHEN MAX(HR.HORA) <= 5 THEN val.fecha_contable + 1 ELSE val.fecha_contable END,
                                     'DD/MM/YYYY'), MAX (hr.hora_desc)),
                                    val.plataforma,
                                 '') As estado,
                                 pozormne.rmn_po_valor_cad (1126,
                                    TO_CHAR (
                                        CASE WHEN MAX(HR.HORA) <= 5 THEN val.fecha_contable + 1 ELSE val.fecha_contable END,
                                     'DD/MM/YYYY'),
                                    pozormne.DEVUELVEIDHORA(TO_CHAR (
                                        CASE WHEN MAX(HR.HORA) <= 5 THEN val.fecha_contable + 1 ELSE val.fecha_contable END,
                                     'DD/MM/YYYY'), MAX (hr.hora_desc)),
                                    val.plataforma,
                                 '') As tipo_pozo,
                                 pozormne.rmn_po_valor_cad (1135,
                                    TO_CHAR (
                                        CASE WHEN MAX(HR.HORA) <= 5 THEN val.fecha_contable + 1 ELSE val.fecha_contable END,
                                     'DD/MM/YYYY'),
                                    pozormne.DEVUELVEIDHORA(TO_CHAR (
                                        CASE WHEN MAX(HR.HORA) <= 5 THEN val.fecha_contable + 1 ELSE val.fecha_contable END,
                                     'DD/MM/YYYY'), MAX (hr.hora_desc)),
                                    val.plataforma,
                                 '') As tipo_crudo
                           FROM pozormne.gas_parametros_valores val,
                                pozormne.gas_plataformas pla,
                                pozormne.gas_c_horas hr
                          WHERE     val.id_parametros = 1126
                                AND val.fecha_contable = TO_DATE(:FECHA, 'DD/MM/YYYY')
                                AND val.plataforma = pla.ID
                                AND val.id_hora = hr.id_hora
                                AND pla.tipo_inst = 'POZO'
                                AND pla.proyecto IN ('CANTARELL','EK-BALAM')
                       GROUP BY val.plataforma,
                                val.id_parametros,
                                val.fecha_contable) a,
       (SELECT ID,
               activo,
               sector,
               proyecto,
               c_proceso,
               bateria,
               plataforma,
               campo,
               desc_corta AS poz_desc_corta,
               desc_larga AS poz_desc_larga,
               orden,
               'POZORMNE' AS esquema_bd
          FROM pozormne.gas_plataformas
         WHERE     tipo_inst = 'POZO'
               AND proyecto IN ('CANTARELL','EK-BALAM')
               AND (baja > TO_DATE(:FECHA, 'DD/MM/YYYY') OR baja IS NULL)) b
 WHERE a.ID(+) = b.ID) POZOS
       INNER JOIN RDP2.PRON_JUST
          ON 1 = 1
       INNER JOIN RDP2.PRON_MOVS
          ON PRON_JUST.ID_JUSTIFICACION = PRON_MOVS.ID_JUSTIFICACION
 WHERE PRON_JUST.FECHA_CONTABLE BETWEEN TO_DATE (TRUNC(TO_DATE (:FECHA,'DD/MM/YYYY'),'MONTH'))
                                                 AND  LAST_DAY(TO_DATE (:FECHA,'DD/MM/YYYY') )
       AND PRON_JUST.PROYECTO IN ('EK BALAM','CANTARELL')
       AND PRON_MOVS.ID_INSTALACION = POZOS.ID
       
       
       
       
       
       
UNION

SELECT TRUNC(FECHA_CONTABLE+ROWNUM),'CANTARELL',NULL,NULL,NULL,NULL,NULL,NULL,NULL,TO_CHAR(TRUNC(TO_DATE('18/FEB/2011','DD/MM/YYYY')+ROWNUM),'MON')
FROM DUAL , RDP2.PRON_JUST
WHERE PRON_JUST.FECHA_CONTABLE BETWEEN TO_DATE (TRUNC(TO_DATE (:FECHA,'DD/MM/YYYY'),'MONTH'))
                                                 AND  LAST_DAY(TO_DATE (:FECHA,'DD/MM/YYYY') )
CONNECT BY ROWNUM < (SELECT TO_NUMBER((TO_DATE(TRUNC(TO_DATE('18/FEB/2011','DD/MM/YYYY'),'YEAR')-1)+365) - TO_DATE('18/FEB/2011','DD/MM/YYYY')) 
FROM DUAL)+1







SELECT LAST_DAY(TO_DATE (:FECHA,'DD/MM/YYYY') ) FROM DUAL

 SELECT TRUNC(TO_DATE (:FECHA,'DD/MM/YYYY'),'MONTH') FROM DUAL
 
 
 
 
SELECT TRUNC(TO_DATE('18/FEB/2011','DD/MM/YYYY')+ROWNUM),'CANTARELL',NULL,NULL,NULL,NULL,NULL,NULL,NULL,TO_CHAR(TRUNC(TO_DATE('18/FEB/2011','DD/MM/YYYY')+ROWNUM),'MON')
FROM DUAL 
CONNECT BY ROWNUM < (SELECT TO_NUMBER((TO_DATE(TRUNC(TO_DATE('18/FEB/2011','DD/MM/YYYY'),'YEAR')-1)+365) - TO_DATE('18/FEB/2011','DD/MM/YYYY')) 
FROM DUAL)+1