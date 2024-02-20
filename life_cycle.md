# Cycle de vie des images / conteneurs

## Montrer docker Hub
* $ docker search ( --filter : peu performant, pas de tags, --format => formatter l'affichage via un Go Template "{{ .Name }}")
* $ docker pull [IMAGE:TAG]
* $ docker pull debian:12
* $ designation la plus fine de l'image, en rapport à d'autres contextes
  comme l'architecture CPU (AMD64,ARM, PPC ...)
  image:tag@sha256:[SHA256]

## manipulation d'images
* `$ docker images`
* `ou $ docker image list | grep -E deb.*` (préférer aux filtres)
* `$ docker image rm`
* `$ docker run debian:12` (rien ne se passe et le conteneur s'arrête!)
* `$ docker run debian:12 /bin/echo 'Hello world'`

> docker run = docker create + docker start
> `docker create --name deb debian:12 /bin/echo 'Hello world'`

* `docker start deb`
* `docker stop deb`

* `docker rm [-f]`: supprimé si arrêté ou avec -f ( --force) 
## surveiller les conteneurs

* `$ docker ps` : conteneurs en cours d’exécution
* `$ docker ps -a`:  tous conteneurs
* `$ docker ps -q`: afficher uniquement les identifiants
* `$ docker ps -f "name=..."`: afficher en filtrant par ex. sur le nom

## lancer un process bloquant en arrière plan (le docker run ne dépend plus du shell courant)
* `docker run --name deb12 -d debian:12 sleep infinity`