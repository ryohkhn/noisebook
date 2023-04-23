## TODO


* [ ]  Mettre des attributs à Organisateur

* [X]  Faire une table pour chaque identification de tag avec un genre/lieu/concert ...

* [X]  Faire une table avis et une relation faible avec les tags

* [X] Ajouter un timestamp aux posts plutôt qu'un id SERIAL

* [ ] "Les utilisateurs qui sont des personnes pourront indiquer être intéressés ou participer à un évènement (mais pas les deux à la fois)"

* [ ] "Pour les concerts ayant déjà eu lieu, il sera possible d’archiver un ensemble de données telles que nombre de participants, avis des participants concernant telle performance de tel groupe lors du concert, photos, vidéos, etc."

Schéma : 


* [X]  Enlever le id_playlist dans la relation morceau/playlist

* [X]  Mettre tous les attributs de utilisateur/concert dans la table concert

* [X]  Hierarchie concerts en cours/à venir/terminés avec des attributs différents

* [ ]  Ne pas laisser des tables vides sans attributs

Contraintes externes:


* [ ]  Associations reflectives et pas l'autre pour les amis
