-- user DBA postgres
-- database : any

select * 
from pg_roles 
where rolname in (
	'postgres',
	'cinema',
	'cinefan',
	'titi',
	'tutu',
	'toto'
);

select * from pg_shadow;

show password_encryption; -- "scram-sha-256"
set password_encryption = 'md5';

create user old_user with login password 'password';
-- ATTENTION:  setting an MD5-encrypted password
-- CREATE ROLE

select * from pg_shadow; -- old_user: "md5cede7becb11e00c48e95fa5814726e9f"

-- recreer le mot de passe + securisé
set password_encryption = 'scram-sha-256';
show password_encryption;
alter user old_user with password 'password';
select * from pg_shadow; -- old_user : "SCRAM-SHA-256$4096:llsYL4WMXKh4dE6zy97rWA==$bTIgGm8Xx5uJU+WYIyZf1b1xaFjltb4dNuqjR2kJvHk=:tk3PANtRYj1/5L8axaI+lKe8R5bGSWAIdv89iCYEphc="

select pg_reload_conf();


-- liste des bases
select * 
from pg_database 
order by oid;

select 
	oid, -- id de l'objet stocké
	relname, -- nom objet stocké: table, index, ...
	relnamespace, -- id du schema
	relfilenode, 
	relkind -- type d'objet (S = sequence, i = index, r = table, v = view, ...)
from pg_class
where relnamespace = 16387 -- schema cinema
order by relkind, relname
;




-- vacuum (auto: cf postgresql.conf)
vacuum cinema.movie;

vacuum full cinema.movie;

vacuum full; -- defragmentation de toute la base

-- toutes les tables et index ont changé de fichier
select 
	oid, -- id de l'objet stocké
	relname, -- nom objet stocké: table, index, ...
	relnamespace, -- id du schema
	relfilenode, 
	relkind -- type d'objet (S = sequence, i = index, r = table, v = view, ...)
from pg_class
where relnamespace = 16387 -- schema cinema
order by relkind, relname
;


-- 
SELECT 
    relname AS table_name,
    pg_size_pretty(pg_relation_size(relid)) AS data_size,
	pg_size_pretty(pg_indexes_size(relid)) AS index_file_size,
	pg_size_pretty(pg_table_size(relid)) AS table_file_size,
	pg_size_pretty(pg_total_relation_size('cinema.play')) AS total_file_size,
	pg_size_pretty(pg_table_size(relid) - pg_relation_size(relid)) as free_plus_map_size,
	-- detail : parcours toute la table avec extension 'pgstattuple'
	-- round(pgstattuple('cinema.play'::regclass).free_percent, 2) AS free_space_percent,
 	--    round(pgstattuple('cinema.play'::regclass).dead_tuple_percent, 2) AS dead_tuple_percent,
 	-- detail : parcours rapide
	-- round((pgstattuple_approx('cinema.play'::regclass)).free_percent, 2) AS approx_free_percent,
 	--    round((pgstattuple_approx('cinema.play'::regclass)).dead_tuple_percent, 2) AS approx_dead_percent

	-- sans extension:
	round(100.0 * n_dead_tup / NULLIF(n_live_tup + n_dead_tup, 0), 2) AS dead_rows_percent,
	last_vacuum,
	last_autovacuum
FROM pg_stat_user_tables
WHERE relname = 'play';











