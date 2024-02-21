# créer des images

## technique artisanale

1. travailler dans un conteneur en mode intéractif lié à une image de base qu'on veut surcharger
  * `docker run --name draft -it <image_base> /bin/bash`

2. modifier l'état du système de ficher pour installer et/ou configure etc.

3. sortir et utiliser le `docker diff` pour reviser les élements ajoutés

4. refabriquer uneimage à partir de l'état instantané du container
  * `docker commit <container name|ID> <new_image:new_tag>`
  * REM: si le container est live, docker commit arrête d'abord le container

## Dockerfile

### cache de build

* quand on modifie le build, les directives identiques sont cachées en tant que couche
* donc le re-build est plus rapide, mais des couches utlérieures peuvent être invalidées par nos changement,

* on peut builder sans cache build --no-cache
* mais le cache de la directive FROM ne peut être invalidée qu'avec `docker buildx prune -a --filter "until=xxm"` i.e pour invalider les caches récents

### gestion du contexte de build

* historiquement, docker build doit transférer le contexte de build i.e l'ensemble des contenus dans le dossier de build (avec le Dockerfile), à travers la socket unix ou tcp
* sur les version récente le BuildKit ne transfère que les éléments demandés par les directive
* par contre on peut utiliser un fichier .dockerignore qui peut interdire certains éléments pour les directive COPY et / ou ADD
