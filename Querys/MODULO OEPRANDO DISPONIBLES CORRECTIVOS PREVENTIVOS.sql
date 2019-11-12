
     
     
     

     /*BUENO*/
     
SELECT FECHA_CONTABLE,SUM(MOD_OPER) AS MOD_OPER,SUM(MOD_DIS) AS MOD_DIS,SUM(MOD_CORR) AS MOD_CORR,SUM(MOD_PREV)AS MOD_PREV
, SUM(MOD_OPER) + SUM(MOD_DIS) + SUM(MOD_CORR)+ SUM(MOD_PREV) AS TOTAL
     FROM
   (SELECT F.FECHA_CONTABLE,A.T AS MOD_OPER,A.D AS MOD_DIS,B.R AS MOD_CORR, C.M AS MOD_PREV  
     
     FROM
     
     
               
(SELECT (:FECHA - ROWNUM)+1 AS FECHA_CONTABLE

FROM DUAL

CONNECT BY ROWNUM <= :FECHA-(:FECHA-30))F,

     
     
     
     (SELECT DATOS.ACTIVO, FECHA_CONTABLE, ROUND(SUM(T) / 24, 2) As T,
     ROUND(SUM(D) / 24, 2) AS  D
     FROM XSIEDE.RMN_SIE_TOTALES DATOS
     WHERE DATOS.TIPO_INSTALACION = 'MODULOS'
          AND DATOS.FECHA_CONTABLE BETWEEN :FECHA-30 AND :FECHA
          AND DATOS.REGION = 'RMNE'
          AND DATOS.ACTIVO IN ('CANTARELL','EK BALAM')
     GROUP By DATOS.ACTIVO,DATOS.FECHA_CONTABLE)A,
 


(SELECT FECHA_CONTABLE,ROUND(SUM(TEMC)/24,2) AS R FROM

  (SELECT DATOS.FECHA_CONTABLE, ROUND(SUM(DATOS.TEMC),2) AS TEMC
     FROM XSIEDE.RMN_SIE_TOTALES DATOS
     WHERE DATOS.TIPO_INSTALACION = 'MODULOS'
          AND DATOS.FECHA_CONTABLE  BETWEEN :FECHA-30 AND :FECHA
          AND DATOS.REGION = 'RMNE'
          AND DATOS.ACTIVO IN ('CANTARELL','EK BALAM')
 
      GROUP By DATOS.FECHA_CONTABLE
     UNION ALL
     SELECT DATOS.FECHA_CONTABLE, ROUND(SUM(DATOS.MC),2)AS MC
     FROM XSIEDE.RMN_SIE_TOTALES DATOS
     WHERE DATOS.TIPO_INSTALACION = 'MODULOS'
          AND DATOS.FECHA_CONTABLE BETWEEN :FECHA-30 AND :FECHA
          AND DATOS.REGION = 'RMNE'
          AND DATOS.ACTIVO IN ('CANTARELL','EK BALAM')
 
      GROUP By DATOS.FECHA_CONTABLE
     UNION ALL
       SELECT DATOS.FECHA_CONTABLE, ROUND(SUM(DATOS.TEPPMC),2) AS TEPPMC 
     FROM XSIEDE.RMN_SIE_TOTALES DATOS
     WHERE DATOS.TIPO_INSTALACION = 'MODULOS'
          AND DATOS.FECHA_CONTABLE  BETWEEN :FECHA-30 AND :FECHA
          AND DATOS.REGION = 'RMNE'
          AND DATOS.ACTIVO IN ('CANTARELL','EK BALAM')
 
      GROUP By DATOS.FECHA_CONTABLE)
     GROUP By FECHA_CONTABLE)B,
      
     
     (SELECT FECHA_CONTABLE,ROUND(SUM(TEMP)/24,2) AS M FROM

  (SELECT DATOS.FECHA_CONTABLE, ROUND(SUM(DATOS.TEMP),2) AS TEMP
     FROM XSIEDE.RMN_SIE_TOTALES DATOS
     WHERE DATOS.TIPO_INSTALACION = 'MODULOS'
          AND DATOS.FECHA_CONTABLE  BETWEEN :FECHA-30 AND :FECHA
          AND DATOS.REGION = 'RMNE'
          AND DATOS.ACTIVO IN ('CANTARELL','EK BALAM')
 
      GROUP By DATOS.FECHA_CONTABLE
     UNION ALL
     SELECT DATOS.FECHA_CONTABLE, ROUND(SUM(DATOS.MP),2)AS MP
     FROM XSIEDE.RMN_SIE_TOTALES DATOS
     WHERE DATOS.TIPO_INSTALACION = 'MODULOS'
          AND DATOS.FECHA_CONTABLE  BETWEEN :FECHA-30 AND :FECHA
          AND DATOS.REGION = 'RMNE'
          AND DATOS.ACTIVO IN ('CANTARELL','EK BALAM')
 
      GROUP By DATOS.FECHA_CONTABLE
     UNION ALL
       SELECT DATOS.FECHA_CONTABLE, ROUND(SUM(DATOS.TEPPMP),2) AS TEPPMP 
     FROM XSIEDE.RMN_SIE_TOTALES DATOS
     WHERE DATOS.TIPO_INSTALACION = 'MODULOS'
          AND DATOS.FECHA_CONTABLE BETWEEN :FECHA-30 AND :FECHA
          AND DATOS.REGION = 'RMNE'
          AND DATOS.ACTIVO IN ('CANTARELL','EK BALAM')
 
      GROUP By DATOS.FECHA_CONTABLE)
     GROUP By FECHA_CONTABLE)C
      WHERE F.FECHA_CONTABLE=A.FECHA_CONTABLE(+) AND A.FECHA_CONTABLE=B.FECHA_CONTABLE(+) AND B.FECHA_CONTABLE=C.FECHA_CONTABLE(+)
  
 
  
  UNION ALL
  
  

  
   SELECT F.FECHA_CONTABLE,A.T AS MOD_OPER,A.D AS MOD_DIS,B.R AS MOD_CORR, C.M AS MOD_PREV  
     
     FROM
 
(SELECT (:FECHA - ROWNUM)+1 AS FECHA_CONTABLE

FROM DUAL

CONNECT BY ROWNUM <= :FECHA-(:FECHA-30))F,

  
 (SELECT DATOS.FECHA_CONTABLE, ROUND(SUM(T) / 24, 2) As T,ROUND(SUM(D) / 24, 2) As D
          FROM XSIEDE.RMN_SIE_TOTALES DATOS
          WHERE DATOS.TIPO_INSTALACION = 'MODULOS'
          AND DATOS.REGION = 'RMNE'
          AND DATOS.PLATAFORMA = 'AKAL-C7'
          AND DATOS.FECHA_CONTABLE  BETWEEN :FECHA-30 AND :FECHA
          GROUP By DATOS.FECHA_CONTABLE)A,
          
          
        (SELECT FECHA_CONTABLE,ROUND(SUM(TEMC)/24,2) AS R  
          FROM
          
          (SELECT DATOS.FECHA_CONTABLE, ROUND(SUM(DATOS.TEMC),2) AS TEMC
               FROM XSIEDE.RMN_SIE_TOTALES DATOS
          WHERE DATOS.TIPO_INSTALACION = 'MODULOS'
          AND DATOS.REGION = 'RMNE'
          AND DATOS.PLATAFORMA = 'AKAL-C7'
          AND DATOS.FECHA_CONTABLE  BETWEEN :FECHA-30 AND :FECHA
          GROUP By DATOS.FECHA_CONTABLE
          
          UNION ALL
          
          
           SELECT DATOS.FECHA_CONTABLE, ROUND(SUM(DATOS.MC),2)AS MC
               FROM XSIEDE.RMN_SIE_TOTALES DATOS
          WHERE DATOS.TIPO_INSTALACION = 'MODULOS'
          AND DATOS.REGION = 'RMNE'
          AND DATOS.PLATAFORMA = 'AKAL-C7'
          AND DATOS.FECHA_CONTABLE  BETWEEN :FECHA-30 AND :FECHA
          GROUP By DATOS.FECHA_CONTABLE
          
          
          UNION ALL
          
          SELECT DATOS.FECHA_CONTABLE, ROUND(SUM(DATOS.TEPPMC),2) AS TEPPMC 
               FROM XSIEDE.RMN_SIE_TOTALES DATOS
          WHERE DATOS.TIPO_INSTALACION = 'MODULOS'
          AND DATOS.REGION = 'RMNE'
          AND DATOS.PLATAFORMA = 'AKAL-C7'
          AND DATOS.FECHA_CONTABLE BETWEEN :FECHA-30 AND :FECHA
          GROUP By DATOS.FECHA_CONTABLE)
          GROUP By FECHA_CONTABLE)B,
          
          
          (SELECT FECHA_CONTABLE,ROUND(SUM(TEMP)/24,2) AS M 
          FROM
          
          (SELECT DATOS.FECHA_CONTABLE, ROUND(SUM(DATOS.TEMP),2) AS TEMP
               FROM XSIEDE.RMN_SIE_TOTALES DATOS
          WHERE DATOS.TIPO_INSTALACION = 'MODULOS'
          AND DATOS.REGION = 'RMNE'
          AND DATOS.PLATAFORMA = 'AKAL-C7'
          AND DATOS.FECHA_CONTABLE BETWEEN :FECHA-30 AND :FECHA
          GROUP By DATOS.FECHA_CONTABLE
          
          UNION ALL
          
          
           SELECT DATOS.FECHA_CONTABLE, ROUND(SUM(DATOS.MP),2)AS MP
               FROM XSIEDE.RMN_SIE_TOTALES DATOS
          WHERE DATOS.TIPO_INSTALACION = 'MODULOS'
          AND DATOS.REGION = 'RMNE'
          AND DATOS.PLATAFORMA = 'AKAL-C7'
          AND DATOS.FECHA_CONTABLE BETWEEN :FECHA-30 AND :FECHA
          GROUP By DATOS.FECHA_CONTABLE
          
          
          UNION ALL
          
          SELECT DATOS.FECHA_CONTABLE, ROUND(SUM(DATOS.TEPPMP),2) AS TEPPMP 
               FROM XSIEDE.RMN_SIE_TOTALES DATOS
          WHERE DATOS.TIPO_INSTALACION = 'MODULOS'
          AND DATOS.REGION = 'RMNE'
          AND DATOS.PLATAFORMA = 'AKAL-C7'
          AND DATOS.FECHA_CONTABLE BETWEEN :FECHA-30 AND :FECHA
          GROUP By DATOS.FECHA_CONTABLE)
          GROUP By FECHA_CONTABLE)C
              WHERE F.FECHA_CONTABLE=A.FECHA_CONTABLE(+) AND A.FECHA_CONTABLE=B.FECHA_CONTABLE(+) AND B.FECHA_CONTABLE=C.FECHA_CONTABLE(+)
          
          )
          GROUP BY FECHA_CONTABLE 
          ORDER BY FECHA_CONTABLE DESC
          
          
          
          
          
          
          
     /*BUENO RESUMIDO*/
     
     
     SELECT FECHA_CONTABLE,SUM(MOD_OPER) AS MOD_OPER,SUM(MOD_DIS) AS MOD_DIS,SUM(MOD_CORR) AS MOD_CORR,SUM(MOD_PREV)AS MOD_PREV
, SUM(MOD_OPER) + SUM(MOD_DIS) + SUM(MOD_CORR)+ SUM(MOD_PREV) AS TOTAL
     FROM
   (SELECT F.FECHA_CONTABLE,A.T AS MOD_OPER,A.D AS MOD_DIS,ROUND(SUM(B.R)/24,2) AS MOD_CORR, ROUND(SUM(C.M)/24,2) AS MOD_PREV  
     
     FROM
     
     
               
(SELECT (:FECHA - ROWNUM)+1 AS FECHA_CONTABLE

FROM DUAL

CONNECT BY ROWNUM <= :FECHA-(:FECHA-30))F,

     
     
     
     (SELECT DATOS.ACTIVO, FECHA_CONTABLE, ROUND(SUM(T) / 24, 2) As T,
     ROUND(SUM(D) / 24, 2) AS  D
     FROM XSIEDE.RMN_SIE_TOTALES DATOS
     WHERE DATOS.TIPO_INSTALACION = 'MODULOS'
          AND DATOS.FECHA_CONTABLE BETWEEN :FECHA-30 AND :FECHA
          AND DATOS.REGION = 'RMNE'
          AND DATOS.ACTIVO IN ('CANTARELL','EK BALAM')
     GROUP By DATOS.ACTIVO,DATOS.FECHA_CONTABLE)A,
 


(          
SELECT FECHA_CONTABLE,TEMC+TEPPMC+MC AS R
FROM
  (SELECT DATOS.FECHA_CONTABLE, ROUND(SUM(DATOS.TEMC),2) AS TEMC,
   ROUND(SUM(DATOS.MC),2)AS MC, ROUND(SUM(DATOS.TEPPMC),2) AS TEPPMC 
     FROM XSIEDE.RMN_SIE_TOTALES DATOS
     WHERE DATOS.TIPO_INSTALACION = 'MODULOS'
          AND DATOS.FECHA_CONTABLE  BETWEEN :FECHA-30 AND :FECHA
          AND DATOS.REGION = 'RMNE'
          AND DATOS.ACTIVO IN ('CANTARELL','EK BALAM')
          GROUP By DATOS.FECHA_CONTABLE)
          )B,
      
     
     (SELECT FECHA_CONTABLE,TEMP+TEPPMP+MP AS M
FROM
  (SELECT DATOS.FECHA_CONTABLE, ROUND(SUM(DATOS.TEMP),2) AS TEMP,
   ROUND(SUM(DATOS.MP),2)AS MP, ROUND(SUM(DATOS.TEPPMP),2) AS TEPPMP 
     FROM XSIEDE.RMN_SIE_TOTALES DATOS
     WHERE DATOS.TIPO_INSTALACION = 'MODULOS'
          AND DATOS.FECHA_CONTABLE  BETWEEN :FECHA-30 AND :FECHA
          AND DATOS.REGION = 'RMNE'
          AND DATOS.ACTIVO IN ('CANTARELL','EK BALAM')
          GROUP By DATOS.FECHA_CONTABLE
 )
    )C
      WHERE F.FECHA_CONTABLE=A.FECHA_CONTABLE(+) AND A.FECHA_CONTABLE=B.FECHA_CONTABLE(+) AND B.FECHA_CONTABLE=C.FECHA_CONTABLE(+)
  GROUP BY F.FECHA_CONTABLE,A.T,A.D
 
  
  UNION ALL
  
  

  
   SELECT F.FECHA_CONTABLE,A.T AS MOD_OPER,A.D AS MOD_DIS,ROUND(SUM(B.R)/24,2) AS MOD_CORR, ROUND(SUM(C.M)/24,2) AS MOD_PREV  
     
     FROM
 
(SELECT (:FECHA - ROWNUM)+1 AS FECHA_CONTABLE

FROM DUAL

CONNECT BY ROWNUM <= :FECHA-(:FECHA-30))F,

  
 (SELECT DATOS.FECHA_CONTABLE, ROUND(SUM(T) / 24, 2) As T,ROUND(SUM(D) / 24, 2) As D
          FROM XSIEDE.RMN_SIE_TOTALES DATOS
          WHERE DATOS.TIPO_INSTALACION = 'MODULOS'
          AND DATOS.REGION = 'RMNE'
          AND DATOS.PLATAFORMA = 'AKAL-C7'
          AND DATOS.FECHA_CONTABLE  BETWEEN :FECHA-30 AND :FECHA
          GROUP By DATOS.FECHA_CONTABLE)A,
          
          
        (          
SELECT FECHA_CONTABLE,TEMC+MC+TEPPMC AS R  
          FROM
          
          (SELECT DATOS.FECHA_CONTABLE, ROUND(SUM(DATOS.TEMC),2) AS TEMC,
          ROUND(SUM(DATOS.MC),2)AS MC,ROUND(SUM(DATOS.TEPPMC),2) AS TEPPMC
               FROM XSIEDE.RMN_SIE_TOTALES DATOS
          WHERE DATOS.TIPO_INSTALACION = 'MODULOS'
          AND DATOS.REGION = 'RMNE'
          AND DATOS.PLATAFORMA = 'AKAL-C7'
          AND DATOS.FECHA_CONTABLE  BETWEEN :FECHA-30 AND :FECHA
          GROUP By DATOS.FECHA_CONTABLE)
          
         )B,
          
          
          (
         
          SELECT FECHA_CONTABLE,TEMP+MP+TEPPMP AS M 
          FROM
          
          (SELECT DATOS.FECHA_CONTABLE, ROUND(SUM(DATOS.TEMP),2) AS TEMP,
          ROUND(SUM(DATOS.MP),2)AS MP,ROUND(SUM(DATOS.TEPPMP),2) AS TEPPMP 
               FROM XSIEDE.RMN_SIE_TOTALES DATOS
          WHERE DATOS.TIPO_INSTALACION = 'MODULOS'
          AND DATOS.REGION = 'RMNE'
          AND DATOS.PLATAFORMA = 'AKAL-C7'
          AND DATOS.FECHA_CONTABLE BETWEEN :FECHA-30 AND :FECHA
          GROUP By DATOS.FECHA_CONTABLE)
        
          )C
              WHERE F.FECHA_CONTABLE=A.FECHA_CONTABLE(+) AND A.FECHA_CONTABLE=B.FECHA_CONTABLE(+) AND B.FECHA_CONTABLE=C.FECHA_CONTABLE(+)
             GROUP BY F.FECHA_CONTABLE,A.T,A.D 
          
          )
          GROUP BY FECHA_CONTABLE 
          ORDER BY FECHA_CONTABLE DESC
          
          
          
          
          
          
          
          
          
          
          
          
     
          
          
          
          
          
          
          
          
          
          
          
          
          