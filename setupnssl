DISTRIBUTOR=$(lsb_release -i | tr '[:upper:]' '[:lower:]' | cut -f 2)

echo "Votre system est : $DISTRIBUTOR"
echo "l'installation de Rtorrent Rutorrent est sur le point de commencer"
echo "S'il vous plaît patienter"
sleep 5

case $DISTRIBUTOR in

ubuntu)
        echo "Installing my package"
        wget files
        bash ubnssl.sh
        ;;
debian)
        echo "Installing my package"
        wget files
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
