select * from dgp_datos_mantenimiento

select * from dgp_datos_rezago

select max(inst_corre_p) from dgp_datos_mantenimiento


   
   
   
   //ANOMALIAS

select fecha_contable.fecha, datos.inst_anoma_p as equipo_pos,datos.inst_anoma_r as equipo_real,
round(datos.c_anoma_p,0) as dato_pos,round(datos.c_anoma_r,0) as dato_real,rezago.rezago_anomalia, historico.historico_real
from

(SELECT TO_DATE(:FECHA_INI_SEMANA, 'DD/MM/YYYY') + ROWNUM - 1 As fecha
FROM DUAL
CONNECT By ROWNUM <= TO_DATE(:FECHA_FIN_SEMANA, 'DD/MM/YYYY') - TO_DATE(:FECHA_INI_SEMANA, 'DD/MM/YYYY') + 1)fecha_contable,
   
    (select fecha_contable, c_anoma_p,inst_anoma_p,c_anoma_r,inst_anoma_r from dgp_datos_mantenimiento)datos,
    
    (select max(rezago_anomalia) as rezago_anomalia from dgp_datos_rezago)rezago,
    
    
    ( select sum(c_anoma_r)historico_real from dgp_datos_mantenimiento
     where fecha_contable between    
     
     (select min(fecha_contable) from dgp_datos_mantenimiento)
     
 and
     
        (select MAX(fecha_max.fecha)
        from
     
        (SELECT TO_DATE(:FECHA_INI_SEMANA, 'DD/MM/YYYY') + ROWNUM - 1 As fecha
FROM DUAL
CONNECT By ROWNUM <= TO_DATE(:FECHA_FIN_SEMANA, 'DD/MM/YYYY') - TO_DATE(:FECHA_INI_SEMANA, 'DD/MM/YYYY') + 1)fecha_max))historico
    
       
    where fecha_contable.fecha=datos.fecha_contable(+) 
    order by fecha_contable.fecha asc
    
    
    
    
    
    
    //correciones
    
select fecha_contable.fecha, datos.inst_corre_p as equipo_pos,datos.inst_corre_r as equipo_real,
round(datos.c_corre_p,0) as dato_pos,round(datos.c_corre_r,0) as dato_real,rezago.rezago_corre, historico.historico_real
from
(SELECT TO_DATE(:FECHA_INI_SEMANA, 'DD/MM/YYYY') + ROWNUM - 1 As fecha
FROM DUAL
CONNECT By ROWNUM <= TO_DATE(:FECHA_FIN_SEMANA, 'DD/MM/YYYY') - TO_DATE(:FECHA_INI_SEMANA, 'DD/MM/YYYY') + 1)fecha_contable,
   
    (select fecha_contable, c_corre_p,inst_corre_p,c_corre_r,inst_corre_r from dgp_datos_mantenimiento)datos,
    
    (select max(rezago_corre) as rezago_corre from dgp_datos_rezago)rezago,
    
    
       ( select sum(c_corre_r)historico_real from dgp_datos_mantenimiento
     where fecha_contable between    
     
     (select min(fecha_contable) from dgp_datos_mantenimiento)
     
 and
     
        (select MAX(fecha_max.fecha)
        from
     
         (SELECT TO_DATE(:FECHA_INI_SEMANA, 'DD/MM/YYYY') + ROWNUM - 1 As fecha
FROM DUAL
CONNECT By ROWNUM <= TO_DATE(:FECHA_FIN_SEMANA, 'DD/MM/YYYY') - TO_DATE(:FECHA_INI_SEMANA, 'DD/MM/YYYY') + 1)fecha_max))historico
    
    
    where fecha_contable.fecha=datos.fecha_contable(+) 
    order by fecha_contable.fecha asc
    
    
    
    
    
    
    
    
    
    */AMARRE*/
    
      
    select fecha_contable.fecha, datos.inst_amarre_p as equipo_pos,datos.inst_amarre_r as equipo_real,
round(datos.c_amarre_p,0) as dato_pos,round(datos.c_amarre_r,0) as dato_real
from
(SELECT TO_DATE(:FECHA_INI_SEMANA, 'DD/MM/YYYY') + ROWNUM - 1 As fecha
FROM DUAL
CONNECT By ROWNUM <= TO_DATE(:FECHA_FIN_SEMANA, 'DD/MM/YYYY') - TO_DATE(:FECHA_INI_SEMANA, 'DD/MM/YYYY') + 1)fecha_contable,
   
    (select fecha_contable, c_amarre_p,inst_amarre_p,c_amarre_r,inst_amarre_r from dgp_datos_mantenimiento)datos
    
    where fecha_contable.fecha=datos.fecha_contable(+) 
    order by fecha_contable.fecha asc
    
    
    
    /*MANTTO*/
    
    
    select fecha_contable.fecha as fecha, datos.inst_mantto_p as equipo_pos,datos.inst_mantto_r as equipo_real,
round(datos.c_mantto_p,0) as dato_pos,round(datos.c_mantto_r,0) as dato_real,rezago.rezago_mantto,historico.historico_real
from
(SELECT TO_DATE(:FECHA_INI_SEMANA, 'DD/MM/YYYY') + ROWNUM - 1 As fecha
FROM DUAL
CONNECT By ROWNUM <= TO_DATE(:FECHA_FIN_SEMANA, 'DD/MM/YYYY') - TO_DATE(:FECHA_INI_SEMANA, 'DD/MM/YYYY') + 1)fecha_contable,
   
    (select fecha_contable, c_mantto_p,inst_mantto_p,c_mantto_r,inst_mantto_r from dgp_datos_mantenimiento)datos,
    
    (select max(rezago_mantto) as rezago_mantto from dgp_datos_rezago)rezago,
    
       ( select sum(c_mantto_r) as historico_real from dgp_datos_mantenimiento
     where fecha_contable between    
     
     (select min(fecha_contable) from dgp_datos_mantenimiento)
     
 and
     
        (select MAX(fecha_max.fecha)
        from
     
       (SELECT TO_DATE(:FECHA_INI_SEMANA, 'DD/MM/YYYY') + ROWNUM - 1 As fecha
FROM DUAL
CONNECT By ROWNUM <= TO_DATE(:FECHA_FIN_SEMANA, 'DD/MM/YYYY') - TO_DATE(:FECHA_INI_SEMANA, 'DD/MM/YYYY') + 1)fecha_max))historico
    
    
    where fecha_contable.fecha=datos.fecha_contable(+) 
    order by fecha_contable.fecha asc
    
    
    
    
    
    */intervencion*/
    
    
         select fecha_contable.fecha, datos.inst_inter_p as equipo_pos,datos.inst_inter_r as equipo_real,
round(datos.c_inter_p,0) as dato_pos,round(datos.c_inter_r,0) as dato_real
from
(SELECT TO_DATE(:FECHA_INI_SEMANA, 'DD/MM/YYYY') + ROWNUM - 1 As fecha
FROM DUAL
CONNECT By ROWNUM <= TO_DATE(:FECHA_FIN_SEMANA, 'DD/MM/YYYY') - TO_DATE(:FECHA_INI_SEMANA, 'DD/MM/YYYY') + 1)fecha_contable,
   
    (select fecha_contable, c_inter_p,inst_inter_p,c_inter_r,inst_inter_r from dgp_datos_mantenimiento)datos
    
    where fecha_contable.fecha=datos.fecha_contable(+) 
    order by fecha_contable.fecha asc
    
    
    


/*CAMBIOS*/
select * from dgp_datos_rezago
 
   //ANOMALIAS

select fecha_contable.fecha,
round(datos.c_anoma_p,0) as dato_pos,round(datos.c_anoma_r,0) as dato_real,rezago.rezago_anomalia_pos,rezago.rezago_anomalia_real
from

(SELECT TO_DATE(:FECHA_INI_SEMANA, 'DD/MM/YYYY') + ROWNUM - 1 As fecha
FROM DUAL
CONNECT By ROWNUM <= TO_DATE(:FECHA_FIN_SEMANA, 'DD/MM/YYYY') - TO_DATE(:FECHA_INI_SEMANA, 'DD/MM/YYYY') + 1)fecha_contable,
   
    (select fecha_contable, c_anoma_p,c_anoma_r from dgp_datos_mantenimiento)datos,
    
   
(select max(rezago.reza_anomalia_pos) as rezago_anomalia_pos, max(rezago.reza_anomalia_real) as rezago_anomalia_real
from

 (select fecha_contable, reza_anomalia_pos, reza_anomalia_real  from dgp_datos_rezago)rezago,


 (SELECT TO_DATE(:FECHA_INI_SEMANA, 'DD/MM/YYYY') + ROWNUM - 1 As fecha
FROM DUAL
CONNECT By ROWNUM <= TO_DATE(:FECHA_FIN_SEMANA, 'DD/MM/YYYY') - TO_DATE(:FECHA_INI_SEMANA, 'DD/MM/YYYY') + 1)fecha_contable
where
fecha_contable.fecha=rezago.fecha_contable(+))rezago


        
       
    where fecha_contable.fecha=datos.fecha_contable(+) 
    order by fecha_contable.fecha asc
    
    
    
    
    
    //CORRECIONES
    
select fecha_contable.fecha,
round(datos.c_corre_p,0) as dato_pos,round(datos.c_corre_r,0) as dato_real,rezago.rezago_corre_pos,rezago.rezago_corre_real
from
(SELECT TO_DATE(:FECHA_INI_SEMANA, 'DD/MM/YYYY') + ROWNUM - 1 As fecha
FROM DUAL
CONNECT By ROWNUM <= TO_DATE(:FECHA_FIN_SEMANA, 'DD/MM/YYYY') - TO_DATE(:FECHA_INI_SEMANA, 'DD/MM/YYYY') + 1)fecha_contable,
   
    (select fecha_contable, c_corre_p,c_corre_r from dgp_datos_mantenimiento)datos,
    



(select max(rezago.reza_corre_pos) as rezago_corre_pos, max(rezago.reza_corre_real) as rezago_corre_real
from

 (select fecha_contable, reza_corre_pos, reza_corre_real  from dgp_datos_rezago)rezago,


 (SELECT TO_DATE(:FECHA_INI_SEMANA, 'DD/MM/YYYY') + ROWNUM - 1 As fecha
FROM DUAL
CONNECT By ROWNUM <= TO_DATE(:FECHA_FIN_SEMANA, 'DD/MM/YYYY') - TO_DATE(:FECHA_INI_SEMANA, 'DD/MM/YYYY') + 1)fecha_contable
where
fecha_contable.fecha=rezago.fecha_contable(+))rezago
    

    
    where fecha_contable.fecha=datos.fecha_contable(+) 
    order by fecha_contable.fecha asc
    
    
    
    //AMARRE
    
    
        select fecha_contable.fecha,
round(datos.c_amarre_p,0) as dato_pos,round(datos.c_amarre_r,0) as dato_real, rezago.rezago_amarre_pos, rezago.rezago_amarre_real
from
(SELECT TO_DATE(:FECHA_INI_SEMANA, 'DD/MM/YYYY') + ROWNUM - 1 As fecha
FROM DUAL
CONNECT By ROWNUM <= TO_DATE(:FECHA_FIN_SEMANA, 'DD/MM/YYYY') - TO_DATE(:FECHA_INI_SEMANA, 'DD/MM/YYYY') + 1)fecha_contable,
   
    (select fecha_contable, c_amarre_p,c_amarre_r from dgp_datos_mantenimiento)datos,
    
   
 
(select max(rezago.reza_amarre_pos) as rezago_amarre_pos, max(rezago.reza_amarre_real) as rezago_amarre_real
from

 (select fecha_contable, reza_amarre_pos, reza_amarre_real  from dgp_datos_rezago)rezago,


 (SELECT TO_DATE(:FECHA_INI_SEMANA, 'DD/MM/YYYY') + ROWNUM - 1 As fecha
FROM DUAL
CONNECT By ROWNUM <= TO_DATE(:FECHA_FIN_SEMANA, 'DD/MM/YYYY') - TO_DATE(:FECHA_INI_SEMANA, 'DD/MM/YYYY') + 1)fecha_contable
where
fecha_contable.fecha=rezago.fecha_contable(+))rezago



    
    where fecha_contable.fecha=datos.fecha_contable(+) 
    order by fecha_contable.fecha asc
    
    
    
    
     
    /*MANTTO*/
    
    
    select fecha_contable.fecha as fecha,
round(datos.c_mantto_p,0) as dato_pos,round(datos.c_mantto_r,0) as dato_real,rezago.rezago_mantto_pos, rezago.rezago_mantto_real
from
(SELECT TO_DATE(:FECHA_INI_SEMANA, 'DD/MM/YYYY') + ROWNUM - 1 As fecha
FROM DUAL
CONNECT By ROWNUM <= TO_DATE(:FECHA_FIN_SEMANA, 'DD/MM/YYYY') - TO_DATE(:FECHA_INI_SEMANA, 'DD/MM/YYYY') + 1)fecha_contable,
   
    (select fecha_contable, c_mantto_p,c_mantto_r from dgp_datos_mantenimiento)datos,
    
   
(select max(rezago.reza_mantto_pos) as rezago_mantto_pos, max(rezago.reza_mantto_real) as rezago_mantto_real
from

 (select fecha_contable, reza_mantto_pos, reza_mantto_real  from dgp_datos_rezago)rezago,


 (SELECT TO_DATE(:FECHA_INI_SEMANA, 'DD/MM/YYYY') + ROWNUM - 1 As fecha
FROM DUAL
CONNECT By ROWNUM <= TO_DATE(:FECHA_FIN_SEMANA, 'DD/MM/YYYY') - TO_DATE(:FECHA_INI_SEMANA, 'DD/MM/YYYY') + 1)fecha_contable
where
fecha_contable.fecha=rezago.fecha_contable(+))rezago


    
    
    where fecha_contable.fecha=datos.fecha_contable(+) 
    order by fecha_contable.fecha asc
    
        
    */intervencion*/
    
    
         select fecha_contable.fecha,
round(datos.c_inter_p,0) as dato_pos,round(datos.c_inter_r,0) as dato_real
from
(SELECT TO_DATE(:FECHA_INI_SEMANA, 'DD/MM/YYYY') + ROWNUM - 1 As fecha
FROM DUAL
CONNECT By ROWNUM <= TO_DATE(:FECHA_FIN_SEMANA, 'DD/MM/YYYY') - TO_DATE(:FECHA_INI_SEMANA, 'DD/MM/YYYY') + 1)fecha_contable,
   
    (select fecha_contable, c_inter_p,c_inter_r from dgp_datos_mantenimiento)datos
    
    where fecha_contable.fecha=datos.fecha_contable(+) 
    order by fecha_contable.fecha asc
    
    
    
    
    /*DATOS POS DE LA SEMA SIGUIENTE*/
    
    
    select fecha_contable.fecha, datos.anoma_pos, datos.corre_pos, datos.amarre_pos, datos.mantto_pos, 
    datos.inter_pos,pos.reza_anomalia,pos.reza_corre,
    pos.reza_amarre, pos.reza_mantto
    from
    
     (SELECT TO_DATE(:FECHA_INI_SEMANA, 'DD/MM/YYYY') + ROWNUM - 1 As fecha
FROM DUAL
CONNECT By ROWNUM <= TO_DATE(:FECHA_FIN_SEMANA, 'DD/MM/YYYY') - TO_DATE(:FECHA_INI_SEMANA, 'DD/MM/YYYY') + 1)fecha_contable,
    
    (select fecha_contable,c_anoma_p as anoma_pos,c_anoma_r as anoma_real,c_corre_p as corre_pos, c_corre_r as corre_real,
    c_amarre_p as amarre_pos, c_amarre_r as amarre_real, c_mantto_p as mantto_pos, c_mantto_r as mantto_real,
    c_inter_p as inter_pos, c_inter_r as inter_real
     from dgp_datos_mantenimiento)datos,
     
    
   
 (select max(rezago.reza_anomalia_pos) as reza_anomalia,max(rezago.reza_amarre_pos) as reza_amarre, max(rezago.reza_corre_pos) as reza_corre, max(rezago.reza_mantto_pos) as reza_mantto
from

 (select fecha_contable, reza_amarre_pos, reza_anomalia_pos,reza_corre_pos, reza_mantto_pos  from dgp_datos_rezago)rezago,


 (SELECT TO_DATE(:FECHA_INI_SEMANA, 'DD/MM/YYYY') + ROWNUM - 1 As fecha
FROM DUAL
CONNECT By ROWNUM <= TO_DATE(:FECHA_FIN_SEMANA, 'DD/MM/YYYY') - TO_DATE(:FECHA_INI_SEMANA, 'DD/MM/YYYY') + 1)fecha_contable
where
fecha_contable.fecha=rezago.fecha_contable(+))pos


     
     
      where fecha_contable.fecha=datos.fecha_contable(+) 
    order by fecha_contable.fecha asc
     
     
    
    
    


 (select max(reza_anomalia_pos) as reza_anomalia, max(reza_corre_pos)as reza_corre,
max(reza_amarre_pos) as reza_amarre, max(reza_mantto_pos) as reza_mantto from dgp_datos_rezago
where 


fecha_contable between

(select min(fecha_contable) from dgp_datos_rezago)

and

(select Max(fecha) 
from

 (SELECT TO_DATE(:FECHA_INI_SEMANA, 'DD/MM/YYYY') + ROWNUM - 1 As fecha
FROM DUAL
CONNECT By ROWNUM <= TO_DATE(:FECHA_FIN_SEMANA, 'DD/MM/YYYY') - TO_DATE(:FECHA_INI_SEMANA, 'DD/MM/YYYY') + 1)))pos



/*REZAGO*/




(select max(rezago.reza_anomalia_pos) as reza_anomalia,max(rezago.reza_amarre_pos) as reza_amarre, max(rezago.reza_corre_pos) as reza_corre, max(rezago.reza_mantto_pos) as reza_mantto
from

 (select fecha_contable, reza_amarre_pos, reza_anomalia_pos,reza_corre_pos, reza_mantto_pos  from dgp_datos_rezago)rezago,


 (SELECT TO_DATE(:FECHA_INI_SEMANA, 'DD/MM/YYYY') + ROWNUM - 1 As fecha
FROM DUAL
CONNECT By ROWNUM <= TO_DATE(:FECHA_FIN_SEMANA, 'DD/MM/YYYY') - TO_DATE(:FECHA_INI_SEMANA, 'DD/MM/YYYY') + 1)fecha_contable
where
fecha_contable.fecha=rezago.fecha_contable(+))pos








select * from dgp_datos_rezago












select min(fecha), max(fecha) from

(SELECT TO_DATE(:FECHA_INI_SEMANA, 'DD/MM/YYYY') + ROWNUM - 1 As fecha
FROM DUAL
CONNECT By ROWNUM <= TO_DATE(:FECHA_FIN_SEMANA, 'DD/MM/YYYY') - TO_DATE(:FECHA_INI_SEMANA, 'DD/MM/YYYY') + 1)








select * from dgp_datos_rezago