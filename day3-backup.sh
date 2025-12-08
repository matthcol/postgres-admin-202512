# Export base complete
pg_dump -U postgres -d dbcinema -f dump-dbcinema.sql
pg_dump -U postgres -d dbcinema -C -f dump-dbcinema-create.sql

-- create database dbcinema_test encoding 'UTF-8';

# Import base prod -> base test
psql -U postgres -d dbcinema_test -f dump-dbcinema.sql

# Export User/Role : -r --roles-only
pg_dumpall -U postgres -r -f dump-roles.sql

# Import docker
docker run --name dbcinema -p 5435:5432 -e POSTGRES_PASSWORD=mysecretpassword -v "${PWD}:/backup" -d postgres:18
docker exec -it dbcinema bash
cd /backup
psql -U postgres -d postgres -f dump-roles.sql
psql -U postgres -d postgres -f create-database.sql
psql -U postgres -d dbcinema -f dump-dbcinema.sql 

# BAckup serveur
pg_dumpall -U postgres -f dump-server.sql

# Separer DDL (structures) et Data
pg_dump -U postgres -d dbcinema -s -f dump-dbcinema-ddl.sql
pg_dump -U postgres -d dbcinema -a -f dump-dbcinema-data.sql
pg_dump -U postgres -d dbcinema -a --inserts -f dump-dbcinema-data-insert.sql

# Selection d'objets
- extraire la table movie (ddl + data)
pg_dump -U postgres -d dbcinema -t cinema.movie -f dump-dbcinema-movie.sql

- extraire la table movie (data)
pg_dump -U postgres -d dbcinema -a -t cinema.movie -f dump-dbcinema-movie-data.sql

- extraire toutes les tables du schema cinema sauf la table boxoffice
pg_dump -U postgres -d dbcinema -T cinema.boxoffice -f dump-dbcinema-ss-boxoffice.sql

# Compression : SQL => compression gzip, bzip2, 7z, zip, ...

# Autres formats de dump (non SQL)
# - tar => TODO : compression externe
pg_dump -U postgres -d dbcinema -F t -f dump-dbcinema.tar | gzip
# - custom = archive compressée
pg_dump -U postgres -d dbcinema -F c -f dump-dbcinema.arch
pg_dump -U postgres -d dbcinema -F c -Z 9 -f dump-dbcinema.z9.arch
# - directory => TODO : archiver externe
pg_dump -U postgres -d dbcinema -F d -f dump-dbcinema-directory

# Import avec pg_restore (avec qqs filtres: nom d'objets, sans data)
pg_restore -U postgres -d dbcinema_test dump-dbcinema.arch
pg_restore -U postgres -d dbcinema_test dump-dbcinema-directory

# avec psql
\copy person to 'person.tsv'  -- TSV, UTF-8
\copy person to 'person.csv' DELIMITER E';' CSV HEADER ENCODING 'UTF-8'
\copy (select id, title, year, duration from movie where year between 1980 and 1989 order by year, title) to 'movie80.csv' DELIMITER E';' CSV HEADER ENCODING 'UTF-8'
\copy movie (id, title, year, duration) from 'movie80.csv' WITH (FORMAT csv, DELIMITER E';', HEADER, ENCODING 'UTF-8');
\copy (select id, title, year, duration from movie where year between 1980 and 1989 order by year, title) to 'movie80.1252.csv' DELIMITER E';' CSV HEADER ENCODING 'WIN1252'
\copy (select id, title, year, duration from movie where year between 1980 and 1989 order by year, title) to 'movie80.1252.csv' WITH (DELIMITER E';', FORMAT CSV, HEADER, ENCODING 'WIN1252')

# BAckup complet avec archivage
https://www.postgresql.org/docs/18/continuous-archiving.html
1 - mise en place de l'archivage des WAL : postgresql.conf + restart
NB: pour la copie des WAL, on peut utiliser tt outil de copie : cp, scp, copy, robocopy, rsync

wal_level = replica
archive_mode = on
archive_command = 'test ! -f /backup/wal_archive/%f && cp %p /backup/wal_archive/%f'

2 - backup complet (copie physique)
-- format plain (TODO: à archiver)
pg_basebackup -U postgres -D dbcinema_data

-- avec archive
pg_basebackup -U postgres -Ft -D dbcinema_data_arch

3 - restauration
base arrétée:
3A - editer postgresql.auto.conf

restore_command = 'copy C:\\Backup\\dbcinema_wal\\%f %p'
recovery_target_timeline = 'latest'

NB pour du PITR plus precis:
recovery_target_time = '2024-12-05 14:32:15+01'

3B - creer le fichier signal de recovery
touch ${PGDATA}/recovery.signal

3C - redemarrer la base

3D - nettoyer le postgresql.auto.conf



