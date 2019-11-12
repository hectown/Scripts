  
SELECT id_det_concepto AS id, descripcion
                FROM aceitene.mne_ace_c_det_conceptos        
               where

               
                id_det_concepto IN('122','120','123','124','140','142','144','115','117','118','119','105','108','25','26','52','141','143','145','121','114','30','31','53','144','116') 



  select id_det_concepto,det_concepto,to_char(fecha_contable,'DD/MM/YYYY')as fecha_contable, ROUND(SUM(volumen), 1) AS volumen,
    CASE id_det_concepto
                        
                        WHEN 141 THEN 1
                        WHEN 143 THEN 2
                        WHEN 145 THEN 3
                        WHEN 122 THEN 4
                        WHEN 120 THEN 5
                        WHEN 123 THEN 6
                        WHEN 108 THEN 7
                        WHEN 124 THEN 8
                        WHEN 140 THEN 9
                        WHEN 142 THEN 10
                        WHEN 144 THEN 11
                        WHEN 115 THEN 11
                        WHEN 117 THEN 12
                        WHEN 118 THEN 13
                        WHEN 119 THEN 14
                        WHEN 105 THEN 15
                    END AS orden
   
   from pron_just 
     where fecha_contable + 1 BETWEEN to_date(:FECHAINI,'dd/mm/yyyy') and to_date(:FECHAFIN,'dd/mm/yyyy')
     and id_det_concepto IN('141','143','145','122','120','123','124','140','142','144','115','117','118','119','105','108') 
     and proyecto in('CANTARELL','EK BALAM','KU MALOB ZAAP') 
      group by det_concepto, id_det_concepto, fecha_contable
        ORDER BY 5, 3
        
        
        
        
        
        
    SELECT
                    SUM(id_141) AS tot_141, ROUND(AVG(id_141),2) AS prom_141, ROUND(STDDEV(id_141),2) AS desvst_141,
                    SUM(id_143) AS tot_143, ROUND(AVG(id_143),2) AS prom_143, ROUND(STDDEV(id_143),2) AS desvst_143,
                    SUM(id_145) AS tot_145, ROUND(AVG(id_145),2) AS prom_145, ROUND(STDDEV(id_145),2) AS desvst_145,
                    SUM(id_122) AS tot_122, ROUND(AVG(id_122),2) AS prom_122, ROUND(STDDEV(id_122),2) AS desvst_122,
                    SUM(id_120) AS tot_120, ROUND(AVG(id_120),2) AS prom_120, ROUND(STDDEV(id_120),2) AS desvst_120,
                   
                    SUM(id_123) AS tot_123, ROUND(AVG(id_123),2) AS prom_123, ROUND(STDDEV(id_123),2) AS desvst_123,
                    SUM(id_108) AS tot_108, ROUND(AVG(id_108),2) AS prom_108, ROUND(STDDEV(id_108),2) AS desvst_108,                    
                    SUM(id_124) AS tot_124, ROUND(AVG(id_124),2) AS prom_124, ROUND(STDDEV(id_124),2) AS desvst_124,
                   
                  
                    SUM(id_140) AS tot_140, ROUND(AVG(id_140),2) AS prom_140, ROUND(STDDEV(id_140),2) AS desvst_140,
                    SUM(id_142) AS tot_142, ROUND(AVG(id_142),2) AS prom_142, ROUND(STDDEV(id_142),2) AS desvst_142,
                    SUM(id_144) AS tot_144, ROUND(AVG(id_144),2) AS prom_144, ROUND(STDDEV(id_144),2) AS desvst_144,
                    SUM(id_115) AS tot_115, ROUND(AVG(id_115),2) AS prom_115, ROUND(STDDEV(id_115),2) AS desvst_115,
                   
                    SUM(id_117) AS tot_117, ROUND(AVG(id_117),2) AS prom_117, ROUND(STDDEV(id_117),2) AS desvst_117,
                    SUM(id_118) AS tot_118, ROUND(AVG(id_118),2) AS prom_118, ROUND(STDDEV(id_118),2) AS desvst_118,
                    SUM(id_119) AS tot_119, ROUND(AVG(id_119),2) AS prom_119, ROUND(STDDEV(id_119),2) AS desvst_119,
                    SUM(id_105) AS tot_105, ROUND(AVG(id_105),2) AS prom_105, ROUND(STDDEV(id_105),2) AS desvst_105
                FROM
                    (
                    SELECT fecha_contable,
                        SUM(CASE WHEN id_det_concepto = 141 THEN volumen ELSE NULL END) AS id_141,
                        SUM(CASE WHEN id_det_concepto = 143 THEN volumen ELSE NULL END) AS id_143,
                      
                        SUM(CASE WHEN id_det_concepto = 145 THEN volumen ELSE NULL END) AS id_145,
                    
                        SUM(CASE WHEN id_det_concepto = 122 THEN volumen ELSE NULL END) AS id_122,
                        SUM(CASE WHEN id_det_concepto = 120 THEN volumen ELSE NULL END) AS id_120,
                      
                        SUM(CASE WHEN id_det_concepto = 123 THEN volumen ELSE NULL END) AS id_123,
                        SUM(CASE WHEN id_det_concepto = 108 THEN volumen ELSE NULL END) AS id_108,
                        SUM(CASE WHEN id_det_concepto = 124 THEN volumen ELSE NULL END) AS id_124,
                     
                     
                        SUM(CASE WHEN id_det_concepto = 140 THEN volumen ELSE NULL END) AS id_140,
                        SUM(CASE WHEN id_det_concepto = 142 THEN volumen ELSE NULL END) AS id_142,
                        SUM(CASE WHEN id_det_concepto = 144 THEN volumen ELSE NULL END) AS id_144,
                        SUM(CASE WHEN id_det_concepto = 115 THEN volumen ELSE NULL END) AS id_115,
                       
                        SUM(CASE WHEN id_det_concepto = 117 THEN volumen ELSE NULL END) AS id_117,
                        SUM(CASE WHEN id_det_concepto = 118 THEN volumen ELSE NULL END) AS id_118,
                        SUM(CASE WHEN id_det_concepto = 119 THEN volumen ELSE NULL END) AS id_119,
                        
                          SUM(CASE WHEN id_det_concepto = 105 THEN volumen ELSE NULL END) AS id_105
                         
                    FROM pron_just
                    WHERE fecha_contable + 1 BETWEEN TO_DATE(:FECHAINI,'DD/MM/YYYY') AND TO_DATE(:FECHAFIN,'DD/MM/YYYY')
                        AND proyecto IN (" + activo+ @")
                        AND id_det_concepto IN('141','143','145','122','120','123','124','140','142','144','115','117','118','119','105','108') 
                    GROUP BY fecha_contable
                    ORDER BY 1
                    )
                    
                    
                    
                    
                     WITH pozos AS
                    (
                    SELECT just.fecha_contable, pla.id, pla.activo, pla.desc_larga,
                        COUNT(just.id_justificacion) AS cont, SUM(just.volumen) AS volumen
                    FROM pron_just just, pron_movs mov, pozormne.gas_plataformas pla
                    WHERE just.fecha_contable + 1 BETWEEN TO_DATE(:FECHA_INI,'DD/MM/YYYY') AND TO_DATE(:FECHA_FIN,'DD/MM/YYYY')
                        AND just.proyecto IN (" + sProyecto + @")
                        AND just.id_det_concepto IN (" + sId_Conceptos + @")
                        AND just.id_justificacion = mov.id_justificacion
                        AND mov.id_instalacion = pla.id
                    GROUP BY just.fecha_contable, pla.id, pla.activo, pla.desc_larga
                    ORDER BY 1, 3
                    )

                SELECT TO_CHAR(a.fecha_contable, 'DD/MM/YYYY') AS fecha_contable,
                    a.id, a.activo, a.desc_larga, a.cont, a.volumen, b.movimiento
                FROM
                    (
                    SELECT *
                    FROM pozos
                    ) a,
                    (
                    SELECT dist.fecha_real - 1 AS fecha_contable, dist.id, dist.movimiento
                    FROM pozormne.rmn_po_dist_por_pozo dist
                    WHERE (dist.fecha_real, dist.id) IN
                            (
                            SELECT fecha_contable + 1 AS fecha_rel, id
                            FROM pozos
                            )
                    ) b
                WHERE a.id = b.id(+)
                    AND a.fecha_contable = b.fecha_contable(+) and b.movimiento is not null
                ORDER BY 3, 4, 1
                
                
                
                
                
                 select to_char(fecha.fecha_contable,'dd/MM/yyyy') as fecha, SUM(b.volumen) OVER(ORDER By fecha.fecha_contable ASC) as acum,positivos.volumen as positivos, negativos.volumen as negativos

         from

        (SELECT to_date(:FECHA_INI,'dd/mm/yyyy')-1 + ROWNUM - 1 As FECHA_CONTABLE  FROM DUAL 
               CONNECT By ROWNUM <= to_date(:FECHA_FIN,'dd/mm/yyyy') - to_date(:FECHA_INI,'dd/mm/yyyy') + 1 )fecha,

  
   (select fecha_contable, ROUND(SUM(volumen), 1) AS volumen
   
    from pron_just 
     where fecha_contable + 1 BETWEEN to_date(:FECHA_INI,'dd/mm/yyyy') and to_date(:FECHA_FIN,'dd/mm/yyyy')
     and id_det_concepto IN("+sId_Conceptos+@") 
     and proyecto IN ("+sProyecto+@")
      group by fecha_contable)b,
      
      
      (select fecha_contable, ROUND(SUM(volumen), 1) AS volumen
   
    from pron_just 
     where fecha_contable + 1 BETWEEN to_date(:FECHA_INI,'dd/mm/yyyy') and to_date(:FECHA_FIN,'dd/mm/yyyy')
     and id_det_concepto IN('141','143','145','122','120','123','124','144') 
     and proyecto IN (" + sProyecto + @")
      group by fecha_contable)positivos,
      
      
         
      (select fecha_contable, ROUND(SUM(volumen), 1) AS volumen
   
    from pron_just 
     where fecha_contable + 1 BETWEEN to_date(:FECHA_INI,'dd/mm/yyyy') and to_date(:FECHA_FIN,'dd/mm/yyyy')
     and id_det_concepto  IN('140','142','115','117','118','119','105','108') 
     and proyecto IN (" + sProyecto + @")
      group by fecha_contable)negativos
      
      
      
                    where fecha.fecha_contable = b.fecha_contable(+) and
                   fecha.fecha_contable =positivos.fecha_contable(+) and
                   fecha.fecha_contable=negativos.fecha_contable(+)              
                   
                 
                 order by fecha.fecha_contable
                 
                 
                 
               
                 
                 
                 SELECT distinct id_det_concepto AS id, det_concepto as descripcion
                FROM pron_just
                WHERE fecha_contable + 1 BETWEEN to_date(:FECHA_INI,'dd/mm/yyyy') and to_date(:FECHA_FIN,'dd/mm/yyyy') and
                id_det_concepto IN('141','143','145','122','120','123','124','140','142','144','115','117','118','119','105','108') 
                
                
                
                @"SELECT id_det_concepto AS id, descripcion
                FROM aceitene.mne_ace_c_det_conceptos
                WHERE id_det_concepto IN (" + idConcepto + ")";
