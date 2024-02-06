###########################################################################
# Ce script permet de lister les couches utilisées dans les projets QGIS  #
# avec l'extension QGZ.                                                   #
###########################################################################
# Fonctionnement :                                                        #
#     1. Modifier le script "liste_couche" dans les parties nommées       #
#     "A ADAPTER" pour le mettre en cohérence avec votre serveur SIG      #
#     2. Lancer le script                                                 #
#     3. Indiquer le dossier contenant les fichiers QGZ                   #
#                                                                         #
# Résultat :                                                              #
#     Le fichier contenant la liste des couches se trouve dans le dossier #
# "result" et se nomme "couche_sig".                                      #
#                                                                         #
# Attention :                                                             #
#     - si une couche est présente plusieurs fois dans le même            #
# projet, elle n'est comptabilisé qu'une fois.                            #
###########################################################################


#################### chargement des librairies

source("./script/librairie.R")

#################### Suppression des fichiers gitkeep

source("script/suppression_gitkeep.R")

#################### Lister les projets GQZ dans une arborescence

source("./script/lister_qgz.R")

#################### Liste des couches contenues dans les projets QGS

source("./script/lister_couche.R")
