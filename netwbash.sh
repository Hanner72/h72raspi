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
read -p "Wie lautet die Netzwerk SSID?:" netzssid
read -p "Wie lautet das Passwort für das Netzwerk?:" netzpwd

echo
echo "Deine Eingaben: "
echo "Raspberry IP: "$ipraspi
echo "Subnetmask: "$subnetraspi
echo "IP vom Router: "$iprouter
echo

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

sleep 2

# Reconfigure interfaces
cat /etc/network/interfaces > /etc/network/interfacesorig
sleep 3
echo "Datei /etc/network/interfaces nach /etc/network/interfacesorig kopiert!"
echo

cat > /etc/network/interfaces <<EOF
\# interfaces(5) file used by ifup(8) and ifdown(8)
\# Please note that this file is written to be used with dhcpcd
\# For static IP, consult /etc/dhcpcd.conf and 'man dhcpcd.conf'
\# Include files from /etc/network/interfaces.d:
\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#
source-directory /etc/network/interfaces.d
auto lo
iface lo inet loopback
\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#
\# MIT FESTER IP \#
iface eth0 inet manual
auto wlan0
allow-hotplug wlan0
iface wlan0 inet static
address $ipraspi
netmask $subnetraspi
gateway $iprouter
   wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf
iface default inet dhcp
EOF

sleep 3
echo "Neue Daten in /etc/network/interfaces geschrieben!"
echo

sudo ifconfig wlan0 down
sleep 3
sudo ifconfig wlan0 up
sleep 3
echo "Netzwerkdienst neu gestartet!"
sleep 1
echo
echo "FERTIG !!!"
echo
echo "Jetz nur noch den Installordner entfernen lassen!"
sleep 2

sudo rm -r h72raspi

echo
echo "OK!"
