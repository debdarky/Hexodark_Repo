DISTRIBUTOR=$(lsb_release -i | tr '[:upper:]' '[:lower:]' | cut -f 2)

echo "Votre system est : $DISTRIBUTOR"
echo "l'installation de Rtorrent Rutorrent est sur le point de commencer"
echo "S'il vous plaît patienter"
sleep 5

case $DISTRIBUTOR in

ubuntu)
        echo "Installing my package"
        wget files
        bash ubyssl.sh
        ;;
debian)
        echo "Installing my package"
        wget files
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
