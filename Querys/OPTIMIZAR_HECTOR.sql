WITH datos AS (
	SELECT 
		just2.id_justificacion,
		just2.proyecto,
		just2.fecha_contable,
		TRUNC(just2.fecha_contable - 1, 'WW') + 1 AS ini_semana,
		TO_CHAR(just2.fecha_contable - 1, 'YYYYWW') AS semana,
		TO_CHAR(just2.fecha_contable + 13, 'YYYYWW') AS semana_ant1,
		TO_CHAR(just2.fecha_contable + 6, 'YYYYWW') AS semana_ant2,
		just2.id_det_concepto,
		movs2.id_instalacion,
		movs2.desc_instalacion		
	FROM pron_just just2, pron_movs movs2
	WHERE just2.id_justificacion = movs2.id_justificacion
		AND just2.fecha_contable BETWEEN :FECHA_INI - 14 AND :FECHA_FIN
		AND just2.id_det_concepto IN (59,60,61,62)
		AND movs2.cve_tipo = 'P'
	ORDER BY 3
	
	
	)
	



	

SELECT semana, proyecto, COUNT(DISTINCT desc_instalacion) AS pozos
FROM datos
WHERE (proyecto, id_det_concepto, semana, desc_instalacion) NOT IN
		(
		SELECT a.proyecto, a.id_det_concepto, a.semana, a.desc_instalacion
		FROM
			(
			SELECT *
			FROM datos
			) a,
			(
			SELECT *
			FROM datos
			
			) b
		WHERE a.proyecto = b.proyecto
			AND (a.semana = b.semana_ant1 OR a.semana = b.semana_ant2)
			AND a.id_det_concepto = b.id_det_concepto
			AND a.desc_instalacion = b.desc_instalacion	
		)
	AND fecha_contable >= :FECHA_INI
GROUP BY semana, proyecto
ORDER BY 1

	
	