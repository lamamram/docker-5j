## namespace NET

* à l'installation de doccker

un namespace net lié à une pile réseau virtuelle est créé
   => l'interface **docker0** de nom réseau 172.17.0.0/16
   => de passerelle 172.17.0.1
   => le câble virtuel **veth** entre les "machine" (vm et conteneurs)

* par défaut, un conteneur créé avec `docker run` utilise ce namespace
  => reçoit une addresse ip sur docker0

## publication et exposition de ports

* par construction, une image selectionne les ports utilisés par le service installé dedans 
=> EXPOSITION
=> on la voit a priori dans le docker run
=> ne sert qu'à l'option **-P | --publish-all** du docker run
=> pour publier les ports exposés sur des ports du host > 32768s


## communication entre conteneur

1. utilisation de fichiers de connexions
   * injecte les fichiers avec `docker cp path ctn:path`
   => le fichier copié est un autre **inode**
