DISTRIBUTOR=$(lsb_release -i | tr '[:upper:]' '[:lower:]' | cut -f 2)

echo "Votre system est : $DISTRIBUTOR"
echo "l'installation de Rtorrent Rutorrent est sur le point de commencer"
sleep 6

case $DISTRIBUTOR in

ubuntu)
        echo "Installing my package"
        wget https://raw.github.com/darkyrepo/Hexodark_Repo/master/os/ubnssl.sh
        bash ubnssl.sh
        ;;
debian)
        echo "Installing my package"
        wget https://raw.github.com/darkyrepo/Hexodark_Repo/master/os/debyssl.sh
        bash debnssl.sh
        ;;
fedora)
        echo "Installing my package"
        wget files
        bash fedonssl.sh
        ;;
centos)
        echo "Installing my package"
        wget files
        bash centonssl.sh
        ;;
esac
