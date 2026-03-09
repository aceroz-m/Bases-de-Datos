--Valor mensual que recibe cada sede por concepto de impuesto
CREATE OR REPLACE VIEW v_impuesto_mensual_sede AS
WITH conferencias_por_mes AS (
    SELECT
        se.NOMBRE_SEDE,
        EXTRACT(YEAR  FROM cs.FECHA) AS anio,
        EXTRACT(MONTH FROM cs.FECHA) AS mes,
        SUM(cs.VALOR_DIA)            AS total_valor_dia
    FROM SEDE se
    LEFT JOIN SALA sa             ON sa.ID_SEDE = se.ID
    LEFT JOIN CONFERENCIA_SALA cs ON cs.ID_SALA = sa.ID
    GROUP BY se.NOMBRE_SEDE, EXTRACT(YEAR FROM cs.FECHA), EXTRACT(MONTH FROM cs.FECHA)
),
calculo_impuesto AS (
    SELECT
        NOMBRE_SEDE,
        anio,
        mes,
        CASE 
            WHEN total_valor_dia IS NULL THEN 0
            ELSE total_valor_dia * 0.12
        END AS valor_impuesto
    FROM conferencias_por_mes
)
SELECT
    NOMBRE_SEDE    AS "Nombre de la sede",
    anio           AS "Año",
    mes            AS "Mes",
    valor_impuesto AS "Valor del impuesto"
FROM calculo_impuesto
ORDER BY NOMBRE_SEDE, anio, mes;

GRANT SELECT ON v_impuesto_mensual_sede TO jcarreno;
--PUNTO 5 
create or replace view v_porcentaje_participacion as
with total_por_conferencista as (
    select c.id,
           c.nombre,
           sum(cs.valor_dia) as total_cobrado
    from conferencista c, conferencia_sala cs
    where c.id = cs.id_conferencista
    group by c.id, c.nombre
),
total_general as (
    select sum(valor_dia) as total_general_cobrado
    from conferencia_sala
)
select t.nombre,
       t.total_cobrado,
       g.total_general_cobrado,
       round((t.total_cobrado / g.total_general_cobrado) * 100, 2) as porcentaje_participacion
from total_por_conferencista t, total_general g;

GRANT SELECT ON v_porcentaje_participacion to jcarreno;

--PUNTO 6
create or replace view v_conferencistas_todas_salas as select c.nombre
from conferencista c
where not exists (
    (select s.id
     from sala s)
    minus
    (select cs.id_sala
     from conferencia_sala cs
     where cs.id_conferencista = c.id)
);
GRANT SELECT ON v_conferencistas_todas_salas TO jcarreno;
--Querie 7, conferencistas por genero 
CREATE OR REPLACE VIEW v_conferencistas_por_genero_sede AS
WITH genero AS (
    SELECT
        se.NOMBRE_SEDE,
        co.GENERO,
        COUNT(DISTINCT co.ID) AS cantidad
    FROM SEDE se
    LEFT JOIN SALA sa             ON sa.ID_SEDE          = se.ID
    LEFT JOIN CONFERENCIA_SALA cs ON cs.ID_SALA           = sa.ID
    LEFT JOIN CONFERENCISTA co    ON co.ID                = cs.ID_CONFERENCISTA
    GROUP BY se.NOMBRE_SEDE, co.GENERO
),
conteo_genero AS (
    SELECT
        NOMBRE_SEDE,
        SUM(CASE WHEN GENERO = 'F' THEN cantidad ELSE 0 END) AS femenino,
        SUM(CASE WHEN GENERO = 'M' THEN cantidad ELSE 0 END) AS masculino
    FROM genero
    GROUP BY NOMBRE_SEDE
),
totales AS (
    SELECT
        'Totales'        AS NOMBRE_SEDE,
        SUM(femenino)    AS femenino,
        SUM(masculino)   AS masculino
    FROM conteo_genero
),
resultado AS (
    SELECT NOMBRE_SEDE, femenino, masculino, 0 AS orden FROM conteo_genero
    UNION ALL
    SELECT NOMBRE_SEDE, femenino, masculino, 1 AS orden FROM totales
)
SELECT
    NOMBRE_SEDE            AS "Sede",
    femenino               AS "Total de conferencistas mujeres",
    masculino              AS "Total de conferencistas hombres",
    (femenino + masculino) AS "Total"
FROM resultado 
ORDER BY orden, NOMBRE_SEDE;

GRANT SELECT ON v_conferencistas_por_genero_sede TO jcarreno;
SELECT owner, table_name, select_priv, insert_priv, delete_priv, update_priv, references_priv, alter_priv, index_priv 
  FROM table_privileges
 WHERE grantee = 'JCARRENO'
 ORDER BY owner, table_name;