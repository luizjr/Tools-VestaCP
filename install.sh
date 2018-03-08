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

if [ "$opcao" -eq 1 ] then
	if [ ! -d "/usr/local/scripts" ]; then
		mkdir /usr/local/scripts
	fi

	cd /usr/local/scripts

	echo 'Vamos começar a ativação '
	git clone https://github.com/luizjrdeveloper/filemanager-vestacp.git
	cd filemanager-vestacp
	echo "FILEMANAGER_KEY=''" >> /usr/local/vesta/conf/vesta.conf
	cp filemanager.sh /usr/local/scripts/
	chmod a+x /usr/local/scripts/filemanager.sh
	chown admin:admin /usr/local/scripts/filemanager.sh
	echo "admin   ALL=NOPASSWD:/usr/local/scripts/*" >> /etc/sudoers.d/admin
	cd ..
	rm -rf filemanager-vestacp

elif [ "$opcao" -eq 2 ]
then
	echo "Cancelando a ativação..."
	exit
fi
