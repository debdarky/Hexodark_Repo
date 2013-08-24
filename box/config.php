<?php
 
define('LOCAL_LANG', 'fr');                         // Modification de la langue (EN ou FR)
define('TIME_CHECK_UPDATE', 12);                    // Temps entre chaque vérification de mise à jour (0 = force la MàJ; -1 = désactive)
define('EDITMODE_ENABLE', FALSE);                   // Active ou désactive la fonction d'EDITMODE
define('SEEN_MODE_ENABLE', TRUE);                   // Active ou désactive la fonction de marquage des episodes comme vu
define('DISPLAY_HIDDEN_FILESDIRS', FALSE);          // Affiche ou ignore les fichiers cachés
$excludeFiles = array(".", "..", ".htaccess", "");  // Liste des fichiers ignorés dans le listing de Cakebox
define('IGNORE_CHMOD', TRUE);                       // Active ou ignore la vérification des CHMOD sur /data et /downloads
define('SEEN_SPAN', "<span style='color:#76D6B7;'>");// Modifie le style du module vu/non vu
 
/* Options Divx Web Player */
define('USE_DIVX', TRUE);                            // On choisi le lecteur DivX Web Player par défaut
define('DIVX_AUTOPLAY', 'TRUE');                    // Option autoplay (démarrage de la lecture automatique)
define('DIVX_WIDTH', '720');                        // Option de la largeur
define('DIVX_HEIGTH', '440');                       // Option de la hauteur
 
/* Option d'affichage des nouveautés */
define('LAST_ADD', TRUE);                           // Affiche l'icone NEW
define('TIME_LAST_ADD', '24');                       // Temps de la nouveauté (en heure)
 
/* Modification pour mondedie.fr */
$user = $_SERVER['REMOTE_USER'];
$host = $_SERVER['HTTP_HOST'];
$local_dl_path = '../../users/'.$user;              // Modifie le dossier que surveille Cakebox
if (is_dir($local_dl_path)) {
  define('LOCAL_DL_PATH', $local_dl_path);
}
else {
  header("Location: http://$host/");
  exit;
}
 
define('DOWNLOAD_LINK', '');  // Modifie l'URL de stream des fichiers
?>
