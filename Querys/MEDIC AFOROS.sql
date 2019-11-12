delete from aforo 
where fecha=:fecha and
poz_id=:pozo and
cons=:consecutivo


select * from aforo
where fecha=:fecha
and poz_id = :pozo



select distinct to_date(fecha,'dd/mm/yyyy') as fecha, GP.plataforma AS plataforma , POZ_ID,cons,DECODE(ESTADO,'a','Autorizado','x','Desautorizado','n','No Autorizado') AS estado, estrangulador,
round(ptp,1) as ptp, round(pbaj,1) as pbaj, round(psep,1) as psep, round(psal,1) as psal, round(temp_sep_pba,1) as temp_sep_pba, round(iny_bn,1) as iny_bn, round(ptr,1) as ptr,round(gasto_Ace_bpd,0) as gasto_ace_bpd
,round(gasto_ace_bruto,0) as gasto_ace_bruto, round(gasto_gas_mmp,1) as gasto_gas_mmp,round(gasto_gas_for,1) as gasto_gas_for, round(qgzt_mmpcd,1) as qgzt_mmpcd
,round(rgaf,1) as rgaf,round(rga_totalm3,1) as rga_totalm3,round(rgil,1) as rgil,round(temp_baj,1) as temp_baj, round(pred_bn,1) as pred_bn, round(porc_h2o,1) as porc_h2o, 
round(porc_mol_n2,1) as porc_mol_n2, round(gasto_Agua,1) as gasto_agua, round(placa_aceite,3) as placa_aceite, round(placa_gas,3) as placa_gas, round(ld_aceite,0) as ld_aceite
,round(ld_gas,0) as ld_gas, round(le_gas,0) as le_gas, round(rh_aceite,0) as rh_aceite, round(rf_gas2,0) as rf_gas2, round(rf_gas,0) as rf_gas,
observ,usuario, round(bec_frecuencia,1) as bec_frecuencia, round(bec_fasea,1) as bec_fasea, round(bec_faseb,1) as bec_faseb, round(bec_fasec,1) as bec_fasec,
round(bec_volt_ent,1) as bec_volt_ent, round(bec_volt_sal,1) as bec_volt_sal, round(bec_presion_succ,1) as bec_presion_succ, round(bec_presion_desc,1) as bec_presion_desc
, round(bec_temp_succ,1) as bec_temp_succ, round(bec_temp_motor,1) as bec_temp_motor
FROM AFORO  INNER JOIN POZORMNE.GAS_PLATAFORMAS GP on GP.ID_AFOROS=POZ_ID
                                                                                WHERE POZ_ID IN (SELECT P0.id_aforos as id_aforos
                                                                                                                FROM POZORMNE.GAS_PLATAFORMAS P0,
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
                                                                                                                                WHERE FECHA_CONTABLE <= :fecha
                                                                                                                                           GROUP By ID_POZO)
                                                                                                                                    GROUP By ID_POZO, FECHA_CONTABLE)) EDO1
                                                                                                                WHERE
                                                                                                                             EDO1.ID_POZO(+) = P0.ID
                                                                                                                AND P0.TIPO_INST = 'POZO'
                                                                                                                AND ID_AFOROS LIKE DECODE(:POZO,'Todos','%',:POZO)
                                                                                                                and  PLATAFORMA LIKE DECODE(:PLATAFORMA,'Todos','%',:PLATAFORMA)
                                                                                                                AND (P0.BAJA IS NULL OR P0.BAJA > :fecha)
                                                                                                              )
                                AND FECHA BETWEEN TO_DATE(:fechainicial,'DD/MM/YYYY') AND TO_DATE(:fecha,'DD/MM/YYYY') ORDER BY FECHA asc






SELECT P0.id_aforos as id_aforos
FROM POZORMNE.GAS_PLATAFORMAS P0,
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
AND ID_AFOROS LIKE DECODE(:POZO,'Todos','%',:POZO)
and  PLATAFORMA LIKE DECODE(:PLATAFORMA,'Todos','%',:PLATAFORMA)
AND (P0.BAJA IS NULL OR P0.BAJA > :FECHA_CONTABLE)























update aforo set 
                              INY_BN=13
                              where fecha='04/02/2013' and poz_id='S-18' and cons=4



COMMIT;

                        
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
(SELECT distinct A.ACTIVO
FROM POZORMNE.GAS_PLATAFORMAS A
WHERE A.ID_AFOROS = :POZO),'CANTARELL',1,'KU MALOOB ZAAP',2
)
,:temp_baj,:pred_bn,:porc_h2o,:porc_mol_n2,:gasto_Agua,:placa_aceite,:placa_gas,:ld_aceite,:ld_gas,:le_gas,:rh_aceite,:rf_gas2,:rf_gas,
:observ,:usuario,
sysdate
,:bec_frecuencia,:bec_fasea,:bec_faseb,:bec_fasec,
:bec_volt_ent,:bec_volt_sal,:bec_presion_succ,:bec_presion_desc,:bec_temp_succ, :bec_temp_motor,:usuario_promar)
commit;





COMMIT;



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
(SELECT distinct A.ACTIVO
FROM POZORMNE.GAS_PLATAFORMAS A
WHERE A.ID_AFOROS = :POZO),'CANTARELL',1,'KU MALOOB ZAAP',2
)
,:temp_baj,:pred_bn,:porc_h2o,:porc_mol_n2,:gasto_Agua,:placa_aceite,:placa_gas,:ld_aceite,:ld_gas,:le_gas,:rh_aceite,:rf_gas2,:rf_gas,
:observ,:usuario,
sysdate
,:bec_frecuencia,:bec_fasea,:bec_faseb,:bec_fasec,
:bec_volt_ent,:bec_volt_sal,:bec_presion_succ,:bec_presion_desc,:bec_temp_succ, :bec_temp_motor,:usuario_promar)






UPDATE AFORO SET
                              INY_BN=:INY_BN,PRED_BN=:PRED_BN,ESTRANGULADOR=:ESTRANGULADOR,PTP=:PTP,PBAJ=:PBAJ,
                              PSEP=:PSEP, PSAL=:PSAL, TEMP_BAJ=:TEMP_BAJ, PTR=:PTR, TEMP_SEP_PBA=:TEMP_SEP_PBA, GASTO_GAS_FOR=:GASTO_GAS_FOR,
                              GASTO_ACE_BPD=:GASTO_ACE_BPD,GASTO_GAS_MMP=:GASTO_GAS_MMP,GASTO_ACE_BRUTO=:GASTO_ACE_BRUTO,QGZT_MMPCD=:QGZT_MMPCD,RGAF=:RGAF,RGA_TOTALM3=:RGA_TOTALM3,
                              RGIL=:RGIL,PORC_MOL_N2=:PORC_MOL_N2,PORC_H2O=:PORC_H2O,GASTO_AGUA=:GASTO_AGUA,PLACA_GAS=:PLACA_GAS,PLACA_ACEITE=:PLACA_ACEITE,
                              LD_ACEITE=:LD_ACEITE, LD_GAS=:LD_GAS, LE_GAS=:LE_GAS,RH_ACEITE=:RH_ACEITE,RF_GAS2=:RF_GAS2,RF_GAS=:RF_GAS,BEC_FRECUENCIA=:BEC_FRECUENCIA,
                              BEC_FASEA=:BEC_FASEA,BEC_FASEB=:BEC_FASEB,BEC_FASEC=:BEC_FASEC,BEC_VOLT_ENT=:BEC_VOLT_ENT,BEC_VOLT_SAL=:BEC_VOLT_SAL,
                              BEC_PRESION_SUCC=:BEC_PRESION_SUCC,BEC_PRESION_DESC=:BEC_PRESION_DESC,BEC_TEMP_SUCC=:BEC_TEMP_SUCC,BEC_TEMP_MOTOR=:BEC_TEMP_MOTOR,
                              OBSERV=:OBSERV,USUARIO=:USUARIO,FEC_ALTA=SYSDATE, USUARIO_PROMAR=:USUARIO_PROMAR
                              WHERE FECHA=TO_DATE(SYSDATE,'DD/MM/YYYY') AND POZ_ID=:POZO AND CONS=:CONS
                              
                              
                              
                              
  

SELECT DECODE(MAX(CONS),NULL,1,MAX(CONS)+1) AS CONS FROM AFORO
WHERE FECHA= TO_DATE(:FECHA,'DD/MM/YYYY') 
AND POZ_ID = :POZO







SELECT DECODE(:CONS,CONS,CONS,DECODE(MAX(CONS),NULL,1,MAX(CONS)+1)) CONS FROM AFORO
WHERE FECHA= TO_DATE(:FECHA,'DD/MM/YYYY') 
AND POZ_ID = :POZO