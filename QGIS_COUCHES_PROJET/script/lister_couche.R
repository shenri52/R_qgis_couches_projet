#################### Liste des couches contenues dans les projets QGS

# Boucle de listing des projets couches contenues dans les projets QGS
couche_utilisee <- data.frame()

# Décompression et vérification du contenu
for (i in 1: nrow(list_qgz))
{
  # Fichiers QGZ à décompresser
  zip_fichier <- list_qgz$Chemin[i]
  
  # Création d'une liste des fichiers QGS contenu dans les fichiers QGZ à décompresser
  zip_qgs <- grep('\\.qgs$', unzip(zip_fichier, list=TRUE)$Name, ignore.case=TRUE, value=TRUE)
  
  # Décompression des QGS contenu dans les QGZ
  unzip(zip_fichier, files=zip_qgs, exdir = "result/")
  
  # Récupération de la liste des couche utilisées dans le projet QGS
  couche_sig <- read_html(paste("result/", zip_qgs, sep ="")) %>%
                html_nodes("layer-tree-layer") %>%
                html_attr("source") %>%
                as.data.frame() %>%
                # Suppression des couches dupliquées
                unique(.) %>%
                rename.variable(".", "couche") %>%
                #### A ADAPTER :
                # Conservation des couches stockées sur le serveur SIG
                filter(substr(couche, 1, 1) %in% c("R", "S", "T")) %>%
                ####
                # Suppression des informations de filtres des couches qui se trouve après le caractère |
                mutate(couche = gsub("\\|.*$", "", couche))

  # Assemblage des listes de couches utilisées dans les projets
  
  couche_utilisee <- rbind(couche_utilisee, couche_sig)
  
  # Suppression du fichier QGS traité
  file.remove(paste("result/", zip_qgs, sep =""))
  
}
  
# Regroupement des couches par nom et indication du nombre de fois ou elles apparaissent
couche_utilisee <- couche_utilisee %>%
                   # Normalisation des noms de chemins : remplacement des \ par des /
                   mutate(couche = gsub("\\\\", "/", couche)) %>%
                   # Regroupement et comptage par couche
                   group_by(couche) %>%
                   summarize(Freq = n()) %>%
                   #### A ADAPTER :
                   # Ajout du libellé du compartiment
                   mutate(COMPARTIMENT = case_when(
                                                   substr(couche, 1, 1) == "R" ~ "REFERENTIELS",
                                                   substr(couche, 1, 1) == "S" ~ "PRODUCTION",
                                                   substr(couche, 1, 1) == "T" ~ "CONSULTATION"))
                   ####

#Classement par ordre décroissant d'utilisation
couche_utilisee <- couche_utilisee[order(couche_utilisee$Freq, decreasing = T),]

# Export des données
write.table(couche_utilisee,
            file = "result/couche_sig.csv",
            fileEncoding = "UTF-8",
            sep =";",
            row.names = FALSE)

remove(list_qgs)
