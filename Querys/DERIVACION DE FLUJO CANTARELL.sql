  INSERT INTO GAS_PLATAFORMAS (ID, BAJA,DESC_CORTA,DESC_LARGA,ID_PLATAFORMAS,PADRE,CATEGORIA,
                            CONTENEDOR,REPORTE_URL,ICONO,VERANEXARCHIVOS,C_PROCESO,SECTOR,ACTIVO,REGION,MARCA, MODELO,PLATAFORMA,AGRUPADOR,ORDEN,SISTEMA,
                            SUBSISTEMA,DESC_REPORTE,CAMPO,TIPO_INST,VEROBSERVACIONES,YACIMIENTO,SIOP_NUMPOZO,SIOP_LETRA,SIOP_NOMPOZO,PANTALLAT,UWI,COL_TEMPORAL,PRESION_BN,
                            ORIGEN,DESTINO,ID_CALRMNE,BATERIA,PROYECTO,SNIP_PLAT_NOMBRE,SNIP_POZ_NOMBRE,ID_AFOROS,INICIO,FECHA_PROGRAMADA,ID_ORIGEN,TIPO_CAMBIO)

                            SELECT ID.ID, DATOS.BAJA,DATOS.DESC_CORTA,DATOS.DESC_LARGA,ID.ID AS ID_PLATAFORMAS,DATOS.PADRE,DATOS.CATEGORIA,
                            DATOS.CONTENEDOR,DATOS.REPORTE_URL,DATOS.ICONO,DATOS.VERANEXARCHIVOS,DESTINO.C_PROCESO,DESTINO.SECTOR,DESTINO.ACTIVO,DATOS.REGION,DATOS.MARCA, DATOS.MODELO,DATOS.PLATAFORMA,DATOS.AGRUPADOR,DATOS.ORDEN,DATOS.SISTEMA,
                            DATOS.SUBSISTEMA,DATOS.DESC_REPORTE,DATOS.CAMPO,DATOS.TIPO_INST,DATOS.VEROBSERVACIONES,DATOS.YACIMIENTO,DATOS.SIOP_NUMPOZO,DATOS.SIOP_LETRA,DATOS.SIOP_NOMPOZO,DATOS.PANTALLAT,DATOS.UWI,DATOS.COL_TEMPORAL,DATOS.PRESION_BN,
                            DATOS.ORIGEN,DATOS.DESTINO,DATOS.ID_CALRMNE,DATOS.BATERIA,DATOS.PROYECTO,DATOS.SNIP_PLAT_NOMBRE,DATOS.SNIP_POZ_NOMBRE,DATOS.ID_AFOROS,DATOS.INICIO,DATOS.FECHA_PROGRAMADA,DATOS.ID,:TIPO_CAMBIO
                            FROM
                            (SELECT PADRE,C_PROCESO,SECTOR,ACTIVO
                            FROM GAS_PLATAFORMAS 
                            WHERE
                            C_PROCESO=:C_PROCESO_PROG
                            AND TIPO_INST='PLATAFORMA'
                            AND DESC_LARGA NOT IN('Pozos','Ductos')
                            AND baja is NULL
                            GROUP BY PADRE,C_PROCESO,SECTOR,ACTIVO)DESTINO,  
                            (SELECT ID, TO_DATE(:FECHA_PROGRAMADA)-1 AS BAJA,DESC_CORTA,DESC_LARGA,ID_PLATAFORMAS,:PADRE AS PADRE,CATEGORIA,
                            CONTENEDOR,REPORTE_URL,ICONO,VERANEXARCHIVOS,:C_PROCESO_PROG AS C_PROCESO,SECTOR,ACTIVO,REGION,MARCA, MODELO,:PLATAFORMA_PROG AS PLATAFORMA,AGRUPADOR,ORDEN,SISTEMA,
                            SUBSISTEMA,DESC_REPORTE,:CAMPO_PROG AS CAMPO,'POZO_PROG' AS TIPO_INST,VEROBSERVACIONES,YACIMIENTO,SIOP_NUMPOZO,SIOP_LETRA,SIOP_NOMPOZO,PANTALLAT,UWI,COL_TEMPORAL,PRESION_BN,
                            ORIGEN,DESTINO,ID_CALRMNE,BATERIA,PROYECTO,SNIP_PLAT_NOMBRE,SNIP_POZ_NOMBRE,ID_AFOROS,:FECHA_PROGRAMADA AS INICIO,:FECHA_PROGRAMADA AS FECHA_PROGRAMADA
                                                                FROM GAS_PLATAFORMAS
                                                                WHERE TIPO_INST='POZO'
                                                                AND CAMPO=:CAMPO
                                                                AND C_PROCESO =:C_PROCESO
                                                                AND PLATAFORMA=:PLATAFORMA
                                                                AND BAJA IS NULL
                                                                AND ID=:ID_POZO)DATOS,
                             (SELECT MAX(ID)+1 AS  ID FROM GAS_PLATAFORMAS)ID
 
 
 

 
 
 
 
 --CREA DERIVACION DE FLUJO PERO SOLO CAMBIA EL CAMPO
 
INSERT INTO GAS_PLATAFORMAS (ID, BAJA,DESC_CORTA,DESC_LARGA,ID_PLATAFORMAS,PADRE,CATEGORIA,
CONTENEDOR,REPORTE_URL,ICONO,VERANEXARCHIVOS,C_PROCESO,SECTOR,ACTIVO,REGION,MARCA, MODELO,PLATAFORMA,AGRUPADOR,ORDEN,SISTEMA,
SUBSISTEMA,DESC_REPORTE,CAMPO,TIPO_INST,VEROBSERVACIONES,YACIMIENTO,SIOP_NUMPOZO,SIOP_LETRA,SIOP_NOMPOZO,PANTALLAT,UWI,COL_TEMPORAL,PRESION_BN,
ORIGEN,DESTINO,ID_CALRMNE,BATERIA,PROYECTO,SNIP_PLAT_NOMBRE,SNIP_POZ_NOMBRE,ID_AFOROS,INICIO,FECHA_PROGRAMADA,ID_ORIGEN)

SELECT ID.ID, DATOS.BAJA,DATOS.DESC_CORTA,DATOS.DESC_LARGA,ID.ID AS ID_PLATAFORMAS,DATOS.PADRE,DATOS.CATEGORIA,
DATOS.CONTENEDOR,DATOS.REPORTE_URL,DATOS.ICONO,DATOS.VERANEXARCHIVOS,DATOS.C_PROCESO,DATOS.SECTOR,DATOS.ACTIVO,DATOS.REGION,DATOS.MARCA, DATOS.MODELO,DATOS.PLATAFORMA,DATOS.AGRUPADOR,DATOS.ORDEN,DATOS.SISTEMA,
DATOS.SUBSISTEMA,DATOS.DESC_REPORTE,DATOS.CAMPO,DATOS.TIPO_INST,DATOS.VEROBSERVACIONES,DATOS.YACIMIENTO,DATOS.SIOP_NUMPOZO,DATOS.SIOP_LETRA,DATOS.SIOP_NOMPOZO,DATOS.PANTALLAT,DATOS.UWI,DATOS.COL_TEMPORAL,DATOS.PRESION_BN,
DATOS.ORIGEN,DATOS.DESTINO,DATOS.ID_CALRMNE,DATOS.BATERIA,DATOS.PROYECTO,DATOS.SNIP_PLAT_NOMBRE,DATOS.SNIP_POZ_NOMBRE,DATOS.ID_AFOROS,DATOS.INICIO,DATOS.FECHA_PROGRAMADA,DATOS.ID AS ID_ORIGEN
FROM

(SELECT ID, TO_DATE(:FECHA_PROGRAMADA)-1 AS BAJA,DESC_CORTA,DESC_LARGA,ID_PLATAFORMAS, PADRE,CATEGORIA,
CONTENEDOR,REPORTE_URL,ICONO,VERANEXARCHIVOS,C_PROCESO,SECTOR,ACTIVO,REGION,MARCA, MODELO,PLATAFORMA,AGRUPADOR,ORDEN,SISTEMA,
SUBSISTEMA,DESC_REPORTE,:CAMPO_PROG AS CAMPO,'POZO_PROG' AS TIPO_INST,VEROBSERVACIONES,YACIMIENTO,SIOP_NUMPOZO,SIOP_LETRA,SIOP_NOMPOZO,PANTALLAT,UWI,COL_TEMPORAL,PRESION_BN,
ORIGEN,DESTINO,ID_CALRMNE,BATERIA,PROYECTO,SNIP_PLAT_NOMBRE,SNIP_POZ_NOMBRE,ID_AFOROS,:FECHA_PROGRAMADA AS INICIO,:FECHA_PROGRAMADA AS FECHA_PROGRAMADA
                                    FROM GAS_PLATAFORMAS
                                    WHERE TIPO_INST='POZO'
                                    AND CAMPO=:CAMPO
                                    AND C_PROCESO =:C_PROCESO
                                    AND PLATAFORMA=:PLATAFORMA
                                    AND BAJA IS NULL
                                    AND ID=:ID_POZO)DATOS,
(SELECT MAX(ID)+1 AS  ID FROM GAS_PLATAFORMAS)ID
 
 
 SELECT * FROM GAS_PLATAFORMAS
 
 
 
 
 
 
 
 
 --ID_PLATAFORMAS PARA CAMBIAR UN POZO DE PLATAFORMA
 
SELECT ID_PLATAFORMAS,PLATAFORMA
FROM GAS_PLATAFORMAS 
WHERE PLATAFORMA = :PLATAFORMA_PROG
AND DESC_LARGA='Pozos'
AND baja is null



 --ID_PLATAFORMAS PARA CAMBIAR UN POZO DE PLATAFORMA PROGRAMADA
SELECT ID_PLATAFORMAS,PLATAFORMA
FROM GAS_PLATAFORMAS 
WHERE PLATAFORMA = :PLATAFORMA
AND TIPO_INST='PLATAFORMA_PROG'





--PARA BUSCAR UNA PLATAFORMA EN EL  CENTRO DE PROCESO

SELECT DESC_LARGA
FROM GAS_PLATAFORMAS 
WHERE
C_PROCESO=:C_PROCESO_PROG
AND TIPO_INST='PLATAFORMA'
AND DESC_LARGA NOT IN('Pozos','Ductos')
AND baja is null



--PARA BUSCAR  UN POZO 

SELECT DESC_LARGA
FROM GAS_PLATAFORMAS 
WHERE
C_PROCESO=:C_PROCESO_PROG
AND TIPO_INST='PLATAFORMA'
AND DESC_LARGA NOT IN('Pozos','Ductos')
AND baja is null





--PARA BUSCAR UNA PLATAFORMA PROGRAMADA EN EL  CENTRO DE PROCESO
SELECT DESC_LARGA
                                FROM GAS_PLATAFORMAS 
                                WHERE
                                C_PROCESO=:C_PROCESO_PROG
                                AND TIPO_INST='PLATAFORMA_PROG'
                                AND DESC_LARGA NOT IN('Pozos','Ductos')
                                AND baja is null




--ID_PLATAFORMAS DE UN CENTRO DE PROCESO

SELECT ID_PLATAFORMAS,C_PROCESO
FROM GAS_PLATAFORMAS 
WHERE
TIPO_INST='C_PROCESO'
AND C_PROCESO=:CPROCESO_PROG
AND BAJA IS NULL



     --BUSCA EL ID_PLATAFORMA DE LA CARPETA DE POZOS DE LA PLATAFORMA DESTINO

SELECT ID_PLATAFORMAS,PLATAFORMA
                                FROM GAS_PLATAFORMAS 
                                WHERE PLATAFORMA = :PLATAFORMA
                                AND FECHA_PROGRAMADA=:FECHA_PROGRAMADA
                                AND C_PROCESO= :C_PROCESO_PROG
                                AND TIPO_INST='CPLATAFORMA_PROG'

                     




 --PARA EL PADRE DE CENTRO DE PROCESO
 
SELECT PADRE,C_PROCESO,CAMPO 
FROM GAS_PLATAFORMAS 
WHERE TIPO_INST='C_PROCESO' 
AND PLATAFORMA=:PLATAFORMA_PROG 
AND BAJA IS NULL 
              



--BUSCA UNA PLATAFORMA PROGRAMADA EN EL CENTRO DE PROCESO
SELECT DESC_LARGA
                                FROM GAS_PLATAFORMAS
                                WHERE TIPO_INST='PLATAFORMA_PROG'
                                AND C_PROCESO=:C_PROCESO_PROG
                                AND FECHA_PROGRAMADA=TO_DATE(:FECHA_PROGRAMADA,'DD/MM/YYYY')





--CREA LA PLATAFORMA EN EL CENTRO DE PROCESO DESTINO
 INSERT INTO GAS_PLATAFORMAS (ID, BAJA,DESC_CORTA,DESC_LARGA,ID_PLATAFORMAS,PADRE,CATEGORIA,
                            CONTENEDOR,REPORTE_URL,ICONO,VERANEXARCHIVOS,C_PROCESO,SECTOR,ACTIVO,REGION,MARCA, MODELO,PLATAFORMA,AGRUPADOR,ORDEN,SISTEMA,
                            SUBSISTEMA,DESC_REPORTE,CAMPO,TIPO_INST,VEROBSERVACIONES,YACIMIENTO,SIOP_NUMPOZO,SIOP_LETRA,SIOP_NOMPOZO,PANTALLAT,UWI,COL_TEMPORAL,PRESION_BN,
                            ORIGEN,DESTINO,ID_CALRMNE,BATERIA,PROYECTO,SNIP_PLAT_NOMBRE,SNIP_POZ_NOMBRE,ID_AFOROS,INICIO,FECHA_PROGRAMADA,ID_ORIGEN)

                            SELECT ID.ID,TO_DATE(:FECHA_PROGRAMADA)-1 AS BAJA,ORIGEN.DESC_CORTA,ORIGEN.DESC_LARGA,ID.ID AS ID_PLATAFORMAS,DESTINO.PADRE,
                            ORIGEN.CATEGORIA,ORIGEN.CONTENEDOR,ORIGEN.REPORTE_URL,ORIGEN.ICONO,ORIGEN.VERANEXARCHIVOS,DESTINO.C_PROCESO,DESTINO.SECTOR,ORIGEN.ACTIVO,ORIGEN.REGION,
                            ORIGEN.MARCA,ORIGEN.MODELO,ORIGEN.PLATAFORMA,ORIGEN.AGRUPADOR,ORIGEN.ORDEN,ORIGEN.SISTEMA,ORIGEN.SUBSISTEMA,ORIGEN.DESC_REPORTE,ORIGEN.CAMPO,
                            'PLATAFORMA_PROG',ORIGEN.VEROBSERVACIONES,ORIGEN.YACIMIENTO,ORIGEN.SIOP_NUMPOZO,ORIGEN.SIOP_LETRA, ORIGEN.SIOP_NOMPOZO,ORIGEN.PANTALLAT,ORIGEN.UWI,
                            ORIGEN.COL_TEMPORAL,ORIGEN.PRESION_BN,ORIGEN.ORIGEN,ORIGEN.DESTINO,ORIGEN.ID_CALRMNE,ORIGEN.BATERIA,ORIGEN.PROYECTO,ORIGEN.SNIP_PLAT_NOMBRE,ORIGEN.SNIP_POZ_NOMBRE,
                            ORIGEN.ID_AFOROS,:FECHA_PROGRAMADA AS INICIO,:FECHA_PROGRAMADA AS FECHA_PROGRAMADA,ORIGEN.ID AS ID_ORIGEN
                            FROM
                            (SELECT PADRE,C_PROCESO,SECTOR
                            FROM GAS_PLATAFORMAS 
                            WHERE
                            C_PROCESO=:C_PROCESO_PROG
                            AND TIPO_INST='PLATAFORMA'
                            AND DESC_LARGA NOT IN('Pozos','Ductos')
                            AND baja is NULL
                            GROUP BY PADRE,C_PROCESO,SECTOR)DESTINO,       
                                
                            (SELECT *
                            FROM GAS_PLATAFORMAS 
                            WHERE
                            C_PROCESO=:C_PROCESO
                            AND TIPO_INST='PLATAFORMA'
                            AND PLATAFORMA=:PLATAFORMA
                            AND DESC_LARGA NOT IN('Pozos','Ductos')
                            AND baja is null)ORIGEN ,
                            (SELECT MAX(ID)+1 AS  ID FROM GAS_PLATAFORMAS)ID           
                            
                            
                            
                            
  --CAMBIA PLATAFORMA Y CENTRO DE PROCESO
  
   INSERT INTO GAS_PLATAFORMAS (ID, BAJA,DESC_CORTA,DESC_LARGA,ID_PLATAFORMAS,PADRE,CATEGORIA,
                            CONTENEDOR,REPORTE_URL,ICONO,VERANEXARCHIVOS,C_PROCESO,SECTOR,ACTIVO,REGION,MARCA, MODELO,PLATAFORMA,AGRUPADOR,ORDEN,SISTEMA,
                            SUBSISTEMA,DESC_REPORTE,CAMPO,TIPO_INST,VEROBSERVACIONES,YACIMIENTO,SIOP_NUMPOZO,SIOP_LETRA,SIOP_NOMPOZO,PANTALLAT,UWI,COL_TEMPORAL,PRESION_BN,
                            ORIGEN,DESTINO,ID_CALRMNE,BATERIA,PROYECTO,SNIP_PLAT_NOMBRE,SNIP_POZ_NOMBRE,ID_AFOROS,INICIO,FECHA_PROGRAMADA,ID_ORIGEN)

                            SELECT ID.ID,TO_DATE(:FECHA_PROGRAMADA)-1 AS BAJA,DESTINO.DESC_CORTA,DESTINO.DESC_LARGA,ID.ID AS ID_PLATAFORMAS,C_PROCESO_DESTINO.ID_PLATAFORMAS AS PADRE,
                            DESTINO.CATEGORIA,DESTINO.CONTENEDOR,DESTINO.REPORTE_URL,DESTINO.ICONO,DESTINO.VERANEXARCHIVOS,C_PROCESO_DESTINO.C_PROCESO,DESTINO.SECTOR,DESTINO.ACTIVO,DESTINO.REGION,
                            DESTINO.MARCA,DESTINO.MODELO,DESTINO.PLATAFORMA,DESTINO.AGRUPADOR,DESTINO.ORDEN,DESTINO.SISTEMA,DESTINO.SUBSISTEMA,DESTINO.DESC_REPORTE,ORIGEN.CAMPO,
                            'PLATAFORMA_PROG',DESTINO.VEROBSERVACIONES,DESTINO.YACIMIENTO,DESTINO.SIOP_NUMPOZO,DESTINO.SIOP_LETRA, DESTINO.SIOP_NOMPOZO,DESTINO.PANTALLAT,DESTINO.UWI,
                            DESTINO.COL_TEMPORAL,DESTINO.PRESION_BN,DESTINO.DESTINO,DESTINO.DESTINO,DESTINO.ID_CALRMNE,DESTINO.BATERIA,DESTINO.PROYECTO,DESTINO.SNIP_PLAT_NOMBRE,DESTINO.SNIP_POZ_NOMBRE,
                            DESTINO.ID_AFOROS,:FECHA_PROGRAMADA AS INICIO,:FECHA_PROGRAMADA AS FECHA_PROGRAMADA,ID.ID AS ID_ORIGEN
                            FROM
                            
                            (SELECT *
                            FROM GAS_PLATAFORMAS 
                            WHERE
                            C_PROCESO=:C_PROCESO_PROG
                            AND TIPO_INST='C_PROCESO'
                            AND baja is NULL
                            )C_PROCESO_DESTINO,     
                            
                            (SELECT BAJA,DESC_CORTA,DESC_LARGA,CATEGORIA,CONTENEDOR,REPORTE_URL,ICONO,VERANEXARCHIVOS,SECTOR,ACTIVO,REGION,MARCA,MODELO,PLATAFORMA,
                            AGRUPADOR,ORDEN,SISTEMA,SUBSISTEMA,DESC_REPORTE,CAMPO,TIPO_INST,VEROBSERVACIONES,YACIMIENTO,SIOP_NUMPOZO,SIOP_LETRA,SIOP_NOMPOZO,PANTALLAT,UWI,COL_TEMPORAL,PRESION_BN,
                            ORIGEN,DESTINO,ID_CALRMNE,BATERIA,PROYECTO,SNIP_PLAT_NOMBRE,SNIP_POZ_NOMBRE,ID_AFOROS,INICIO,FECHA_PROGRAMADA,ID_ORIGEN
                            FROM GAS_PLATAFORMAS 
                            WHERE
                            TIPO_INST='PLATAFORMA'
                            AND PLATAFORMA=:PLATAFORMA_PROG
                            AND DESC_LARGA NOT IN('Pozos','Ductos')
                            AND baja is NULL
                            GROUP BY  BAJA,DESC_CORTA,DESC_LARGA,CATEGORIA,CONTENEDOR,REPORTE_URL,ICONO,VERANEXARCHIVOS,SECTOR,ACTIVO,REGION,MARCA,MODELO,PLATAFORMA,
                            AGRUPADOR,ORDEN,SISTEMA,SUBSISTEMA,DESC_REPORTE,CAMPO,TIPO_INST,VEROBSERVACIONES,YACIMIENTO,SIOP_NUMPOZO,SIOP_LETRA,SIOP_NOMPOZO,PANTALLAT,UWI,COL_TEMPORAL,PRESION_BN,
                            ORIGEN,DESTINO,ID_CALRMNE,BATERIA,PROYECTO,SNIP_PLAT_NOMBRE,SNIP_POZ_NOMBRE,ID_AFOROS,INICIO,FECHA_PROGRAMADA,ID_ORIGEN
                            )DESTINO,       
                                
                           (SELECT MAX(ID)+1 AS  ID FROM GAS_PLATAFORMAS)ID                                     
                            
                            



--CREA CARPETA DE LA PLATAFORMA DONDE VAN LOS POZOS

  INSERT INTO GAS_PLATAFORMAS (ID, BAJA,DESC_CORTA,DESC_LARGA,ID_PLATAFORMAS,PADRE,CATEGORIA,
                            CONTENEDOR,REPORTE_URL,ICONO,VERANEXARCHIVOS,C_PROCESO,SECTOR,ACTIVO,REGION,MARCA, MODELO,PLATAFORMA,AGRUPADOR,ORDEN,SISTEMA,
                            SUBSISTEMA,DESC_REPORTE,CAMPO,TIPO_INST,VEROBSERVACIONES,YACIMIENTO,SIOP_NUMPOZO,SIOP_LETRA,SIOP_NOMPOZO,PANTALLAT,UWI,COL_TEMPORAL,PRESION_BN,
                            ORIGEN,DESTINO,ID_CALRMNE,BATERIA,PROYECTO,SNIP_PLAT_NOMBRE,SNIP_POZ_NOMBRE,ID_AFOROS,INICIO,FECHA_PROGRAMADA,ID_ORIGEN)

                             SELECT ID.ID,TO_DATE(:FECHA_PROGRAMADA)-1 AS BAJA,ORIGEN.DESC_CORTA,ORIGEN.DESC_LARGA,ID.ID AS ID_PLATAFORMAS,:PADRE AS PADRE,
                            ORIGEN.CATEGORIA,ORIGEN.CONTENEDOR,ORIGEN.REPORTE_URL,ORIGEN.ICONO,ORIGEN.VERANEXARCHIVOS,DESTINO.C_PROCESO AS C_PROCESO,DESTINO.SECTOR,DESTINO.ACTIVO,ORIGEN.REGION,
                            ORIGEN.MARCA,ORIGEN.MODELO,ORIGEN.PLATAFORMA,ORIGEN.AGRUPADOR,ORIGEN.ORDEN,ORIGEN.SISTEMA,ORIGEN.SUBSISTEMA,ORIGEN.DESC_REPORTE,ORIGEN.CAMPO,
                            'TAB_POZO_PROG' AS TIPO_INST,ORIGEN.VEROBSERVACIONES,ORIGEN.YACIMIENTO,ORIGEN.SIOP_NUMPOZO,ORIGEN.SIOP_LETRA, ORIGEN.SIOP_NOMPOZO,ORIGEN.PANTALLAT,ORIGEN.UWI,
                            ORIGEN.COL_TEMPORAL,ORIGEN.PRESION_BN,ORIGEN.ORIGEN,ORIGEN.DESTINO,ORIGEN.ID_CALRMNE,ORIGEN.BATERIA,ORIGEN.PROYECTO,ORIGEN.SNIP_PLAT_NOMBRE,ORIGEN.SNIP_POZ_NOMBRE,
                            ORIGEN.ID_AFOROS,:FECHA_PROGRAMADA AS INICIO,:FECHA_PROGRAMADA AS FECHA_PROGRAMADA,ORIGEN.ID AS ID_ORIGEN

                            FROM
                            (SELECT PADRE,C_PROCESO,SECTOR,ACTIVO
                            FROM GAS_PLATAFORMAS 
                            WHERE
                            C_PROCESO=:C_PROCESO_PROG
                            AND TIPO_INST='PLATAFORMA'
                            AND DESC_LARGA NOT IN('Pozos','Ductos')
                            AND baja is NULL
                            GROUP BY PADRE,C_PROCESO,SECTOR,ACTIVO)DESTINO,  
                            (SELECT ID,BAJA,DESC_CORTA,DESC_LARGA,CATEGORIA,CONTENEDOR,REPORTE_URL,ICONO,VERANEXARCHIVOS,SECTOR,ACTIVO,REGION,MARCA,MODELO,PLATAFORMA,
                            AGRUPADOR,ORDEN,SISTEMA,SUBSISTEMA,DESC_REPORTE,CAMPO,TIPO_INST,VEROBSERVACIONES,YACIMIENTO,SIOP_NUMPOZO,SIOP_LETRA,SIOP_NOMPOZO,PANTALLAT,UWI,COL_TEMPORAL,PRESION_BN,
                            ORIGEN,DESTINO,ID_CALRMNE,BATERIA,PROYECTO,SNIP_PLAT_NOMBRE,SNIP_POZ_NOMBRE,ID_AFOROS,INICIO,FECHA_PROGRAMADA,ID_ORIGEN
                            FROM GAS_PLATAFORMAS 
                            WHERE PLATAFORMA=:PLATAFORMA
                            AND TIPO_INST='TAB_POZO'
                            AND baja is null
                             GROUP BY  ID,BAJA,DESC_CORTA,DESC_LARGA,CATEGORIA,CONTENEDOR,REPORTE_URL,ICONO,VERANEXARCHIVOS,SECTOR,ACTIVO,REGION,MARCA,MODELO,PLATAFORMA,
                            AGRUPADOR,ORDEN,SISTEMA,SUBSISTEMA,DESC_REPORTE,CAMPO,TIPO_INST,VEROBSERVACIONES,YACIMIENTO,SIOP_NUMPOZO,SIOP_LETRA,SIOP_NOMPOZO,PANTALLAT,UWI,COL_TEMPORAL,PRESION_BN,
                            ORIGEN,DESTINO,ID_CALRMNE,BATERIA,PROYECTO,SNIP_PLAT_NOMBRE,SNIP_POZ_NOMBRE,ID_AFOROS,INICIO,FECHA_PROGRAMADA,ID_ORIGEN
                            ) ORIGEN,
                            (SELECT MAX(ID)+1 AS  ID FROM GAS_PLATAFORMAS)ID     










--CREA CARPETA DE LA PLATAFORMA DONDE VAN LOS POZOS Y SE CAMBIO EL CENTRO DE PROCESO


INSERT INTO GAS_PLATAFORMAS (ID, BAJA,DESC_CORTA,DESC_LARGA,ID_PLATAFORMAS,PADRE,CATEGORIA,
CONTENEDOR,REPORTE_URL,ICONO,VERANEXARCHIVOS,C_PROCESO,SECTOR,ACTIVO,REGION,MARCA, MODELO,PLATAFORMA,AGRUPADOR,ORDEN,SISTEMA,
SUBSISTEMA,DESC_REPORTE,CAMPO,TIPO_INST,VEROBSERVACIONES,YACIMIENTO,SIOP_NUMPOZO,SIOP_LETRA,SIOP_NOMPOZO,PANTALLAT,UWI,COL_TEMPORAL,PRESION_BN,
ORIGEN,DESTINO,ID_CALRMNE,BATERIA,PROYECTO,SNIP_PLAT_NOMBRE,SNIP_POZ_NOMBRE,ID_AFOROS,INICIO,FECHA_PROGRAMADA,ID_ORIGEN)

SELECT ID.ID,TO_DATE(:FECHA_PROGRAMADA)-1 AS BAJA,ORIGEN.DESC_CORTA,ORIGEN.DESC_LARGA,ID.ID AS ID_PLATAFORMAS,:PADRE AS PADRE,
ORIGEN.CATEGORIA,ORIGEN.CONTENEDOR,ORIGEN.REPORTE_URL,ORIGEN.ICONO,ORIGEN.VERANEXARCHIVOS,DESTINO.C_PROCESO AS C_PROCESO,DESTINO.SECTOR,DESTINO.ACTIVO,ORIGEN.REGION,
ORIGEN.MARCA,ORIGEN.MODELO,ORIGEN.PLATAFORMA,ORIGEN.AGRUPADOR,ORIGEN.ORDEN,ORIGEN.SISTEMA,ORIGEN.SUBSISTEMA,ORIGEN.DESC_REPORTE,ORIGEN.CAMPO,
'TAB_POZO_PROG' AS TIPO_INST,ORIGEN.VEROBSERVACIONES,ORIGEN.YACIMIENTO,ORIGEN.SIOP_NUMPOZO,ORIGEN.SIOP_LETRA, ORIGEN.SIOP_NOMPOZO,ORIGEN.PANTALLAT,ORIGEN.UWI,
ORIGEN.COL_TEMPORAL,ORIGEN.PRESION_BN,ORIGEN.ORIGEN,ORIGEN.DESTINO,ORIGEN.ID_CALRMNE,ORIGEN.BATERIA,ORIGEN.PROYECTO,ORIGEN.SNIP_PLAT_NOMBRE,ORIGEN.SNIP_POZ_NOMBRE,
ORIGEN.ID_AFOROS,:FECHA_PROGRAMADA AS INICIO,:FECHA_PROGRAMADA AS FECHA_PROGRAMADA,ORIGEN.ID AS ID_ORIGEN

FROM
(SELECT PADRE,C_PROCESO,SECTOR,ACTIVO
FROM GAS_PLATAFORMAS 
WHERE
C_PROCESO=:C_PROCESO_PROG
AND TIPO_INST='PLATAFORMA_PROG'
AND FECHA_PROGRAMADA=:FECHA_PROGRAMADA
GROUP BY PADRE,C_PROCESO,SECTOR,ACTIVO)DESTINO,  
(SELECT *
FROM GAS_PLATAFORMAS 
WHERE
PLATAFORMA=:PLATAFORMA_PROG
AND TIPO_INST='TAB_POZO'
AND baja is null) ORIGEN,
(SELECT MAX(ID)+1 AS  ID FROM GAS_PLATAFORMAS)ID   



--CREA POZO DERIVANDO SOLO SU PRODUCCION SIN MOVER SU POSICION

   INSERT INTO GAS_PLATAFORMAS (ID, BAJA,DESC_CORTA,DESC_LARGA,ID_PLATAFORMAS,PADRE,CATEGORIA,
                            CONTENEDOR,REPORTE_URL,ICONO,VERANEXARCHIVOS,C_PROCESO,SECTOR,ACTIVO,REGION,MARCA, MODELO,PLATAFORMA,AGRUPADOR,ORDEN,SISTEMA,
                            SUBSISTEMA,DESC_REPORTE,CAMPO,TIPO_INST,VEROBSERVACIONES,YACIMIENTO,SIOP_NUMPOZO,SIOP_LETRA,SIOP_NOMPOZO,PANTALLAT,UWI,COL_TEMPORAL,PRESION_BN,
                            ORIGEN,DESTINO,ID_CALRMNE,BATERIA,PROYECTO,SNIP_PLAT_NOMBRE,SNIP_POZ_NOMBRE,ID_AFOROS,INICIO,FECHA_PROGRAMADA,ID_ORIGEN,TIPO_CAMBIO)

 SELECT ID.ID, DATOS.BAJA,DATOS.DESC_CORTA,DATOS.DESC_LARGA,ID.ID AS ID_PLATAFORMAS,DATOS.PADRE,DATOS.CATEGORIA,
                            DATOS.CONTENEDOR,DATOS.REPORTE_URL,DATOS.ICONO,DATOS.VERANEXARCHIVOS,DATOS.C_PROCESO,DATOS.SECTOR,DATOS.ACTIVO,DATOS.REGION,DATOS.MARCA, DATOS.MODELO,DATOS.PLATAFORMA,DATOS.AGRUPADOR,DATOS.ORDEN,DATOS.SISTEMA,
                            DATOS.SUBSISTEMA,DATOS.DESC_REPORTE,DATOS.CAMPO,DATOS.TIPO_INST,DATOS.VEROBSERVACIONES,DATOS.YACIMIENTO,DATOS.SIOP_NUMPOZO,DATOS.SIOP_LETRA,DATOS.SIOP_NOMPOZO,DATOS.PANTALLAT,DATOS.UWI,DATOS.COL_TEMPORAL,DATOS.PRESION_BN,
                            DATOS.ORIGEN,DATOS.DESTINO,DATOS.ID_CALRMNE,DATOS.BATERIA,DATOS.PROYECTO,DATOS.SNIP_PLAT_NOMBRE,DATOS.SNIP_POZ_NOMBRE,DATOS.ID_AFOROS,DATOS.INICIO,DATOS.FECHA_PROGRAMADA,DATOS.ID,:TIPO_CAMBIO
                            FROM
                           (SELECT ID, TO_DATE(:FECHA_PROGRAMADA)-1 AS BAJA,DESC_CORTA,DESC_LARGA,ID_PLATAFORMAS,PADRE,CATEGORIA,
                            CONTENEDOR,REPORTE_URL,ICONO,VERANEXARCHIVOS, C_PROCESO,SECTOR,ACTIVO,REGION,MARCA, MODELO, PLATAFORMA,AGRUPADOR,ORDEN,SISTEMA,
                            SUBSISTEMA,DESC_REPORTE,CAMPO,'POZO_PROG' AS TIPO_INST,VEROBSERVACIONES,YACIMIENTO,SIOP_NUMPOZO,SIOP_LETRA,SIOP_NOMPOZO,PANTALLAT,UWI,COL_TEMPORAL,PRESION_BN,
                            ORIGEN,DESTINO,ID_CALRMNE,:BATERIA AS BATERIA,PROYECTO,SNIP_PLAT_NOMBRE,SNIP_POZ_NOMBRE,ID_AFOROS,:FECHA_PROGRAMADA AS INICIO,:FECHA_PROGRAMADA AS FECHA_PROGRAMADA
                                                                FROM GAS_PLATAFORMAS
                                                                WHERE TIPO_INST='POZO'
                                                                AND CAMPO=:CAMPO
                                                                AND C_PROCESO =:C_PROCESO
                                                                AND PLATAFORMA=:PLATAFORMA
                                                                AND BAJA IS NULL
                                                                AND ID=:ID_POZO)DATOS,
                             (SELECT MAX(ID)+1 AS  ID FROM GAS_PLATAFORMAS)ID














--QUERYS DEL SERVICIO A WINDOWS

--BUSCA MOVIMIENTOS PROGRAMADOS E DIA DE HOY

SELECT * FROM GAS_PLATAFORMAS
WHERE TIPO_INST LIKE '%_PROG'
AND FECHA_PROGRAMADA = TO_DATE(:FECHA_PROGRAMADA,'DD/MM/YYYY')
ORDER BY ID ASC




--BUSCA PLATAFORMA ORIGEN

SELECT * FROM GAS_PLATAFORMAS
WHERE 
DESC_LARGA = :POZO
AND TIPO_INST IN ('POZO')
AND BAJA IS NULL


--BUSCA CARPETA PLATAFORMA ORIGEN

SELECT *
FROM GAS_PLATAFORMAS 
WHERE
C_PROCESO=:C_PROCESO
AND PLATAFORMA=:PLATAFORMA
AND DESC_LARGA IN('Pozos')
AND baja is null



--PARA ACTIVAR EL CAMBIO PROGRAMADO

--0. BUSCA MOVIMIENTOS
SELECT * FROM GAS_PLATAFORMAS
                                WHERE TIPO_INST LIKE '%_PROG'
                                AND FECHA_PROGRAMADA = TO_DATE(:FECHA_PROGRAMADA,'DD/MM/YYYY')
                                ORDER BY ID ASC


--.dar de baja instalacion

UPDATE GAS_PLATAFORMAS
SET BAJA=:FECHA_BAJA
WHERE ID=:ID



--1. ACTIVA POZO PROGRAMADO

UPDATE GAS_PLATAFORMAS
SET BAJA='', TIPO_INST='POZO'
WHERE ID=:ID



-- 2. ASIGNA PARAMETROS DE LA PLATAFORMA ORIGEN A LA PLATAFORMA DESTINO

INSERT INTO GAS_PLATAFORMAS_PARAMETROS
SELECT ID_PARAMETROS, :ID_PLATAFORMA_PROG AS PLATAFORMA, ORDEN FROM
GAS_PLATAFORMAS_PARAMETROS
WHERE PLATAFORMA=:ID_PLATAFORMA


SELECT * FROM GAS_PLATAFORMAS_PARAMETROS
WHERE PLATAFORMA=3573



-- 3. ASIGNA PERMISOS AL USUARIO
SELECT PLATAFORMA, GRUPO FROM GAS_PLATAFORMAS_GRUPOS
WHERE PLATAFORMA=:ID



INSERT INTO GAS_PLATAFORMAS_GRUPOS
(PLATAFORMA,GRUPO)
VALUES(:ID_PLATAFORMA_PROG,:GRUPO)

--4. EJECUTAR PROCEDIMIENTOS PARA REFRESCAR PERMISOS

EXECUTE GAS_ELIMINARPLATAFORMATEMP(:GRUPO)

EXECUTE GAS_INSERTARPLATAFORMATEMP(:GRUPO)

--5. CREA POZO EN LA PANTALLA TABULAR


--BUSCA PANTALLA TABULAR DE LA INSTALACION
SELECT * FROM GAS_PLATAFORMAS
WHERE TIPO_INST = 'TAB_POZO' 
AND PLATAFORMA=:PLATAFORMA
AND C_PROCESO=:C_PROCESO
AND BAJA IS NULL


SELECT * FROM GAS_PANTALLAS_TABULARES
WHERE ID_PANTALLAS_TABULARES=:ID_PANTALLA


UPDATE GAS_PANTALLAS_TABULARES
SET RENGLONES=:DATOS
WHERE ID_PANTALLAS_TABULARES=:ID_PANTALLA


--6. INSERTA EN LA PANTALLA TABULAR DE PRODUCCION BASE

SELECT * FROM GAS_PLATAFORMAS
WHERE TIPO_INST='PROD_BASE'
AND C_PROCESO=:C_PROCESO
AND BAJA IS NULL

-----------------------------------------------------ACTIVAR PLATAFORMA

--1. ACTIVA PLATAFORMA PROGRAMADO

UPDATE GAS_PLATAFORMAS
SET BAJA='', TIPO_INST='PLATAFORMA'
WHERE ID=:ID



----------------------------------BORRAR MOVIMIENTOS PROGRAMADOS




DELETE FROM GAS_PLATAFORMAS
WHERE ID_ORIGEN = :ID
AND TIPO_INST='POZO_PROG'
AND FECHA_PROGRAMADA






--QUERYS DE PRUEBA


 SELECT * FROM GAS_PLATAFORMAS
                                WHERE PLATAFORMA=:PLATAFORMA
                                AND C_PROCESO=:C_PROCESO
                                AND TIPO_INST='POZO'
                                AND BAJA IS NULL

565
3887




SELECT * FROM GAS_PLATAFORMAS
WHERE PADRE IN (565,3887)


SELECT * FROM GAS_PLATAFORMAS
WHERE DESC_LARGA = 'C-1029'





SELECT * FROM GAS_PLATAFORMAS
WHERE TIPO_INST LIKE '%PROG'
ORDER BY ID ASC



SELECT * FROM GAS_PLATAFORMAS
                                WHERE TIPO_INST = 'TAB_POZO' 
                                AND PLATAFORMA=:PLATAFORMA
                                AND C_PROCESO=:C_PROCESO
                                AND BAJA IS NULL





SELECT * FROM GAS_PLATAFORMAS
WHERE FECHA_PROGRAMADA = TO_DATE('31/05/2013','DD/MM/YYYY')




SELECT * FROM GAS_PLATAFORMAS
WHERE TIPO_INST='TAB_POZO'
AND PLATAFORMA='AKAL-BN'


SELECT * FROM GAS_PLATAFORMAS
WHERE DESC_LARGA IN ('Pozos')
AND BAJA IS NOT NULL




DELETE FROM GAS_PLATAFORMAS
WHERE TIPO_INST LIKE '%PROG'


DELETE FROM GAS_PLATAFORMAS
WHERE ID=3967



DELETE FROM GAS_PLATAFORMAS
WHERE ID_PLATAFORMAS IN
(SELECT ID FROM GAS_PLATAFORMAS
WHERE ID_PLATAFORMAS IN(SELECT ID FROM GAS_PLATAFORMAS 
WHERE FECHA_PROGRAMADA = TO_DATE('31/05/2013','dd/MM/yyyy'))
)

DELETE FROM GAS_PLATAFORMAS_GRUPOS
WHERE PLATAFORMA IN
(SELECT ID FROM GAS_PLATAFORMAS
WHERE ID_PLATAFORMAS IN(SELECT ID FROM GAS_PLATAFORMAS 
WHERE FECHA_PROGRAMADA = TO_DATE('31/05/2013','dd/MM/yyyy'))
)

DELETE FROM GAS_PLATAFORMAS_PARAMETROS
WHERE PLATAFORMA IN
(SELECT ID FROM GAS_PLATAFORMAS
WHERE ID_PLATAFORMAS IN(SELECT ID FROM GAS_PLATAFORMAS 
WHERE FECHA_PROGRAMADA = TO_DATE('31/05/2013','dd/MM/yyyy'))
)



SELECT * FROM GAS_PLATAFORMAS
WHERE FECHA_PROGRAMADA = TO_DATE('31/05/2013','DD/MM/YYYY')




SELECT * FROM GAS_PLATAFORMAS
WHERE PLATAFORMA='AKAL-B'
AND BAJA IS NULL
AND TIPO_INST = 'POZO'


SELECT * FROM GAS_PLATAFORMAS_PARAMETROS
WHERE PLATAFORMA IN
(
SELECT ID FROM GAS_PLATAFORMAS
WHERE PLATAFORMA='AKAL-B'
AND BAJA IS NULL
AND TIPO_INST = 'POZO'
)

SELECT * FROM GAS_PLATAFORMAS
WHERE padre = 3573




ID_PLATAFORMAS=3591




SELECT * FROM GAS_PLATAFORMAS
WHERE ID_PLATAFORMAS=3556



SELECT * FROM GAS_PLATAFORMAS
WHERE ID_PLATAFORMAS=3967




SELECT * FROM GAS_PLATAFORMAS_GRUPOS
WHERE GRUPO='PEMEX\481814'


SELECT * FROM GAS_PLATAFORMAS_GRUPOS
WHERE plataforma=3558




SELECT DISTINCT PLATAFORMA, ID_PLATAFORMAS
                                FROM GAS_PLATAFORMAS
                                WHERE TIPO_INST='PLATAFORMA'
                              AND ACTIVO=:ACTIVO
                              AND BAJA IS NULL
                              ORDER BY PLATAFORMA
                              
                              
                              
 SELECT TO_CHAR(INICIO,'DD/MM/YYYY') AS FECHA,DESC_LARGA AS POZO, CAMPO, C_PROCESO AS "C. PROCESO", PLATAFORMA
                                    FROM GAS_PLATAFORMAS 
                                    WHERE ID=:ID