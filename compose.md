## notion de service

* l'objet "service" de docker compose
est la définition d'un ou plusieurs répliques de conteneur

* on parle de service parce qu'à un instant donné, un utilisateur ne sait pas combien de répliques de conteneur
satisfait la demande.

## règles de nommmage de docker compose

* soit on fixe les noms  
  => des services avec les clés **container_name**
  => des réseaux et volume avec les clés **name**

* soit on laisse docker compose de fabriquer les noms
=> des conteneur avec **le nom du dossier - le nom du servive - suffixe incrémenté**

* on va plus fixer les conteneurs avec les clés
* il vaut mieux utliser le "dash" - plutôt "underscore" _
=> - est plus compatible que _ en URL