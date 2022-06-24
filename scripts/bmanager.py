#!/usr/bin/env python3
import sys
import os
import time
import re


#Variaveis
pathbareos = /etc/bareos/bareos-dir.d/











def createjob()
        nomejob = input('Qual nome do novo job ? : Evite os caracteres .{}[], Use a nomeclatura da empresa')
        jobexist = os.path.exists('/etc/bareos/bareos-dir.d/'+nomejob+.conf)
        if jobexist == True;
            print("Job já cadastrado escolha outro nome")
        else
           print ('Criando jobdef')
           os.system("curl  -H 'Cache-Control: no-cache, no-store 'https://raw.githubusercontent.com/wellesximenes/ws_public/main/bareos/jobdefs/jobdef.conf.exemplo' -o "+pathbareos+nomejob+.conf)
           print ('Job Criado')

def menujob():
    opcao = 0
    while opcao != 5:
        print('''
                ------Menu de configuração do bareos------

                [1] Criar Job
                [2] Editar Job
                [3] Deletar Job 
                [0] Para sair      ''')
        print('')
        opcao = int(input('O que deseja fazer?: '))
        if opcao == 1:
            createjob()
        elif opcao == 2:
            editjob()
        elif opcao == 3:
            deljob()    

        elif opcao == 0:
            opcao = 5
            print('Bye!!!!')
        else:
            print('Lascou')
    

def menu():
    opcao = 0
    while opcao != 5:
        print('''
                ------Menu de configuração do bareos------

                [1] Gerenciar jobs
                [2] Backup do bareos 
                [0] Para sair      ''')
        print('')
        opcao = int(input('O que deseja configurar no bareos: '))
        if opcao == 1:
            managejobs()
        elif opcao == 2:
            backupbareos()

        elif opcao == 0:
            opcao = 5
            print('Bye!!!!')
        else:
            print('Lascou')
          


menu()