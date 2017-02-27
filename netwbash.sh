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

sleep 2

# Reconfigure interfaces
cat /etc/network/interfaces > /etc/network/interfacesorig
sleep 3
echo "Datei /etc/network/interfaces nach /etc/network/interfacesorig kopiert!"
echo

cat > /etc/network/interfaces <<EOF
source-directory /etc/network/interfaces.d

auto lo
iface lo inet loopback

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
echo "Jetz nur noch den Installordner entfernen lassen!"
sleep 2

sudo rm -r h72raspi

echo
echo "OK!"
echo
echo "Deine IP Adresse! :"
ip -4 addr show dev wlan0 | grep inet
sleep 10
echo
read -p "Einstellung erst nach einem reboot aktuell! Jetzt rebooten? (y/n)" $rebootyn
echo
if [ $rebootyn==y ]; then
   echo "RasPI wird neu gestartet..."
   sleep 3
   sudo reboot now
   else
   echo "FERTIG!"
   echo
fi
