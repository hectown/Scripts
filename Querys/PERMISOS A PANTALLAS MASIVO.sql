
        INSERT INTO GAS_PLATAFORMAS_GRUPOS (PLATAFORMA, GRUPO) SELECT ID AS PLATAFORMA,'PEMEX\419464' AS GRUPO
         FROM
         
          gas_plataformas
   
         START WITH PADRE=493
         CONNECT BY PRIOR ID_PLATAFORMAS = PADRE
         
         COMMIT;
         
         
         
         
         SELECT * FROM GAS_PLATAFORMAS WHERE DESC_CORTA LIKE '%GTDH%'