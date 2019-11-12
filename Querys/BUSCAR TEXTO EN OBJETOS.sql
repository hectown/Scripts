    select OWNER, NAME, TYPE, LINE, TEXT
    from all_source
   where owner = 'ACEITENE'  --USUARIO DE BASE DE DATOS
      and type in ('PACKAGE', 'PACKAGE BODY','FUNCTION','PROCEDURE') --BUSCA EN PAQUETES FUNCIONES...ETC.
      and upper(text) like upper('%INTEGRADAS_CALIDAD_BAT%') --BUSCA CADENA DE TEXTO
      and rownum < 3
      
      /
      
      
      select * from SYS.ALL_SOURCE where upper(TEXT) like '%WPSERVICIOS%';
      
      
      /
      
      
      SELECT DISTINCT SUBSTR (:val, 1, 11) "Searchword",
      SUBSTR (table_name, 1, 14) "Table",
     SUBSTR (column_name, 1, 14) "Column"
    FROM cols,
      TABLE (xmlsequence (dbms_xmlgen.getxmltype ('select '
      || column_name
      || ' from '
      || table_name
      || ' where upper('
     || column_name
     || ') like upper(''%'
     || :val
     || '%'')' ).extract ('ROWSET/ROW/*') ) ) t
   ORDER BY "Table"