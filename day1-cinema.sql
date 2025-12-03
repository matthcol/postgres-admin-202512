-- database dbcinema
-- user métier cinema (propriétaire des tables)

select * from movie where year = 2025;

insert into movie (title, year) values ('Zootopia 2', 2025); -- id : 8079249

select * from movie where year = 2025;

insert into movie (title, year) values ('Sinners', 2025) returning id;  -- id: 8079250

select currval('movie_id_seq'); -- current value, current session
select nextval('movie_id_seq'); -- next value (unique pour toutes les sessions) : 8079251

-- en // une autre session, fait x fois nextval : 8079252 à 8079262

select currval('movie_id_seq'); -- 8079251
select nextval('movie_id_seq'); -- 8079263
select currval('movie_id_seq'); -- 8079263

select setval('movie_id_seq', 1);
select nextval('movie_id_seq');
select setval('movie_id_seq', max(id)) from movie;




-- clé primaires automatiques
-- sol 1: serial
--    serial <-> integer + sequence + default
--    smallserial <-> smallint + sequence + default
--    bigserial <-> bigint + sequence + default

create table boxoffice(
	id serial constraint pk_boxoffice primary key, -- => sequence : boxoffice_id_seq
	movie_id integer,
	income bigint
);
drop table boxoffice;

-- sol 2 : clause standard SQL identity
-- https://www.postgresql.org/docs/current/ddl-identity-columns.html
create table boxoffice(
	id integer 
		GENERATED ALWAYS AS IDENTITY   -- => sequence : boxoffice_id_seq
		constraint pk_boxoffice primary key, 
	movie_id integer,
	income bigint
);

insert into boxoffice (movie_id, income) values (8079249, 10000000);
insert into boxoffice (movie_id, income) values (8079250,  5000000);


select * from boxoffice;


-- gestion des schemas

show search_path; -- "$user", public => cinema, public	

-- base dbcinema
select * from movie where year = 2025;
select * from cinema.movie where year = 2025;

-- base dbcinemadev
select * from movie where year = 2025;
select * from public.movie where year = 2025;

-------------------------------------------------------------------------------------------------

-- base dbcinema
-- creation d'une vue (ok pour lecture)

create or replace view v_movie_current_year as
select * from movie m where m.year = extract(year from current_date);

select 
	current_date,
	extract(year from current_date),
	date_part('year', CURRENT_DATE)
	;

-- NB : vue trop souple pour des modifications
-- => protéger avec with check option 

create or replace view v_movie_current_year as
select * from movie m where m.year = extract(year from current_date)
with check option; -- verification supplementaire pour insert et update

-- 2e vue pour les années 80s

create or replace view v_movie_80s as
select * from movie m where m.year = 1980
with check option;

-- cf scenario DBA pour les privileges et les sessions cinefan, toto, titi, tutu pour les utilisations





































