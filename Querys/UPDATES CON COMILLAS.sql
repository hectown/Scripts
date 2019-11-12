select
    'update gas_c_parametros set inicio_js = ''' || replace(inicio_js, '''', '''''') || ''' where id_parametros = ' || ID_PARAMETROS || ';'
from gas_c_parametros
where id_paraMetros in( 2739)