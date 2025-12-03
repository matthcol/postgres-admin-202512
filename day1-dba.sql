-- dabase dbcinema
-- user DBA postgres
CREATE SCHEMA cinema; -- default owner : postgres
ALTER SCHEMA cinema OWNER TO cinema;

DROP schema cinema;
CREATE SCHEMA cinema AUTHORIZATION cinema; -- AUTHORIZATION signifie OWNER TO

-- pour le schema public : protégé depuis PG 15
GRANT ALL ON SCHEMA public TO cinema;

-----------------------------------------------------------------------------------

-- Exercice 1 :
-- creer une base dbcinemadev
-- importer les tables sur le schema public avec proprietaire cinema

-- base de maintenance postgres
-- user DBA postgres
drop database dbcinemadev;
create database dbcinemadev encoding 'UTF-8';

-- base de dbcinemadev
-- user DBA postgres
GRANT ALL ON SCHEMA public TO cinema; 
-- ou via le GUI onglet security: ALL = CREATE + USAGE (CU)

-- puis importer les données
-- psql -U cinema -d dbcinemadev -f .\00b-import-tables.sql

-----------------------------------------------------------------------------------

-- creer une utilisateur tiers
drop user cinefan;
create user cinefan with login password 'password';

-- sur la base dbcinema : aucun acces au schema cinema
-- sur la base dbcinemadev : access au schema public, on voit les tables mais aucun droits sur les tables

-- sur la base dbcinema :
GRANT USAGE ON SCHEMA cinema TO cinefan;
GRANT SELECT ON TABLE cinema.movie TO cinefan;

alter user cinefan set search_path = cinema;

-- lecture sur toutes les tables (ordre résumé) / NB : non retroactif
grant select on all tables in schema cinema to cinefan; --  table + view


-- mots clés USER/ROLE interchangeable
create user toto; -- réponse: CREATE ROLE
drop role toto;

create role titi;
drop user titi;

-- 1 "user db" = 1 USER/ROLE WITH LOGIN

-- 1 "role db" = 1 USER/ROLE WITH NOLOGIN
create role role_reader;
grant select on all tables in schema cinema to role_reader;
grant usage on schema cinema to role_reader;


create user titi with login password 'password';
alter user titi set search_path = cinema;
grant role_reader to titi;


-- apres ajout d'une table ou vue:
grant select on all tables in schema cinema to role_reader;


-- role manager
create role role_manager;
grant role_reader to role_manager;
grant insert on cinema.v_movie_current_year to role_manager;
grant all on sequence cinema.movie_id_seq to role_manager;

create user tutu with login password 'password';
alter user tutu set search_path = cinema;
grant role_manager to tutu;


-- role explicite : décidé en debut session
create role role_manager_current_year;
grant select,insert,update,delete on cinema.v_movie_current_year to role_manager_current_year;
grant all on sequence cinema.movie_id_seq to role_manager_current_year;
grant usage on schema cinema to role_manager_current_year;

create role role_manager_80s;
grant select,insert,update,delete on cinema.v_movie_80s to role_manager_80s;
grant all on sequence cinema.movie_id_seq to role_manager_80s;
grant usage on schema cinema to role_manager_80s;

create user toto with
	login
	password 'password'
	noinherit   -- aucune role hérité par défaut
;
alter user toto set search_path = cinema;
grant role_manager_current_year to toto;
grant role_manager_80S to toto;

-- NB: toto doit choisir son role à la connexion avec SET ROLE











































