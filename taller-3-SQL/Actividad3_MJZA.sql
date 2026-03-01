--Liste el nombre del estudiante, el topic del examen y la puntuaci�n obtenida en los examenes. (v_listadototalizado). 
--En una utima fila muestre el promedio de la puntuaci�n de todos los registros del listado anterior.
PURGE RECYCLEBIN;
CREATE OR REPLACE VIEW v_listadoTotalizado AS

SELECT 
    s.first || ' ' || s.last AS nombre_completo,
    e.topic AS tema,
    r.points AS puntuacion
FROM students s, results r, exercises e
where s.sid = r.sid AND e.eid = r.eid

UNION ALL

SELECT 
    'PROMEDIO' AS nombre_completo,
    NULL AS tema,
    AVG(r.points) AS puntuacion
FROM results r;

-- Estudiantes y monitores (v_EstudiantesYMonitores)
--Liste el nombre del estudiante y el nombre del monitor. Si un estudiante no tiene monitor debe aparecer (usar SUBCONSULTAS CORRELACIONADAS)

CREATE OR REPLACE VIEW v_EsudiantesyMonitores as 
SELECT s.first || ' ' || s.last as nombre_completo, 
    (SELECT s2.first || ' ' || s2.last as nombre
        from students s2
            where s2.sid=s.monitor) as MONITOR
FROM students s;

--Genere un listado de examenes que no han sido presentados, liste el topic. (v_examenessinres) 
--verison not IN
--version outer join
--version except

INSERT INTO EXERCISES (EID, CAT, ENO, TOPIC, MAXPT, AVRG)
VALUES (4, 'M', 3, 'TRIGONOMETRIA', 100, NULL);

INSERT INTO EXERCISES (EID, CAT, ENO, TOPIC, MAXPT, AVRG)
VALUES (5, 'M', 4, 'SQL3', 100, NULL);

--Version 1

CREATE OR REPLACE VIEW v_examenesSinRes1 as
SELECT e.topic
FROM exercises e
WHERE e.eid NOT IN (SELECT r.eid FROM results r
);
GRANT SELECT ON v_examenessinres1 TO jcarreno;

--version 2
CREATE OR REPLACE VIEW v_examenesSinRes2 as
SELECT e.topic, e.eid
FROM exercises e
LEFT OUTER JOIN results r ON r.eid = e.eid
WHERE r.eid IS NULL;
GRANT SELECT ON v_examenessinres2 TO jcarreno;

--version 3
CREATE OR REPLACE VIEW v_examenessinres3 AS
SELECT e.eid, e.topic
FROM exercises e
MINUS
SELECT e.eid, e.topic
FROM exercises e
JOIN results r ON r.eid = e.eid;

GRANT SELECT ON v_examenessinres3 TO jcarreno;

GRANT SELECT ON v_listadototalizado TO jcarreno;
GRANT SELECT ON v_EsudiantesyMonitores TO jcarreno;

SELECT owner, table_name, select_priv, insert_priv, delete_priv, update_priv, references_priv, alter_priv, index_priv 
  FROM table_privileges
 WHERE grantee = 'JCARRENO'
 ORDER BY owner, table_name;