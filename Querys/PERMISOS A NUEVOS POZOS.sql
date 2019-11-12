-- Zona de declaración 
declare
-- Declaramos el cursor sobre una consulta de una 
-- supuesta tabla usuarios.
cursor USERNAME is
    SELECT DISTINCT USERNAME FROM GAS_GRUPOS_USUARIOS 
                                    WHERE GRUPO IN (SELECT grupo FROM GAS_PLATAFORMAS_GRUPOS 
                                                                    WHERE PLATAFORMA IN (2260));
 
-- Fin declaración. Comenzamos el procedimento
begin
-- Recorremos el cursor con un bucle for - loop
    for u in USERNAME loop
           GAS_ELIMINARPLATAFORMATEMP(u.USERNAME);
          GAS_INSERTARPLATAFORMATEMP(u.USERNAME);
    end loop; 
-- Fin bucle
end; 
-- Fin procedimiento

   --GAS_INSERTARPLATAFORMATEMP
--GAS_ELIMINARPLATAFORMATEMP
