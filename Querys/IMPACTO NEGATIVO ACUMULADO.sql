          
   
      /*query principal*/
      
      select b.fecha_contable as fecha, b.acum as acum, to_char(suma.sumatoria,'FM9,999.99') as sumatoria,b.det_concepto
                from
                
            
(select fecha.fecha_contable, SUM(a.volumen) OVER(ORDER By fecha.fecha_contable ASC) as acum,a.id_det_concepto,a.det_concepto

from


(SELECT to_date(:FECHAINI,'dd/mm/yyyy')-1 + ROWNUM - 1 As FECHA_CONTABLE FROM DUAL 

CONNECT By ROWNUM <= to_date(:FECHAFIN,'dd/mm/yyyy') - to_date(:FECHAINI,'dd/mm/yyyy') + 1 )fecha,

 

(select fecha_contable,id_det_concepto,det_concepto, sum(volumen) as volumen from pron_just 

where fecha_contable between to_date(:FECHAINI,'dd/mm/yyyy')-1 and to_date(:FECHAFIN,'dd/mm/yyyy')-1 

and id_det_concepto IN ('120','115','121','116','122','117','123','118','124','119','145','144','141','140') and proyecto in ('KU MALOOB ZAAP')
group by fecha_contable,id_det_concepto,det_concepto

)a

where fecha.fecha_contable = a.fecha_contable(+)
)b,



(


select sum(acum) as sumatoria
from
(select fecha.fecha_contable, SUM(a.volumen) OVER(ORDER By fecha.fecha_contable ASC) as acum

from


(SELECT to_date(:FECHAINI,'dd/mm/yyyy')-1 + ROWNUM - 1 As FECHA_CONTABLE FROM DUAL 

CONNECT By ROWNUM <= to_date(:FECHAFIN,'dd/mm/yyyy') - to_date(:FECHAINI,'dd/mm/yyyy') + 1 )fecha,

 

(select fecha_contable, sum(volumen) as volumen from pron_just 

where fecha_contable between to_date(:FECHAINI,'dd/mm/yyyy')-1 and to_date(:FECHAFIN,'dd/mm/yyyy')-1 

and id_det_concepto IN ('122','117') and proyecto in ('KU MALOOB ZAAP')
group by fecha_contable

)a

where fecha.fecha_contable = a.fecha_contable(+))

)suma
                       
    










































                   
  select b.fecha_contable as fecha, b.acum as acum, to_char(suma.sumatoria,'FM9,999.99') as sumatoria,b.det_concepto from
                
            
(select fecha.fecha_contable, SUM(a.volumen) OVER(ORDER By fecha.fecha_contable ASC) as acum,a.id_det_concepto,a.det_concepto,a.comentarios
                 from
                 
 (SELECT to_date(:FECHAINI,'dd/mm/yyyy')-1 + ROWNUM - 1 As FECHA_CONTABLE  FROM DUAL 
                       CONNECT By ROWNUM <= to_date(:FECHAFIN,'dd/mm/yyyy') - to_date(:FECHAINI,'dd/mm/yyyy') + 1 )fecha,


 (select fecha_contable,id_det_concepto,det_concepto, volumen,comentarios from pron_just 
                       where fecha_contable between to_date(:FECHAINI,'dd/mm/yyyy')-1 and to_date(:FECHAFIN,'dd/mm/yyyy')-1 
                       and id_det_concepto IN ('144','145') and proyecto in ('KU MALOOB ZAAP'))a

where fecha.fecha_contable = a.fecha_contable(+))b,



(select sum(acum) as sumatoria from

(select distinct fecha_contable,SUM(volumen) OVER(ORDER By fecha_contable ASC) as acum from pron_just 
                       where fecha_contable between to_date(:FECHAINI,'dd/mm/yyyy')-1 and to_date(:FECHAFIN,'dd/mm/yyyy')-1 
                       and id_det_concepto IN ('144','145') and proyecto in ('KU MALOOB ZAAP') ))suma








select fecha_contable as fecha,'  '||comentarios as observaciones,DECODE(det_concepto,null,'No hay observaciones para esta fecha','-'||det_concepto||':') as concepto, 'Volumen: '|| volumen || ' MBls' as volumen  
from pron_just
where fecha_contable in to_date(:FECHA,'dd/mm/yyyy')
and id_det_concepto IN ('144','145')  and proyecto in('KU MALOOB ZAAP') and comentarios is not null






 SELECT * FROM aceitene.MNE_ACE_C_DET_CONCEPTOS WHERE DESCRIPCION LIKE '%ATASTA%'




  
  
  /*LLENADO DE LISTA DE CONCEPTOS*/  
                    
              select a.det_concepto as det_concepto,''''|| b.id_det_concepto_inc || '''' || ',' || '''' || b.id_det_concepto_dec ||'''' as id_det_concepto
                    from
                    (select id_det_concepto, descripcion as det_concepto 
                                from aceitene.MNE_ACE_C_DET_CONCEPTOS 
                                  where id_det_concepto in ('80','81','8','11','12','131','13','104','105','106',
                                     '93','99','19','20','21','22','70','78','79','80','82','33','37','43','44','45',
                                        '83','28','29','75','114','115','116','117','118','119','140','144','142'))a,
                                      
                                        
                    (select id_det_concepto_inc, id_det_concepto_dec from
                aceitene.mne_ace_c_inc_dec_conceptos
                where id_det_concepto_dec in ('80','81','8','11','12','131','13','104','105','106',
                                     '93','99','19','20','21','22','70','78','79','80','82','33','37','43','44','45',
                                        '83','28','29','75','114','115','116','117','118','119','140','144','142'))b
                                        
                                        where a.id_det_concepto = b.id_det_concepto_dec
                                           order by a.det_concepto
                                 
                                        
                                        
                                        
                   
                                        
                                        
                                        
                                        
                                        
                                        




/*RESPALDO
*/
               
  select b.fecha_contable as fecha, b.acum as acum, to_char(suma.sumatoria,'FM99999,999.99') as sumatoria,b.det_concepto, b.comentarios as observaciones,b.punto as punto
                from
                
              (select fecha.fecha_contable, SUM(a.volumen) OVER(ORDER By fecha.fecha_contable ASC) as acum,a.id_det_concepto,a.det_concepto,a.comentarios,a.punto
                 from
                      (SELECT to_date(:FECHAINI,'dd/mm/yyyy')-1 + ROWNUM - 1 As FECHA_CONTABLE  FROM DUAL 
                       CONNECT By ROWNUM <= to_date(:FECHAFIN,'dd/mm/yyyy') - to_date(:FECHAINI,'dd/mm/yyyy') + 1 )fecha,
          
                 
                  (select fecha_contable, id_det_concepto,det_concepto, sum(volumen) as volumen, comentarios, 1 as punto from pron_just 
                       where fecha_contable between to_date(:FECHAINI,'dd/mm/yyyy')-1 and to_date(:FECHAFIN,'dd/mm/yyyy')-1 
                       and id_det_concepto IN (" + sID+@") and proyecto in("+nactivo+@")
                       group by fecha_contable,det_concepto, id_det_concepto, comentarios)
                     a
                 
               where fecha.fecha_contable = a.fecha_contable(+) )b,
                   
                   
                (select sum(acum) as sumatoria
                    from
                    
                      (select fecha.fecha_contable, SUM(a.volumen) OVER(ORDER By fecha.fecha_contable ASC) as acum
                        from
                      (SELECT to_date(:FECHAINI,'dd/mm/yyyy')-1 + ROWNUM - 1 As FECHA_CONTABLE  FROM DUAL 
                       CONNECT By ROWNUM <= to_date(:FECHAFIN,'dd/mm/yyyy') - to_date(:FECHAINI,'dd/mm/yyyy') + 1 )fecha,
          
                      (select fecha_contable,det_concepto, sum(volumen) as volumen from pron_just 
                       where fecha_contable between to_date(:FECHAINI,'dd/mm/yyyy')-1 and to_date(:FECHAFIN,'dd/mm/yyyy')-1 
                       and id_det_concepto IN (" + sID + @") and proyecto in(" + nactivo + @")
                       group by fecha_contable,det_concepto)a
                 
                 where fecha.fecha_contable = a.fecha_contable(+) ))suma
