#!/bin/bash

eu=$('whoami')

echo "$eu"

if [ "$eu" = "root" ]; then
    echo "Instalando pacotes "
    apt -qq update -y && apt install smartmontools hdparm 
    echo "Qual disco deseja testar: (ex:/dev/sda)?"
    read disco
    #Testando velocidade do disco
    echo "Testando velocidade do disco "
    dispositivo=$(echo  $disco |cut -d/ -f3)
    > /root/testspeed_$dispositivo 
    date >> /root/testspeed_$dispositivo 
    hdparm -Tt $disco  | cat >> /root/testspeed_$dispositivo  
    hdparm -I $disco |grep speed
    echo "Relatorio de velocidade salvo em /root/testspeed_$dispositivo"
    #Teste smart 
    echo "Gostaria de rodar teste curto(2M) ou longo(30M)? :  "
    read teste 
      
    
    if [[ "$teste" = "curto" ]];
    then
        smartctl --test short $disco 
        sleep 1m
        > /root/smart_$dispositivo 
        date >> /root/smart_$dispositivo 
        smartctl -a $disco >> /root/smart_$dispositivo 
        echo "Teste curto concluido "
        echo "Teste salvo em /root/smart_$dispositivo "
    elif [[ "$teste" = "longo" ]];
    then
        > /root/smart_$dispositivo 
        date >> /root/smart_$dispositivo 
        smartctl --test short $disco 
        sleep 30m
        smartctl -a $disco >> /root/smart_$dispositivo 
        echo "Teste  longo concluido "
        echo "Teste salvo em /root/smart_$dispositivo "
    else
        echo "Nome invalido do teste !!!"
    fi
    resultado=$(cat /root/smart_nvme0n1 |grep PASSED |wc -l)
    if [[ "$resultado" -ge 1 ]];
    then
        RED='\033[0;31m'
        NC='\033[0m' # No Color
        Green='\033[0;32m'
        Yellow='\033[0;33m' 
        echo -e "${Green}   !!!!Passou no teste!!!! "
        echo -e "${Yellow}  !!!!Aconselho ver os logs mesmo assim!!!!"
        
    else
        RED='\033[0;31m'
        Yellow='\033[0;33m' 
        echo -e "${RED}!!!HD com defeito atenção !!!"
        echo -e "${Yellow} !!!Aconselho ver os logs !!!"
        
    fi
    

    else 
    echo "É necessario ser root"
    exit 1
   
fi
