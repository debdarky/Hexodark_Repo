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

 # DÃƒÂ©tÃƒÂ©ction du gestionnaire de paquet Ãƒ  utiliser (aptitude en prioritÃƒÂ©)
if [ "`dpkg --status aptitude | grep Status:`" == "Status: install ok installed" ]
then
        packetg="aptitude"
else
        packetg="apt-get"
fi

ip=$(ip addr | grep eth0 | grep inet | awk '{print $2}' | cut -d/ -f1)

##Log de l'instalation
exec 2>/log

# Ajoute des dÃƒÂ©pots non-free
echo "deb http://ftp2.fr.debian.org/debian/ squeeze main non-free
deb-src http://ftp2.fr.debian.org/debian/ squeeze main non-free" >> /etc/apt/sources.list

# Installation des paquets vitaux
$packetg update
$packetg install -y  apache2 apache2-utils autoconf build-essential ca-certificates comerr-dev libapache2-mod-php5 libcloog-ppl-dev libcppunit-dev libcurl3 libcurl4-openssl-dev libncurses5-dev ncurses-base ncurses-term libterm-readline-gnu-perl libsigc++-2.0-dev libssl-dev libtool libxml2-dev ntp openssl patch libperl-dev php5 php5-cli php5-dev php5-fpm php5-curl php5-geoip php5-mcrypt php5-xmlrpc pkg-config python-scgi dtach ssl-cert subversion unrar zlib1g-dev pkg-config unzip htop irssi curl cfv rar zip ffmpeg mediainfo git screen perl libapache2-mod-scgi
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

##  Installation XMLRPC Libtorrent Rtorrent Plowshare
 
    # XMLRPC
 
    svn checkout http://xmlrpc-c.svn.sourceforge.net/svnroot/xmlrpc-c/stable xmlrpc-c
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
 
    git clone https://code.google.com/p/plowshare/ plowshare4
    cd plowshare4
    make install
 rm -r -f plowshare4
# Script de demarrage automatique de rtorrent
wget
chmod +x /$initd/debian-daemon.sh
update-rc.d debian-daemon.sh defaults 99


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

# Creation du mot de passe de l'interface Rutorrent
a2enmod auth_digest
echo "${user}:rutorrent:"$(printf "${user}:rutorrent:${pwd}" | md5sum | awk '{print $1}') > $apachedir/htpasswd

#On instal  Rutorrent

cd $wwwdir/
svn checkout http://rutorrent.googlecode.com/svn/trunk/rutorrent
svn checkout http://rutorrent.googlecode.com/svn/trunk/plugins
rm -r -f rutorrent/plugins
mv plugins rutorrent/

cd $wwwdir/rutorrent/conf
rm -r -f plugins.ini config.php
wget https://raw.github.com/darkyrepo/Hexodark_Repo/master/files/plugins.ini
wget https://raw.github.com/darkyrepo/Hexodark_Repo/master/files/config.php
perl -e "s/darky/$user/g;" -pi.bak $(find $wwwdir/rutorrent/conf -type f)

cd $wwwdir/rutorrent/plugins

# On instal Filemanager et  MediaStream
svn co http://svn.rutorrent.org/svn/filemanager/trunk/mediastream
svn co http://svn.rutorrent.org/svn/filemanager/trunk/filemanager
mkdir -p $wwwdir/stream/
ln -s $wwwdir/rutorrent/plugins/mediastream/view.php $wwwdir/stream/view.php
chown www-data: $wwwdir/stream
chown www-data: $wwwdir/stream/view.php
perl -e "s/mydomain.com/$ip/g;" -pi.bak $(find /var/www/rutorrent/plugins/mediastream/conf.php -type f)


# FILEUPLOAD


svn co http://svn.rutorrent.org/svn/filemanager/trunk/fileupload
chmod 775 $wwwdir/rutorrent/plugins/fileupload/scripts/upload

chown -R www-data:www-data $wwwdir/rutorrent
chmod -R 755 $wwwdir/rutorrent


cd /$homedir/$user
wget https://raw.github.com/darkyrepo/Hexodark_Repo/master/files/.rtorrent.rc
perl -e "s/darky/$user/g;" -pi.bak $(find $homedir/$user/.rtorrent.rc -type f)
chown -R $user:$user /$homedir/$user/.rtorrent.rc


# Configuration apache2
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
wget https://raw.github.com/darkyrepo/Hexodark_Repo/master/os/ssl/default
perl -e "s/127.0.0.1/$ip/g;" -pi.bak $(find $apachedir/sites-available/default -type f)
a2enmod rewrite
a2ensite default-ssl
a2enmod ssl
a2enmod scgi && /etc/init.d/apache2 restart

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
