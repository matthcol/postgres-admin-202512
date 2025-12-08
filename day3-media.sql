-- postgres :
analyze;



select 'person' as "table",  count(*) as nb_row  from person
UNION
select 'media' as "table",  count(*) as nb_row  from media
UNION
select 'profession' as "table",  count(*) as nb_row  from profession
UNION
select 'have_profession' as "table",  count(*) as nb_row  from have_profession
UNION
select 'known_for' as "table",  count(*) as nb_row  from known_for
UNION
select 'direct' as "table",  count(*) as nb_row  from direct
UNION
select 'have_genre' as "table",  count(*) as nb_row  from have_genre
UNION
select 'play' as "table",  count(*) as nb_row  from play
UNION
select 'have_episode' as "table",  count(*) as nb_row  from have_episode
UNION
select 'aka' as "table",  count(*) as nb_row  from aka;
;


-- avec la recherche full texte, on pourra mettre en place un index de qualité
-- FTS = Full Text Search
-- https://www.postgresql.org/docs/current/textsearch.html

select 
	id,
	title,  -- Star Wars: The Last Jedi Opening Event
	release_year,
	to_tsvector('english', title)  -- 'event':7 'jedi':5 'last':4 'open':6 'star':1 'war':2
from media
where id = 8312260;


select * 
from media
where to_tsvector('english', title) @@ plainto_tsquery('english', 'star'); -- 13 s

-- avec l'index => très rapide
drop index idx_media_title;
create index idx_media_title on media using gin(to_tsvector('english', title)); -- ~1mn

select * 
from media
where to_tsvector('english', title) @@ plainto_tsquery('english', 'star'); -- 0.3 s

create index idx_person_name on person(name);
create index idx_play_media on play(media_id);
create index idx_play_actor on play(actor_id);
create index idx_play_character on play(character);
create index idx_aka_media on aka(media_id);
create index idx_aka_title_fr on aka using gin(to_tsvector('french', title))
    where language = 'fr';
create index idx_aka_title_es on aka using gin(to_tsvector('spanish', title))
    where language = 'es';
create index idx_episode_series on have_episode(series_id, season_number, episode_number);

SELECT * 
FROM media 
WHERE 
	to_tsvector('english', title) @@ to_tsquery('english', 'desperate & (housewife | housewive)')
	and media_type = 'tvSeries';

SELECT 
	ms.title,
	he.season_number, 
	he.episode_number,
	me.title
FROM media ms
	join have_episode he on ms.id = he.series_id
	join media me on he.episode_id = me.id 
WHERE 
	to_tsvector('english', ms.title) @@ to_tsquery('english', 'desperate & (housewife | housewive)')
	and ms.media_type = 'tvSeries'
order by ms.id, he.season_number, he.episode_number;

select
	title,
	language,
	region,
	to_tsvector('french', title)
from aka
where 
	to_tsvector('french', title) @@ to_tsquery('french', 'bon & dieu & fait')
	and language = 'fr'
;










