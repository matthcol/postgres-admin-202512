# PostgreSQL

## Docker
Cli:
```
docker run --name dbpg -p 5433:5432 -e POSTGRES_PASSWORD=mysecretpassword -d postgres:16-bookworm
docker run --name dbpg18 -p 5434:5432 -e POSTGRES_PASSWORD=mysecretpassword -d postgres:18
```
NB:  ou utiliser docker compose, k8s, ...

## Windows
Service:
"C:\Program Files\PostgreSQL\18\bin\pg_ctl.exe" runservice -N "postgresql-x64-18" -D "C:\Program Files\PostgreSQL\18\data" -w

## CLI psql
```
psql                                                # username = user os + database = username
psql -U postgres                                    # database = username
psql -U postgres -d postgres                        # default port = 5432, 
                                                    # default host = socket UNIX ou localhost
psql -U postgres -d postgres -p 5433 -h localhost
```
Commandes psql:
```
\q    # quit
\d    # liste des tables, vues et sequences
\l    # liste des bases
```

## Creation Base métier
- (optionnel) créer la base métier
- créer le user métier propriétaire de la data
- (optionnel) créer le(s) schema(s) métier

```
psql -U cinema -d dbcinema -f 01-tables.sql            # script 1 par 1
psql -U cinema -d dbcinema -f 00b-import-tables.sql    # macro script
```

## Congiguration

Reload:
- en interne (psql, pgadmin4):
select pg_reload_conf();
- via le service
systemctl reload postgresql.service
- via pg_ctl
${env:PGDATA}='C:\Program Files\PostgreSQL\18\data'
pg_ctl  reload

pg_ctl -D "C:\Program Files\PostgreSQL\18\data" reload

### Réseau
Fichier postgresql.conf
```
listen_addresses = '*'  # default 'localhost'
port = 5432
```

Check:
- Linux
```
netstat -plantu | grep LISTEN
ss - plantu | grep LISTEN
```

- Windows
```
netstat -ano | Select-String -Pattern LISTEN
netstat -abn     # en admin pour voir le nom du processus
```