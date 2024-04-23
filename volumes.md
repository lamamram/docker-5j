## docker cp vs volume - bind mounts

* les deux technos permettent d'injecter des éléments dans un conteneur

1. injecte les fichiers avec `docker cp path ctn:path`
   => le fichier copié est un autre **inode**

2. ou monte le fichier dans un emplacement du conteneur
   => le fichier monté est le même **inode**
   => il faut sécuriser ces points de montage pour éviter d'éditer
   => un fichier qui est dispo également dans le host 
   => FAILLE par INJECTIONS de scripts !!!