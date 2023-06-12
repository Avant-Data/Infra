#!/bin/bash
#----------------------------------------------------------------------#
#				   	
# Autor: João Gabriel       e-mail: joao.oliveira@avantsec.com.br
# Autor: Felipe Avalanche   e-mail: felipe@avantsec.com.br
#				   	
#----------------------------------------------------------------------#


# Script criado com a finalidade de realizar backup de:
#       - Scripts
#       - Dashboars
#       - Parsers
#       - Banco de dados

# OBS: Para realizar o restore dos arquivos é preciso que eles sejam descompactados na raiz do AvantData.
#       Ex: tar -xvzf ./bkp_parsers_2023-01-31.tgz -C /

#Colors definitions
green=`tput setaf 2`
blue=`tput setaf 4`
red=`tput setaf 1`
purple=`tput setaf 125`
reset=`tput sgr0`

#Variáveis
# export BackupSRV={IP_ServidorDeBackup}
export dataAtual=$(date +"%Y-%m-%d")


echo "${green}Iniciando o Backup...${reset}"
echo "${purple}Verificando se já foi realizado backup na data atual...${reset}"

if [ -d /mnt/backup/${dataAtual} ]
then

    echo "${red}Já existe um backup realizado hoje. Se deseja realizar o backup em outra pasta, favor digite o nome da nova pasta...${reset}"
    read newFolder
    mkdir -vp /mnt/backup/${newFolder}_${dataAtual}

    echo "${blue}Compactando Scripts Python...${reset}"
    tar -czvf /mnt/backup/${newFolder}/bkp_scripts_${dataAtual}.tgz /opt/AvantData/volumes/avantdata/codigo/AvantdataNovo/users/*.py

    echo "${blue}Compactando Dashboards...${reset}"
    tar -czvf /mnt/backup/${newFolder}/bkp_dashboard_${dataAtual}.tgz /opt/AvantData/volumes/avantdata/codigo/AvantdataNovo/users/dashboard

    echo "${blue}Compactando Parsers...${reset}"
    tar -czvf /mnt/backup/${newFolder}/bkp_parsers_${dataAtual}.tgz /opt/AvantData/volumes/avantcollector/parsers


    echo "${purple}Realizando backup do banco de dados...${reset}"

    echo "${blue}Parando os contâiners...${reset}"
    sudo -u avantsystems sudo docker-compose -f /home/avantsystems/infra/AvantData_Dev.yml stop
    sleep 5
    sudo -u avantsystems sudo docker-compose -f /home/avantsystems/infra/AvantData_Dev.yml up -d avantbase
    sleep 5
    sudo -u avantsystems sudo docker-compose -f /home/avantsystems/infra/AvantData_Dev.yml stop avantdata
    sleep 5

    echo "${blue}Extraindo Schema...${reset}"
    docker exec -it avantbase pg_dump --schema-only -U avantdata AvantData > /mnt/backup/${newFolder}/avantbase_${dataAtual}_structure.sql

    echo "${blue}Extraindo Dados...${reset}"
    docker exec -it avantbase pg_dump --data-only --insert -U avantdata AvantData > /mnt/backup/${newFolder}/avantbase_${dataAtual}_data.sql

    echo "${blue}Extraindo DataBase completo...${reset}"
    docker exec -it avantbase pg_dump -U avantdata AvantData > /mnt/backup/${newFolder}/avantbase_${dataAtual}_backup.sql

    echo "${blue}Compactando DataBase...${reset}"
    tar -czvf /mnt/backup/${newFolder}/DataBase_${dataAtual}.tgz /mnt/backup/${newFolder}/*.sql

    rm -rf /mnt/backup/${newFolder}/*.sql

    echo "${green}Recriando link simbólico...${reset}"
    if [ -d /mnt/backup/latest ]
    then
    
    unlink /mnt/backup/latest
    
    fi

    ln -vs /mnt/backup/${newFolder}_${dataAtual} /mnt/backup/latest

    echo "${blue}Levantando os contâiners...${reset}"
    sudo -u avantsystems sudo docker-compose -f /home/avantsystems/infra/AvantData_Dev.yml up -d

else
    
    mkdir -vp /mnt/backup/${dataAtual}

    echo "${blue}Compactando Scripts Python...${reset}"
    tar -czvf /mnt/backup/${dataAtual}/bkp_scripts_${dataAtual}.tgz /opt/AvantData/volumes/avantdata/codigo/AvantdataNovo/users/*.py

    echo "${blue}Compactando Dashboards...${reset}"
    tar -czvf /mnt/backup/${dataAtual}/bkp_dashboard_${dataAtual}.tgz /opt/AvantData/volumes/avantdata/codigo/AvantdataNovo/users/dashboard

    echo "${blue}Compactando Parsers...${reset}"
    tar -czvf /mnt/backup/${dataAtual}/bkp_parsers_${dataAtual}.tgz /opt/AvantData/volumes/avantcollector/parsers


    echo "${purple}Realizando backup do banco de dados...${reset}"

    echo "${blue}Parando os contâiners...${reset}"
    sudo -u avantsystems sudo docker-compose -f /home/avantsystems/infra/AvantData_Dev.yml stop
    sleep 5
    sudo -u avantsystems sudo docker-compose -f /home/avantsystems/infra/AvantData_Dev.yml up -d avantbase
    sleep 5
    sudo -u avantsystems sudo docker-compose -f /home/avantsystems/infra/AvantData_Dev.yml stop avantdata
    sleep 5

    echo "${blue}Extraindo Schema...${reset}"
    docker exec -it avantbase pg_dump --schema-only -U avantdata AvantData > /mnt/backup/${dataAtual}/avantbase_${dataAtual}_structure.sql

    echo "${blue}Extraindo Dados...${reset}"
    docker exec -it avantbase pg_dump --data-only --insert -U avantdata AvantData > /mnt/backup/${dataAtual}/avantbase_${dataAtual}_data.sql

    echo "${blue}Extraindo DataBase completo...${reset}"
    docker exec -it avantbase pg_dump -U avantdata AvantData > /mnt/backup/${dataAtual}/avantbase_${dataAtual}_backup.sql

    echo "${blue}Compactando DataBase...${reset}"
    tar -czvf /mnt/backup/${dataAtual}/DataBase_${dataAtual}.tgz /mnt/backup/${dataAtual}/avantbase_${dataAtual}_*.sql

    rm -rf /mnt/backup/${dataAtual}/*.sql

    echo "${green}Recriando link simbólico...${reset}"
    if [ -d /mnt/backup/latest ]
    then
    
    unlink /mnt/backup/latest
    
    fi

    ln -vs /mnt/backup/${dataAtual} /mnt/backup/latest

    echo "${blue}Levantando os contâiners...${reset}"
    sudo -u avantsystems sudo docker-compose -f /home/avantsystems/infra/AvantData_Dev.yml up -d

fi


#Exemplo de configuração para exportar o backup para um servidor externo:
# echo "${green}Copiando arquivos para o servidor de Backup ...${reset}"
# ssh avantexport@$BackupSRV 'export dataAtual=$(date +"%Y-%m-%d") && mkdir /home/avantexport/bkp_avantdata/bkp_${dataAtual}'
# scp -r /mnt/backup/latest/* avantexport@$BackupSRV:/home/avantexport/bkp_avantdata/bkp_${dataAtual}/


# echo "${green}Excluindo arquivos do diretório /mnt/backup/latest/ ...${reset}"
# rm -rf /mnt/backup/latest/*

echo "${green}######## FIM ######## ${reset}"
