select * from pron_just where id_det_concepto='80' and fecha_contable between to_date(:FECHAINI,'dd/mm/yyyy')-1 and to_date(:FECHAFIN,'dd/mm/yyyy')-1 



                  
                    
                   
                     select fecha.fecha_contable as fecha,a.volumen as vol,SUM(a.volumen) OVER(ORDER By fecha.fecha_contable ASC) as acum,b.det_concepto as concepto, a.det_concepto
      
                    from
             
                      (SELECT to_date(:FECHAINI,'dd/mm/yyyy')-1 + ROWNUM - 1 As FECHA_CONTABLE  FROM DUAL 
               CONNECT By ROWNUM <= to_date(:FECHAFIN,'dd/mm/yyyy') - to_date(:FECHAINI,'dd/mm/yyyy') + 1 )fecha,
          
                    ( select fecha_contable,det_concepto, sum(volumen) as volumen from pron_just 
                        where fecha_contable between to_date(:FECHAINI,'dd/mm/yyyy')-1 and to_date(:FECHAFIN,'dd/mm/yyyy')-1 
                            and id_det_concepto IN ('80','69') and proyecto in('CANTARELL','EK BALAM','KU MALOOB ZAAP')
                             group by fecha_contable,det_concepto)a,
                             
                             
                              (select distinct det_concepto from pron_just 
                        where fecha_contable between TRUNC(TO_DATE(:FECHAINI,'DD/MM/YYYY'),'YEAR')-365 and to_date(:FECHAFIN,'dd/mm/yyyy')-1 
                            and id_det_concepto ='80' and proyecto in('CANTARELL','EK BALAM','KU MALOOB ZAAP')
                             group by fecha_contable,det_concepto)b
               
                   where fecha.fecha_contable = a.fecha_contable(+)            
                   
                 
                 order by fecha.fecha_contable



                    
                    
                    
                    
                    ( select fecha_contable,det_concepto, sum(volumen) as volumen from pron_just 
                        where fecha_contable between to_date(:FECHAINI,'dd/mm/yyyy')-1 and to_date(:FECHAFIN,'dd/mm/yyyy')-1 
                            and id_det_concepto IN ('80','69') and proyecto in('CANTARELL','EK BALAM','KU MALOOB ZAAP')
                             group by fecha_contable,det_concepto)
                             
                             
                             
                             
                             
                             
                             select * from pron_just where DET_CONCEPTO like '%CLIMATOLOGICAS%'