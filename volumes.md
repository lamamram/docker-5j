# persistence des données

* 3 types de "volumes"
  1. bind mounts => pour injecter et persister des confs dans un conteneur
  2. named volumes => pour extraire ( et persister) les données d'un conteneur
  3. tmpfs mounts => pour accéder à des données sensibles en RAM le temps de l'exécution du conteneur

* par défaut, les volumes sont des dossiers stockés dans l'instance du docker local ou sur l'hôte

## bind mounts

1. -v src_directory:dest_directory
  * :ro ou :readonly => une fois injecté, pas de MAJ dans le container si changement dans le host
  * `docker run --name nginx -d -p 8080:80 -v /vagrant/php8.2.conf:/etc/nginx/conf.d/php8.2.conf:ro nginx:1.25.4`

2. --mount type=bind,src=/vagrant/php8.2.conf,dst=/etc/nginx/conf.d/php8.2.conf,readonly
  * intérêt de --mount: utiliser le paramètre volume-opts (customiser le type de stockage)
  *  --mount key=value,...,
            volume-opt driver=local,
            volume-opt type=nfs
            volume-opt device=192.168.x.y:/storage

> remplace avantageusement le docker cp !!!

### volumes nommés

> étiquette qui désigne un dossier dans /var/lib/docker/volumes géré par docker

1. création rapide
  * -v name:/path/to/dir:ro
2. création à configurer
  * docker volume create [name] --opt=... --opt=... --driver=...
    + -v name:/path/to/dir
3. --mount type=volume,src=[name],...
4. volume anonyme
  * -v /var/lib/mysql
  > à utiliser avec l'option --volumes-from qui attache auto. les volumes d'un autre conteneur
