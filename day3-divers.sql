-- user : cinema
-- database : dbcinema

analyze movie;

-- user DBA

analyze;

-- dans postgresql.conf
-- autovacuum_analyze_threshold = 50	# min number of row updates before  analyze
-- autovacuum_analyze_scale_factor = 0.1	# taille echantillon

-- user cinema
-- statistiques customisée pour 1 table (autovacuum_analyze_threshold, autovacuum_analyze_scale_factor) 
ALTER TABLE movie SET (autovacuum_analyze_scale_factor = 0.75);
analyze movie;


-- user DBA
drop database dbcinema_test;
create database dbcinema_test encoding 'UTF-8';

-- exemple de remap
-- user postgres
-- database dbcinema_test
alter schema cinema rename to cinematest;
alter table cinematest.boxoffice rename to bo;


-- tablespace: par defaut = pg_default (oid=0)
select * from pg_class; -- reltablespace
-- clause tablespace dans le DDL des table/index
-- dosier pgdata\pg_tblspc qui va contenier des liens symboliques


-- gros volume d'ecriture (user cinema, db dbcinema)

DO $$
BEGIN
	FOR i IN 11 .. 100000 LOOP
		INSERT INTO movie (title, year) values ('Qu''est ce qu''on a fait au bon dieu ' || i, 2050);
	END LOOP;
END $$;

select count(*) from movie where title like 'Qu''est ce qu''on a fait au bon dieu %';

DO $$
BEGIN
	FOR i IN 1 .. 100000 LOOP
		INSERT INTO movie (title, year) values ('Fast and Furious ' || i, 2050);
	END LOOP;
END $$;

select count(*) from movie where title like 'Fast %';


DO $$
BEGIN
	FOR i IN 1 .. 100000 LOOP
		INSERT INTO movie (title, year) values ('Moi moche et mechant ' || i, 2050);
	END LOOP;
END $$;

select count(*) from movie where title like 'Moi moche et mechant %';




