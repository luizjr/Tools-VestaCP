#! /bin/bash
#created luizjrdeveloper@gmail.com
#author Luiz Jr
#created 10/03/2018

clear

echo 'Bem Vindo ao Canivete Suíço do VestaCP'
echo '======'
echo ' 1 -> Atualizar php7.0 para php7.1'
echo ' 2 -> Instalar SSL para VestaCP Painel e E-mail'
echo ' 3 -> Ativar FileManager'
echo ' 4 -> Cancelar'
read -p 'Escolha a opção e pressione [ENTER]: ' opcao

if [ "$opcao" -eq 1 ]; then
	echo "Vamos começar a atualização do php7.0 para o php7.1"
	sudo apt-get update
	sudo apt-get install python-software-properties
	sudo LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php
	apt-get update
	apt-get install php7.1
	a2dismod php7.0
	a2enmod php7.1

	apt-get install php7.1-common php7.1-zip libapache2-mod-php7.1 php7.1-cgi php7.1-cli php7.1-phpdbg php7.1-fpm libphp7.1-embed php7.1-dev php7.1-curl php7.1-gd php7.1-imap php7.1-interbase php7.1-intl php7.1-ldap php7.1-mcrypt php7.1-readline php7.1-odbc php7.1-pgsql php7.1-pspell php7.1-recode php7.1-tidy php7.1-xmlrpc php7.1 php7.1-json php-all-dev php7.1-sybase php7.1-sqlite3 php7.1-mysql php7.1-opcache php7.1-bz2 libapache2-mod-php7.1 php7.1-mbstring php7.1-pdo php7.1-dom

	service apache2 restart
	exit

elif [ "$opcao" -eq 2 ]; then
	echo "Iniciando a Instalação do SSL..."
	sleep 1
	read -p "Digite o Domínio(url) do VestaCP e pressione [ENTER]: " dominio_vesta
	echo "Emitindo Certificado SSL para o Dominío..."
	/usr/local/vesta/bin/v-add-letsencrypt-domain admin $dominio_vesta

	file_vesta_ssl="/etc/cron.daily/vesta_ssl"
	if [ -f "$file_vesta_ssl" ]; then
		echo "Reescrevendo Tarefa Cron"
		rm $file_vesta_ssl
		echo '	cert_src="/home/admin/conf/web/ssl.'${dominio_vesta}'.pem"
		key_src="/home/admin/conf/web/ssl.'${dominio_vesta}'.key"
		cert_dst="/usr/local/vesta/ssl/certificate.crt"
		key_dst="/usr/local/vesta/ssl/certificate.key"

		if ! cmp -s $cert_dst $cert_src
		then
		        # Copiando Certificado
		        cp $cert_src $cert_dst

		        # Copiando Chave
		        cp $key_src $key_dst

		        # Aplicando Permissões
		        chown root:mail $cert_dst
		        chown root:mail $key_dst

		        # Reiniciando Serviços
		        service vesta restart &> /dev/null
		        service exim4 restart &> /dev/null

		fi' >> $file_vesta_ssl

		chmod +x $file_vesta_ssl
		echo "Ativando SSL para o Dominío..."
		bash $file_vesta_ssl
		sleep 2
		echo "SSL Ativado com Sucesso!"
	else
		echo '			cert_src="/home/admin/conf/web/ssl.'${dominio_vesta}'.pem"
		key_src="/home/admin/conf/web/ssl.'${dominio_vesta}'.key"
		cert_dst="/usr/local/vesta/ssl/certificate.crt"
		key_dst="/usr/local/vesta/ssl/certificate.key"

		if ! cmp -s $cert_dst $cert_src
		then
		        # Copiando Certificado
		        cp $cert_src $cert_dst

		        # Copiando Chave
		        cp $key_src $key_dst

		        # Aplicando Permissões
		        chown root:mail $cert_dst
		        chown root:mail $key_dst

		        # Reiniciando Serviços
		        service vesta restart &> /dev/null
		        service exim4 restart &> /dev/null

		fi' >> $file_vesta_ssl

		chmod +x $file_vesta_ssl
		echo "Ativando SSL para o Dominío..."
		bash $file_vesta_ssl
		sleep 2
		echo "SSL Ativado com Sucesso!"
	fi
	sleep 3
	exit


# Ativacao do FileManager
elif [ "$opcao" -eq 3 ]; then
	echo "Iniciando Ativação do FileManager..."
	sleep 1
	file_vesta_filemanager="/etc/cron.hourly/vesta_filemanager"
	file_emp="FILEMANAGER_KEY=''"
	file_tex="FILEMANAGER_KEY='ILOVEREO'"

	if [ -f "$file_vesta_filemanager" ]; then
		echo "Limpando Ativação Anterior..."
		rm $file_vesta_filemanager

		echo '
		#! /bin/bash
		#created luizjrdeveloper@gmail.com
		#author Luiz Jr
		#created 10/03/2018

		a="'${file_emp}'"
		b="'${file_tex}'"

		if grep -Fxq "$b" /usr/local/vesta/conf/vesta.conf
		then
			sed -i -e "s/$b/$b/g" /usr/local/vesta/conf/vesta.conf
		else
			if grep -Fxq "$a" /usr/local/vesta/conf/vesta.conf
			then
			# Encontrou a TAG
				sed -i -e "s/$a/$b/g" /usr/local/vesta/conf/vesta.conf
			else
				echo $b >> /usr/local/vesta/conf/vesta.conf
			fi
		fi' >> $file_vesta_filemanager
		chmod +x $file_vesta_filemanager
		echo "Ativando FileManager..."
		bash $file_vesta_filemanager
		sleep 2
		echo "FileManager Ativado com Sucesso!"
	else
		echo '
		#! /bin/bash
		#created luizjrdeveloper@gmail.com
		#author Luiz Jr
		#created 10/03/2018

		a="'${file_emp}'"
		b="'${file_tex}'"

		if grep -Fxq "$b" /usr/local/vesta/conf/vesta.conf
		then
			sed -i -e "s/$b/$b/g" /usr/local/vesta/conf/vesta.conf
		else
			if grep -Fxq "$a" /usr/local/vesta/conf/vesta.conf
			then
			# Encontrou a TAG
				sed -i -e "s/$a/$b/g" /usr/local/vesta/conf/vesta.conf
			else
				echo $b >> /usr/local/vesta/conf/vesta.conf
			fi
		fi' >> $file_vesta_filemanager
		chmod +x $file_vesta_filemanager
		echo "Ativando FileManager..."
		bash $file_vesta_filemanager
		sleep 2
		echo "FileManager Ativado com Sucesso!"
	fi
	exit

elif [ "$opcao" -eq 4 ]; then
	echo "Cancelando a ativação..."
	sleep 3
	exit
else
	echo "Opção inválida"
	exit
fi
