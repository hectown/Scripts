quisiera me eloboraras un query que traiga fecha contable, pom, prod_real, y proy(prod real reptidiendo el ultimo valor real en contrado hasta fin de mes)
en un periodo de mes en base a la fecha contable consultada
las informacion la puedes tomar de las tablas del rdp2
hist_prod
y


08:09 a.m.Heredia Chulines Yolanda Del Carmenpron_prod

select DISTINCT TIPO_PROD from pron_prod


select FEC_PROD, ROUND(SUM(PROD_ACE)/1000,2) AS PROD_REAL from hist_prod WHERE FEC_PROD BETWEEN TRUNC(:FECHA,'MM') AND :FECHA AND PROYECTO IN ('KU MALOOB ZAAP')
GROUP BY FEC_PROD
ORDER BY FEC_PROD 



SELECT DIA, SUM(PROD_PRON) AS PROD_PRON, SUM(PROD_REAL) AS PROD_REAL from pron_prod where dia between TRUNC(:FECHA,'MM')-1 AND :FECHA-1 AND PROYECTO IN ('KU MALOOB ZAAP') 
GROUP BY DIA
ORDER BY DIA



/*BUENO*/

SELECT FECHA.FECHA_CONTABLE,PRODUCCION.PROD_REAL,PRODUCCION.PROD_PRON AS POM, PROY.PRODUCCION AS PROY
FROM
(SELECT TRUNC(:FECHA,'MM')-1 + ROWNUM  As FECHA_CONTABLE  FROM DUAL 
               CONNECT By ROWNUM <= LAST_DAY(:FECHA)+1 - TRUNC(:FECHA,'MM'))FECHA,


(SELECT DIA as FECHA_CONTABLE, SUM(PROD_PRON) AS PROD_PRON, SUM(PROD_REAL) AS PROD_REAL from pron_prod where dia between TRUNC(:FECHA,'MM') AND :FECHA AND PROYECTO IN ('CANTARELL', 'EK BALAM','KU MALOOB ZAAP') 
GROUP BY DIA
ORDER BY DIA)PRODUCCION,


(

SELECT FECHA.FECHA_CONTABLE,ULTIMO.PROD_REAL AS PRODUCCION
FROM

(SELECT (:FECHA)+ ROWNUM  As FECHA_CONTABLE  FROM DUAL 
               CONNECT By ROWNUM <= LAST_DAY(:FECHA) - :FECHA)FECHA,

(SELECT SUM(PROD_REAL) AS PROD_REAL from pron_prod where PROYECTO IN ('CANTARELL', 'EK BALAM','KU MALOOB ZAAP') 
AND DIA =(
SELECT MAX(DIA) from pron_prod where dia between TRUNC(:FECHA,'MM')
AND :FECHA AND PROYECTO IN ('CANTARELL', 'EK BALAM','KU MALOOB ZAAP') 
))ULTIMO

union all

SELECT DIA, SUM(PROD_REAL) AS PRODUCCION from pron_prod 
where dia between TRUNC(:FECHA,'MM') AND :FECHA AND PROYECTO IN ('CANTARELL', 'EK BALAM','KU MALOOB ZAAP') 
GROUP BY DIA
ORDER BY 1


)PROY

WHERE FECHA.FECHA_CONTABLE = PRODUCCION.FECHA_CONTABLE(+) AND FECHA.FECHA_CONTABLE=PROY.FECHA_CONTABLE(+)
ORDER BY FECHA.FECHA_CONTABLE
































WITH FECHAS AS
(SELECT
   TO_DATE(:FECHA_INI_SEMANA, 'DD/MM/YYYY') - 1 As FEC_INI_SEMANA,
   TO_DATE(:FECHA_FIN_SEMANA, 'DD/MM/YYYY') - 1 As FEC_FIN_SEMANA,
   ADD_MONTHS(TRUNC(
          TO_DATE(:FECHA_FIN_SEMANA, 'DD/MM/YYYY') - 1
     , 'YYYY'),-12) As FEC_INI_ANIO_ANT,
    TRUNC(
         TO_DATE(:FECHA_FIN_SEMANA, 'DD/MM/YYYY') - 1
     , 'YYYY') As FEC_INI_ANIO_ACT
FROM DUAL)

SELECT
    FECHAS.FECHA_CONTABLE, 
    FECHAS.FECHA_CONTABLE + 1 As FECHA_REAL,
    GAS_ZT_REAL.GAS_ZT As GAS_ZT_REAL, 
    GAS_ZT_PROG.GAS_ZT As GAS_ZT_PROG,
    GAS_ZT_PROG.GAS_POT As GAS_ZT_POT,
    FECHAS_SEM.FEC_INI_SEMANA, 
    FECHAS_SEM.FEC_FIN_SEMANA, 
    FECHAS_SEM.FEC_INI_ANIO_ANT,
    FECHAS_SEM.FEC_INI_ANIO_ACT,
    CASE
       WHEN FECHAS_SEM.FEC_FIN_SEMANA = LAST_DAY(FECHAS_SEM.FEC_FIN_SEMANA) THEN FECHAS_SEM.FEC_FIN_SEMANA
       ELSE TRUNC(FECHAS_SEM.FEC_FIN_SEMANA, 'MM') - 1
    END As FEC_FIN_PROM_REAL,
    CASE
       WHEN TRUNC(FECHAS.FECHA_CONTABLE, 'MM') <= ADD_MONTHS(TRUNC(FECHAS_SEM.FEC_FIN_SEMANA, 'MM'), -1)
            OR (TRUNC(FECHAS.FECHA_CONTABLE, 'MM') = TRUNC(FECHAS_SEM.FEC_FIN_SEMANA, 'MM') AND FECHAS_SEM.FEC_FIN_SEMANA = LAST_DAY(FECHAS_SEM.FEC_FIN_SEMANA)) THEN
          1
       ELSE
          0
    END As PROMEDIAR_REAL
FROM
   (SELECT DISTINCT FECHAS.FEC_INI_ANIO_ACT + ROWNUM - 1 As FECHA_CONTABLE
   FROM FECHAS
   CONNECT By ROWNUM <= LAST_DAY(ADD_MONTHS(TRUNC(FECHAS.FEC_FIN_SEMANA, 'YYYY'), 11)) - FECHAS.FEC_INI_ANIO_ACT ) FECHAS,
   (
      ---------empieza REAL
   SELECT /*+ INDEX(GPV GPVINDXCONT) */ 
   GPV.fecha_contable,
   GPV.fecha_real,
   GPV.valor_numerico as GAS_ZT
   FROM GASRMN.gas_parametros_valores GPV, 
   FECHAS
   WHERE  GPV.id_parametros=1872
       AND GPV.plataforma=371
       AND GPV.fecha_contable BETWEEN FECHAS.FEC_INI_ANIO_ACT AND FECHAS.FEC_FIN_SEMANA) GAS_ZT_REAL,
       --------termina REAL
       
       --------empieza  Prog
   (SELECT TRUNC(PROG.DIA, 'MM') As FECHA_CONTABLE, 
   ROUND(AVG(PROG.POM), 4) AS GAS_ZT, ROUND(AVG(PROG.pot1), 4) AS GAS_POT
     FROM programas_gas_rmne PROG, FECHAS
     WHERE PROG.PRODUCTO='ZONA DE TRANSICION'
         AND PROG.DIA BETWEEN FECHAS.FEC_INI_ANIO_ACT AND LAST_DAY(ADD_MONTHS(TRUNC(FECHAS.FEC_FIN_SEMANA, 'YYYY'), 11))
      GROUP By TRUNC(PROG.DIA, 'MM')) GAS_ZT_PROG,
      FECHAS FECHAS_SEM
WHERE
   FECHAS.FECHA_CONTABLE = GAS_ZT_REAL.FECHA_CONTABLE(+)
   AND TRUNC(FECHAS.FECHA_CONTABLE, 'MM') = TRUNC(GAS_ZT_PROG.FECHA_CONTABLE(+), 'MM')
