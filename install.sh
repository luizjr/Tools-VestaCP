#!/bin/bash
# Program:
#   Ativador do File Manager do VestaCP
# History:
# 05.03.2018 luizjr First release.
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

params=$#
param1=$1

function show_help(){
cat <<EOF
    Usage:
    bash vestacp-filemanager.sh 1|do         exec this script.
    bash vestacp-filemanager.sh debug        just echo script will do.
    bash vestacp-filemanager.sh -h           show this help.
EOF
}

function vestacp-filemanager(){
    script="just a test"
    if [[ "$param1" == "debug" ]];then
        echo "${script}"
    else
        eval "${script}"
    fi
    echo "done."
}

function main(){
    case "$params" in
        "0")
            show_help;
            exit 0;
            ;;
        "1" | "2")
            if [[ "$param1" == "-h" ]];then
                show_help;
            elif [[ "$param1" == "1" || "$param1" == "do" ]];then
                vestacp-filemanager;
            else
                show_help;
            fi
            exit 0;
            ;;
        *)
            show_help;
            exit 0;
            ;;
    esac
}

main;
#! /bin/bash
#created luizjrdeveloper@gmail.com
#author Luiz Jr
#created 10/03/2018

clear

echo 'Bem Vindo à ativação do FileManager do VestaCP'
echo '======'
echo ' 1 -> Ativar FileManager'
echo ' 2 -> Cancelar'

read opcao

if [ "$opcao" -eq 1 ]; then
	echo "Vamos começar a ativação"
elif [ "$opcao" -eq 2 ]; then
	echo "Cancelando a ativação..."
	exit
else
	echo "Opção inválida"
	exit
fi

if [ -d /usr/local/scripts ]
then
echo "diretório válido"
else
echo "diretório inexistente"
exit
fi

cd /usr/local/scripts
git clone https://github.com/luizjrdeveloper/filemanager-vestacp.git
cd filemanager-vestacp
echo "FILEMANAGER_KEY=''" >> /usr/local/vesta/conf/vesta.conf
cp filemanager.sh /usr/local/scripts/
chmod a+x /usr/local/scripts/filemanager.sh
chown admin:admin /usr/local/scripts/filemanager.sh
echo "admin   ALL=NOPASSWD:/usr/local/scripts/*" >> /etc/sudoers.d/admin
cd ..
rm -rf filemanager-vestacp
