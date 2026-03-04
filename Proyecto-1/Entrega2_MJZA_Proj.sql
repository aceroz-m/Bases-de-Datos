--Entrega 2

--Querie #1
CREATE OR REPLACE VIEW v_ConferenciasDictadas AS 
SELECT ss.nombre_sede as Nombre_Sede, s.nombre_sala as Nombre_Sala, c.nombre as Nombre_Conferencista, cs.fecha, cs.valor_dia
FROM  conferencia_sala cs
JOIN conferencista c ON cs.id_conferencista = c.id
JOIN  sala s ON cs.id_sala = s.id
JOIN sede ss ON s.id_sede = ss.id
ORDER BY ss.nombre_sede, s.nombre_sala, c.nombre;

GRANT SELECT ON  v_ConferenciasDictadas TO jcarreno;

--querie#2
CREATE OR REPLACE VIEW v_conferencistas_distintos_por_sala AS
    SELECT se.nombre_sede AS nombre_sede, 
    sa.nombre_sala AS nombre_sala, 
    COUNT (DISTINCT cs.id_conferencista)AS cantidad_Conferencistas_distintos
    FROM sede se
    JOIN sala sa ON sa.id_sede = se.id
    LEFT JOIN conferencia_sala cs ON cs.id_sala = sa.id
    GROUP BY se.nombre_sede, sa.nombre_sala;
    
SELECT * 
FROM v_conferencistas_distintos_por_sala
ORDER BY nombre_sede, nombre_sala;

GRANT SELECT ON v_conferencistas_distintos_por_sala TO jcarreno;
    
--QUerie #3
CREATE OR REPLACE VIEW v_pago_por_sede AS 
SELECT se.nombre_sede, co.nombre AS nombre_conferencista, SUM(cs.valor_dia)AS total_cobrado
FROM conferencia_sala cs
JOIN sala sa ON cs.id_sala = sa.id 
JOIN sede se ON sa.id_sede = se.id
JOIN conferencista co ON cs.id_conferencista = co.id 
GROUP BY se.nombre_sede, co.nombre
ORDER BY se.nombre_sede, co.nombre; 

SELECT 'Total General', null, SUM (cs.valor_dia)
FROM conferencia_sala cs;
SELECT * 
FROM v_pago_por_sede;

GRANT SELECT ON v_pago_por_sede TO jcarreno;

SELECT owner, table_name, select_priv, insert_priv, delete_priv, update_priv, references_priv, alter_priv, index_priv 
  FROM table_privileges
 WHERE grantee = 'JCARRENO'
 ORDER BY owner, table_name;