

SELECT MOD_OP_REAL.FECHA_CONTABLE, MOD_OP_REAL.MOD_OPERANDO AS "Módulos Operando", MOD_OP_PROG.MOD_OPERANDO AS "POM",MOD_OP_POT.MOD_OPERANDO AS "Meta interna/POT-1"
FROM

(SELECT DATOS.ACTIVO, FECHA_CONTABLE, FECHA_CONTABLE + 1 As FECHA_REAL, ROUND(SUM(T) / 24, 6) As MOD_OPERANDO
     FROM XSIEDE.RMN_SIE_TOTALES DATOS
     WHERE DATOS.TIPO_INSTALACION = 'MODULOS'
          AND DATOS.FECHA_CONTABLE BETWEEN TO_DATE(:FECHAINI,'DD/MM/YYYY')-1 AND TO_DATE(:FECHAFIN,'DD/MM/YYYY')-1
          AND DATOS.REGION = 'RMNE'
          AND DATOS.ACTIVO IN ('CANTARELL','EK BALAM')
     GROUP By DATOS.ACTIVO,DATOS.FECHA_CONTABLE) MOD_OP_REAL,
 
          (SELECT
               FECHA_CONTABLE, SUM( MOD_OPERANDO ) As MOD_OPERANDO
           FROM RDP2.POS_GH_N2_PROY_VARS@CRTIZMD10G.ACEITENE PROG
           WHERE PROG.FECHA_CONTABLE BETWEEN TO_DATE(:FECHAINI,'DD/MM/YYYY')-1 AND TO_DATE(:FECHAFIN,'DD/MM/YYYY')-1
                AND PROG.TIPO = 'A'
                AND VALOR_TIPO IN ('CANTARELL','EK BALAM')
            GROUP By PROG.FECHA_CONTABLE) MOD_OP_PROG,
      (SELECT
            PROG.VALOR_TIPO,FECHA_CONTABLE, AVG( MOD_OPERANDO_POT1 ) As MOD_OPERANDO
       FROM RDP2.POS_GH_N2_PROY_VARS@CRTIZMD10G.ACEITENE PROG
       WHERE PROG.FECHA_CONTABLE BETWEEN TO_DATE(:FECHAINI,'DD/MM/YYYY')-1 AND TO_DATE(:FECHAFIN,'DD/MM/YYYY')-1
           AND PROG.TIPO = 'A'
           AND VALOR_TIPO IN ('CANTARELL','EK BALAM')
       GROUP By VALOR_TIPO,FECHA_CONTABLE) MOD_OP_POT
   
WHERE


 MOD_OP_REAL.FECHA_CONTABLE=MOD_OP_PROG.FECHA_CONTABLE AND
MOD_OP_POT.FECHA_CONTABLE = MOD_OP_PROG.FECHA_CONTABLE
















SELECT ORIGINAL.FECHA_CONTABLE AS FECHA_CONTABLE, ORIGINAL.OPERANDO AS OPERANDO, ORIGINAL.POM AS POM, ORIGINAL.POT AS POT1, PROMEDIO.OPERANDO AS PROM_OPERANDO, PROMEDIO.POM AS PROM_POM
                                    FROM
                                    (SELECT MOD_OP_REAL.FECHA_CONTABLE AS FECHA_CONTABLE, SUM(MOD_OP_REAL.MOD_OPERANDO) AS OPERANDO, MOD_OP_PROG.MOD_OPERANDO AS POM, MOD_OP_POT.MOD_OPERANDO AS POT
                                              
                                    FROM
                                        (SELECT DATOS.ACTIVO, FECHA_CONTABLE, FECHA_CONTABLE + 1 As FECHA_REAL, ROUND(SUM(T) / 24, 6) As MOD_OPERANDO
                                             FROM XSIEDE.RMN_SIE_TOTALES DATOS
                                             WHERE DATOS.TIPO_INSTALACION = 'MODULOS'
                                                  AND DATOS.FECHA_CONTABLE BETWEEN TO_DATE(:FECHAINI,'DD/MM/YYYY')-1 AND TO_DATE(:FECHAFIN,'DD/MM/YYYY')-1
                                                  AND DATOS.REGION = 'RMNE'
                                                  --AND DATOS.ACTIVO IN (" + activo + @")
                                                  AND (('CANTARELL' IN(" + activo + @") AND DATOS.ACTIVO = 'CANTARELL') OR ('GTDH' IN(" + activo + @") AND DATOS.ACTIVO = 'GTDH' AND DATOS.PLATAFORMA = 'AKAL-C7'))
                                             GROUP By DATOS.ACTIVO,DATOS.FECHA_CONTABLE) MOD_OP_REAL,
                                         
                                                  (SELECT
                                                       FECHA_CONTABLE, SUM( MOD_OPERANDO ) As MOD_OPERANDO
                                                   FROM DATAWAREZM.POS_GH_N2_PROY_VARS PROG
                                                   WHERE PROG.FECHA_CONTABLE BETWEEN TO_DATE(:FECHAINI,'DD/MM/YYYY')-1 AND TO_DATE(:FECHAFIN,'DD/MM/YYYY')-1
                                                        AND PROG.TIPO = 'A'
                                                        AND VALOR_TIPO IN (" + activo + @")
                                                    GROUP By PROG.FECHA_CONTABLE) MOD_OP_PROG,
                                                    
                                                    
                                                      (SELECT PROG.FECHA_CONTABLE As FECHA_CONTABLE, AVG( MOD_OPERANDO_POT1 ) As MOD_OPERANDO
                                                   FROM DATAWAREZM.POS_GH_N2_PROY_VARS PROG
                                                   WHERE PROG.FECHA_CONTABLE BETWEEN TO_DATE(:FECHAINI,'DD/MM/YYYY')-1 AND TO_DATE(:FECHAFIN,'DD/MM/YYYY')-1
                                                       AND PROG.TIPO = 'R' AND VALOR_TIPO = 'RMNE'
                                                   GROUP By FECHA_CONTABLE) MOD_OP_POT
                                              
                                          WHERE
                                         MOD_OP_REAL.FECHA_CONTABLE=MOD_OP_PROG.FECHA_CONTABLE AND
                                         MOD_OP_PROG.FECHA_CONTABLE=MOD_OP_POT.FECHA_CONTABLE
                                              
                                            GROUP BY MOD_OP_REAL.FECHA_CONTABLE,MOD_OP_PROG.MOD_OPERANDO, MOD_OP_POT.MOD_OPERANDO) ORIGINAL, 
                                         
                                           (SELECT TO_CHAR(MOD_OP_REAL.FECHA_CONTABLE,'MONTH') AS FECHA_CONTABLE, ROUND( AVG(MOD_OP_REAL.MOD_OPERANDO),6) AS OPERANDO, ROUND(AVG (MOD_OP_PROG.MOD_OPERANDO),6) AS POM
                                    FROM
                                        (SELECT FECHA_CONTABLE, FECHA_CONTABLE + 1 As FECHA_REAL, ROUND(SUM(T) / 24, 6) As MOD_OPERANDO
                                             FROM XSIEDE.RMN_SIE_TOTALES DATOS
                                             WHERE DATOS.TIPO_INSTALACION = 'MODULOS'
                                                
                                                  AND DATOS.REGION = 'RMNE'
                                                  --AND DATOS.ACTIVO IN (" + activo + @")
                                                  AND (('CANTARELL' IN(" + activo + @") AND DATOS.ACTIVO = 'CANTARELL') OR ('GTDH' IN(" + activo + @") AND DATOS.ACTIVO = 'GTDH' AND DATOS.PLATAFORMA = 'AKAL-C7'))
                                             GROUP By DATOS.FECHA_CONTABLE) MOD_OP_REAL,
                                         
                                                  (SELECT
                                                       FECHA_CONTABLE, SUM( MOD_OPERANDO ) As MOD_OPERANDO
                                                   FROM DATAWAREZM.POS_GH_N2_PROY_VARS PROG
                                                   WHERE 
                                                        PROG.TIPO = 'A'
                                                        AND VALOR_TIPO IN (" + activo + @")
                                                    GROUP By PROG.FECHA_CONTABLE) MOD_OP_PROG
                                          WHERE
                                           MOD_OP_REAL.FECHA_CONTABLE BETWEEN TO_DATE(:FECHAINI,'DD/MM/YYYY')-1 AND TO_DATE(:FECHAFIN,'DD/MM/YYYY')-1
                                           AND (SELECT TRUNC(TO_DATE(MOD_OP_REAL.FECHA_CONTABLE,'DD/MM/YYYY'),'MONTH') FROM DUAL) = (SELECT TRUNC(TO_DATE(MOD_OP_PROG.FECHA_CONTABLE,'DD/MM/YYYY'),'MONTH')FROM DUAL)
                                         GROUP BY TO_CHAR(MOD_OP_REAL.FECHA_CONTABLE,'MONTH')) PROMEDIO
                                     WHERE
                                     
                                     PROMEDIO.FECHA_CONTABLE = TO_CHAR(ORIGINAL.FECHA_CONTABLE,'MONTH')