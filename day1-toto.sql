-- user toto
set role = role_manager_current_year;
select id, title, year from v_movie_current_year; -- ok
select id, title, year from v_movie_80s; -- ko

set role = role_manager_80s;
select id, title, year from v_movie_current_year; -- ko
select id, title, year from v_movie_80s; -- ok

select current_role, session_user; --  role_manager_80s | toto