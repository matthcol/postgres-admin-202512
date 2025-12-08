Exemple de conf : petit serveur

shared_buffers = 1GB            # partagée par toutes le connexions (cache table et index)
work_mem = 16MB                 # pour 1 requete (1 connexion), 1 operation: tri, group by
maintenance_work_mem = 256MB    # taches de maintenance
wal_buffers = 16MB              # taille buffer 1 wal

effective_cache_size = 3GB      # estimation taille max allouée (influe le planificateur)