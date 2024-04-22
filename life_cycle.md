# images docker

* nomenclature des images
* `docker pull IMAGE_NAME:([TAG_NAME]|[@sha26:HASH])`

# docker run: REMARQUES

* le processus lancé es t indenpendant du PID du process du terminal (shell) qui a mancé le docker run => çà l'effet du namespace PID
* la redirection de sortie du docker run bloque le shell si le processus est un démon

# les namespace Linux

1. les namespaces sont des sgtructures imbriquées avec une hierachie
   => il ya toujours un namespace parent
   => le namespace root est celui du host lui même
2. au moment de la création un namespace, l'état du systême est identique dans les deux namespaces
   => comme avec un fork en progrommation temps réel
   => ensuite l'effet du namespace va s'affecter

3. Exception: il ya deux façon de fabriquer des namespaces
   1. setns() appel system en C qui va permettre de connaître l'état unitial de l'objet isolé 
      => permet de voir par ex : `ps -ef <sur le pid du conteneur depuis la vm>`
   2. `unshare` : commande du noyau qui va départager complètement les états entre le namespace parent est enfant 

* SYNTHESE:
   * un host attaqué par un utilsateur malveillant aura la possibilité d'attaquer plus facilement les conteneur qu'une vm à partir du moment ou l'attaquant peut trouver des élevation de privilèges vers les capacités du noyau
   => namespaces => conteneur => KO.
   * la problématique de la sécurisation est d'ABORD d'endurcir de l'environnement conteneur pour ne pas remonter dans le host 