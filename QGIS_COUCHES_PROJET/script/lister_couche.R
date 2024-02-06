#################### Liste des couches contenues dans les projets QGS

# Récupérer la liste des fichiers QGS décompressés
list_qgs <- list.files(path = "result/",
                       full.names = TRUE,
                       recursive = TRUE) %>%
                       as.data.frame() %>%
            rename.variable(".", "Chemin")

# Boucle de listing des projets couches contenues dans les projets QGS
nb_qgs <- count(list_qgs)
couche_utilisee <- data.frame()

for (i in 1: nb_qgs$n)
{
  # Fichiers QGZ à décompresser
  projet_qgs <- list_qgs$Chemin[i]
  
  # Récupération de la liste des couche utilisées dans le projet QGS
  couche_sig <- read_html(projet_qgs) %>%
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
  file.remove(list_qgs$Chemin[i])
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
            file = paste("result/couche_sig.csv"),
            fileEncoding = "UTF-8",
            sep =";",
            row.names = FALSE)
