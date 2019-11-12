--POZORMNE
ALTER TABLE POZORMNE.GAS_PLATAFORMAS
ADD (ID_AFOROS VARCHAR2(60 BYTE),INICIO DATE);
COMMIT;



--MEDIC

ALTER TABLE MEDIC.AFORO
ADD (USR_AUTORIZA_PROMAR VARCHAR2(50 BYTE),USUARIO_PROMAR VARCHAR2(50 BYTE),GASTO_ACE_BRUTO FLOAT(63));
COMMIT;


--REGISTROS
UPDATE  P
SET P.ID_AFOROS=D.ID_AFOROS
FROM GAS_PLATAFORMAS P
INNER JOIN POZORMNE.GAS_PLATAFORMAS@PEPBDD01 D on D.ID=P.ID
WHERE P.TIPO_INST='POZO'

UPDATE  P
SET P.ID_AFOROS=D.ID_AFOROS
FROM GAS_PLATAFORMAS P, POZORMNE.GAS_PLATAFORMAS@PEPBDD01 D
WHERE P.TIPO_INST='POZO' AND D.ID=P.ID
