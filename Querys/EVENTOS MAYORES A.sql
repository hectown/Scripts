

select  detalle_dec,
    detalle_inc,
    volumen_dec,
    volumen_inc,
    rownum as orden
    from
    
    (
SELECT detalle_dec,
    detalle_inc,
    volumen_dec,
    volumen_inc
   

from
(
SELECT

     decrementos.detalle AS detalle_dec,
     incrementos.detalle AS detalle_inc,
     decrementos.volumen As volumen_dec,
     incrementos.volumen As volumen_inc
FROM
    (SELECT
        detalle.id_inc_dec_concepto,
        a.id_det_concepto,
        a.det_concepto AS detalle,
        SUM(a.volumen) AS volumen
    FROM pron_just a, aceitene.mne_ace_c_inc_dec_conceptos detalle
    WHERE a.fecha_contable BETWEEN TO_DATE(:FECHA_INI, 'DD/MM/YYYY') -1 AND TO_DATE(:FECHA_FIN, 'DD/MM/YYYY') - 1
        AND a.proyecto IN ('CANTARELL','EK BALAM','KU MALOOB ZAAP')
        AND a.id_det_concepto not in(80,69,81,71)
        AND a.id_det_concepto = detalle.id_det_concepto_inc
        AND nvl(a.volumen, 0) > 0
    GROUP BY a.id_det_concepto, a.det_concepto, detalle.id_inc_dec_concepto) incrementos,
    (SELECT
        detalle.id_inc_dec_concepto,
        a.id_det_concepto,
        a.det_concepto AS detalle,
        SUM(a.volumen) AS volumen
    FROM pron_just a, aceitene.mne_ace_c_inc_dec_conceptos detalle
    WHERE a.fecha_contable BETWEEN TO_DATE(:FECHA_INI, 'DD/MM/YYYY') -1 AND TO_DATE(:FECHA_FIN, 'DD/MM/YYYY') - 1
        AND a.proyecto IN ('CANTARELL','EK BALAM','KU MALOOB ZAAP')
        AND a.id_det_concepto not in(80,69,81,71)
        AND a.id_det_concepto = detalle.id_det_concepto_dec
        AND nvl(a.volumen, 0) < 0
    GROUP BY a.id_det_concepto, a.det_concepto, detalle.id_inc_dec_concepto) decrementos,
    aceitene.mne_ace_c_inc_dec_conceptos inc_dec
WHERE inc_dec.id_inc_dec_concepto = incrementos.id_inc_dec_concepto(+)
    AND inc_dec.id_inc_dec_concepto = decrementos.id_inc_dec_concepto(+)
    AND (nvl(decrementos.volumen, 0) <> 0 Or nvl(incrementos.volumen, 0) <> 0) 
 

   UNION ALL
     
    /*LIBRANZAS INSTALACIONES*/ 
  

select

CASE WHEN libranza.volumen<0 THEN libranza.detalle ELSE null END,
CASE WHEN libranza.volumen>=0 THEN libranza.detalle ELSE null END,
CASE WHEN libranza.volumen<0 THEN libranza.volumen ELSE null END,
CASE WHEN libranza.volumen>=0 THEN libranza.volumen ELSE null END

from
 (SELECT ---11 as ORDEN, 
           a.detalle,nvl(sum(a.acum),0) AS volumen
     FROM
        (SELECT
              fecha.fecha_contable as fecha,a.volumen as vol,b.detalle,
              SUM(a.volumen) OVER(ORDER By fecha.fecha_contable ASC) as acum,b.macroconcepto
         FROM             
             (SELECT to_date(:FECHA_INI,'dd/mm/yyyy')-1 + ROWNUM - 1 As FECHA_CONTABLE  FROM DUAL 
                  CONNECT By ROWNUM <= to_date(:FECHA_FIN,'dd/mm/yyyy') - to_date(:FECHA_INI,'dd/mm/yyyy') + 1 )fecha,          
             (SELECT fecha_contable,det_concepto, sum(volumen) as volumen
               FROM pron_just 
               WHERE fecha_contable between to_date(:FECHA_INI,'dd/mm/yyyy')-1 and to_date(:FECHA_FIN,'dd/mm/yyyy')-1 
                   And id_det_concepto IN (80,69) and proyecto in ('CANTARELL','EK BALAM','KU MALOOB ZAAP')
               GROUP By fecha_contable,det_concepto)a,                             
             (SELECT ace.id_det_concepto, aco.macroconcepto, ace.descripcion as detalle 
               FROM aceitene.mne_ace_c_det_conceptos ace, aceitene.mne_ace_c_conceptos aco
               WHERE ace.id_concepto = aco.id_concepto
                    And ace.id_det_concepto = 80 )b               
         WHERE fecha.fecha_contable = a.fecha_contable(+)            
         ORDER By fecha.fecha_contable)a
     GROUP By a.detalle, a.macroconcepto)libranza


 UNION ALL

 select

CASE WHEN clima.volumen<0 THEN clima.detalle ELSE null END,
CASE WHEN clima.volumen>=0 THEN clima.detalle ELSE null END,
CASE WHEN clima.volumen<0 THEN clima.volumen ELSE null END,
CASE WHEN clima.volumen>=0 THEN clima.volumen ELSE null END

from

 
   --------CIERRE DE  PRODUCCIÓN POR MALAS COND. CLIMATOLOGICAS 
     (SELECT ----12 as ORDEN, 
           a.detalle, nvl(sum(a.acum),0) AS volumen
     FROM
          (SELECT
             fecha.fecha_contable as fecha,a.volumen as vol, b.detalle,
             SUM(a.volumen) OVER(ORDER By fecha.fecha_contable ASC) as acum,b.macroconcepto
          FROM
             (SELECT to_date(:FECHA_INI,'dd/mm/yyyy')-1 + ROWNUM - 1 As FECHA_CONTABLE  FROM DUAL 
               CONNECT By ROWNUM <= to_date(:FECHA_FIN,'dd/mm/yyyy') - to_date(:FECHA_INI,'dd/mm/yyyy') + 1 )fecha,
             (SELECT fecha_contable,det_concepto, sum(volumen) as volumen
               FROM pron_just 
               WHERE fecha_contable between to_date(:FECHA_INI,'dd/mm/yyyy')-1 and to_date(:FECHA_FIN,'dd/mm/yyyy')-1 
                    And id_det_concepto IN (81,71) and proyecto in ('CANTARELL','EK BALAM','KU MALOOB ZAAP')
               GROUP By fecha_contable,det_concepto)a,     
              (SELECT ace.id_det_concepto, aco.macroconcepto, ace.descripcion as detalle 
                FROM aceitene.mne_ace_c_det_conceptos ace, aceitene.mne_ace_c_conceptos aco
                WHERE ace.id_concepto = aco.id_concepto
                     And ace.id_det_concepto = 81 )b
        WHERE fecha.fecha_contable = a.fecha_contable(+)                 
        ORDER By fecha.fecha_contable)a    
GROUP By a.detalle, a.macroconcepto)clima
)

where

ABS(volumen_dec) * 1000 >= :LIMITE
order by volumen_dec asc
)










