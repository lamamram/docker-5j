# Docker Swarm

## lancement des machines

* après le setup,
  - `vagrant destroy -f` pour supprimer toutes les machines
  - `vagrant up` pour:
     + création de trois vms worker1.lan, worker2.lan, formation.lan
     + ajout de la clé privée de Windows à formation.lan
     + installation de docker + docker-machine sur formation.lan
     + ajouts de worker1 et worker2 comme hôtes docker via docker-machine
  
  - utilisation sans swarm:
     + voir les machines `docker-machine ls`
     + eval(`docker-machine env <machine_name>`) => modification de variables d'env
	 + pour rediriger la cli sur le daemon docker d'une machine distante
	 + eval(`docker-machine env --unset`) => revenir sur l'host original

## création du cluster

1. création d'un noeud de type **manager**
  * sur formation.lan: `docker swarm init --advertise-addr [ip de formation.lan]`
  * voir les noeuds du cluster: `docker node ls`

2. ajout d'un noeud de type **worker** au cluster
  * se rendre sur la machine: `sudo docker-machine ssh workeri`
  * exécuter
  ```
   docker swarm join --token SWMTKN-1-[SEPCIFIC_TOKEN] [manager_ip]:2377
  ```

## lancement d'un service sur le cluster

* un service est l'abstraction de l'accès à un conteneur sans savoir sur quelle machine il se trouve
* le conteneur peut mêmeêtre répliqué sur plusieurs noeuds du cluster
* pour 1 **service**, on peut avoir n conteneurs répliqués que l'on nomme **task**

* exemple: 
```
docker service create \
  --name helloswarm \
  --replicas 2 \
  alpine:3.16 \
  ping 8.8.8.8
```

* liste des services du cluster: `docker service ls`
* inspection d'un service: `docker service inspect --pretty [service_name]`
* détail des conteneurs d'un service (task): `docker service ps [service_name]`
* les logs du service: `docker service logs [service_name]`
* suppression du service: `docker service rm [service_name]`
* attention: on ne stoppe ni démarre un sevrvice !!!

## mise à jour d'un service : rolling update

* mise à jour de tous les aspects d'un service
  - image des conteneurs: `--image [new_image]`
  - commande des tâches: `--args "new command"`
  - config réseaux des conteneurs `--network-add, --network-rm ...`
  - volumes
  - ressources dispo ...
  - repliques : `docker service scale`

* montée en versions
  - préalable: établir un timeout entre 2 mises à jours de conteneurs pour un même service
  ```
  docker service create \
  --name helloswarm \
  --replicas 2 \
  --update-delay 10s \
  --
  alpine:3.16 \
  ping 8.8.8.8
  ```

  - mise à jour de l'image : `docker service update --image [new_image] [service]`
  - le service garde l'historique des conteneur de la version précédente en cas de rollback
  - fixer la profondeur de l'historique défaut 5: `docker service update --task-history-limit n`

  * mises à jour secondaires

  - ex: modifier le délais entre 2 phases d'une update
  - ex: modifier le nb de tâches mises à jour par phase
  `docker service update --update-delay --update-parallelism [service_name]`

## configuration réseau mesh

* l'option `--publish published=8080,target=80` pilote l'utilisation du réseau 'mesh' ou réseau maillé de docker swarm par défaut
* quelque soit le noeud public sur lequel on demande le port publié, on aura accès au service
* cette disponibilité est assurée par des agents d'équilibrage de charge "load balancer" installé sur tous les noeuds

## relier les conteneur à travers les noeuds (overlay network)

* création sur le manager d'un réseau de type overlay qui couvre tous les noeuds
  - `docker network create --driver overlay app_net`

* ajout d'un service au réseau
  - `docker service update --network-add app_net nginx`

* tester le service java_app sur un réseau overlay
  - pb: l'image custom java_tomcat:1.0 n'existe a priori que sur le manager
  - les images doivent être téléchargeables depuis tous les noeuds ==> installer un service registry !!
  - WorkAround: utiliser les dossiers partagés /vagrant des VM vagrant
    + `docker save -o [/path/to/java_tomcat.tar] java_tomcat:1.0`: svg au format tar
    + `sudo docker load -i java_tomcat.tar` : charger sur worker1 et 2 à partir du tar dans /vagrant
  
  - création des deux services httpd et tomcat sur le réseau app_net
    + reconnaissance des **noms de services comme alias réseaux**
  ```
  docker service create \
    --name tomcat \
    --replicas 2 \
    --network app_net \
    java_tomcat:1.0
  
  docker service create \
    --name httpd \
    --replicas 2 \
    --network app_net \
    --publish published=8081,target=80 \
    java_httpd:1.0
  ```

  ## déploiement sur le cluster via docker compose

  * modification du docker-compose.yml
    - voir swarm_stack_java/docker-compose.yml
  
  * déploiement de la stack
  ```
  docker stack deploy \
    --compose-file swarm_stack_java/docker-compose.yml \
    java_stack
  ```

  * analyse de la stack
    - `docker stack ls`
    - `docker stack ps [stack_name]`
  
  * relancer un conf
    - `docker stack rm [stack_name] && docker deploy ...`