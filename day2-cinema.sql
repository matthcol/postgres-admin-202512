-- user cinema
-- database dbcinema

select count(*) from play; -- 66547

delete from play
where actor_id % 2 = 1; -- DELETE 32963

select count(*) from play; -- 33584

vacuum play;
vacuum full play;  -- verrou sur la table


-- données

select 0.1::real * 3;  --  0.30000000447034836   car 0.1 (base 10) = 0.0001100110011001100110011001100110011.... (base 2)

select 0.1::numeric * 3; -- 0.3



select
	id,
	title,
	year,
	synopsis
from movie
where
	year = 1984
;


select 
	CURRENT_DATE,
	CURRENT_TIME,  -- 14:42:33.065828+01:00 , type: time with time zone
	CURRENT_TIMESTAMP,  -- 2025-12-04 14:42:33.065828+01 , type : timestamp with time zone
	CURRENT_TIMESTAMP::timestamp -- idem mais type timestamp without time zone
;



select 
	id,
	name,
	birthdate,
	current_date - birthdate as delta_days,
	extract(year from current_date) - extract(year from birthdate) as delta_years,
	date_part('year', current_date) - date_part('year', birthdate) as delta_years2
	-- NB : pas de fonction year, month, day, hour, ...
from person
where name = 'Steve McQueen';

select
	current_timestamp - '7 days 12 hours'::interval,
	current_timestamp - '2025-11-27 02:52:27.066803+01', -- conversion implicite text => timestamptz
	current_timestamp - '2025-11-27 02:52:27.066803+01'::timestamptz
;

select
	current_date::timestamp, -- "2025-12-04 00:00:00"
	current_date::timestamptz, -- "2025-12-04 00:00:00+01" =>  timestamptz = timestamp with time zone
	CURRENT_TIMESTAMP::date -- "2025-12-04"
;

select *
from person
where name like 'Steve%'
;

select *
from movie
where title ilike '%star%'
;

insert into movie (title, year) 
values
	('In the stars', 2042),
	('I''m a star', 2045)
;

select *
from movie
where title ~* '(^stars?( |$)| stars?$)'  -- regexp POSIX
;


select
	id,
	name,
	birthdate,
	-- age de la personne
	age(current_date, birthdate),
	age(birthdate)
from person
where name in (
	'Clint Eastwood',
	'Quentin Tarantino',
	'Jamie Lee Curtis',
	'Steven Spielberg',
	'Leonardo DiCaprio'
);


select *
from person
where id = 130; -- ok : index pk_person

-- index implicite : contrainte unicité (primary key ou unique)

select *
from person
where name = 'Clint Eastwood'; -- plan fait un full scan de la table

-- index explicite
create index idx_person_name on person (name); -- NB : non unique, BTREE

select *
from person
where name = 'Clint Eastwood'; -- plan passe par l'index: idx_person_name


select * from pg_indexes where schemaname = 'cinema';
-- select * from pg_index;

-- selectivité des colonnes
select 
	count(distinct id)::real / count(id) as selectivity_id, -- 1
	count(distinct name)::real / count(name) as selectivity_name -- 0.9926886744949546
from person;

select 
	count(distinct id)::real / count(id) as selectivity_id, -- 1
	count(distinct title)::real / count(title) as selectivity_title, -- 0.9958088851634534
	count(distinct year)::real / count(year) as selectivity_year -- 0.09136630343671416
from movie;

select *
from pg_stats
where tablename in ('person', 'movie')
order by tablename, attname;

-- ndistinct :
--   * - selectivity si selectivity n'est pas trop mauvaise (> 0.1)
--   * + nb de valeurs distinctes (selectivity très mauvaise)

drop index idx_person_birthyear;
create index idx_person_birthyear on person (extract(year from birthdate))
where birthdate is not null;

select *
from person
where birthdate is not null
	and extract(year from birthdate) = 1930; -- 0.122


select *
from 
	movie m
	join person d on m.director_id  = d.id
where 
	d.name = 'Clint Eastwood'
;

create index idx_movie_director on movie (director_id);






