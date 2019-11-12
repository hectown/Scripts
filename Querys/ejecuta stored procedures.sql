var c refcursor;
execute  RMNE_OP_CARGA_EXP_MENS.REP_CARGAMENTO_EXPORTACION('FPSO','08/2018','08/2018':c);
print c;