
WITH DATOS_REAL As(
SELECT

INFO.TIPO,INFO.ID_DET_CONCEPTO_DEC,INFO.ID_DET_CONCEPTO_INC,INFO.ID_INC_DEC_CONCEPTO,INFO.ID_JUSTIFICACION,INFO.PROYECTO,
     INFO.FECHA_CONTABLE,INFO.ID_DET_CONCEPTO,INFO.VOLUMEN,INFO.ID_CONCEPTO,
     conceptos.macroconcepto||' '|| conceptos.concepto||' '|| DET_CONCEPTOS.DESCRIPCION AS DET_CONCEPTO,
     INFO.IDS_POZOS,INFO.DESC_INSTALACION
FROM
(SELECT * FROM
    (SELECT
     DATOS.TIPO,DATOS.ID_DET_CONCEPTO_DEC,DATOS.ID_DET_CONCEPTO_INC,DATOS.ID_INC_DEC_CONCEPTO,DATOS.ID_JUSTIFICACION,DATOS.PROYECTO,
     DATOS.FECHA_CONTABLE,CONCEPTOS.ID_DET_CONCEPTO,DATOS.VOLUMEN,DATOS.ID_CONCEPTO,DATOS.IDS_POZOS,DATOS.DESC_INSTALACION
       
        FROM 

 
 (SELECT
        'R' as tipo,di.id_det_concepto_dec,di.id_det_concepto_inc, di.id_inc_dec_concepto,jd.id_justificacion, jd.proyecto, 
        jd.fecha_contable, jd.id_det_concepto, jd.volumen, jd.id_concepto,
        DBMS_XMLGEN.CONVERT(rtrim(extract(xmlagg(xmlelement("VALS",ijd.ID_INSTALACION|| ',') ORDER By ijd.ID_INSTALACION ASC),'//text()').getStringVal(), ','),1) AS IDS_POZOS,
        DBMS_XMLGEN.CONVERT(rtrim(extract(xmlagg(xmlelement("VALS",ijd.DESC_INSTALACION|| ',') ORDER By ijd.DESC_INSTALACION ASC),'//text()').getStringVal(), ','),1) AS DESC_INSTALACION
    FROM aceitene.mne_ace_c_inc_dec_conceptos di, aceitene.mne_ace_c_det_conceptos ca, pron_just jd,pron_movs ijd
    WHERE di.id_det_concepto_dec is not null
        AND di.id_det_concepto_inc is not null  
        AND jd.id_det_concepto=ca.id_det_concepto
        AND((ca.cve_tipo_concepto in ('A', 'D')
        AND ca.id_det_concepto=di.id_det_concepto_dec)
        OR (ca.cve_tipo_concepto IN('A', 'I')
        AND ca.id_det_concepto=di.id_det_concepto_inc))
        AND jd.proyecto IN (:PROYECTO)
        AND jd.id_justificacion=ijd.id_justificacion
        AND ijd.cve_tipo='P'
        AND jd.fecha_contable between to_date(:fecha_ini,'dd/mm/yyyy') and to_date('31/12/2011','dd/mm/yyyy')
    GROUP By di.id_det_concepto_dec,di.id_det_concepto_inc, di.id_inc_dec_concepto,jd.id_justificacion, jd.proyecto, 
        jd.fecha_contable, jd.volumen, jd.id_det_concepto, jd.id_concepto   
        order by jd.fecha_contable) DATOS,
        
        ( SELECT EQUIV.ID_DET_CONCEPTO_EQUIV As ID_DET_CONCEPTO, DET_CONCEPTOS.CVE_TIPO_CONCEPTO, MAX(DET_CONCEPTOS.ID_DET_CONCEPTO) As ID_DET_CONCEPTO_EQUIV
        FROM
            ACEITENE.MNE_ACE_C_DET_CONCEPTOS DET_CONCEPTOS
            ,ACEITENE.MNE_ACE_EQUIV_CONCEPTOS EQUIV
        WHERE DET_CONCEPTOS.ID_DET_CONCEPTO = EQUIV.ID_DET_CONCEPTO
        GROUP By EQUIV.ID_DET_CONCEPTO_EQUIV, DET_CONCEPTOS.CVE_TIPO_CONCEPTO) CONCEPTOS
        
        WHERE
         DATOS.ID_DET_CONCEPTO = CONCEPTOS.ID_DET_CONCEPTO
          And ( CONCEPTOS.cve_tipo_concepto = 'A' Or DECODE(SIGN(DATOS.volumen), 1, 'I', 'D') = CONCEPTOS.cve_tipo_concepto )
         ORDER BY DATOS.FECHA_CONTABLE)
       

        UNION ALL

SELECT * FROM

  ( SELECT
        'R' as tipo,di.id_det_concepto_dec,di.id_det_concepto_inc, di.id_inc_dec_concepto,jd.id_justificacion, jd.proyecto, 
        jd.fecha_contable, equiv.id_det_concepto_equiv,jd.volumen, jd.id_concepto,
        DBMS_XMLGEN.CONVERT(rtrim(extract(xmlagg(xmlelement("VALS",ijd.ID_INSTALACION|| ',') ORDER By ijd.ID_INSTALACION ASC),'//text()').getStringVal(), ','),1) AS IDS_POZOS,
        DBMS_XMLGEN.CONVERT(rtrim(extract(xmlagg(xmlelement("VALS",ijd.DESC_INSTALACION|| ',') ORDER By ijd.DESC_INSTALACION ASC),'//text()').getStringVal(), ','),1) AS DESC_INSTALACION
    FROM aceitene.mne_ace_c_inc_dec_conceptos di, aceitene.mne_ace_c_det_conceptos ca, pron_just jd,pron_movs ijd,
     (SELECT EQUIV.ID_DET_CONCEPTO_EQUIV As ID_DET_CONCEPTO, DET_CONCEPTOS.CVE_TIPO_CONCEPTO, MAX(DET_CONCEPTOS.ID_DET_CONCEPTO) As ID_DET_CONCEPTO_EQUIV,max(det_conceptos.descripcion) as descripcion
        FROM
            ACEITENE.MNE_ACE_C_DET_CONCEPTOS DET_CONCEPTOS
            ,ACEITENE.MNE_ACE_EQUIV_CONCEPTOS EQUIV
        WHERE DET_CONCEPTOS.ID_DET_CONCEPTO = EQUIV.ID_DET_CONCEPTO
        GROUP By EQUIV.ID_DET_CONCEPTO_EQUIV, DET_CONCEPTOS.CVE_TIPO_CONCEPTO) equiv
    WHERE di.id_det_concepto_dec is not null
        AND di.id_det_concepto_inc is not null  
        AND jd.id_det_concepto=ca.id_det_concepto
        AND((ca.cve_tipo_concepto in ('A', 'D')
        AND ca.id_det_concepto=di.id_det_concepto_dec)
        OR (ca.cve_tipo_concepto IN('A', 'I')
        AND ca.id_det_concepto=di.id_det_concepto_inc)) 
        AND jd.proyecto IN (:PROYECTO)
        AND jd.id_justificacion=ijd.id_justificacion
        AND ijd.cve_tipo='P'
        AND jd.fecha_contable between to_date('01/01/2012','dd/mm/yyyy') and to_date(:fecha_fin,'dd/mm/yyyy')
        And ca.id_det_concepto=equiv.id_det_concepto
        And ( equiv.cve_tipo_concepto = 'A' Or DECODE(SIGN(jd.volumen), 1, 'I', 'D') = equiv.cve_tipo_concepto )
       GROUP By di.id_det_concepto_dec,di.id_det_concepto_inc, di.id_inc_dec_concepto,jd.id_justificacion, jd.proyecto, 
        jd.fecha_contable, jd.volumen, equiv.id_det_concepto_equiv, jd.id_concepto
        ORDER BY JD.FECHA_CONTABLE
        ))INFO,
        ACEITENE.MNE_ACE_C_DET_CONCEPTOS DET_CONCEPTOS,
        ACEITENE.MNE_ACE_C_CONCEPTOS CONCEPTOS
      
      WHERE  
      det_conceptos.id_det_concepto = info.id_det_concepto
      AND conceptos.id_concepto = det_conceptos.id_concepto)
      
      
   SELECT DT_OUT.TIPO, DT_OUT.id_det_concepto_dec, DT_OUT.id_det_concepto_inc, DT_OUT.id_inc_dec_concepto,
    DT_OUT.id_justificacion, DT_OUT.proyecto, DT_OUT.fecha_contable, DT_OUT.id_det_concepto, DT_OUT.det_concepto, DT_OUT.volumen,
    DT_OUT.ids_pozos, DT_OUT.desc_instalacion,
    1 As consec
FROM DATOS_REAL DT_OUT
WHERE
     DT_OUT.FECHA_CONTABLE >= (SELECT MIN(FECHA_CONTABLE) FROM DATOS_REAL DT_IN WHERE DT_IN.id_inc_dec_concepto = DT_OUT.id_inc_dec_concepto AND DT_IN.IDS_POZOS = DT_OUT.IDS_POZOS AND DT_IN.VOLUMEN < 0)
        
