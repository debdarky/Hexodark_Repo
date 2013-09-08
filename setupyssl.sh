DISTRIBUTOR=$(lsb_release -i | tr '[:upper:]' '[:lower:]' | cut -f 2)

echo "Votre system est : $DISTRIBUTOR"
echo "l'installation de Rtorrent Rutorrent est sur le point de commencer"
sleep 5

case $DISTRIBUTOR in

ubuntu)
        echo "Installing my package"
        wget --no-check-certificate https://raw.github.com/darkyrepo/Hexodark_Repo/master/os/ubyssl.sh
        bash ubyssl.sh
        ;;
debian)
        echo "Installing my package"
        wget --no-check-certificate https://raw.github.com/darkyrepo/Hexodark_Repo/master/os/debyssl.sh
        bash debyssl.sh
        ;;
fedora)
        echo "Installing my package"
        wget files
        bash fedoyssl.sh
        ;;
centos)
        echo "Installing my package"
        wget files
        bash centoyssl.sh
        ;;
esac
