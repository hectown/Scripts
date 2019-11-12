CREATE OR REPLACE FUNCTION AGUA_XCPROCESO (
sCP VARCHAR2,
FECHA VARCHAR2) 

RETURN NUMBER IS
RESULTADO NUMBER;
p_akj_2b NUMBER;
p_akj NUMBER;
p_akl NUMBER;
p_akn NUMBER;
p_akb NUMBER;
p_akc NUMBER;
p_akcl NUMBER;
p_nha NUMBER;
a_akj NUMBER;
a_akl NUMBER;
a_akn NUMBER;
a_akb NUMBER;
a_akc NUMBER;
a_akcl NUMBER;
a_nha NUMBER;
dAgua NUMBER;
dAgua_SN_Sal_2B NUMBER;
dAgua_SN NUMBER;
dAgua_JL NUMBER;
dAgua_AKC_NHA NUMBER;
f_contable VARCHAR(15);
f_real VARCHAR(15);


/******************************************************************************
   NAME:       AGUA_XCPROCESO
   PURPOSE:    

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        30/11/2012   481814       1. Created this function.

   NOTES:

   Automatically available Auto Replace Keywords:
      Object Name:     AGUA_XCPROCESO
      Sysdate:         30/11/2012
      Date and Time:   30/11/2012, 12:10:42 p.m., and 30/11/2012 12:10:42 p.m.
      Username:        481814 (set in TOAD Options, Procedure Editor)
      Table Name:       (set in the "New PL/SQL Object" dialog)

******************************************************************************/
BEGIN

RESULTADO:=0;

SELECT pla.fecha_contable, pla.fecha_real,
    NVL(AVG(CASE pla.id WHEN 1618 THEN val.agua_porc ELSE NULL END), 0) AS porc_akj_2b,
    NVL(AVG(CASE pla.id WHEN 1673 THEN val.agua_porc ELSE NULL END),
        NVL(AVG(CASE pla.id WHEN 1671 THEN val.agua_porc ELSE NULL END), 0)) AS porc_akj,
    NVL(AVG(CASE pla.id WHEN 1620 THEN val.agua_porc ELSE NULL END), 0) AS porc_akl,
    NVL(AVG(CASE pla.id WHEN 1660 THEN val.agua_porc ELSE NULL END), 0) AS porc_akn,
    NVL(AVG(CASE pla.id WHEN 1552 THEN val.agua_porc ELSE NULL END),
        NVL(AVG(CASE pla.id WHEN 1562 THEN val.agua_porc ELSE NULL END), 0)) AS porc_akb,    
    NVL(AVG(CASE pla.id WHEN 1567 THEN val.agua_porc ELSE NULL END), 0) AS porc_akc,    
    NVL(AVG(CASE pla.id WHEN 1559 THEN val.agua_porc ELSE NULL END), 0) AS porc_akcl,
    NVL(AVG(CASE pla.id WHEN 1647 THEN val.agua_porc ELSE NULL END), 0) AS porc_nha,
    mne_ace_integ_pes_ca_cp(pla.fecha_real, mne_ace_id_hora(pla.fecha_real, '05:00'), 'AKAL-J') AS ace_akj,
    mne_ace_integ_pes_ca_cp(pla.fecha_real, mne_ace_id_hora(pla.fecha_real, '05:00'), 'AKAL-L') AS ace_akl,
    mne_ace_integ_pes_ca_cp(pla.fecha_real, mne_ace_id_hora(pla.fecha_real, '05:00'), 'AKAL-N') AS ace_akn,
    mne_ace_integ_pes_ca_cp(pla.fecha_real, mne_ace_id_hora(pla.fecha_real, '05:00'), 'AKAL-B') AS ace_akb,
    mne_ace_integ_pes_ca_cp(pla.fecha_real, mne_ace_id_hora(pla.fecha_real, '05:00'), 'AKAL-C') AS ace_akc,
    mne_ace_integ_lig_ca_cp(pla.fecha_real, mne_ace_id_hora(pla.fecha_real, '05:00'), 'AKAL-C') AS ace_akcl,
    mne_ace_integ_pes_ca_cp(pla.fecha_real, mne_ace_id_hora(pla.fecha_real, '05:00'), 'NOHOCH-A') AS ace_nha
    INTO
    f_contable,
    f_real,
    p_akj_2b,
    p_akj,
    p_akl,
    p_akn,
    p_akb,
    p_akc,
    p_akcl,
    p_nha,
    a_akj,
    a_akl,
    a_akn,
    a_akb,
    a_akc,
    a_akcl,
    a_nha 
FROM
    (
    SELECT id.id, id.desc_larga, id.modelo,
       fec.fecha_contable, TO_CHAR(fec.fecha_contable + 1, 'DD/MM/YYYY') AS fecha_real
    FROM
        (
        SELECT id, desc_larga, modelo
        FROM CALRMNE.gas_plataformas
        WHERE id IN (1618,1673,1671,1620,1660,1552,1562,1567,1647,1559)
        ) id,        
        (
        SELECT TO_DATE(FECHA, 'DD/MM/YYYY') - 1 AS fecha_contable
        FROM DUAL
    
        ) fec
    
    ) pla,
    (
    SELECT plataforma, fecha_real AS fecha_contable, ROUND(AVG(valor_numerico), 4) AS agua_porc
    FROM CALRMNE.gas_parametros_valores
    WHERE id_parametros = 117
        AND fecha_real BETWEEN TO_DATE(FECHA, 'DD/MM/YYYY') - 2
           AND TO_DATE(FECHA, 'DD/MM/YYYY') - 1
        AND plataforma IN (1618,1673,1671,1620,1660,1552,1562,1567,1647,1559)
    GROUP BY plataforma, fecha_real
    ) val
WHERE pla.id = val.plataforma(+)
    AND pla.fecha_contable = val.fecha_contable(+)
GROUP BY pla.fecha_contable, pla.fecha_real;


  IF sCP = 'AKAL-N' THEN
             RESULTADO := round((a_akn*p_akn)/100,1);
         END IF;          
             
              IF sCP = 'AKAL-J' OR sCP = 'AKAL-L' THEN
                   IF TO_DATE(f_real,'DD/MM/YYYY') >= TO_DATE('01/08/2011','DD/MM/YYYY') THEN
                    dAgua_SN_Sal_2B := round((p_akj_2b*(a_akj+a_akl+a_akn))/100,1);
                    
                    --Vol. de Agua del Sector Norte
                     dAgua_SN := dAgua_SN_Sal_2B;
                     ELSE
                    dAgua_SN_Sal_2B := ROUND((p_akj_2b*(a_akj+a_akj+a_akn+a_akb))/100,1);
                     
                     --Vol. de Agua del Sector Norte                AKAL-B  
                     dAgua_SN := dAgua_SN_Sal_2B-ROUND((a_akb*p_akb)/100,1);
                END IF;
              --Vol. Agua Akal-J y Akal-L
                 dAgua_JL := ROUND((a_akj*p_akj)/100,1)+ROUND((a_akl*p_akl)/100,1);
                 
                 IF sCP = 'AKAL-J' THEN
                    dAgua := ROUND((a_akj*p_akj)/100,1);
                    ELSE
                    dAgua :=  ROUND((a_akl*p_akl)/100,1);
                 END IF;
                
                IF dAgua_JL > 0 THEN
                    RESULTADO := ROUND((dAgua*dAgua_SN)/dAgua_JL,1);
                   
                END IF; 
             END IF; 
                         
               IF sCP = 'AKAL-B' THEN
             RESULTADO := ROUND((a_akb*p_akb)/100,1);
                   END IF; 
          
            IF sCP = 'AKAL-C' THEN
                dAgua_AKC_NHA := ROUND((p_nha*(a_akc+a_akcl+a_nha))/100,1);
                 RESULTADO := dAgua_AKC_NHA-ROUND((a_akcl*p_akcl)/100,1)-ROUND((a_nha*p_nha)/100,1);
                     END IF; 
          
              IF  sCP = 'NOHOCH-A' THEN
                RESULTADO := ROUND((a_nha*p_nha)/100,1);
                END IF; 
                
   RETURN RESULTADO;
   
 END AGUA_XCPROCESO;



/

