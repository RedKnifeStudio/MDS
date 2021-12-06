#!/bin/bash
##############################################################################
# Skrypt dodający użytkownika na serwerze
#-----------------------------------------------------------------------
# Wyślij ten plik na serwer:
# scp useradd.sh root@ip.ser.we.ra:~/
# Daj uprawnienia plikowi:
# sudo chmod +x useradd.sh
# Wykonaj plik:
# sudo ./useradd.sh
#
# wersja 1.2.2 [2021-11-29]
#############################################################################
## fixed parameters

SCRIPT_NAME="Dodanie użytkownika"
SCRIPT_VERSION="1.2.2"

#---------------------------------------------------------------------------------------
#                                     Script Execution
#---------------------------------------------------------------------------------------
echo "=============================================================================="
echo "             			          ${SCRIPT_NAME}          		            	"
echo "                             wersja ${SCRIPT_VERSION} 		            	"
echo "                         $(date +"%Y.%m.%d %H:%M:%S")		            		"
echo "=============================================================================="

echo -e "**************************************************************************"
echo -e ">   		                   	User Name           				       "
echo -e "**************************************************************************"

read -p "Podaj nazwę tworzonego użytkownika: " username
adduser $username

cd /home/$username/
mkdir .ssh
chmod 700 .shh/
cd .ssh
touch authorized_keys
chmod 600 authorized_keys

echo -e "**************************************************************************"
echo -e ">   			                Klucz SSH				                   "
echo -e "**************************************************************************"

read -p "Podaj klucz publiczny: " pub_key
echo $pub_key >> /home/$username/.ssh/authorized_keys
usermod -aG sudo $username

echo " "
echo "==============================="
echo "Weryfikacja stworzonego użytkownika"
echo "==============================="
id $username

echo " "
echo "==============================="
echo "Weryfikacja uprawnień użytkownika"
echo "==============================="
sudo -l -U $username

echo -e "**************************************************************************"
echo -e ">                              Aliasy                                     "
echo -e "**************************************************************************"

echo '
alias server_update="sudo apt update -y && sudo apt-get update -y && sudo apt upgrade -y && sudo apt-get upgrade -y && sudo apt dist-upgrade -y && sudo apt-get dist-upgrade -y"
alias start_prod="sudo systemctl start odooprod-server.service"
alias stop_prod="sudo systemctl stop odooprod-server.service"
alias restart_prod="sudo systemctl restart odooprod-server.service"
alias source_prod="source ../../../odooprod/env_odooprod/bin/activate"
alias start_test="sudo systemctl start odootest-server.service"
alias stop_test="sudo systemctl stop odootest-server.service"
alias restart_test="sudo systemctl restart odootest-server.service"
alias source_test="source ../../../odootest/env_odootest/bin/activate"
alias start_nginx="sudo systemctl start nginx.service"
alias stop_nginx="sudo systemctl stop nginx.service"
alias restart_nginx="sudo systemctl restart nginx.service"
alias test_nginx="sudo nginx -t"
alias aliasy="echo \"server_update -> aktualizacja systemu operacyjnego Linux
start_prod -> włączenie środowiska produkcyjnego
stop_prod -> wyłączenie środowiska produkcyjnego
restart_prod -> restart środowiska produkcyjnego
source_prod -> wejście do wirtuaknego środowiska produkcyjnego
start_test -> włączenie środowiska testowego
stop_test -> wyłączenie środowiska testowego
restart_test -> restart środowiska testowego
source_test -> wejście do wirtualnego środowiska testowego
start_nginx -> włączenie usługi NGINX
stop_nginx -> wyłączenie usługi NGINX
restart_nginx -> restart usługi NGINX
test_nginx -> test usługi NGINX\""' >> ~/.bashrc


source ~/.bashrc

echo "Wpisz "aliasy" w konsoli aby zobaczyć wszystkie dostępne aliasy"

echo "**************************************************************************"
echo "      User ${USER_NAME} add on $(date +"%Y.%m.%d %H:%M:%S")			    " 
echo "**************************************************************************"
