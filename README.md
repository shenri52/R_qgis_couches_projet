# Script R : qgis_couches_projet

Ce script permet de lister les couches utilisées dans les projets QGIS avec l'extension QGZ.

## Descriptif du contenu

* Racine : emplacement du projet R --> "QGIS_COUCHES_PROJET.Rproj"
* Un dossier "result" pour le stockage du résultat
* Un dosssier script qui contient :
  * prog_couche_projet_qgis.R --> script principal
  * librairie.R --> script contenant les librairies utiles au programme
  * lister_qgz --> script listant les fichiers QGZ dans l'arborescence choisie
  * lister_couche.R --> script listant les couches présentent dans les projets QGZ
  * suppression_gitkeep.R --> script de suppression des .gitkeep

## Fonctionnement

1. Modifier le script "lister_couche" dans les parties nommées "A ADAPTER" pour le mettre en cohérence avec votre serveur SIG
2. Lancer le script intitulé "prog_couche_projet_qgis" qui se trouve dans le dossier "script"
3. Indiquer le dossier contenant les fichiers QGZ

## Résultat

Le fichier contenant la liste des couches se trouve dans le dossier "result" et se nomme "couche_sig".

#### Attention :
Si une couche est présente plusieurs fois dans le même projet, elle n'est comptabilisé qu'une fois.
