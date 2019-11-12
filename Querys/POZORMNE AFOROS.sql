select distinct plataforma from gas_plataformas
where c_proceso=:c_proceso
and tipo_inst='POZO'
order by plataforma asc




select distinct plataforma, c_proceso, sector, activo from gas_plataformas
where c_proceso=:c_proceso
and tipo_inst='POZO'
order by plataforma asc




select  BAJA,DESC_LARGA, sector,C_PROCESO FROM GAS_PLATAFORMAS where tipo_inst='POZO' AND SECTOR='SECTOR SUR' AND PLATAFORMA='AKAL-B'
select  BAJA,DESC_LARGA, sector,C_PROCESO FROM GAS_PLATAFORMAS where tipo_inst='POZO' AND SECTOR='SECTOR NORTE' AND PLATAFORMA='AKAL-B'






SELECT
       P0.ID_AFOROS as id_aforos,EDO1.TIPO_POZO AS TIPO_POZO,P0.plataforma,p0.C_proceso
FROM GAS_PLATAFORMAS P0,
       (SELECT
             EDO.ID_POZO, EDO.FECHA_REAL, EDO.FECHA_CONTABLE, EDO.HORA,
       EDO.TIPO_POZO, EDO.ESTADO, EDO.TIPO_FLUIDO
       FROM RMN_PO_EDO_POZOS EDO 
       WHERE
             (EDO.ID_POZO, EDO.FECHA_CONTABLE, EDO.CONS_CONTABLE) IN(
                    /*SE OBTIENE LA MAXIMA HORA DEL DIA POR POZO*/
                    SELECT ID_POZO, FECHA_CONTABLE, MAX(CONS_CONTABLE) As CONS_CONTABLE
                    FROM RMN_PO_EDO_POZOS
                    WHERE (ID_POZO, FECHA_CONTABLE) IN (
                    /* SE OBTIENE LA MAXIMA FECHA POR POZO */
                           SELECT ID_POZO, MAX(FECHA_CONTABLE) As FECHA_CONTABLE
                           FROM RMN_PO_EDO_POZOS
                WHERE FECHA_CONTABLE <= :FECHA_CONTABLE
                           GROUP By ID_POZO)
                    GROUP By ID_POZO, FECHA_CONTABLE)) EDO1
WHERE
             EDO1.ID_POZO(+) = P0.ID
AND P0.TIPO_INST = 'POZO'
--AND P0.ID_AFOROS = :POZO
AND (P0.BAJA IS NULL OR P0.BAJA > :FECHA_CONTABLE)



COMMIT;


SELECT distinct  P0.sector as sector,
FROM GAS_PLATAFORMAS P0,
       (SELECT
             EDO.ID_POZO, EDO.FECHA_REAL, EDO.FECHA_CONTABLE, EDO.HORA,
       EDO.TIPO_POZO, EDO.ESTADO, EDO.TIPO_FLUIDO
       FROM RMN_PO_EDO_POZOS EDO 
       WHERE
             (EDO.ID_POZO, EDO.FECHA_CONTABLE, EDO.CONS_CONTABLE) IN(
                    /*SE OBTIENE LA MAXIMA HORA DEL DIA POR POZO*/
                    SELECT ID_POZO, FECHA_CONTABLE, MAX(CONS_CONTABLE) As CONS_CONTABLE
                    FROM RMN_PO_EDO_POZOS
                    WHERE (ID_POZO, FECHA_CONTABLE) IN (
                    /* SE OBTIENE LA MAXIMA FECHA POR POZO */
                           SELECT ID_POZO, MAX(FECHA_CONTABLE) As FECHA_CONTABLE
                           FROM RMN_PO_EDO_POZOS
                WHERE FECHA_CONTABLE <= :FECHA_CONTABLE
                           GROUP By ID_POZO)
                    GROUP By ID_POZO, FECHA_CONTABLE)) EDO1
WHERE
             EDO1.ID_POZO(+) = P0.ID
AND P0.TIPO_INST = 'POZO'
AND P0.PLATAFORMA = :PLATAFORMA
AND (P0.BAJA IS NULL OR P0.BAJA > :FECHA_CONTABLE)
ORDER BY POZO ASC


select * from gas_c_parametros
where id_parametros=1465





SELECT NOM_USUARIO AS NOMBRE  FROM RMN_AFORO_USUARIO
                                WHERE PERMISO IN ('MAR','AMBOS') 
                                AND UBICACION IN(:C_PROCESO,
                                (SELECT distinct  P0.sector as sector
FROM GAS_PLATAFORMAS P0,
       (SELECT
             EDO.ID_POZO, EDO.FECHA_REAL, EDO.FECHA_CONTABLE, EDO.HORA,
       EDO.TIPO_POZO, EDO.ESTADO, EDO.TIPO_FLUIDO
       FROM RMN_PO_EDO_POZOS EDO 
       WHERE
             (EDO.ID_POZO, EDO.FECHA_CONTABLE, EDO.CONS_CONTABLE) IN(
                    /*SE OBTIENE LA MAXIMA HORA DEL DIA POR POZO*/
                    SELECT ID_POZO, FECHA_CONTABLE, MAX(CONS_CONTABLE) As CONS_CONTABLE
                    FROM RMN_PO_EDO_POZOS
                    WHERE (ID_POZO, FECHA_CONTABLE) IN (
                    /* SE OBTIENE LA MAXIMA FECHA POR POZO */
                           SELECT ID_POZO, MAX(FECHA_CONTABLE) As FECHA_CONTABLE
                           FROM RMN_PO_EDO_POZOS
                WHERE FECHA_CONTABLE <= :FECHA_CONTABLE
                           GROUP By ID_POZO)
                    GROUP By ID_POZO, FECHA_CONTABLE)) EDO1
WHERE
             EDO1.ID_POZO(+) = P0.ID
AND P0.TIPO_INST = 'POZO'
AND P0.PLATAFORMA = :PLATAFORMA
AND (P0.BAJA IS NULL OR P0.BAJA > :FECHA_CONTABLE)
                                ))
                                ORDER BY NOMBRE ASC
                                
                                
                                
                                
  INSERT INTO Aforo
(fecha, estado, poz_id, cons, estrangulador,
ptp,pbaj,psep,psal,temp_sep_pba,iny_bn,ptr,gasto_Ace_bpd,gasto_ace_bruto,gasto_gas_mmp,gasto_gas_for,qgzt_mmpcd,rgaf,rga_totalm3, 
rgil,act_id,temp_baj,pred_bn,porc_h2o,porc_mol_n2,gasto_Agua,placa_aceite,placa_gas,ld_aceite,ld_gas,le_gas,rh_aceite,rf_gas2,rf_gas,
observ,usuario,fec_alta,bec_frecuencia,bec_fasea,bec_faseb,bec_fasec,
bec_volt_ent,bec_volt_sal,bec_presion_succ,bec_presion_desc,bec_temp_succ,bec_temp_motor,usuario_promar)
VALUES
(
TO_DATE(:FECHA, 'DD/MM/YYYY'), 'n', :POZO, 
(
--CONS
SELECT DECODE(MAX(CONS),NULL,1,MAX(CONS)+1) AS CONS FROM AFORO
WHERE FECHA= TO_DATE(:FECHA,'DD/MM/YYYY') 
AND POZ_ID = :POZO
),:ESTRANG, :PTP,:PBAJ,:psep,:psal,:temp_sep_pba,:iny_bn,:ptr,:gasto_Ace_bpd,:gasto_ace_bruto,:gasto_gas_mmp,:gasto_gas_for,:qgzt_mmpcd,
:rgaf,:rga_totalm3, :rgil,
--ACT_ID
DECODE(
(SELECT A.ACTIVO
FROM POZORMNE.GAS_PLATAFORMAS A
WHERE A.ID_AFOROS = :POZO),'CANTARELL',1,'KU MALOOB ZAAP',2
)
,:temp_baj,:pred_bn,:porc_h2o,:porc_mol_n2,:gasto_Agua,:placa_aceite,:placa_gas,:ld_aceite,:ld_gas,:le_gas,:rh_aceite,:rf_gas2,:rf_gas,
:observ,:usuario,
sysdate
,:bec_frecuencia,:bec_fasea,:bec_faseb,:bec_fasec,
:bec_volt_ent,:bec_volt_sal,:bec_presion_succ,:bec_presion_desc,:bec_temp_succ, :bec_temp_motor,:usuario_promar)












select distinct plataforma from gas_plataformas
where c_proceso=:c_proceso
and tipo_inst='POZO'
order by plataforma asc










select * from gas_plataformas 
where C_PROCESO='ZAAP C'
and tipo_inst='POZO'







SELECT P0.id_aforos as id_aforos
FROM GAS_PLATAFORMAS P0,
       (SELECT
             EDO.ID_POZO, EDO.FECHA_REAL, EDO.FECHA_CONTABLE, EDO.HORA,
       EDO.TIPO_POZO, EDO.ESTADO, EDO.TIPO_FLUIDO
       FROM POZORMNE.RMN_PO_EDO_POZOS EDO 
       WHERE
             (EDO.ID_POZO, EDO.FECHA_CONTABLE, EDO.CONS_CONTABLE) IN(
                    /*SE OBTIENE LA MAXIMA HORA DEL DIA POR POZO*/
                    SELECT ID_POZO, FECHA_CONTABLE, MAX(CONS_CONTABLE) As CONS_CONTABLE
                    FROM POZORMNE.RMN_PO_EDO_POZOS
                    WHERE (ID_POZO, FECHA_CONTABLE) IN (
                    /* SE OBTIENE LA MAXIMA FECHA POR POZO */
                           SELECT ID_POZO, MAX(FECHA_CONTABLE) As FECHA_CONTABLE
                           FROM POZORMNE.RMN_PO_EDO_POZOS
                WHERE FECHA_CONTABLE <= :FECHA_CONTABLE
                           GROUP By ID_POZO)
                    GROUP By ID_POZO, FECHA_CONTABLE)) EDO1
WHERE
             EDO1.ID_POZO(+) = P0.ID
AND P0.TIPO_INST = 'POZO'
and  PLATAFORMA LIKE DECODE(:PLATAFORMA,'Todos','%',:PLATAFORMA)
AND (P0.BAJA IS NULL OR P0.BAJA > :FECHA_CONTABLE)
