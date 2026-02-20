--Genere un listado de los resultados obtenidos por los estudiantes en los ejercicios que presentaron (v_Resultados) 
--Liste el nombre, apellido del estudiante, tema y puntos obtenidos en el ejercicio, ordene el listado por documento del estudiante,
--tema y puntuaci�n de la mayor a menor dentro de cada tema.
CREATE OR REPLACE VIEW v_resultados AS 
SELECT s.first as nombre, s.last as apellido, e.topic as tema, s.documento, r.points as puntos
FROM exercises e,  results r, students s
WHERE r.sid = s.sid AND r.eid = e.eid;

SELECT * FROM v_resultados
ORDER BY documento, tema, puntos desc;

GRANT SELECT ON v_resultados TO JCARRENO;
SELECT owner, table_name, select_priv, insert_priv, delete_priv, update_priv, references_priv, alter_priv, index_priv 
  FROM table_privileges
 WHERE grantee = 'JCARRENO'
 ORDER BY owner, table_name;

--Estudiantes que no han presentado ejercicios (v_EstudiantesSinResultados)
--Liste el nombre del estudiante (sugiero usar JOINED RELATIONS)
CREATE OR REPLACE VIEW v_EstudiantesSinResultados AS 
SELECT s.first as nombre, s.last as apellido
FROM students s
LEFT JOIN results r ON r.sid = s.sid
WHERE r.sid is null;

select * from v_estudiantessinresultados;

GRANT SELECT ON v_estudiantessinresultados TO JCARRENO;

SELECT owner, table_name, select_priv, insert_priv, delete_priv, update_priv, references_priv, alter_priv, index_priv 
  FROM table_privileges
 WHERE grantee = 'JCARRENO'
 ORDER BY owner, table_name;
 
 --3.Obtenga las definitivas del curso de cada uno de los estudiantes. (v_definitivasEstudiante)
--Liste el nombre y apellido del estudiante y la sumatoria de puntos de todos los ejercicios (la definitiva del curso).
CREATE OR REPLACE VIEW v_definitivasEstudiantes AS 
SELECT s.first as nombre, s.last as apellido, sum (points) as sumatoria_puntos
FROM students s, results r
WHERE r.sid = s.sid
group by s.first, s.last;

GRANT SELECT ON v_definitivasEstudiantes TO JCARRENO;

SELECT owner, table_name, select_priv, insert_priv, delete_priv, update_priv, references_priv, alter_priv, index_priv 
  FROM table_privileges
 WHERE grantee = 'JCARRENO'
 ORDER BY owner, table_name;
 
