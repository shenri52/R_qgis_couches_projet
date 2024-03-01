#################### Lister les projets GQZ dans une arborescence

# Afficher une boîte de dialogue pour indiquer le lecteur à analyser

lecteur <- NULL

while (is_empty(lecteur))
{
  lecteur <- dlg_dir(default = getwd(), title = "Choisir le dossier à analyser")$res
}

# Récupérer la liste des fichiers
list_qgz <- list.files(path = lecteur,
                       pattern = ".qgz",
                       full.names = TRUE,
                       recursive = TRUE) %>%
                       # Récupérer la taille et la date de modification
                       file.info() %>%
                       select(mtime) %>%
                       # Filtrer les données sur l'année N et N-1
                       filter(year(mtime) == year(Sys.Date()) | year(mtime) == year(Sys.Date())-1) %>%
                       select(-mtime)

# Création d'une colonne avec le chemin d'accès au fichier
list_qgz <- list_qgz %>%
            mutate(Chemin = row.names(list_qgz))

# Suppression des noms de ligne
row.names(list_qgz) <- NULL