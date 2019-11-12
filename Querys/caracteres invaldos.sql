select * from actividades where id_actividades in (select id_actividades from actividades where codigo  = 'PE-PO-OP-2365-2010 ')

select desc_actividades from actividades where id_actividades in (select id_actividades from actividades where codigo  = 'PE-PO-OP-2365-2010 ')

update actividades set desc_actividades = 'VERIFICACION Y RECEPCION DE TRABAJOS DE INTERCONEXION DE MODULOS DE RENTA PARA COMPRESION' where codigo = 'PE-PO-OP-2365-2010' and id_actividades = 30304
