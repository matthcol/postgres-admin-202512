-- supervision session
select * 
from pg_stat_activity
where datname = 'dbcinema'
	and usename is not null
	and usename <> 'postgres';

-- chaque session à 1 identifiant : pid = 29796 pour une session psql
select pg_cancel_backend(29796); -- mettre fin aux requetes en cours (gentil)
select pg_terminate_backend(29796);  -- connexion coupée : psql en recree 1 autre => pid = 3856

select * from pg_class; -- table movie = "16398"

select * from pg_locks 
where 
	pid in (27884, 3856) 
	and relation = 16398
order by pid;

select id, title, year, duration, director_id from cinema.movie where title in ('Zootopia 2', 'Sinners');

-- scenario 1 : user cinema (3856)
BEGIN;  -- debut de transaction
update cinema.movie set duration = 90 where id = 8079249;  -- verrou : "RowExclusiveLock"
update cinema.movie set duration = 120 where id = 8079250; 
COMMIT;  -- ou ROLLBACK



-- scenario 2 : user cinema (27884)
BEGIN;  -- debut de transaction
update cinema.movie set duration = 91 where id = 8079249; 
COMMIT;


-- interblocage (deadlock)

-- scenario 1 : user cinema (3856)
BEGIN;  -- debut de transaction
update cinema.movie set duration = 99 where id = 8079249;  -- Zootopia
update cinema.movie set duration = 129 where id = 8079250; -- Sinners
COMMIT;

-- scenario 1 : user cinema (27884)
BEGIN;  -- debut de transaction 
update cinema.movie set duration = 127 where id = 8079250; -- Sinners
update cinema.movie set duration = 97 where id = 8079249;  -- Zootopia
COMMIT;

-- NB : mettre en place 1 ordre => pas de deadlock


-------------------------------------------------------------
-- supervision des requetes

-- liste des extensions activées sur CETTE base
select * from pg_extension; -- plpgsql : langage pl/pgsql de code stocké 

-- liste des extensions disponibles
select * from pg_available_extensions
order by name;  -- repere : "pg_stat_statements"

-- RHEL10: sudo dnf install postgresql16-contrib

-- dans postgresql.conf : 
-- shared_preload_libraries = 'pg_stat_statements'

select * from pg_extension; -- pas encore là
create extension pg_stat_statements; -- activer l'extension sur la base courante
select * from pg_extension; -- ok elle apparait


select * from pg_stat_statements order by total_exec_time desc;

SELECT pg_stat_statements_reset();



















