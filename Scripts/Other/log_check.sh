#!/bin/bash
###########################################################################
# Script for checking error in logs 
#-------------------------------------------------------------------------
# Send this file to server:
# scp -r log_check.sh root@ip.ser.we.ra:~/
# Make the file executable:
# sudo chmod +x log_check.sh
# Execute the script:
# sudo ./log_check.sh
# 
# version 1.0.4 [2021-10-26]
# prepared by Bartosz Barański & Paweł Lusiński
###########################################################################
## fixed parameters

SCRIPT_NAME="Error Log Checker"
SCRIPT_VERSION="1.0.4"
DATE=$(date +%d_$m_$y)
#--------------------------------------------------------------------------
#                           Execute the script
#--------------------------------------------------------------------------
echo "====================================================================="
echo "			Executing the script ${SCRIPT_NAME}       	       "
echo "			version ${SCRIPT_VERSION}   	  	       "
echo "			$(date +"%Y.%m.%d %H:%M:%S")		       "
echo "====================================================================="
echo -e "Launching checking script [${0}] ver.=${SCRIPT_VERSION}  $(date +"%Y.%m.%d %H:%M:%S") "


echo -e "*********************************************************************"
echo -e "	       Checking Logs in Production Environment	          "
echo -e "*********************************************************************"

echo "*************************************************************" >> log_$DATE.log
echo "Błędy na środowisku produkcyjnym z dnia $(date +"%Y.%m.%d")" >> log_$DATE.log
echo "*************************************************************" >> log_$DATE.log

while read p; do
        if [[ $p == *"WARN"* || $p == *"ERROR"* ]]; then
                echo $p >> log_$DATE.log
        fi
done < /var/log/odooprod/odooprod-server.log

echo -e "*********************************************************************"
echo -e "	       Checking Logs in Test Environment 	 	          "
echo -e "*********************************************************************"

echo "*************************************************************" >> log_$DATE.log
echo "Błędy na środowisku testowym z dnia $(date +"%Y.%m.%d")" >> log_$DATE.log
echo "*************************************************************" >> log_$DATE.log

while read p; do
        if [[ $p == *"WARN"* || $p == *"ERROR"* ]]; then
                echo $p >> log_$DATE.log
        fi
done < /var/log/odootest/odootest-server.log

echo -e "*********************************************************************"
echo -e "	       Checking Logs in PostgreSQL	 	          "
echo -e "*********************************************************************"

echo "*************************************************************" log_$DATE.log
echo "Błędy baz danych z dnia $(date +"%Y.%m.%d")" >> log_$DATE.log
echo "*************************************************************" >> log_$DATE.log

while read p; do
        if [[ $p == *"WARN"* || $p == *"ERROR"* ]]; then
                echo $p >> log_$DATE.log
        fi
done < /var/log/postgresql/postgresql-12-main.log.1

echo -e "*********************************************************************"
echo -e "           Checking Logs in NGINX                   "
echo -e "*********************************************************************"

echo "*************************************************************" >> log_$DATE.log
echo "Błędy NGINX z dnia $(date +"%Y.%m.%d")" >> log_$DATE.log
echo "*************************************************************" >> log_$DATE.log

while read p; do
        if [[ $p == *"failed"* ]]; then
                echo $p >> log_$DATE.log
        fi
done < /var/log/nginx/error.log


echo -e "*********************************************************************"
echo -e "          Check completed on $(date +"%Y.%m.%d %H:%M:%S")           "
echo -e "*********************************************************************"
