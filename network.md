# Réseaux Docker

## réseau bridge par défaut "docker0"

* gamme d'ip internes à la vm: 172.17.0.0/16

* l'hôte (ici la vm) est la passerelle de ce sous réseau en 172.17.0.1

### forwarder un port de l'hôte sur un port du conteneur:

1. -p ou --publish port_externe:port_interne (associer un port externe avec un port interne)
  * $ `docker run --name nginx -d --restart unless-stopped -p 8080:80 nginx:1.25.4`
2. -p port_min-port_max:port_interne (choisir un port externe entre min et max)
  * $ `docker run --name nginx_range -d --restart unless-stopped -p 8080-8089:80 nginx:1.25.4`
3. -p IP:PORT|PORT_MIN-PORT_MAX:port_interne : idem avec restrictionsur l'interface
  * $ `docker run --name nginx_local -d --restart unless-stopped -p localhost:8082:80 nginx:1.25.4`
4. -P ou --publish-all: port random >= 32768
  * $ `docker run --name nginx_rand -d --restart unless-stopped -P nginx:1.25.4`

### manip 1: communication inter conteneurs via les ips

* création d'un conteneur php-fpm:8.2-debian-11 de nom php_fpm

1. trouver l'ip du conteneur php pour éditer le nginx.conf (fastcgi_pass et server_name =>ip de l'hôte)
  * `docker inspect php_fpm -f "ip: {{.NetworkSettings.IPAddress}}"`
2. copier nginx_conf/nginx.conf dans le conteneur nginx => /etc/nginx/conf.f/nginx.conf
  * `docker cp /vagrant/php8.2.conf nginx:/etc/nginx/conf.d/php8.2.conf`
3. copier index_php/index.php dans le conteneur php-fpm => /srv/index.php
  > rappel: le contenu du dossier contenant le Vagrantfile est dispo dans la vm sous /vagrant
  * `docker cp /vagrant/index.php php8:/srv/index.php`

### utiliser des alias réseaux avec --link (uniquement avec le bridge par défaut)

> permet de statibiliser la communication sans connaître les IPs

1. création conteneur php_fpm et copie du index.php
2. création d'un alias réseau "app_php" (hostname) pour le conteneur php_fpm dans le conteneur nginx
  * `docker run --name nginx -d --restart unless-stopped -p 8080:80 --link app_php[:alias] nginx:1.25.4`
3. on remplace l'ip du conteneur par app_php dans la conf nginx et on copie
4. après copie exécuter chown root:root sur la copie qui appartient à l'uid 1000 (vagrant)
  * `docker exec nginx chown root:root /etc/nginx/conf.d/nginx.conf`
5. redémarrer le conteneur nginx
  * `docker restart nginx`

## création d'un réseau custom

### les commandes docker network

* voir les réseaux
  - `docker network ls` 

* créer un réseau custom: choix du driver, subnet et gateway au min (valeurs par défauts ci dessous)
  - `docker network create --driver=bridge --subnet=172.18.0.0/16 --gateway=172.18.0.1 stack_php`

* connecter un conteneur à un réseau
  - `docker network connect stack_php nginx`

* idem à la création du conteneur (option --net)
  - `docker run --name app_nginx -d --restart unless-stopped -p 8080:80 --net=stack_php nginx:1.25.4`
  > sur un réseau bridge custom, le nom du conteneur est directement un alias réseau !!!

