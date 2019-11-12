-- CONCEPTOS EQUVALENTES
in (" + sProyecto + @")

in ('CANTARELL')


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
    (
    
    
    SELECT INFO.ID_INC_DEC_CONCEPTO, conceptos.macroconcepto||' '|| conceptos.concepto||' '|| DET_CONCEPTOS.DESCRIPCION AS DETALLE,INFO.VOLUMEN AS VOLUMEN
    FROM
   ( SELECT
   ID_INC_DEC_CONCEPTO,
    ID_DET_CONCEPTO, SUM(VOLUMEN) As VOLUMEN
    FROM
     ( SELECT
      CONCEPTOS.id_inc_dec_concepto,
         CONCEPTOS.ID_DET_CONCEPTO_EQUIV As ID_DET_CONCEPTO
        ,SUM(DATOS.VOLUMEN) As VOLUMEN
        FROM    
      ---- TOTAL DE VOLUMEN DE LOS CONCEPTOS ANTIGUOS QUE TENGAN RELACION 
    ---- CON LOS CONCEPTOS NUEVOS, ESTA PREMISA SE CUMPLE CON LA OPCION
    ----  DE QUE LOS CONCEPTOS ANTIGUOS YA NO SE GUARDARAN MENORES
    ----  A LA FECHA DE CORTE (INICIO DE LOS NUEVOS CONCEPTOS)
       (SELECT
        detalle.id_inc_dec_concepto,
        a.id_det_concepto,
        SUM(a.volumen) AS volumen
    FROM pron_just a, aceitene.mne_ace_c_inc_dec_conceptos detalle
    WHERE a.fecha_contable BETWEEN TO_DATE(:FECHA_INI, 'DD/MM/YYYY') -1 AND TO_DATE(:FECHA_INI_REGLA_CPT, 'DD/MM/YYYY') - 2
        AND a.proyecto in (" + sProyecto + @")
        AND a.id_det_concepto not in(80,69,81,71)
        AND a.id_det_concepto = detalle.id_det_concepto_inc
        AND nvl(a.volumen, 0) > 0
    GROUP BY a.id_det_concepto, detalle.id_inc_dec_concepto)DATOS,  
    
    (
        --- OBTIENE EL MAXIMO ID DEL CONCEPTO NUEVO
        ---  POR CADA CONCEPTO VIEJO,
        --- AGRUPADO POR CONCEPTO VIEJO Y CVE_TIPO_CONCEPTO DE LOS NUEVOS
        SELECT MAX(detalle.id_inc_dec_concepto) AS id_inc_dec_concepto ,
        EQUIV.ID_DET_CONCEPTO_EQUIV As ID_DET_CONCEPTO, 
        DET_CONCEPTOS.CVE_TIPO_CONCEPTO,
         MAX(DET_CONCEPTOS.ID_DET_CONCEPTO) As ID_DET_CONCEPTO_EQUIV
        FROM
         
            ACEITENE.MNE_ACE_C_DET_CONCEPTOS DET_CONCEPTOS
            ,ACEITENE.MNE_ACE_EQUIV_CONCEPTOS EQUIV,
            aceitene.mne_ace_c_inc_dec_conceptos detalle
        WHERE DET_CONCEPTOS.ID_DET_CONCEPTO = EQUIV.ID_DET_CONCEPTO
        AND DET_CONCEPTOS.ID_DET_CONCEPTO = DETALLE.ID_DET_CONCEPTO_INC
        
        GROUP By EQUIV.ID_DET_CONCEPTO_EQUIV, DET_CONCEPTOS.CVE_TIPO_CONCEPTO
    ) CONCEPTOS
    
     WHERE
            DATOS.ID_DET_CONCEPTO = CONCEPTOS.ID_DET_CONCEPTO
       GROUP By CONCEPTOS.ID_DET_CONCEPTO_EQUIV,CONCEPTOS.id_inc_dec_concepto
        
    
    UNION ALL

   --- SELECCIONA TODOS LOS CONCEPTOS NUEVOS
   --- EXCEPTO CONDICIONES CLIMATOLOGICAS Y LIBRANZA DE INSTALACIONES
   --- DESPUES DE LA FECHA DE CORTE PARA LOS NUEVOS CONCEPTOS
    SELECT
    detalle.id_inc_dec_concepto,
        a.id_det_concepto,
        SUM(a.volumen) AS volumen
    FROM pron_just a, aceitene.mne_ace_c_inc_dec_conceptos detalle
    WHERE a.fecha_contable BETWEEN TO_DATE(:FECHA_INI_REGLA_CPT, 'DD/MM/YYYY') -1 AND TO_DATE(:FECHA_FIN, 'DD/MM/YYYY') - 1
        AND a.proyecto in (" + sProyecto + @")
        AND a.id_det_concepto not in (
            SELECT ID_DET_CONCEPTO
            FROM ACEITENE.MNE_ACE_EQUIV_CONCEPTOS
            WHERE ID_DET_CONCEPTO_EQUIV IN( 80,69,81,71)) 
             AND a.id_det_concepto = detalle.id_det_concepto_inc
            AND nvl(a.volumen, 0) > 0
    GROUP BY SIGN(a.volumen), a.id_det_concepto,id_inc_dec_concepto
    
    )
    GROUP By ID_INC_DEC_CONCEPTO,ID_DET_CONCEPTO)INFO, 
    
    ACEITENE.MNE_ACE_C_DET_CONCEPTOS DET_CONCEPTOS,
     ACEITENE.MNE_ACE_C_CONCEPTOS CONCEPTOS
    
    WHERE det_conceptos.id_det_concepto = info.id_det_concepto
    AND conceptos.id_concepto = det_conceptos.id_concepto
    
    
    ) incrementos,
   
    (
 
     SELECT INFO.ID_INC_DEC_CONCEPTO,INFO.ID_DET_CONCEPTO, conceptos.macroconcepto||' '|| conceptos.concepto||' '|| DET_CONCEPTOS.DESCRIPCION AS DETALLE,INFO.VOLUMEN AS VOLUMEN
    FROM
   (     
    SELECT
    id_inc_dec_concepto,
    ID_DET_CONCEPTO, SUM(VOLUMEN) As VOLUMEN
    FROM
     (
     
     
     
     
     
    SELECT
     CONCEPTOS.id_inc_dec_concepto,
         CONCEPTOS.ID_DET_CONCEPTO_EQUIV As ID_DET_CONCEPTO
        ,SUM(DATOS.VOLUMEN) As VOLUMEN
        FROM    
     ---- TOTAL DE VOLUMEN DE LOS CONCEPTOS ANTIGUOS QUE TENGAN RELACION 
    ---- CON LOS CONCEPTOS NUEVOS, ESTA PREMISA SE CUMPLE CON LA OPCION
    ----  DE QUE LOS CONCEPTOS ANTIGUOS YA NO SE GUARDARAN MENORES
    ----  A LA FECHA DE CORTE (INICIO DE LOS NUEVOS CONCEPTOS)
      (SELECT
        detalle.id_inc_dec_concepto,
        a.id_det_concepto,
        SUM(a.volumen) AS volumen
    FROM pron_just a, aceitene.mne_ace_c_inc_dec_conceptos detalle
    WHERE a.fecha_contable BETWEEN TO_DATE(:FECHA_INI, 'DD/MM/YYYY') -1 AND TO_DATE(:FECHA_INI_REGLA_CPT, 'DD/MM/YYYY') - 2
        AND a.proyecto in (" + sProyecto + @")
        AND a.id_det_concepto not in(80,69,81,71)
        AND a.id_det_concepto = detalle.id_det_concepto_dec
        AND nvl(a.volumen, 0) < 0
    GROUP BY a.id_det_concepto, detalle.id_inc_dec_concepto)DATOS,
    
    
        --- OBTIENE EL MAXIMO ID DEL CONCEPTO NUEVO
        ---  POR CADA CONCEPTO VIEJO,
        --- AGRUPADO POR CONCEPTO VIEJO Y CVE_TIPO_CONCEPTO DE LOS NUEVOS
      
      (
      
     SELECT MAX(detalle.id_inc_dec_concepto) AS id_inc_dec_concepto,EQUIV.ID_DET_CONCEPTO_EQUIV As ID_DET_CONCEPTO, DET_CONCEPTOS.CVE_TIPO_CONCEPTO, MAX(DET_CONCEPTOS.ID_DET_CONCEPTO) As ID_DET_CONCEPTO_EQUIV
        FROM
            ACEITENE.MNE_ACE_C_DET_CONCEPTOS DET_CONCEPTOS
            ,ACEITENE.MNE_ACE_EQUIV_CONCEPTOS EQUIV,
             aceitene.mne_ace_c_inc_dec_conceptos detalle
        WHERE DET_CONCEPTOS.ID_DET_CONCEPTO = EQUIV.ID_DET_CONCEPTO
              AND EQUIV.ID_DET_CONCEPTO=DETALLE.ID_DET_CONCEPTO_DEC
        GROUP By EQUIV.ID_DET_CONCEPTO_EQUIV, DET_CONCEPTOS.CVE_TIPO_CONCEPTO
   

      
    ) CONCEPTOS
    
     WHERE
            DATOS.ID_DET_CONCEPTO = CONCEPTOS.ID_DET_CONCEPTO
        GROUP By CONCEPTOS.id_inc_dec_concepto, CONCEPTOS.ID_DET_CONCEPTO_EQUIV
  


     UNION ALL

   --- SELECCIONA TODOS LOS CONCEPTOS NUEVOS
   --- EXCEPTO CONDICIONES CLIMATOLOGICAS Y LIBRANZA DE INSTALACIONES
   --- DESPUES DE LA FECHA DE CORTE PARA LOS NUEVOS CONCEPTOS
    SELECT
     detalle.id_inc_dec_concepto,
        a.id_det_concepto,
        SUM(a.volumen) AS volumen
    FROM pron_just a, aceitene.mne_ace_c_inc_dec_conceptos detalle
    WHERE a.fecha_contable BETWEEN TO_DATE(:FECHA_INI_REGLA_CPT, 'DD/MM/YYYY') -1 AND TO_DATE(:FECHA_FIN, 'DD/MM/YYYY') - 1
        AND a.proyecto in (" + sProyecto + @")
        AND a.id_det_concepto not in (
            SELECT ID_DET_CONCEPTO
            FROM ACEITENE.MNE_ACE_EQUIV_CONCEPTOS
            WHERE ID_DET_CONCEPTO_EQUIV IN( 80,69,81,71)) 
             AND a.id_det_concepto = detalle.id_det_concepto_dec
            AND nvl(a.volumen, 0) < 0
    GROUP BY SIGN(a.volumen), a.id_det_concepto,DETALLE.id_inc_dec_concepto
    )
     GROUP By  ID_INC_DEC_CONCEPTO,ID_DET_CONCEPTO)INFO,
        
     ACEITENE.MNE_ACE_C_DET_CONCEPTOS DET_CONCEPTOS,
       ACEITENE.MNE_ACE_C_CONCEPTOS CONCEPTOS
       
    WHERE det_conceptos.id_det_concepto = info.id_det_concepto
      AND conceptos.id_concepto = det_conceptos.id_concepto
      
    ) decrementos,
    
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
           a.macroconcepto ||' '||a.concepto ||' '|| a.detalle as detalle,nvl(sum(a.acum),0) AS volumen
     FROM
        (SELECT
              fecha.fecha_contable as fecha,a.volumen as vol,b.detalle,
              SUM(a.volumen) OVER(ORDER By fecha.fecha_contable ASC) as acum,b.macroconcepto,b.concepto
         FROM             
             (SELECT to_date(:FECHA_INI,'dd/mm/yyyy')-1 + ROWNUM - 1 As FECHA_CONTABLE  FROM DUAL 
                  CONNECT By ROWNUM <= to_date(:FECHA_FIN,'dd/mm/yyyy') - to_date(:FECHA_INI,'dd/mm/yyyy') + 1 )fecha,          
             (SELECT fecha_contable,det_concepto, sum(volumen) as volumen
               FROM pron_just 
               WHERE fecha_contable between to_date(:FECHA_INI,'dd/mm/yyyy')-1 and to_date(:FECHA_FIN,'dd/mm/yyyy')-1 
                   And id_det_concepto IN (80,69,345,347,348,350) and proyecto in (" + sProyecto + @")
               GROUP By fecha_contable,det_concepto)a,                             
             (SELECT ace.id_det_concepto, aco.macroconcepto,aco.concepto, ace.descripcion as detalle 
               FROM aceitene.mne_ace_c_det_conceptos ace, aceitene.mne_ace_c_conceptos aco
               WHERE ace.id_concepto = aco.id_concepto
                    And ace.id_det_concepto = 347 )b               
         WHERE fecha.fecha_contable = a.fecha_contable(+)            
         ORDER By fecha.fecha_contable)a
     GROUP By a.detalle, a.macroconcepto ||' '||a.concepto ||' '|| a.detalle)libranza


 UNION ALL

 select

CASE WHEN clima.volumen<0 THEN clima.detalle ELSE null END,
CASE WHEN clima.volumen>=0 THEN clima.detalle ELSE null END,
CASE WHEN clima.volumen<0 THEN clima.volumen ELSE null END,
CASE WHEN clima.volumen>=0 THEN clima.volumen ELSE null END

from

 
   --------CIERRE DE  PRODUCCIÃ“N POR MALAS COND. CLIMATOLOGICAS 
     (SELECT ----12 as ORDEN, 
           a.macroconcepto ||' '|| a.concepto ||' '|| a.detalle as detalle, nvl(sum(a.acum),0) AS volumen
     FROM
          (SELECT
             fecha.fecha_contable as fecha,a.volumen as vol, b.detalle,
             SUM(a.volumen) OVER(ORDER By fecha.fecha_contable ASC) as acum,b.macroconcepto,b.concepto
          FROM
             (SELECT to_date(:FECHA_INI,'dd/mm/yyyy')-1 + ROWNUM - 1 As FECHA_CONTABLE  FROM DUAL 
               CONNECT By ROWNUM <= to_date(:FECHA_FIN,'dd/mm/yyyy') - to_date(:FECHA_INI,'dd/mm/yyyy') + 1 )fecha,
             (SELECT fecha_contable,det_concepto, sum(volumen) as volumen
               FROM pron_just 
               WHERE fecha_contable between to_date(:FECHA_INI,'dd/mm/yyyy')-1 and to_date(:FECHA_FIN,'dd/mm/yyyy')-1 
                    And id_det_concepto IN (81,71,385,387,389,390) and proyecto in (" + sProyecto + @")
               GROUP By fecha_contable,det_concepto)a,     
              (SELECT ace.id_det_concepto, aco.macroconcepto,aco.concepto, ace.descripcion as detalle 
                FROM aceitene.mne_ace_c_det_conceptos ace, aceitene.mne_ace_c_conceptos aco
                WHERE ace.id_concepto = aco.id_concepto
                     And ace.id_det_concepto = 389 )b
        WHERE fecha.fecha_contable = a.fecha_contable(+)                 
        ORDER By fecha.fecha_contable)a    
GROUP By a.detalle,  a.macroconcepto ||' '|| a.concepto ||' '|| a.detalle)clima



)

where

ABS(volumen_dec) * 1000 >= :LIMITE
order by volumen_dec asc
)




