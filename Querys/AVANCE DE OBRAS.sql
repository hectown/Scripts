select * from pot where id_obra='64'
select * from obras where id='64'


select anyo from pot 


select distinct anyo from pot a, obras b where a.id_obra='92'

select

select a.id, a.descripcion from obras a, pot b 
where a.id = b.id_obra and a.id_ejecutor='1' and a.activo='KU MALOOB ZAAP' 



select distinct anyo, pot from pot 



select distinct pot from pot where anyo='2011'




//Combo año




select * from pot_estatus

select * from c_estatus
select * from pot_efectivo_avance where id_pot='9'

select * from c_ejecutor


select id,descripcion from c_ejecutor


(select to_date(:fechaini, 'DD/MM/YYYY') + rownum - 2 as fecha_contable
             from dual
             connect by rownum <= ((to_date(:fechafin, 'DD/MM/YYYY') - to_date(:fechaini, 'DD/MM/YYYY')) + 1))fechas,
             
             
             
             
    select real.id_obra,obras.descripcion,obras.companya,obras.beneficio,real.mes,real.monto as monto_real,real.avance as avance_real,
    programado.monto as monto_programado,programado.avance as avance_programado
    from efectivo_avance real, pot_efectivo_avance programado, pot,obras
    where real.mes = programado.mes and pot.id_obra=real.id_obra and pot.id = programado.id_pot and pot.id_obra=obras.id and
    pot.id_obra = '64' 
    
    
    
    
    
    
    
    
    
    
               
    select obras.fec_ini_obra_real as INICIO,obras.fec_fin_obra_real as TERMINO, sum(programado.monto) as ORIGINAL,sum(real.monto) as ACTUAL,
    sum(programado.avance)*.100||'%' as PROGRAMADO,sum(real.avance)*.100 ||'%' as REAL,obras.num_contrato as "NO. CONTRATO", obras.companya as CONTRATISTA
   
    from efectivo_avance real, pot_efectivo_avance programado, pot,obras
    where real.mes = programado.mes and pot.id_obra=real.id_obra and pot.id = programado.id_pot and pot.id_obra=obras.id and
    obras.id = '64' and pot.anyo='2011'
    group by obras.fec_ini_obra_real,obras.fec_fin_obra_real,obras.num_contrato, obras.companya 
   
    
    
    
    select * from efectivo_Avance
    select * from pot_efectivo_Avance
    
    
    select a.fec_ini_obra_real as fecha_inicio,a.fec_fin_obra_real as fecha_final, programado.monto as ORIGINAL,
    real.monto as ACTUAL, programado.avance as PROGRAMADO, real.avance as REAL, a.num_contrato as "NO. CONTRATO", a.companya as CONTRATISTA
    from obras a, efectivo_avance real, pot_efectivo_avance programado
    
     where a.id=real.id_obra and a.id=programado.id_obra and a.id='64'