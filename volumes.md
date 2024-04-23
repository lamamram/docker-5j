## docker cp vs volume - bind mounts

* les deux technos permettent d'injecter des éléments dans un conteneur

1. injecte les fichiers avec `docker cp path ctn:path`
   => le fichier copié est un autre **inode**

2. ou monte le fichier dans un emplacement du conteneur
   => le fichier monté est le même **inode**
   => il faut sécuriser ces points de montage pour éviter d'éditer
   => un fichier qui est dispo également dans le host 
   => FAILLE par INJECTIONS de scripts !!!

## volume bind vs volume nommé

1. volume bind: point de montage sur un ou plusieurs conteneurs, depuis la vm
   * rendre le montage read-only avec :ro

2. volume nommé: allocation d'un emplacement
   * par défaut dans l'emplacement de /var/lib/docker/volumes
   * pour faire sortir les données dans le host pour persister les donées

3. il est possible qu'un mount bind modifie les données travers un script (par ex. entrypoint)
   => mais que le volume nommé écrase ces modifications