#!/bin/bash
#----------------------------------------------------------------------#
#				   	
# Autor: João Gabriel       e-mail: joao.oliveira@avantsec.com.br
# Autor: Felipe Avalanche   e-mail: felipe@avantsec.com.br
#				   	
#----------------------------------------------------------------------#


# Script criado com a finalidade de realizar restore de:
#       - Scripts
#       - Dashboars
#       - Parsers
#       - Banco de dados

#Colors definitions
green=`tput setaf 2`
blue=`tput setaf 4`
red=`tput setaf 1`
purple=`tput setaf 125`
reset=`tput sgr0`


echo "${green}Iniciando o Restore...${reset}"
echo "${purple}Serão restaurados scripts, dashboards, parsers e configurações gerais...${reset}"
echo "${blue}Extraindo Scripts Python...${reset}"
    tar -xzvf /mnt/backup/latest/bkp_scripts_* -C /

echo "${blue}Extraindo Dashboards...${reset}"
    tar -xzvf /mnt/backup/latest/bkp_dashboard_* -C /

echo "${blue}Extraindo Parsers...${reset}"
    tar -xzvf /mnt/backup/latest/bkp_parsers_* -C /

echo "${purple}Extraindo backup do banco de dados...${reset}"    

echo "${blue}Extraindo Data Base...${reset}"
    tar -xzvf /mnt/backup/latest/DataBase_* -C /

#TODO: automatizar alteração do pg_hba.conf de md5 para trust

echo "${purple}Iniciando restore do banco de dados...${reset}" 
echo "${blue}Parando os contâiners...${reset}"
    sudo -u avantsystems sudo docker-compose -f /home/avantsystems/infra/AvantData_Dev.yml stop
    sleep 5
    sudo -u avantsystems sudo docker-compose -f /home/avantsystems/infra/AvantData_Dev.yml up -d avantbase
    sleep 5
    sudo -u avantsystems sudo docker-compose -f /home/avantsystems/infra/AvantData_Dev.yml stop avantdata
    sleep 5

echo "${blue}Deletando a antiga DATABASE...${reset}"    
    docker exec -it avantbase psql -U avantdata postgres -c 'DROP DATABASE "AvantData";'

echo "${blue}Criando a nova DATABASE e realizando os ajustes necessários...${reset}"
    docker exec -it avantbase psql -U avantdata postgres -c 'CREATE DATABASE "AvantData";'

    docker exec -it avantbase psql -U avantdata postgres -c 'GRANT ALL ON DATABASE "AvantData" TO avantdata;'

echo "${blue}Restaurando a Estrutura...${reset}"    
    docker exec -i avantbase psql -U avantdata AvantData < /mnt/backup/latest/avantbase_*_structure.sql

echo "${blue}Restaurando os Dados...${reset}"
    docker exec -i avantbase psql -U avantdata AvantData < /mnt/backup/latest/avantbase_*_data.sql
    sleep 5

echo "${blue}Levantando os contâiners...${reset}"
    sudo -u avantsystems sudo docker-compose -f /home/avantsystems/infra/AvantData_Dev.yml up -d







#    docker exec avantbase psql -U avantdata AvantData < /mnt/backup/latest/*_backup.sql
#    sudo -u avantsystems sudo docker-compose -f /home/avantsystems/infra/AvantData.yml stop avantbase
#    sleep 10
#    sudo -u avantsystems sudo docker-compose -f /home/avantsystems/infra/AvantData.yml up -d avantbase

echo "${green}######## FIM ######## ${reset}"