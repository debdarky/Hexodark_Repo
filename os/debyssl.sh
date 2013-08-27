#!/bin/bash

  clear
 
    if [ $(id -u) -ne 0 ]
    then
       echo
       echo "This script must be run as root." 1>&2
       echo
       exit 1
    fi
 
    # demander nom et mot de passe
    read -p "Adding user now, please type your user name: " user
    read -s -p "Enter password: " pwd
    echo
 
    # ajout utilisateur
    useradd -m  -s /bin/bash "$user"
 
    # creation du mot de passe pour cet utilisateur
    echo "${user}:${pwd}" | chpasswd

 # gestionnaire de paquet
if [ "`dpkg --status aptitude | grep Status:`" == "Status: install ok installed" ]
then
        packetg="aptitude"
else
        packetg="apt-get"
fi

ip=$(ip addr | grep eth0 | grep inet | awk '{print $2}' | cut -d/ -f1)

if [ -z $homedir ]
then
        homedir="/home"
fi


if [ -z $wwwdir ]
then
        wwwdir="/var/www"
fi

if [ -z $apachedir ]
then
        apachedir="/etc/apache2"
fi

if [ -z $initd ]
then
        initd="/etc/init.d"
fi

##Log de l'instalation
exec 2>/$homedir/$user/log

# Ajoute des depots non-free
echo "deb http://ftp.fr.debian.org/debian/ wheezy main contrib non-free
deb-src http://ftp.fr.debian.org/debian/ wheezy main contrib non-free" >> /etc/apt/sources.list

# Installation des paquets vitaux
$packetg update
$packetg install -y  apache2 apache2-utils autoconf build-essential ca-certificates comerr-dev libapache2-mod-php5 libcloog-ppl-dev libcppunit-dev libcurl3 libcurl4-openssl-dev libncurses5-dev ncurses-base ncurses-term libterm-readline-gnu-perl libsigc++-2.0-dev libssl-dev libtool libxml2-dev ntp openssl patch libperl-dev php5 php5-cli php5-dev php5-fpm php5-curl php5-geoip php5-mcrypt php5-xmlrpc pkg-config python-scgi dtach ssl-cert subversion unrar zlib1g-dev pkg-config unzip htop irssi curl cfv rar zip ffmpeg mediainfo git screen perl libapache2-mod-scgi

##  Installation XMLRPC Libtorrent Rtorrent Plowshare
 
    # XMLRPC
 
    svn checkout http://svn.code.sf.net/p/xmlrpc-c/code/stable xmlrpc-c
    cd xmlrpc-c
    ./configure --prefix=/usr --enable-libxml2-backend --disable-libwww-client --disable-wininet-client --disable-abyss-server --disable-cgi-server
    make
    make install
    cd ..
    rm -rv xmlrpc-c
 
    # Libtorrent
 
    wget http://libtorrent.rakshasa.no/downloads/libtorrent-0.13.2.tar.gz
    tar -zxvf libtorrent-0.13.2.tar.gz
    cd libtorrent-0.13.2
    ./autogen.sh
    ./configure
    make
    make install
    cd ..
    rm -rv libtorrent-0.13.2*
 
    # Rtorrent
 
    wget http://libtorrent.rakshasa.no/downloads/rtorrent-0.9.2.tar.gz
    tar -zxvf rtorrent-0.9.2.tar.gz
    cd rtorrent-0.9.2
    ./autogen.sh
    ./configure --with-xmlrpc-c
    make
    make install
    ldconfig
    cd  ..
    rm -rv rtorrent-0.9.2*
 
# Plowshare
cd    /$homedir
    git clone https://code.google.com/p/plowshare/ plowshare4
    cd plowshare4
    make install

#------------Instalation de Rutorrent--------
#--------------------------------------------

cd $wwwdir/
svn checkout http://rutorrent.googlecode.com/svn/trunk/rutorrent
svn checkout http://rutorrent.googlecode.com/svn/trunk/plugins

rm -r rutorrent/plugins
mv plugins rutorrent/

cd $wwwdir/rutorrent/conf
rm -r -f Config.php plugins.ini


#-----Fichier Configuration Config.php--------
#---------------------------------------------
echo "
<?php
        // configuration parameters

        // for snoopy client
        @define('HTTP_USER_AGENT', 'Mozilla/5.0 (Windows; U; Windows NT 5.1; pl; rv:1.9) Gecko/2008052906 Firefox/3.0', true);
        @define('HTTP_TIME_OUT', 30, true);     // in seconds
        @define('HTTP_USE_GZIP', true, true);
        $httpIP = null;                         // IP string. Or null for any.

        @define('RPC_TIME_OUT', 5, true);       // in seconds

        @define('LOG_RPC_CALLS', false, true);
        @define('LOG_RPC_FAULTS', true, true);

        // for php
        @define('PHP_USE_GZIP', false, true);
        @define('PHP_GZIP_LEVEL', 2, true);

        $do_diagnostic = true;
        $log_file = '/tmp/rutorrent_errors.log';                // path to log file (comment or leave blank to disable logging)

        $saveUploadedTorrents = true;           // Save uploaded torrents to profile/torrents directory or not
        $overwriteUploadedTorrents = false;     // Overwrite existing uploaded torrents in profile/torrents directory or make unique name

        $topDirectory = '/home/$user/downloads';                    // Upper available directory. Absolute path with trail slash.
        $forbidUserSettings = false;

        $scgi_port = 5000;
        $scgi_host = "127.0.0.1";

        // For web->rtorrent link through unix domain socket
        // (scgi_local in rtorrent conf file), change variables
        // above to something like this:
        //
    //$scgi_port = 0;
        //$scgi_host = "unix:///tmp/rtorrent.sock";

        $XMLRPCMountPoint = "/RPC2";            // DO NOT DELETE THIS LINE!!! DO NOT COMMENT THIS LINE!!!

        $pathToExternals = array(
                "php"  => '/usr/bin/php',                       // Something like /usr/bin/php. If empty, will be found in PATH.
                "curl" => '/usr/bin/curl',                      // Something like /usr/bin/curl. If empty, will be found in PATH.
                "gzip" => '/bin/gzip',                  // Something like /usr/bin/gzip. If empty, will be found in PATH.
                "id"   => '/usr/bin/id',                        // Something like /usr/bin/id. If empty, will be found in PATH.
                "stat" => '/usr/bin/stat',                      // Something like /usr/bin/stat. If empty, will be found in PATH.
        );

        $localhosts = array(                    // list of local interfaces
                "127.0.0.1",
                "localhost",
        );

        $profilePath = '../share';              // Path to user profiles
        $profileMask = 0777;                    // Mask for files and directory creation in user profiles.
                                                // Both Webserver and rtorrent users must have read-write access to it.
                                                // For example, if Webserver and rtorrent users are in the same group then the value may be 0770.

?>
" >> $wwwdir/rutorrent/conf/config.php
 
#----Fin du fichier configuration------------- 
#---------------------------------------------

#-----Fichier Configuration plugins.ini-------
#---------------------------------------------
echo "

;; Plugins' permissions.
;; If flag is not found in plugin section, corresponding flag from "default" section is used.
;; If flag is not found in "default" section, it is assumed to be "yes".
;;
;; For setting individual plugin permissions you must write something like that:
;;
;; [ratio]
;; enabled = yes			;; also may be "user-defined", in this case user can control plugin's state from UI
;; canChangeToolbar = yes
;; canChangeMenu = yes
;; canChangeOptions = no
;; canChangeTabs = yes
;; canChangeColumns = yes
;; canChangeStatusBar = yes
;; canChangeCategory = yes
;; canBeShutdowned = yes

[default]
enabled = user-defined
canChangeToolbar = yes
canChangeMenu = yes
canChangeOptions = yes
canChangeTabs = yes
canChangeColumns = yes
canChangeStatusBar = yes
canChangeCategory = yes
canBeShutdowned = yes

;; Default

[_getdir]
enabled = yes
[cpuload]
enabled = user-defined
[create]
enabled = user-defined
[datadir]
enabled = yes
[diskspace]
enabled = user-defined
[erasedata]
enabled = user-defined
[show_peers_like_wtorrent]
enabled = user-defined
[theme]
enabled = yes
[tracklabels]
enabled = user-defined
[trafic]
enabled = user-defined

;; Enabled

[autotools]
enabled = user-defined
[cookies]
enabled = user-defined
[data]
enabled = user-defined
[edit]
enabled = user-defined
[extratio]
enabled = user-defined
[extsearch]
enabled = user-defined
[filedrop]
enabled = user-defined
[filemanager]
enabled = user-defined
[geoip]
enabled = user-defined
[httprpc]
enabled = yes
canBeShutdowned = no
[pausewebui]
enabled = yes
[ratio]
enabled = user-defined
[ratiocolor]
enabled = user-defined
[rss]
enabled = user-defined
[_task]
enabled = yes
[throttle]
enabled = user-defined
[titlebar]
enabled = user-defined
[unpack]
enabled = user-defined

;; Disabled

[chat]
enabled = no
[chunks]
enabled = no
[feeds]
enabled = no
[fileshare]
enabled = no
[fileupload]
enabled = yes
[history]
enabled = no
[instantsearch]
enabled = no
[ipad]
enabled = no
[logoff]
enabled = no
[loginmgr]
enabled = no
[mediainfo]
enabled = yes
[mediastream]
enabled = yes
[check_port]
enabled = no
[retrackers]
enabled = no
[rpc]
enabled = no
[rssurlrewrite]
enabled = no
[rutracker_check]
enabled = no
[scheduler]
enabled = no
[screenshots]
enabled = no
[seedingtime]
enabled = no
[source]
enabled = no

" >> $wwwdir/rutorrent/conf/plugins.ini
#----Fin du fichier configuration-------------
#---------------------------------------------

#-----Fichier Configuration .rtorrent.rc------
#---------------------------------------------
echo "
# Fichier de configuration de rtorrent.
 
download_rate = 0
upload_rate = 0
 
directory = /home/$user/downloads/complete
session = /home/$user/downloads/.session
schedule = watch_directory,5,5,load_start=/home/$user/downloads/watch/*.torrent
schedule = untied_directory,5,5,stop_untied=

port_range = 55995-56000
port_random = no
 
# check_hack sur 'yes' peut faire ramer le serveur
check_hash = yes

dht = disable
peer_exchange = no
 
#encryption = allow_incoming,require,require_rc4
encryption = allow_incoming,enable_retry,prefer_plaintext
 
# Ca, c'est nécessaire pour que rutorrent fonctionne
scgi_port = localhost:5000
" >> $homedir/$user/.rtorrent.rc

#----Fin du fichier configuration-------------
#---------------------------------------------

#---Creation du mot de passe de l'interface Rutorrent---
#-------------------------------------------------------
a2enmod auth_digest
echo "${user}:rutorrent:"$(printf "${user}:rutorrent:${pwd}" | md5sum | awk '{print $1}') > $apachedir/htpasswd


#----Debut de Creation des dossier------------
#---------------------------------------------
if [ ! -d $homedir/$user/downloads ]; then
mkdir $homedir/$user/downloads
chown $user.$user $homedir/$user/downloads
 
else
chown $user.$user $homedir/$user/downloads
fi


if [ ! -d $homedir/$user/downloads/complete ]; then
mkdir $homedir/$user/downloads/complete
chown $user.$user $homedir/$user/downloads/complete

else
chown $user.$user $homedir/$user/downloads/complete
fi

if [ ! -d $homedir/$user/downloads/watch ]; then
mkdir $homedir/$user/downloads/watch
chown $user.$user $homedir/$user/downloads/watch

else
chown $user.$user $homedir/$user/downloads/watch
fi

if [ ! -d $homedir/$user/downloads/.session ]; then
mkdir $homedir/$user/downloads/.session
chown $user.$user $homedir/$user/downloads/.session

else
chown $user.$user $homedir/$user/downloads/.session
fi
#--------------Fin de Creation des dossier---------
#--------------------------------------------------

# On instal Filemanager et  MediaStream

cd $wwwdir/rutorrent/plugins
svn co http://svn.rutorrent.org/svn/filemanager/trunk/mediastream
svn co http://svn.rutorrent.org/svn/filemanager/trunk/filemanager
mkdir -p $wwwdir/stream/
ln -s $wwwdir/rutorrent/plugins/mediastream/view.php $wwwdir/stream/view.php
perl -e "s/mydomain.com/$ip/g;" -pi.bak $(find /var/www/rutorrent/plugins/mediastream/conf.php -type f)

# FILEUPLOAD

svn co http://svn.rutorrent.org/svn/filemanager/trunk/fileupload
chmod 775 $wwwdir/rutorrent/plugins/fileupload/scripts/upload

#----Permission Rutorrent-------------------- 
#--------------------------------------------

chown www-data: $wwwdir/stream
chown www-data: $wwwdir/stream/view.php
chown -R www-data:www-data $wwwdir/rutorrent
chmod 775 fileupload/scripts/upload

#---Configuration apache2--------------------
#--------------------------------------------
echo "
# security
ServerSignature Off
ServerTokens Prod" >> $apachedir/apache2.conf
perl -e "s/Timeout 300/Timeout 30/g;" -pi.bak $(find $apachedir/apache2.conf -type f)

# Installation du mode SGCI d'Apache (obligatoire pour rtorrent et rutorrent)
echo SCGIMount /RPC2 127.0.0.1:5000 >> $apachedir/apache2.conf

# SSl Configuration

#Configuration du certificat ssl
openssl req -new -x509 -days 3658 -nodes -newkey rsa:2048 -out /etc/apache2/apache.pem -keyout /etc/apache2/apache.pem<<EOF
RU
Russia
Moskva
wrty
wrty LTD
wrty.com
contact@wrty.com
EOF

chmod 600 $apachedir/apache.pem
cd $apachedir/sites-available
rm -r -f default

#Activation des module apache

a2ensite default-ssl
a2enmod ssl
a2enmod scgi

cd $apachedir/sites-available/
rm -r -f default
#-----Fichier Configuration default-----------
#---------------------------------------------
echo "

<VirtualHost *:80>
        ServerAdmin webmaster@localhost
 
        DocumentRoot /var/www/
        <Directory />
                Options FollowSymLinks
                AllowOverride None
        </Directory>
        <Directory /var/www/>
                Options -Indexes
                AllowOverride all
                Order allow,deny
                allow from all
        </Directory>
 
        ScriptAlias /cgi-bin/ /usr/lib/cgi-bin/
        <Directory "/usr/lib/cgi-bin">
                AllowOverride None
                Options +ExecCGI -MultiViews +SymLinksIfOwnerMatch
                Order allow,deny
                Allow from all
        </Directory>
 
        ErrorLog /var/log/apache2/error.log
 
        # Possible values include: debug, info, notice, warn, error, crit,
        # alert, emerg.
        LogLevel warn
 
        CustomLog /var/log/apache2/access.log combined
 
    Alias /doc/ "/usr/share/doc/"
    <Directory "/usr/share/doc/">
        Options -Indexes
        AllowOverride all
        Order deny,allow
        Deny from all
        Allow from 127.0.0.0/255.0.0.0 ::1/128
    </Directory>
 
    <Location /rutorrent>
        AuthType Digest
        AuthName "rutorrent"
        AuthDigestDomain /var/www/rutorrent/ http://$ip/rutorrent
 
        AuthDigestProvider file
        AuthUserFile /etc/apache2/htpasswd
        Require valid-user
        SetEnv R_ENV "/var/www/rutorrent"
    </Location>
 
</VirtualHost>

<IfModule mod_ssl.c>
<VirtualHost *:443>
        ServerAdmin webmaster@localhost
 
        SSLEngine on
        SSLCertificateFile /etc/apache2/apache.pem
 
        DocumentRoot /var/www/
        <Directory />
                Options FollowSymLinks
                AllowOverride None
        </Directory>
        <Directory /var/www/>
                Options Indexes FollowSymLinks MultiViews
                AllowOverride None
                Order allow,deny
                allow from all
        </Directory>
 
        ScriptAlias /cgi-bin/ /usr/lib/cgi-bin/
        <Directory "/usr/lib/cgi-bin">
                AllowOverride None
                Options +ExecCGI -MultiViews +SymLinksIfOwnerMatch
                Order allow,deny
                Allow from all
        </Directory>
 
        ErrorLog /var/log/apache2/error.log
 
        # Possible values include: debug, info, notice, warn, error, crit,
        # alert, emerg.
        LogLevel warn
 
        CustomLog /var/log/apache2/access.log combined
 
    Alias /doc/ "/usr/share/doc/"
    <Directory "/usr/share/doc/">
        Options Indexes MultiViews FollowSymLinks
        AllowOverride None
        Order deny,allow
        Deny from all
        Allow from 127.0.0.0/255.0.0.0 ::1/128
    </Directory>
    <Location /rutorrent>
        AuthType Digest
        AuthName "rutorrent"
        AuthDigestDomain /var/www/rutorrent/ http://$ip/rutorrent
 
        AuthDigestProvider file
        AuthUserFile /etc/apache2/htpasswd
        Require valid-user
        SetEnv R_ENV "/var/www/rutorrent"
     </Location>
</VirtualHost>
</IfModule>

" >> $apachedir/sites-available/default

#----Fin du fichier configuration-------------
#---------------------------------------------

# Script de demarrage automatique de rtorrent
cd /$initd
wget https://raw.github.com/darkyrepo/Hexodark_Repo/master/daemon/debian/rtorrent
chmod +x /$initd/rtorrent
update-rc.d rtorrent defaults 99
perl -e "s/darky/$user/g;" -pi.bak $(find /$initd/rtorrent -type f)



service apache2 reload
clear

# Demarrage de rtorrent
su $user -c 'screen -d -m -U -fa -S rtorrent rtorrent'
echo "--"
echo " =========== FIN DE L'INSTALLATION ! On dirait que tout a fonctionne ! ==="
echo "Username :$user"
echo "Password :${pwd}"
echo "-------------------------------"
echo "-------------------------------"
echo "Maintenant, rendez-vous sur Rutorrent"
echo "https://$ip/rutorrent/"
