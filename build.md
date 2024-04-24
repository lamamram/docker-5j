## mécanisme de build

1. installer un dossier avec un fichier Dockerfile et les artifacts pour le build
2. attention le build se fait du côté serveur
  => au cas où le serveur est à distance avec DOCKER_HOST=192.168.X.Y:2375(6: TLS)
  => au cas où on buil à partir d'un dépôt git
3. a priori le contexte (fichiers environants sont uploadé sur le serveur )
  => attention aux documents lourds et inutiles
  => ajouter un fichier .dockerignore pour discriminer ces fichiers / dosiiers inutiles
4. ajouter l'option --file sur le fichier Dockerfile ne s'appelle pas "Dokerfile"