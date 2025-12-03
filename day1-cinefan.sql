-- apres avoir les droits:
--   - usage sur le schema cinema
--   - select sur la table cinema.movie
select id, title, year from cinema.movie where year = 2025;
select id, title, year from movie where year = 2025; -- ERREUR:  la relation « movie » n'existe pas

show search_path; -- "$user", public => cinefan, public

set search_path = cinema; -- session courante uniquement
show search_path;
select id, title, year from movie where year = 2025; -- OK

alter user cinefan set search_path = cinema; -- ou en DBA


-- apres le grant select on all tables
select * from person limit 10;