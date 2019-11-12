
/*MODULOS Y BOOSTERS EN OPERACION*/

SELECT MODULOS.UBICACION,MODULOS.M_AYER,MODULOS.M_HOY,MODULOS.M_PROM,BOOSTERS.B_AYER,BOOSTERS.B_HOY,BOOSTERS.B_PROM
FROM
(SELECT C_HOY.ACTIVO AS UBICACION, C_AYER.MOD_OPERANDO AS M_AYER, C_HOY.MOD_OPERANDO as M_HOY, ROUND(AVG(C_PROMM.MOD_OPERANDO),2) AS M_PROM
FROM

(SELECT DATOS.ACTIVO, FECHA_CONTABLE + 1 As FECHA_REAL, ROUND(SUM(T) / 24, 2) As MOD_OPERANDO
     FROM XSIEDE.RMN_SIE_TOTALES DATOS
     WHERE DATOS.TIPO_INSTALACION = 'MODULOS'
          AND DATOS.FECHA_CONTABLE = :FECHA
          AND DATOS.REGION = 'RMNE'
          AND DATOS.ACTIVO IN ('CANTARELL','EK BALAM')
     GROUP By DATOS.ACTIVO,DATOS.FECHA_CONTABLE)C_HOY,
     
     (SELECT DATOS.ACTIVO, FECHA_CONTABLE + 1 As FECHA_REAL, ROUND(SUM(T) / 24, 2) As MOD_OPERANDO
     FROM XSIEDE.RMN_SIE_TOTALES DATOS
     WHERE DATOS.TIPO_INSTALACION = 'MODULOS'
          AND DATOS.FECHA_CONTABLE = :FECHA-1
          AND DATOS.REGION = 'RMNE'
          AND DATOS.ACTIVO IN ('CANTARELL','EK BALAM')
     GROUP By DATOS.ACTIVO,DATOS.FECHA_CONTABLE)C_AYER,
     
     (SELECT DATOS.ACTIVO, FECHA_CONTABLE + 1 As FECHA_REAL, ROUND(SUM(T) / 24, 2) As MOD_OPERANDO
     FROM XSIEDE.RMN_SIE_TOTALES DATOS
     WHERE DATOS.TIPO_INSTALACION = 'MODULOS'
          AND DATOS.FECHA_CONTABLE BETWEEN TRUNC(:FECHA,'MM') AND:FECHA
          AND DATOS.REGION = 'RMNE'
          AND DATOS.ACTIVO IN ('CANTARELL','EK BALAM')
     GROUP By DATOS.ACTIVO,DATOS.FECHA_CONTABLE)C_PROMM
     
     GROUP BY C_HOY.ACTIVO, C_AYER.MOD_OPERANDO, C_HOY.MOD_OPERANDO 
 
     
     
     UNION ALL
     

     SELECT AKAL_HOY.PLATAFORMA, AKAL_HOY.MOD_OPERANDO, AKAL_AYER.MOD_OPERANDO, ROUND(AVG(AKAL_PROMM.MOD_OPERANDO),2)
     FROM  
                                            (SELECT FECHA_CONTABLE + 1 As FECHA_REAL, ROUND(SUM(T) / 24, 2) As MOD_OPERANDO, DATOS.PLATAFORMA
                                             FROM XSIEDE.RMN_SIE_TOTALES DATOS
                                             WHERE DATOS.TIPO_INSTALACION = 'MODULOS'
                                                 AND DATOS.REGION = 'RMNE'
                                                 AND DATOS.PLATAFORMA = 'AKAL-C7'
                                                 AND DATOS.FECHA_CONTABLE = :FECHA
                                             GROUP By DATOS.FECHA_CONTABLE,PLATAFORMA)AKAL_HOY,
                                                  
                                                  (SELECT FECHA_CONTABLE + 1 As FECHA_REAL, ROUND(SUM(T) / 24, 2) As MOD_OPERANDO, DATOS.PLATAFORMA
                                             FROM XSIEDE.RMN_SIE_TOTALES DATOS
                                             WHERE DATOS.TIPO_INSTALACION = 'MODULOS'
                                                 AND DATOS.REGION = 'RMNE'
                                                 AND DATOS.PLATAFORMA = 'AKAL-C7'
                                                 AND DATOS.FECHA_CONTABLE = :FECHA-1
                                             GROUP By DATOS.FECHA_CONTABLE,PLATAFORMA)AKAL_AYER,
     
     
     
                                           ( SELECT FECHA_CONTABLE + 1 As FECHA_REAL, ROUND(SUM(T) / 24, 2) As MOD_OPERANDO, DATOS.PLATAFORMA
                                             FROM XSIEDE.RMN_SIE_TOTALES DATOS
                                             WHERE DATOS.TIPO_INSTALACION = 'MODULOS'
                                                 AND DATOS.REGION = 'RMNE'
                                                 AND DATOS.PLATAFORMA = 'AKAL-C7'
                                                 AND DATOS.FECHA_CONTABLE BETWEEN TRUNC(:FECHA,'MM') AND:FECHA
                                             GROUP By DATOS.FECHA_CONTABLE,PLATAFORMA)AKAL_PROMM
     
     GROUP BY AKAL_HOY.PLATAFORMA, AKAL_HOY.MOD_OPERANDO, AKAL_AYER.MOD_OPERANDO)MODULOS,
     
     
     (SELECT C_HOY.ACTIVO AS UBICACION, C_AYER.BOOSTER AS B_AYER, C_HOY.BOOSTER as B_HOY, ROUND(AVG(C_PROMM.BOOSTER),2) AS B_PROM
FROM

(SELECT DATOS.ACTIVO, FECHA_CONTABLE + 1 As FECHA_REAL, ROUND(SUM(T) / 24, 2) As BOOSTER
     FROM XSIEDE.RMN_SIE_TOTALES DATOS
     WHERE DATOS.TIPO_INSTALACION = 'BOOSTERS'
          AND DATOS.FECHA_CONTABLE = :FECHA
          AND DATOS.REGION = 'RMNE'
          AND DATOS.ACTIVO IN ('CANTARELL','EK BALAM')
     GROUP By DATOS.ACTIVO,DATOS.FECHA_CONTABLE)C_HOY,
     
     (SELECT DATOS.ACTIVO, FECHA_CONTABLE + 1 As FECHA_REAL, ROUND(SUM(T) / 24, 2) As BOOSTER
     FROM XSIEDE.RMN_SIE_TOTALES DATOS
     WHERE DATOS.TIPO_INSTALACION = 'BOOSTERS'
          AND DATOS.FECHA_CONTABLE = :FECHA-1
          AND DATOS.REGION = 'RMNE'
          AND DATOS.ACTIVO IN ('CANTARELL','EK BALAM')
     GROUP By DATOS.ACTIVO,DATOS.FECHA_CONTABLE)C_AYER,
     
     (SELECT DATOS.ACTIVO, FECHA_CONTABLE + 1 As FECHA_REAL, ROUND(SUM(T) / 24, 2) As BOOSTER
     FROM XSIEDE.RMN_SIE_TOTALES DATOS
     WHERE DATOS.TIPO_INSTALACION = 'BOOSTERS'
          AND DATOS.FECHA_CONTABLE BETWEEN TRUNC(:FECHA,'MM') AND:FECHA
          AND DATOS.REGION = 'RMNE'
          AND DATOS.ACTIVO IN ('CANTARELL','EK BALAM')
     GROUP By DATOS.ACTIVO,DATOS.FECHA_CONTABLE)C_PROMM
     
     GROUP BY C_HOY.ACTIVO, C_AYER.BOOSTER, C_HOY.BOOSTER 
 
     
     
     UNION ALL
     

     SELECT AKAL_HOY.PLATAFORMA, AKAL_HOY.BOOSTER, AKAL_AYER.BOOSTER, ROUND(AVG(AKAL_PROMM.BOOSTER),2)
     FROM  
                                            (SELECT FECHA_CONTABLE + 1 As FECHA_REAL, ROUND(SUM(T) / 24, 2) As BOOSTER, DATOS.PLATAFORMA
                                             FROM XSIEDE.RMN_SIE_TOTALES DATOS
                                             WHERE DATOS.TIPO_INSTALACION = 'BOOSTERS'
                                                 AND DATOS.REGION = 'RMNE'
                                                 AND DATOS.PLATAFORMA = 'AKAL-C7'
                                                 AND DATOS.FECHA_CONTABLE = :FECHA
                                             GROUP By DATOS.FECHA_CONTABLE,PLATAFORMA)AKAL_HOY,
                                                  
                                                  (SELECT FECHA_CONTABLE + 1 As FECHA_REAL, ROUND(SUM(T) / 24, 2) As BOOSTER, DATOS.PLATAFORMA
                                             FROM XSIEDE.RMN_SIE_TOTALES DATOS
                                             WHERE DATOS.TIPO_INSTALACION = 'BOOSTERS'
                                                 AND DATOS.REGION = 'RMNE'
                                                 AND DATOS.PLATAFORMA = 'AKAL-C7'
                                                 AND DATOS.FECHA_CONTABLE = :FECHA-1
                                             GROUP By DATOS.FECHA_CONTABLE,PLATAFORMA)AKAL_AYER,
     
     
     
                                           ( SELECT FECHA_CONTABLE + 1 As FECHA_REAL, ROUND(SUM(T) / 24, 2) As BOOSTER, DATOS.PLATAFORMA
                                             FROM XSIEDE.RMN_SIE_TOTALES DATOS
                                             WHERE DATOS.TIPO_INSTALACION = 'BOOSTERS'
                                                 AND DATOS.REGION = 'RMNE'
                                                 AND DATOS.PLATAFORMA = 'AKAL-C7'
                                                 AND DATOS.FECHA_CONTABLE BETWEEN TRUNC(:FECHA,'MM') AND:FECHA
                                             GROUP By DATOS.FECHA_CONTABLE,PLATAFORMA)AKAL_PROMM
     
     GROUP BY AKAL_HOY.PLATAFORMA, AKAL_HOY.BOOSTER, AKAL_AYER.BOOSTER)BOOSTERS
     WHERE MODULOS.UBICACION=BOOSTERS.UBICACION(+)
     
     
     
     
     
 /*    ME PODRIAS ELABORAR UNO DONDE mustre tres 4 columnas
fecha_contable, mod_cant,mod_akc7, total (suma de mod_cant,mod_akc7 )
para un rago entre trunc(fecha,MM) and :fecha*/
     
     


select modulo.fecha_contable,modulo.mod_operando as mod_cant,modulo_ak.mod_operando as mod_akc7,TOTAL.TOTAL
from
     
    ( SELECT DATOS.ACTIVO, FECHA_CONTABLE, ROUND(SUM(T) / 24, 2) As MOD_OPERANDO
     FROM XSIEDE.RMN_SIE_TOTALES DATOS
     WHERE DATOS.TIPO_INSTALACION = 'MODULOS'
          AND DATOS.FECHA_CONTABLE between trunc(:fecha,'MM') and :fecha
          AND DATOS.REGION = 'RMNE'
          AND DATOS.ACTIVO IN ('CANTARELL','EK BALAM')
     GROUP By DATOS.ACTIVO,DATOS.FECHA_CONTABLE)modulo,
        
    ( SELECT FECHA_CONTABLE, ROUND(SUM(T) / 24, 2) As MOD_OPERANDO, DATOS.PLATAFORMA
                                             FROM XSIEDE.RMN_SIE_TOTALES DATOS
                                             WHERE DATOS.TIPO_INSTALACION = 'MODULOS'
                                                 AND DATOS.REGION = 'RMNE'
                                                 AND DATOS.PLATAFORMA = 'AKAL-C7'
                                                 AND DATOS.FECHA_CONTABLE between trunc(:FECHA,'MM') and :FECHA
                                             GROUP By DATOS.FECHA_CONTABLE,PLATAFORMA)modulo_ak,
                                             
                                               
  (SELECT FECHA_CONTABLE,ROUND(SUM(MOD_OPERANDO),2) TOTAL
  FROM
  (SELECT FECHA_CONTABLE, ROUND(SUM(T) / 24, 2) As MOD_OPERANDO
                                             FROM XSIEDE.RMN_SIE_TOTALES DATOS
                                             WHERE DATOS.TIPO_INSTALACION = 'MODULOS'
                                                 AND DATOS.REGION = 'RMNE'
                                                  AND (('CANTARELL' IN('CANTARELL') AND DATOS.ACTIVO = 'CANTARELL') OR ('GTDH' IN('GTDH') AND DATOS.ACTIVO = 'GTDH' AND DATOS.PLATAFORMA = 'AKAL-C7'))  
                                                 AND DATOS.FECHA_CONTABLE between trunc(:FECHA,'MM') and :FECHA
                                             GROUP By DATOS.ACTIVO,DATOS.FECHA_CONTABLE,PLATAFORMA)
                                             GROUP BY FECHA_CONTABLE)TOTAL
  
  where modulo.fecha_contable=modulo_ak.fecha_contable(+) AND MODULO_AK.FECHA_CONTABLE=TOTAL.FECHA_CONTABLE(+)                                           
                                             
  

                                             
                                             
                                             
            