select (fecha_real-1) as fecha_contable, fecha_real,c_proceso,desc_larga, id, aceite_neto from rmn_po_dist_por_pozo where id=:ID_POZO





SELECT f.fecha_contable, a.plataforma, a.c_proceso, a.desc_larga,  a.id,
       a.PRESION_TP, 
       a.PRESION_TR,
       a.PRESION_B1,
       a.PRESION_B2,
       a.VOLUMEN_BN,
       a.TEMP_B1,
       a.TEMP_B2,
       b.N2_MOL,
       a.ESTRA_A,
       c.aceite_neto
                
          FROM 
              (SELECT to_date(:fecha_ini,'dd/mm/yyyy') + ROWNUM - 1 As FECHA_CONTABLE  FROM DUAL 
               CONNECT By ROWNUM <= to_date(:fecha_fin,'dd/mm/yyyy') - to_date(:fecha_ini,'dd/mm/yyyy') + 1 )F, 
                              
              (
              SELECT a.orden, b.fecha_contable, b.plataforma, b.c_proceso, b.desc_larga,  b.id, b.PRESION_TP, PRESION_TR,
                   PRESION_B1, PRESION_B2, VOLUMEN_BN, TEMP_B1, TEMP_B2, ESTRA_A  FROM  
                  (SELECT GPV.fecha_contable, GPV.plataforma, MAX(GCH.orden ) AS ORDEN
                   FROM  GAS_C_HORAS GCH, GAS_PARAMETROS_VALORES GPV WHERE GPV.id_hora = GCH.id_hora
                   AND GPV.fecha_contable BETWEEN TO_DATE(:FECHA_INI, 'DD/MM/YYYY') AND TO_DATE(:FECHA_FIN, 'DD/MM/YYYY')
                   AND GPV.plataforma = :ID_POZO GROUP BY GPV.fecha_contable, GPV.plataforma)a,
                  (SELECT GPV.fecha_contable, GP.plataforma, GP.c_proceso, GP.desc_larga,  GP.id,  GCH.orden,
                   MAX(CASE WHEN GPV.id_parametros = 3 THEN GPV.valor_numerico END) AS PRESION_TP,
                   MAX(CASE WHEN GPV.id_parametros = 6 THEN GPV.valor_numerico END) AS PRESION_TR,
                   MAX(CASE WHEN GPV.id_parametros = 4 THEN GPV.valor_numerico END) AS PRESION_B1,
                   MAX(CASE WHEN GPV.id_parametros = 1129 THEN GPV.valor_numerico END) AS PRESION_B2,
                   MAX(CASE WHEN GPV.id_parametros = 5 THEN GPV.valor_numerico END) AS VOLUMEN_BN,
                   MAX(CASE WHEN GPV.id_parametros = 7 THEN GPV.valor_numerico END) AS TEMP_B1,
                   MAX(CASE WHEN GPV.id_parametros = 1131 THEN GPV.valor_numerico END) AS TEMP_B2,
                   MAX(CASE WHEN GPV.id_parametros = 1132 THEN GPV.valor_numerico END) ESTRA_A
                   FROM GAS_PARAMETROS_VALORES GPV, GAS_PLATAFORMAS GP, GAS_C_PARAMETROS GCP, GAS_C_HORAS GCH
                   WHERE fecha_contable BETWEEN TO_DATE(:FECHA_INI, 'DD/MM/YYYY') AND TO_DATE(:FECHA_FIN, 'DD/MM/YYYY')
                   AND GP.tipo_inst = 'POZO' 
                   AND GPV.plataforma = GP.id
                   AND GPV.id_parametros = GCP.id_parametros
                   AND GPV.id_hora = GCH.id_hora
                   AND GP.id = :ID_POZO  
                   GROUP BY GPV.fecha_contable, GP.plataforma, GP.c_proceso, GP.desc_larga, gp.id,  GCH.orden
                   ORDER BY 1)b               
                   WHERE a.orden = b.orden AND a.fecha_contable = b.fecha_contable AND a.plataforma = b.id
                   ORDER BY b.fecha_contable
            )a,
                
            (
            SELECT f.FECHA_CONTABLE, a.activo, a.desc_larga, a.c_proceso,  a.plataforma, a.N2_MOL FROM
                   (SELECT to_date(:fecha_ini,'dd/mm/yyyy') + ROWNUM - 1 As FECHA_CONTABLE 
                   FROM DUAL CONNECT By ROWNUM <= to_date(:fecha_fin,'dd/mm/yyyy') - to_date(:fecha_ini,'dd/mm/yyyy') + 1 )F,      
                  (SELECT activo, desc_larga, c_proceso,  plataforma, N2_MOL,pivote_inicial,
                   decode (lead(pivote_inicial) over(order by pivote_inicial ), null,TO_DATE(:FECHA_FIN, 'DD/MM/YYYY'),lead(pivote_inicial-1) over(order by pivote_inicial) ) as pivote_final 
                   FROM (
                   SELECT cro.id, cro.activo, gp.desc_larga, gp.c_proceso, gp.plataforma, cro.fecha_real-1 as pivote_inicial, cro.porc_mol_n2 AS N2_MOL
                   FROM rmn_po_cromatografia cro, gas_plataformas gp
                   WHERE fecha_real = (SELECT MAX(cro.fecha_real) as pivote_inicial
                   FROM rmn_po_cromatografia cro, gas_plataformas gp
                   WHERE fecha_real < TO_DATE(:FECHA_INI, 'DD/MM/YYYY')+1
                   AND cro.id = gp.id 
                   AND cro.id = :ID_POZO) 
                   AND cro.id = gp.id 
                   AND cro.id = :ID_POZO 
                   UNION
                   SELECT cro.id, cro.activo, gp.desc_larga, gp.c_proceso, gp.plataforma, cro.fecha_real-1 as pivote_inicial,  cro.porc_mol_n2 AS N2_MOL
                   FROM rmn_po_cromatografia cro, gas_plataformas gp
                   WHERE fecha_real BETWEEN TO_DATE(:FECHA_INI, 'DD/MM/YYYY')+1 AND TO_DATE(:FECHA_FIN, 'DD/MM/YYYY')+1
                   AND cro.id = gp.id 
                   AND cro.id = :ID_POZO))a
                   WHERE f.FECHA_CONTABLE BETWEEN a.pivote_inicial AND a.pivote_final ORDER BY f.FECHA_CONTABLE                            
            )b,
                 (
                  
                  select (fecha_real-1) as fecha_contable, fecha_real,c_proceso,desc_larga, id, aceite_neto from rmn_po_dist_por_pozo where id=:ID_POZO and
                  fecha_real BETWEEN TO_DATE(:FECHA_INI, 'DD/MM/YYYY')+1 AND TO_DATE(:FECHA_FIN, 'DD/MM/YYYY')+1 
                  
                  )c 
                  
               
                WHERE f.fecha_contable   = a.fecha_contable (+)
                AND f.fecha_contable  = b.fecha_contable (+) AND
                f.fecha_contable = c.fecha_contable (+)
                order by f.fecha_contable
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                  SELECT id, activo, c_proceso, plataforma, desc_larga, orden
               FROM GAS_PLATAFORMAS
               WHERE TIPO_INST = 'POZO'
               GROUP BY id, activo, c_proceso, plataforma, desc_larga, orden
               ORDER BY 2, 3, 4, 6