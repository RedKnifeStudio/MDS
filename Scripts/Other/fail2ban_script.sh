#!/bin/bash
##############################################################################
# Skrypt instalacyjny programu fail2ban na serwery Odoo z nginx
# Wszystkie paczki wymagane instalują się przez Advanced Packaging Tool - poprzez komendę apt-get
#-----------------------------------------------------------------------
# Wyślij ten plik na serwer:
# scp fail2ban_script.sh root@ip.ser.we.ra:~/
# Daj uprawnienia plikowi:
# sudo chmod +x fail2ban_script.sh
# Wykonaj plik:
# sudo ./fail2ban_script.sh
#
# wersja 1.0 [2021-08-23]
#############################################################################
## fixed parameters

SCRIPT_NAME="Instalacja Fail2ban na serwerze ze skonfigurowanym NGINX"
SCRIPT_VERSION="1.0"

#---------------------------------------------------------------------------------------
#                                     Uruchomienie skryptu instalacyjnego
#---------------------------------------------------------------------------------------
echo "=============================================================================="
echo "             Uruchomienie skryptu ${SCRIPT_NAME}  "
echo "                              wersja ${SCRIPT_VERSION} "
echo "                         $(date +"%Y.%m.%d %H:%M:%S") "
echo "=============================================================================="
echo -e "Uruchomienie skryptu instalacyjnego [${0}]  wersja=${SCRIPT_VERSION}  $(date +"%Y.%m.%d %H:%M:%S") "

echo -e "**************************************************************************"
echo -e ">   Update Serwera "
echo -e "**************************************************************************"

sudo apt-get update
sudo apt-get upgrade -y

echo -e "**************************************************************************"
echo -e ">   Instalacja Fail2ban "
echo -e "**************************************************************************"

sudo apt-get install fail2ban -y

#-------------------------------------------------------------------------------------
#                                    Konfiguracja pliku wykonywanego
#-------------------------------------------------------------------------------------


echo -e "**************************************************************************"
echo -e ">   Konfiguracja Fail2ban "
echo -e "**************************************************************************"

echo "Kopiowanie pliku konfiguracyjnego"
cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local

echo "Stworzenie pliku dla konfiguracji banowania po SSH"
echo -e "[sshd]\nenabled = true\nport = ssh\naction = iptables-multiport\nlogpath = /var/log/secure\nmaxretry = 5\nbantime = 600" > /etc/fail2ban/filter.d/sshd.local

echo -e "Czy skonfigurowałeś NGINX? (y/n)"

read KONF1

# jeżeli NGINX jest skonfigurowany, w pliku konfiguracyjnym zmieni się liczba prób
# po których następuje ban, a także zostaną wpisane zezwolenia na konkretne jaile

if [ $KONF1 == "y" ];then
	echo -e "Świetnie! Zatem zabierajmy się do rzeczy"
	sed -i 's/maxretry = 5/maxretry = 3/' /etc/fail2ban/jail.local
	sed -i '280 i enabled = true'  /etc/fail2ban/jail.local
        sed -i '380 i enabled = true'  /etc/fail2ban/jail.local
	sed -i '381 i filter = nginx-http-auth' /etc/fail2ban/jail.local

else
	echo -e "Pamiętaj o przekierowaniu domeny i zabezpieczeniu poprzez protokół SSL"
        sed -i 's/maxretry = 5/maxretry = 3/' /etc/fail2ban/jail.local
	sed -i '280 i enabled = true' /etc/fail2ban/jail.local
fi

echo "**************************************************************************"
echo -e "			Koniec konfiguracji			"
echo "**************************************************************************"

sudo fail2ban-client reload
sudo fail2ban-client status sshd
sudo fail2ban-client status nginx-http-auth

echo "**************************************************************************"
echo "Instalacja ukończona $(date +"%Y.%m.%d %H:%M:%S")" 
echo "**************************************************************************"
