create function title_year (title varchar, year int) returns varchar
as
$$
begin
	return upper(title) || ' (' || year || ')';
end;
$$ language plpgsql
;


create or replace function exists_person(p_name varchar, p_id int default NULL, p_birthdate date default NULL)
returns boolean
as
$$
declare
	v_person_count int;
begin
	select count(*) into v_person_count from person p
	where p.name = p_name;
	raise notice 'number of persons found: %', v_person_count;
	return v_person_count > 0;
end;
$$ language plpgsql;

select exists_person('Steve McQueen');