$env:PGPASSWORD='password'
psql -U postgres -d postgres -f 00-create-db-user.sql
psql -U movie -d dbmovie -f 00b-import-tables.sql