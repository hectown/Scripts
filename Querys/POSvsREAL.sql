





WITH FECHAS As
(SELECT TO_DATE(:FECHA_INI_SEMANA, 'DD/MM/YYYY') + ROWNUM - 1 As FECHA_CONTABLE
FROM DUAL
CONNECT By ROWNUM <= TO_DATE(:FECHA_FIN_SEMANA, 'DD/MM/YYYY') - TO_DATE(:FECHA_INI_SEMANA, 'DD/MM/YYYY') + 1)



SELECT

   fechas.fecha_contable As dia, fechas.fecha_contable + 1 As dia_real, datos_pos.p_pos,
   datos_pom.p_pom, datos_prod.p_real, 
   TO_NUMBER(DECODE(datos_prod.proyecto,'CANTARELL','520',DECODE(datos_prod.proyecto,'KU MALOOB ZAAP','840','1360'))) as BDini, 
   to_number(DECODE(datos_prod.proyecto,'CANTARELL','530',DECODE(datos_prod.proyecto,'KU MALOOB ZAAP','850','1370'))) as BDfin, 
   to_number(DECODE(datos_prod.proyecto,'CANTARELL','530',DECODE(datos_prod.proyecto,'KU MALOOB ZAAP','850','1370'))) as DAini,
   to_number(DECODE(datos_prod.proyecto,'CANTARELL','540',DECODE(datos_prod.proyecto,'KU MALOOB ZAAP','860','1380'))) as DAfin, 
   to_number(DECODE(datos_prod.proyecto,'CANTARELL','540',DECODE(datos_prod.proyecto,'KU MALOOB ZAAP','860','1380'))) as DDfin 
FROM
   (/* Produccion real y pronosticada mensual */
   SELECT
        prod.proyecto,
        prod.dia As fecha_contable, prod.dia + 1 As fecha_real, 
        sum(PROD.PROD_PRON) As p_pom,
        sum(PROD.PROD_REAL) As p_real
   FROM
       pron_prod prod
   WHERE prod.dia BETWEEN TO_DATE(:FECHA_INI_SEMANA, 'DD/MM/YYYY') AND TO_DATE(:FECHA_FIN_SEMANA, 'DD/MM/YYYY')
        And prod.proyecto IN(:ACTIVO)
   Group By prod.proyecto,prod.dia) datos_prod,
   (/* Pronosticada mensual   */
    SELECT
        fecha As fecha_contable,
        SUM(NVL(PROD_PRON_LIG, 0) + NVL(PROD_PRON_PES, 0)) As p_pom
    FROM ACEITENE.MNE_ACE_POM
    WHERE fecha BETWEEN TO_DATE(:FECHA_INI_SEMANA, 'DD/MM/YYYY') AND TO_DATE(:FECHA_FIN_SEMANA, 'DD/MM/YYYY')
        And  activo IN(:ACTIVO)
    GROUP By fecha) datos_pom,
   (/* Programa Operativo Semanal - POS */
    SELECT
    
        DATOS.FECHA_CONTABLE, SUM(DATOS.VOLUMEN) OVER(ORDER By DATOS.FECHA_CONTABLE ASC) As VOLUMEN_ACUM,
        DATO_INI.PROD_REAL + NVL(SUM(DATOS.VOLUMEN) OVER(ORDER By DATOS.FECHA_CONTABLE ASC), 0) As P_POS
    FROM
       (SELECT fechas.fecha_contable, datos.volumen
        FROM
            (SELECT pos.FECHA_CONTABLE, SUM(pos.VOLUMEN) As VOLUMEN
             FROM MNE_ACE_JUST_POS@CRTIZMD10G.ACEITENE pos
             WHERE pos.FECHA_CONTABLE BETWEEN TO_DATE(:FECHA_INI_SEMANA, 'DD/MM/YYYY') AND TO_DATE(:FECHA_FIN_SEMANA, 'DD/MM/YYYY')
                  And pos.PROYECTO IN(:ACTIVO)
              GROUP By pos.FECHA_CONTABLE) datos,
              (SELECT TO_DATE(:FECHA_INI_SEMANA, 'DD/MM/YYYY') + ROWNUM - 1 As FECHA_CONTABLE
               FROM DUAL
               CONNECT By ROWNUM <= TO_DATE(:FECHA_FIN_SEMANA, 'DD/MM/YYYY') - TO_DATE(:FECHA_INI_SEMANA, 'DD/MM/YYYY') + 1) fechas
         WHERE datos.fecha_contable(+) = fechas.fecha_contable              
        ) DATOS,
       (SELECT SUM(PROD_REAL) As PROD_REAL, COUNT(DISTINCT 1) As DUMMY
         FROM PRON_PROD
         WHERE DIA = TO_DATE(:FECHA_INI_SEMANA, 'DD/MM/YYYY') - 1
              And proyecto IN(:ACTIVO)) DATO_INI) datos_pos, fechas
WHERE datos_prod.fecha_contable(+) = fechas.fecha_contable 
   AND datos_pos.fecha_contable(+) = fechas.fecha_contable
   AND datos_pom.fecha_contable(+) = fechas.fecha_contable
   
   
   
   
   
   
   UNION ALL
   
   
   
 SELECT
'KU MALOOB ZAAP' ACTIVO,
   fechas.fecha_contable As dia, fechas.fecha_contable + 1 As dia_real, datos_pos.p_pos,
   datos_pom.p_pom, datos_prod.p_real, '840' as BDini, '850' as BDfin, '850' as DAini,'860' as DAfin, '860' as DDfin 
FROM
   (/* Produccion real y pronosticada mensual */
   SELECT
        prod.dia As fecha_contable, prod.dia + 1 As fecha_real, 
        sum(PROD.PROD_PRON) As p_pom,
        sum(PROD.PROD_REAL) As p_real
   FROM
       pron_prod prod
   WHERE prod.dia BETWEEN TO_DATE(:FECHA_INI_SEMANA, 'DD/MM/YYYY') AND TO_DATE(:FECHA_FIN_SEMANA, 'DD/MM/YYYY')
        And prod.proyecto IN('KU MALOOB ZAAP')
   Group By prod.dia) datos_prod,
   (/* Pronosticada mensual   */
    SELECT
        fecha As fecha_contable,
        SUM(NVL(PROD_PRON_LIG, 0) + NVL(PROD_PRON_PES, 0)) As p_pom
    FROM ACEITENE.MNE_ACE_POM
    WHERE fecha BETWEEN TO_DATE(:FECHA_INI_SEMANA, 'DD/MM/YYYY') AND TO_DATE(:FECHA_FIN_SEMANA, 'DD/MM/YYYY')
        And  activo IN('KU MALOOB ZAAP')
    GROUP By fecha) datos_pom,
   (/* Programa Operativo Semanal - POS */
    SELECT
    
        DATOS.FECHA_CONTABLE, SUM(DATOS.VOLUMEN) OVER(ORDER By DATOS.FECHA_CONTABLE ASC) As VOLUMEN_ACUM,
        DATO_INI.PROD_REAL + NVL(SUM(DATOS.VOLUMEN) OVER(ORDER By DATOS.FECHA_CONTABLE ASC), 0) As P_POS
    FROM
       (SELECT fechas.fecha_contable, datos.volumen
        FROM
            (SELECT pos.FECHA_CONTABLE, SUM(pos.VOLUMEN) As VOLUMEN
             FROM MNE_ACE_JUST_POS@CRTIZMD10G.ACEITENE pos
             WHERE pos.FECHA_CONTABLE BETWEEN TO_DATE(:FECHA_INI_SEMANA, 'DD/MM/YYYY') AND TO_DATE(:FECHA_FIN_SEMANA, 'DD/MM/YYYY')
                  And pos.PROYECTO IN('KU MALOOB ZAAP')
              GROUP By pos.FECHA_CONTABLE) datos,
              (SELECT TO_DATE(:FECHA_INI_SEMANA, 'DD/MM/YYYY') + ROWNUM - 1 As FECHA_CONTABLE
               FROM DUAL
               CONNECT By ROWNUM <= TO_DATE(:FECHA_FIN_SEMANA, 'DD/MM/YYYY') - TO_DATE(:FECHA_INI_SEMANA, 'DD/MM/YYYY') + 1) fechas
         WHERE datos.fecha_contable(+) = fechas.fecha_contable              
        ) DATOS,
       (SELECT SUM(PROD_REAL) As PROD_REAL, COUNT(DISTINCT 1) As DUMMY
         FROM PRON_PROD
         WHERE DIA = TO_DATE(:FECHA_INI_SEMANA, 'DD/MM/YYYY') - 1
              And proyecto IN('KU MALOOB ZAAP')) DATO_INI) datos_pos, fechas
WHERE datos_prod.fecha_contable(+) = fechas.fecha_contable 
   AND datos_pos.fecha_contable(+) = fechas.fecha_contable
   AND datos_pom.fecha_contable(+) = fechas.fecha_contable) 
   
   WHERE ACTIVO IN (:ACTIVO)
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   SELECT * FROM MNE_ACE_JUST_POS@CRTIZMD10G.ACEITENE
   
  
 
   
   
   
  WITH FECHAS As
(SELECT TO_DATE(:FECHA_INI_SEMANA, 'DD/MM/YYYY') + ROWNUM - 1 As FECHA_CONTABLE
FROM DUAL
CONNECT By ROWNUM <= TO_DATE(:FECHA_FIN_SEMANA, 'DD/MM/YYYY') - TO_DATE(:FECHA_INI_SEMANA, 'DD/MM/YYYY') + 1) 
   
   
   select  programada.fecha_contable, round(programada.P_POS,2) as pom_prog, round(programadaconsulta.P_POS,2)as Pom_prog_consul , round(transcurrida.p_real,2) as real_trans from
 
   (SELECT

       dia,
       sum(PROD.PROD_REAL) As p_real
   FROM
       pron_prod prod
   WHERE prod.dia BETWEEN TO_DATE(:FECHA_INI_SEMANA,'DD/MM/YYYY') AND TO_DATE(:FECHA_FIN_SEMANA1,'DD/MM/YYYY')
        And prod.proyecto IN(:ACTIVO)
      group by dia
        )transcurrida,
 
  (
    SELECT
      DATOS.FECHA_CONTABLE,
         DATO_INI.PROD_REAL + NVL(SUM(DATOS.VOLUMEN) OVER(ORDER By DATOS.FECHA_CONTABLE ASC), 0) As P_POS
        
    FROM
       (SELECT fechas.fecha_contable, datos.volumen
        FROM
            (SELECT pos.FECHA_CONTABLE, SUM(pos.VOLUMEN) As VOLUMEN
             FROM MNE_ACE_JUST_POS@CRTIZMD10G.ACEITENE pos
             WHERE pos.FECHA_CONTABLE BETWEEN TO_DATE(:FECHA_INI_SEMANA, 'DD/MM/YYYY') AND TO_DATE(:FECHA_FIN_SEMANA, 'DD/MM/YYYY')
                  And pos.PROYECTO IN(:ACTIVO)
              GROUP By pos.FECHA_CONTABLE) datos,
              (SELECT TO_DATE(:FECHA_INI_SEMANA, 'DD/MM/YYYY') + ROWNUM - 1 As FECHA_CONTABLE
               FROM DUAL
               CONNECT By ROWNUM <= TO_DATE(:FECHA_FIN_SEMANA, 'DD/MM/YYYY') - TO_DATE(:FECHA_INI_SEMANA, 'DD/MM/YYYY') + 1) fechas
         WHERE datos.fecha_contable(+) = fechas.fecha_contable              
        ) DATOS,
       (SELECT SUM(PROD_REAL) As PROD_REAL
         FROM PRON_PROD
         WHERE DIA = TO_DATE(:FECHA_INI_SEMANA, 'DD/MM/YYYY') - 1
              And proyecto IN(:ACTIVO)) DATO_INI) programada,
              
              (
    SELECT
      DATOS.FECHA_CONTABLE,
         DATO_INI.PROD_REAL + NVL(SUM(DATOS.VOLUMEN) OVER(ORDER By DATOS.FECHA_CONTABLE ASC), 0) As P_POS
        
    FROM
       (SELECT fechas.fecha_contable, datos.volumen
        FROM
            (SELECT pos.FECHA_CONTABLE, SUM(pos.VOLUMEN) As VOLUMEN
             FROM MNE_ACE_JUST_POS@CRTIZMD10G.ACEITENE pos
             WHERE pos.FECHA_CONTABLE BETWEEN TO_DATE(:FECHA_INI_SEMANA, 'DD/MM/YYYY') AND TO_DATE(:FECHA_FIN_SEMANA1, 'DD/MM/YYYY')
                  And pos.PROYECTO IN(:ACTIVO)
              GROUP By pos.FECHA_CONTABLE) datos,
              (SELECT TO_DATE(:FECHA_INI_SEMANA, 'DD/MM/YYYY') + ROWNUM - 1 As FECHA_CONTABLE
               FROM DUAL
               CONNECT By ROWNUM <= TO_DATE(:FECHA_FIN_SEMANA1, 'DD/MM/YYYY') - TO_DATE(:FECHA_INI_SEMANA, 'DD/MM/YYYY') + 1) fechas
         WHERE datos.fecha_contable(+) = fechas.fecha_contable              
        ) DATOS,
       (SELECT SUM(PROD_REAL) As PROD_REAL
         FROM PRON_PROD
         WHERE DIA = TO_DATE(:FECHA_INI_SEMANA, 'DD/MM/YYYY') - 1
              And proyecto IN(:ACTIVO)) DATO_INI)programadaconsulta, FECHAS
         
         
         where programada.fecha_contable(+)=FECHAS.FECHA_CONTABLE AND
         transcurrida.dia(+)=FECHAS.FECHA_CONTABLE AND
         programadaconsulta.fecha_contable(+)=FECHAS.FECHA_CONTABLE
         
         
         
         
         
         
          
         
         
         
         
         
         
         
         
         
      
   
   
   FECHA_CONTABLE IN (SELECT
    TO_DATE(TO_CHAR(TO_DATE('10/JUN/2011','DD/MM/YYYY') + (1-TO_CHAR(TO_DATE('10/JUN/2011','DD/MM/YYYY'),'D')), 'DD/MM/YYYY'),'DD/MM/YYYY')-1 + ROWNUM
    FROM DUAL
    CONNECT BY ROWNUM <= 7) 
    
    
    
   (SELECT
  TO_DATE(TO_CHAR(TO_DATE('10/JUN/2011','DD/MM/YYYY')+1 + (1-TO_CHAR(TO_DATE('10/JUN/2011','DD/MM/YYYY'),'D')), 'DD/MM/YYYY'),'DD/MM/YYYY') + ROWNUM -2 
FROM DUAL
CONNECT By ROWNUM <= 1)







SELECT DECODE (CLAVE,'KU','0',CLAVE) FROM PRON_PROD



SELECT DECODE(CLAVE,"KU",0,CLAVE) FROM PRON_PROD



SELECT * FROM PRON_PROD