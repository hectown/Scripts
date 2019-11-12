SELECT * FROM MNE_ACE_C_DET_CONCEPTOS

INSERT INTO MNE_ACE_C_DET_CONCEPTOS (ID_DET_CONCEPTO,ID_CONCEPTO,DESCRIPCION,CVE_TIPO_CONCEPTO,FEC_VIGENCIA_INI,FEC_VIGENCIA_FIN,DESC_CORTA)
VALUES ('153','10','REESTABLECE DE ENV�O DE CORRIENTE','I','01/01/2000','01/01/2099','Restablece de env�o de corriente');

INSERT INTO MNE_ACE_C_DET_CONCEPTOS (ID_DET_CONCEPTO,ID_CONCEPTO,DESCRIPCION,CVE_TIPO_CONCEPTO,FEC_VIGENCIA_INI,FEC_VIGENCIA_FIN,DESC_CORTA)
VALUES ('154','10','REESTABLECE DE ENV�O DE CORRIENTE','D','01/01/2000','01/01/2099','Restablece de env�o de corriente');

INSERT INTO MNE_ACE_C_DERIV_FLUJO (ID,DERIV_ORIGEN,DERIV_DESTINO,DESCRIPCION,TEXTO,ID_DET_CONCEPTO)
VALUES(7,'KU-S','KU-A','RESTABLECE DERIVACION DE FLUJO DE KU-H/M EN KU-S','KU-S','153')







COMMIT;


SELECT * FROM MNE_ACE_C_INC_DEC_CONCEPTOS

INSERT INTO MNE_ACE_C_INC_DEC_CONCEPTOS (ID_DET_CONCEPTO_INC,ID_DET_CONCEPTO_DEC,ID_INC_DEC_CONCEPTO)
VALUES ('173','174','91');
COMMIT;



SELECT * FROM GAS_C_PARAMETROS
WHERE DESCRIPCION LIKE '%Ejecutivo'


SELECT  CON.CONCEPTO,DET.descripcion,decode(DET.cve_tipo_concepto,'I','INCREMENTO','DECREMENTO') FROM MNE_ACE_C_DET_CONCEPTOS DET,MNE_ACE_C_CONCEPTOS CON
where DET.id_concepto=10
AND DET.ID_CONCEPTO = CON.ID_CONCEPTO


SELECT * FROM MNE_ACE_C_DET_CONCEPTOS, MNE_ACE_C_CONCEPTOS
where id_concepto=10


SELECT * FROM MNE_ACE_C_CONCEPTOS


SELECT  DET.ID_CONCEPTO AS ID_CONCEPTO, DET.CVE_TIPO_CONCEPTO AS TIPO_CONCEPTO, DET.ID_DET_CONCEPTO AS ID, JUST.C_PROCESO_REG, DET.DERIV_ORIGEN AS ORIGEN
                                     FROM MNE_ACE_JUSTIFICACIONES JUST, MNE_ACE_C_DET_CONCEPTOS DET
                                       WHERE JUST.ID_DET_CONCEPTO = DET.ID_DET_CONCEPTO 
                                       AND DET.CVE_TIPO_CONCEPTO ='I'
                                       AND  DET.ID_CONCEPTO = '10'
                                       AND DET.ID_DET_CONCEPTO =:ID
                                                    AND JUST.C_PROCESO_REG=:C_PROCESO
                                                    AND JUST.FECHA_CONTABLE = TO_DATE(:FECHA_CONTABLE, 'DD/MM/YYYY')