#! /bin/bash
#############################################
#          Created by Johann Danner         #
#    E-Mail: johann.danner(at)gmail.com     #
#   Feel free to copy & share this script   #
#############################################

echo
echo "Das Einstellungsscript wurde gestartet!"
echo
# Feste Adressen für eth0 vergeben
echo "Deine momentanen IP Adressen für eth0 sind: "
echo
ip addr show eth0 | grep inet
echo
read -p "Feste IP Adressen für eth0 vergeben? (y/n):" ethyn
echo
if [ "$ethyn" != n ]; then
   read -p "Wie soll die IP Adresse von deinem RasPI lauten? (e.g. 192.168.8.100):" ipethraspi
   read -p "Subnetmaske ändern? Aktuell 255.255.255.0! (y/n):" subnetethyn
   # Subnetmask ändern oder nicht
   if [ "$subnetethyn" != n ]; then
      read -p "Wie lautet die Subnetmask? (e.g. 255.255.255.0):" subnetethraspi
   else
      subnetethraspi="255.255.255.0"
   fi
   read -p "Wie lautet die IP vom Router? (e.g. 192.168.8.1):" ipethrouter
fi
echo

echo "Deine momentanen IP Adressen für wlan0 sind: "
echo
ip addr show wlan0 | grep inet
echo

# Feste Adressen für eth0 vergeben
read -p "Feste IP Adressen für wlan0 vergeben? (y/n):" wlanyn
echo
if [ "$wlanyn" != n ]; then
   read -p "Wie soll die IP Adresse von deinem RasPI lauten? (e.g. 192.168.8.100):" ipraspi
   read -p "Subnetmaske ändern? Aktuell 255.255.255.0! (y/n):" subnetyn
   # Subnetmask ändern oder nicht
   if [ "$subnetyn" != n ]; then
      read -p "Wie lautet die Subnetmask? (e.g. 255.255.255.0):" subnetraspi
   else
      subnetraspi="255.255.255.0"
   fi
   read -p "Wie lautet die IP vom Router? (e.g. 192.168.8.1):" iprouter
fi

echo

read -p "Wie lautet die Netzwerk SSID?:" netzssid
read -p "Wie lautet das Passwort für das Netzwerk?:" netzpwd

echo
echo "Deine Eingaben: "
echo "eth0:------------"
echo "Raspberry IP: "$ipethraspi
echo "Subnetmask: "$subnetethraspi
echo "IP vom Router: "$ipethrouter
echo "wlan0:-----------"
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

if [ "$ethyn" != n ]; then
   $etheinst = echo -e "auto eth0\niface eth0 inet static\naddress $ipethraspi\nnetmask $subnetethraspi\ngateway $ipethrouter"
else
   $etheinst = "iface eth0 inet dhcp " 
fi
cat > /etc/network/interfaces <<EOF
source-directory /etc/network/interfaces.d

auto lo
iface lo inet loopback

$etheinst

if [ "$wlanyn" != n ]; then
allow-hotplug wlan0
iface wlan0 inet static
   address $ipraspi
   netmask $subnetraspi
   gateway $iprouter
      wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf
else
   auto wlan0
   allow-hotplug wlan0
   iface wlan0 inet dhcp
      wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf 
fi

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
sleep 3
echo
read -p "Einstellung erst nach einem reboot aktuell! Jetzt rebooten? (y/n)" rebootyn
echo
if [ "$rebootyn" != n ]; then
   echo "RasPI wird neu gestartet..."
   sleep 3
   sudo reboot now
else
   echo "FERTIG!"
   echo
fi
