#! /bin/bash
#############################################
#          Created by Johann Danner         #
#    E-Mail: johann.danner(at)gmail.com     #
#   Feel free to copy & share this script   #
#############################################

echo
echo "Das Einstellungsscript wurde gestartet!"
echo
read -p "Wie soll die IP Adresse von deinem RasPI lauten? (e.g. 192.168.8.100):" ipraspi
read -p "Wie lautet die Subnetmask? (e.g. 255.255.255.0):" subnetraspi
read -p "Wie lautet die IP vom Router? (e.g. 192.168.8.1):" iprouter

echo
echo "Deine Eingaben: "
echo "Raspberry IP: "$ipraspi
echo "Subnetmask: "$subnetraspi
echo "IP vom Router: "$iprouter

# Change anything beyond this point
###########################################

# the IP of your raspberry
#raspi_client_ip="192.168.2.2"
# subnetmask
#raspi_client_nm="255.255.255.0"
# the IP of your router
#raspi_client_gw="192.168.2.1"

# Don't change anything beyond this point
###########################################

# Reconfigure interfaces

cat > /etc/network/interfaces <<EOF
auto lo
iface lo inet loopback
auto eth0
iface eth0 inet static
address $ipraspi        #vorher raspi_client_ip="192.168.2.2"
gateway $subnetraspi    #vorher raspi_client_nm="255.255.255.0"
netmask $iprouter       #vorher raspi_client_gw="192.168.2.1"
EOF
