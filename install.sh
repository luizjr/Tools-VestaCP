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
echo ' 4 -> Instalar Templates Laravel, ReactJS e HTTPS'
echo ' 5 -> Sair'

read -p 'Escolha a opção e pressione [ENTER]: ' opcao

if [[ -n "$opcao" ]]; then
	if [ "$opcao" -eq 1 ]; then
		echo "Vamos começar a atualização do php7.0 para o php7.1"
		sudo apt update
		sudo apt install software-properties-common python-software-properties -y
		sudo LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php -y
		apt update
		apt install php7.1 -y
		a2dismod php7.0
		a2enmod php7.1

		#Instalando Módulos
		apt install php7.1-common php7.1-zip libapache2-mod-php7.1 php7.1-cgi php7.1-cli php7.1-phpdbg php7.1-fpm libphp7.1-embed php7.1-dev php7.1-curl php7.1-gd php7.1-imap php7.1-interbase php7.1-intl php7.1-ldap php7.1-mcrypt php7.1-readline php7.1-odbc php7.1-pgsql php7.1-pspell php7.1-recode php7.1-tidy php7.1-xmlrpc php7.1 php7.1-json php-all-dev php7.1-sybase php7.1-sqlite3 php7.1-mysql php7.1-opcache php7.1-bz2 libapache2-mod-php7.1 php7.1-mbstring php7.1-pdo php7.1-dom -y
		service apache2 restart
		exit 1

	elif [ "$opcao" -eq 2 ]; then
		echo "Iniciando a Instalação do SSL..."
		sleep 1
		echo "Emitindo Certificado SSL para o Painel VestaCP..."
		/usr/local/vesta/bin/v-add-letsencrypt-domain 'admin' $HOSTNAME '' 'yes'

		echo "Isso aplicará o SSL instalado aos daemons VestaCP, Exim e Dovecot."
		/usr/local/vesta/bin/v-update-host-certificate admin $HOSTNAME

		echo "Isso permitirá que o VestaCP atualize o SSL para os daemons VestaCP, Exim e dovecot toda vez que o SSL for renovado."
		echo "UPDATE_HOSTNAME_SSL='yes'" >> /usr/local/vesta/conf/vesta.conf

		sleep 2
		echo "SSL Ativado para o Painel com Sucesso!"
		exit 1

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
			#Adicionando tarefa para o admin ativar o FileManager
			/usr/local/vesta/bin/v-add-cron-job admin "*/2" "*" "*" "*" "*" "sudo /bin/bash /etc/cron.hourly/vesta_filemanager"
			bash $file_vesta_filemanager
			sleep 2
			echo "FileManager Ativado com Sucesso!"
		fi
		exit 1
	elif [ "$opcao" -eq 4 ]; then
		echo "Instalando Templates..."
		patch_template="/usr/local/vesta/data/templates/web"
		git clone https://github.com/luizjrdeveloper/tools-vestacp.git
		cp -R tools-vestacp/includes/apache2 $patch_template
		cp -R tools-vestacp/includes/nginx $patch_template
		rm -R tools-vestacp
		echo "Templates Instados!"
		sleep 2
		exit 1
	elif [ "$opcao" -eq 5 ]; then
		echo "Cancelando a ativação..."
		sleep 3
		exit 1
	else
		echo "Opção inválida"
		exit 0
	fi
else
	echo "Opção inválida"
	exit 0
fi
