#!/bin/bash
usuario='sisprod'

caminho="/home/$usuario/Dropbox"

caminhopc="/home/$usuario/Backupstodos"


if [ ! -d "$caminhopc" ]; then
    mkdir $caminhopc
fi


aux="/home/$usuario/Backupsbanco"


if [ ! -d "$aux" ]; then
    mkdir $aux
fi

chmod 600 /home/$usuario/.pgpass

    resposta='S'
    indice=0


VAR=$( date  -d "0 days" +"%d/%m")
ATUAL=$( date  -d "0 days" +"%d/%m")

while [ $ATUAL = $VAR ]
do

#colocar as pastas (pasta1 pasta2 pasta3)
#colocar bancos (banco1 banco2 banco3)

pasta=()

banco=()
x=0




varificar="0.8"

#colocar horario que o backup será executado, para adicionar mais de um horario tem que adicionar uma nova variavel horario3,horario4
horario="06:00:00"
horario2="12:30:00"
horario3="19:18:00"
#dia em que o backup vai ser salvo no servidor 01,02,03...10,11,12
dia="01"

#caso adicione mais de um horario é preciso colocar o codigo  '|| [ "$(date +%H:%M:%S)" == $horario2 ]' ao lado do ultimo Colchete
if [ "$(date +%H:%M:%S)" == $horario ] || [ "$(date +%H:%M:%S)" == $horario2 ] || [ "$(date +%H:%M:%S)" == $horario3 ];then
         
	echo "+++++++++++++++++++++++++"  
	echo "++++$(date +%H:%M:%S)++++" 
	echo "+++++++++++++++++++++++++" 

	while [ $x -ne "${#pasta[*]}" ]
	do



	if [ ! -d "$caminho/${pasta[$x]}" ]; then
	    mkdir "$caminho/${pasta[$x]}"
	fi


	if [ ! -d "$aux/${pasta[$x]}" ]; then
	    mkdir "$aux/${pasta[$x]}"
	fi


	if [ ! -d "$caminhopc/${pasta[$x]}" ]; then
	    mkdir "$caminhopc/${pasta[$x]}"
	fi


	 echo "#########################################"
	      echo "-"${pasta[$x]}"."
	      echo "-"${banco[$x]}" ."
		            horario=$(date '+%A %d-%m-%Y %H %M')
		            ubuntu=$(cat /etc/issue | grep -c "12.04")
		            if [ $ubuntu -gt 0 ]
		            then
		                /usr/bin/pg_dump --host localhost --port 5432 --username "postgres" --no-password  --format custom --blobs --verbose --file="$aux/${pasta[$x]}/${banco[$x]} $horario.backup" "${banco[$x]}"
				
				if [ "$(date +%d)" == $dia ];then
	 /usr/bin/pg_dump --host localhost --port 5432 --username "postgres" --no-password  --format custom --blobs --verbose --file="$caminhopc/${pasta[$x]}/${banco[$x]} $horario.backup" "${banco[$x]}"
				fi

		            else

		                /usr/bin/pg_dump --host=localhost --port=5432 --username="postgres" --format=c --blobs --file="$aux/${pasta[$x]}/${banco[$x]} $horario.backup" --dbname="${banco[$x]}" --no-password

				if [ "$(date +%d)" == $dia ];then
		                /usr/bin/pg_dump --host=localhost --port=5432 --username="postgres" --format=c --blobs --file="$caminhopc/${pasta[$x]}/${banco[$x]} $horario.backup" --dbname="${banco[$x]}" --no-password
				fi


		            fi


		            printf " Terminado!\n"

		          mv "$aux/${pasta[$x]}/${banco[$x]} $horario.backup" "$caminho/${pasta[$x]}/${banco[$x]} $horario.backup"
	 
		         

		            qtdeArquivos=$(ls $caminho/${pasta[$x]}/ | wc -l)
		           
		            if [ $qtdeArquivos -gt 2 ]
		            then
		                arqAntigo=$(ls -t $caminho/${pasta[$x]}/ | tail -1)
		                rm "$caminho/${pasta[$x]}/$arqAntigo"
		           
		                

		            fi
		           sleep 2
	let x=$x+1
	done   

else
	echo "------------------------"	
 	echo "Backup será realizado as: ${horario}"
	echo "Horário Atual: $(date +%H:%M:%S)"
	echo "Backup do mes vai ser dia: ${dia}"
 
fi

#echo "Number of items in original array: ${#pasta[*]}"
sleep ${varificar}s


done
fi
