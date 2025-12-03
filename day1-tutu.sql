-- database dbcinema
-- user tiers tutu avec role role_manager
insert into v_movie_current_year (title, year) values ('Superman', 2025);

insert into v_movie_current_year (title, year) values ('Superman', 1978); -- OK mais pas top

select id, title, year from v_movie_current_year;
select id, title, year from movie where title like 'Superman%';

-- apres redefinition de la vue avec la clause: with check option
insert into v_movie_current_year (title, year) values ('Superman II', 1980); -- KO
-- ERREUR:  la nouvelle ligne viole la contrainte de vérification pour la vue « v_movie_current_year »
-- DETAIL:  La ligne en échec contient (8079254, Superman II, 1980, null, null, null, null, null, null).