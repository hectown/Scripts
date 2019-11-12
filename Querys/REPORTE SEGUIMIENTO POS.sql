gas_parametros_valores, gas_plataforma

SELECT * FROM GAS_PARAMETROS_VALORES WHERE ID_PARAMETROS='1124' 

SELECT * FROM GAS_PLATAFORMAS WHERE ACTIVO IN ('CANTARELL','EK BALAM')

SELECT * FROM RDP2.PRON_JUST WHERE PROYECTO IN ('CANTARELL','EK BALAM')

SELECT * FROM RDP2.PRON_MOVS WHERE ID_JUSTIFICACION='117'



SELECT PRON_JUST.FECHA_CONTABLE+rownum,
       POZOS.ACTIVO,
       POZOS.SECTOR,
       POZOS.ESTADO,
       PRON_JUST.CONCEPTO,
       PRON_JUST.DET_CONCEPTO,
       TO_CHAR(PRON_JUST.VOLUMEN,'FM999,999.00'),
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
 WHERE PRON_JUST.FECHA_CONTABLE BETWEEN TO_DATE (
                                                        TRUNC (
                                                           TO_DATE (
                                                              :FECHA,
                                                              'DD/MM/YYYY'),
                                                           'YEAR'))
                                                 AND TO_DATE (:FECHA,'DD/MM/YYYY')
       AND PRON_JUST.PROYECTO IN ('CANTARELL', 'EK BALAM')
       AND PRON_MOVS.ID_INSTALACION = POZOS.ID
CONNECT BY ROWNUM < (SELECT TO_NUMBER((TO_DATE(TRUNC(TO_DATE('18/FEB/2011','DD/MM/YYYY'),'YEAR')-1)+365) - TO_DATE('18/FEB/2011','DD/MM/YYYY')) 
FROM DUAL)+1










UNION

SELECT TRUNC(TO_DATE('18/FEB/2011','DD/MM/YYYY')+ROWNUM),'CANTARELL',NULL,NULL,NULL,NULL,NULL,NULL,NULL,TO_CHAR(TRUNC(TO_DATE('18/FEB/2011','DD/MM/YYYY')+ROWNUM),'MON')
FROM DUAL 
CONNECT BY ROWNUM < (SELECT TO_NUMBER((TO_DATE(TRUNC(TO_DATE('18/FEB/2011','DD/MM/YYYY'),'YEAR')-1)+365) - TO_DATE('18/FEB/2011','DD/MM/YYYY')) 
FROM DUAL)+1



SELECT
   hr.FECHA, 
   ROUND(MNE_ACE_PROD_INTEG_CA(640, to_char(hr.FECHA + 1,'dd/mm/yyyy'), hr.id_hora,'P','S')) As AKAL_C1, 
   ROUND(MNE_ACE_PROD_INTEG_CA(641, to_char(hr.fecha + 1,'dd/mm/yyyy'), hr.id_hora,'P','S')) As AKAL_C2,
   ROUND(MNE_ACE_PROD_INTEG_CA(642, to_char(hr.fecha + 1,'dd/mm/yyyy'), hr.id_hora,'P','S')) As AKAL_C3,
   ROUND(MNE_ACE_PROD_INTEG_CA(643, to_char(hr.fecha + 1,'dd/mm/yyyy'), hr.id_hora,'P','S')) As AKAL_CPer,
   ROUND(MNE_ACE_PROD_INTEG_CA(651, to_char(hr.fecha + 1,'dd/mm/yyyy'), hr.id_hora,'P','S')) As NOHOCH_A1,
   ROUND(MNE_ACE_PROD_INTEG_CA(652, to_char(hr.fecha + 1,'dd/mm/yyyy'), hr.id_hora,'P','S')) As NOHOCH_A2,
   ROUND(MNE_ACE_PROD_INTEG_CA(638, to_char(hr.fecha + 1,'dd/mm/yyyy'), hr.id_hora,'P','S')) As AKAL_B1,
   ROUND(MNE_ACE_PROD_INTEG_CA(644, to_char(hr.fecha + 1,'dd/mm/yyyy'), hr.id_hora,'P','S')) As AKAL_J1,
   ROUND(MNE_ACE_PROD_INTEG_CA(645, to_char(hr.fecha + 1,'dd/mm/yyyy'), hr.id_hora,'P','S')) As AKAL_J2,
   ROUND(MNE_ACE_PROD_INTEG_CA(646, to_char(hr.fecha + 1,'dd/mm/yyyy'), hr.id_hora,'P','S')) As AKAL_J3,
   ROUND(
          MNE_ACE_PROD_INTEG_OTRO_CA(644, to_char(hr.fecha + 1,'dd/mm/yyyy'), hr.id_hora)
          + MNE_ACE_PROD_INTEG_OTRO_CA(645, to_char(hr.fecha + 1,'dd/mm/yyyy'), hr.id_hora)
          + MNE_ACE_PROD_INTEG_OTRO_CA(646, to_char(hr.fecha + 1,'dd/mm/yyyy'), hr.id_hora) )
   As AKAL_J_KUH,
   ROUND(MNE_ACE_PROD_INTEG_CA(649, to_char(hr.fecha + 1,'dd/mm/yyyy'), hr.id_hora,'P','S')) As AKAL_N,
   ROUND(MNE_ACE_PROD_INTEG_CA(647, to_char(hr.fecha + 1,'dd/mm/yyyy'), hr.id_hora,'P','S')) As AKAL_L,
   ROUND(MNE_ACE_PROD_INTEG_CA(648, to_char(hr.fecha + 1,'dd/mm/yyyy'), hr.id_hora,'P','S')) As AKAL_L1,
   O.BN_ANILLO,
   P.BN_LUNA,
   R.Vol_BN,
   MNE_ACE_VALOR_NUM(1968, TO_CHAR(hr.FECHA+1, 'DD/MM/YYYY'), hr.id_hora, 621, '') As REP_CANTARELL

FROM
---------------- DIAS Y HORAS -------------
(
SELECT gpv.fecha_contable AS FECHA, gpv.id_hora
FROM gas_parametros_valores gpv, gas_plataformas gp, gas_c_horas gch
WHERE gpv.id_parametros = 758
   AND gpv.plataforma = gp.id + 0
   AND gp.tipo_inst = 'INSTANTANEA' AND gp.activo = 'CANTARELL'
   AND (gpv.fecha_contable BETWEEN TO_DATE(:FECHA,'DD/MM/YYYY') And TO_DATE(:FECHA_FIN,'DD/MM/YYYY') )
   AND gpv.id_hora = gch.id_hora + 0
   AND gch.hora_desc = :DESC_HORA
GROUP By gpv.fecha_contable, gpv.id_hora
) hr,
---------------- BN_ANILLO -----------------
(
SELECT gpv.fecha_contable AS FECHA, ROUND(AVG(gpv.valor_numerico),4) BN_ANILLO
FROM gas_parametros_valores gpv, gas_plataformas gp, gas_c_horas gch
WHERE gpv.id_parametros=759
   AND gpv.plataforma = gp.id
   AND gp.tipo_inst = 'INSTANTANEA' AND gp.activo = 'CANTARELL'
   AND gpv.plataforma = 651
   AND (gpv.fecha_contable BETWEEN TO_DATE(:FECHA,'DD/MM/YYYY') And TO_DATE(:FECHA_FIN,'DD/MM/YYYY') )
   AND gpv.id_hora = gch.id_hora
GROUP BY gpv.fecha_contable )O,
------------- BN_LUNA ---------------
(
SELECT gpv.fecha_contable AS FECHA, ROUND(AVG(gpv.valor_numerico),4) BN_LUNA
FROM gas_parametros_valores gpv, gas_plataformas gp, gas_c_horas gch
WHERE gpv.id_parametros = 759
   AND gpv.plataforma = gp.id
   AND gp.tipo_inst = 'INSTANTANEA' AND gp.activo = 'CANTARELL'
   AND gpv.plataforma = 652
   AND (gpv.fecha_contable BETWEEN TO_DATE(:FECHA,'DD/MM/YYYY') And TO_DATE(:FECHA_FIN,'DD/MM/YYYY') )
   AND gpv.id_hora = gch.id_hora
GROUP BY gpv.fecha_contable )p,
------------- Vol_BN---------------
(
SELECT G.FECHA,
   ROUND(AVG(CASE WHEN G.GAS<>0  THEN G.GAS + N.N2  ELSE 0 END),4) VOL_BN
FROM
   (SELECT gpv.fecha_contable FECHA,gch.id_hora, gch.hora_desc, gpv.valor_numerico AS GAS
    FROM gas_parametros_valores gpv, gas_c_horas gch, gas_plataformas gp
    WHERE gpv.id_parametros = 2207
       AND gpv.plataforma = gp.id
       AND gp.id = 252
       AND gpv.fecha_contable BETWEEN TO_DATE(:FECHA,'DD/MM/YYYY') And TO_DATE(:FECHA_FIN,'DD/MM/YYYY')
       AND gpv.id_hora = gch.id_hora ) G,
   (SELECT gpv.fecha_contable FECHA,gch.id_hora, gch.hora_desc, gpv.valor_numerico AS N2
    FROM gas_parametros_valores gpv, gas_c_horas gch, gas_plataformas gp
    WHERE gpv.id_parametros = 2208
       AND gpv.plataforma = gp.id
       AND gp.id = 252
       AND gpv.fecha_contable BETWEEN TO_DATE(:FECHA,'DD/MM/YYYY') And TO_DATE(:FECHA_FIN,'DD/MM/YYYY')
       AND gpv.id_hora = gch.id_hora ) N
WHERE G.FECHA = N.FECHA (+)
GROUP BY G.FECHA
ORDER BY 1,2 )r

WHERE HR.FECHA = O.FECHA (+)
AND HR.FECHA = P.FECHA (+)
AND HR.FECHA = R.FECHA (+)
order by fecha