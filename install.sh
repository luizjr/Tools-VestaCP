#! /bin/bash
#created lj@luizjr.dev
#author Luiz Jr
#created 10/03/2018
#last updated 02/04/2019

### Menu da aplicação
menu(){
	### Limpando o Terminal
	clear
	### Escrevendo menu na tela
	echo '=========================================='
	echo 'Bem Vindo ao Canivete Suíço do VestaCP'
	echo '=========================================='
	echo ' 1 -> Atualizar php7.0 para php7.1 (Debian Based)'
	echo ' 2 -> Instalar SSL para VestaCP Painel e E-mail'
	echo ' 3 -> Ativar FileManager'
	echo ' 4 -> Instalar Templates Laravel, ReactJS e HTTPS'
	echo ' 5 -> Corrigir config e storage no phpMyAdmin'
	echo ' 6 -> Todas as Opções'
	echo ' 7 -> Sair'
	echo '============================== By Luiz Jr'
	### Aguardando Input do Usuário
	### Aguardando a opção ser selecionada
	read -p 'Escolha a opção e pressione [ENTER]: ' opcao
}

### Atualização do php7.0 para o php7.1
atualizacao_php71(){
	echo "Vamos começar a atualização do php7.0 para o php7.1"
	# Atualizando Pacotes e preparando sistema
	sudo apt update
	sudo apt install software-properties-common python-software-properties -y
	sudo LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php -y
	sudo apt update
	sudo apt install php7.1 -y
	a2dismod php7.0
	a2enmod php7.1
	# Instalando Módulos
	sudo apt install php7.1-common php7.1-zip libapache2-mod-php7.1 php7.1-cgi php7.1-cli php7.1-phpdbg php7.1-fpm libphp7.1-embed php7.1-dev php7.1-curl php7.1-gd php7.1-imap php7.1-interbase php7.1-intl php7.1-ldap php7.1-mcrypt php7.1-readline php7.1-odbc php7.1-pgsql php7.1-pspell php7.1-recode php7.1-tidy php7.1-xmlrpc php7.1 php7.1-json php-all-dev php7.1-sybase php7.1-sqlite3 php7.1-mysql php7.1-opcache php7.1-bz2 libapache2-mod-php7.1 php7.1-mbstring php7.1-pdo php7.1-dom -y
	# Reiniciando Apache
	sudo service apache2 restart
}

### Instala Certificado SSL para o Painel VestaCP
instala_ssl_no_painel(){
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
}

### Ativação do FileManager
ativar_gerenciador_de_arquivos(){
	echo "Iniciando Ativação do FileManager..."
	sleep 0.4

	### Variáveis
	file_vesta_filemanager="/etc/cron.hourly/vesta_filemanager"
	file_emp="FILEMANAGER_KEY=''"
	file_tex="FILEMANAGER_KEY='ILOVEREO'"

	ativa_file_manager(){
		echo '
		#! /bin/bash
		#created luizjr@gmail.com
		#author Luiz Jr
		#created 10/03/2018

		disabled="'${file_emp}'"
		enabled="'${file_tex}'"

		### Verificando se o FileManager já está ativo
		if ! grep -Fxq "$enabled" /usr/local/vesta/conf/vesta.conf; then
			# Se não está ativo ele verifica se tem uma linha mas não está ativada

			# Verificando se a variável disabled é igual no arquivo
			if grep -Fxq "$disabled" /usr/local/vesta/conf/vesta.conf
			then
				# Encontrou a TAG
				sed -i -e "s/$disabled/$enabled/g" /usr/local/vesta/conf/vesta.conf
			else
				# Se não tem nenhuma linha de ativado ou desativado ele ativa
				echo $enabled >> /usr/local/vesta/conf/vesta.conf
			fi
		fi' >> $file_vesta_filemanager
		chmod +x $file_vesta_filemanager
		sudo echo "Ativando FileManager..."

		### Verificando e Atualizando arquivo sudoers
		texto_para_sudoers='admin  ALL=(ALL) NOPASSWD: ALL'
		sudoers='/etc/sudoers'

		if ! grep -Fxq "$texto_para_sudoers" $sudoers; then
			echo $texto_para_sudoers >> $sudoers
		fi

		### Adicionando tarefa para o admin ativar o FileManager
		/usr/local/vesta/bin/v-add-cron-job admin "*/2" "*" "*" "*" "*" "sudo /bin/bash /etc/cron.hourly/vesta_filemanager"
		bash $file_vesta_filemanager
		sleep 2
		echo "FileManager Ativado com Sucesso!"
	}

	### Verifica se é uma reinistalação ou uma nova instalçao
	if [ -f "$file_vesta_filemanager" ]; then
		echo "Limpando Ativação Anterior..."
		rm $file_vesta_filemanager
		ativa_file_manager
	else
		ativa_file_manager
	fi
}

instala_templates_vestacp(){
	echo "Instalando Templates..."
	patch_template="/usr/local/vesta/data/templates/web"
	git clone https://github.com/luizjr/Tools-VestaCP.git
	cp -R Tools-VestaCP/includes/apache2 $patch_template
	cp -R Tools-VestaCP/includes/nginx $patch_template
	rm -R Tools-VestaCP
	echo "Templates Instados!"
}

phpMyAdmin_Fixer(){
	bash <(curl -s https://raw.github.com/luizjr/phpMyAdmin-Fixer-VestaCP/master/pma.sh)
}

opcoes(){
	### Verifica a opção selecionada no menu
	if [[ -n "$opcao" ]]; then

		# Atualiza o PHP
		if [ "$opcao" -eq 1 ]; then
			atualizacao_php71
			sair_ou_continuar

		# Instal SSL no Painel VestaCP
		elif [ "$opcao" -eq 2 ]; then
			instala_ssl_no_painel
			sair_ou_continuar

		# Ativacao do FileManager
		elif [ "$opcao" -eq 3 ]; then
			ativar_gerenciador_de_arquivos
			sair_ou_continuar

		# Instalando Templates para o VestaCP
		elif [ "$opcao" -eq 4 ]; then
			instala_templates_vestacp
			sair_ou_continuar

		# Corrigindo phpMyAdmin para o VestaCP
		elif [ "$opcao" -eq 5 ]; then
			phpMyAdmin_Fixer
			sair_ou_continuar

		# Todas as opções
		elif [ "$opcao" -eq 6 ]; then
			atualizacao_php71
			instala_ssl_no_painel
			ativar_gerenciador_de_arquivos
			instala_templates_vestacp
			sair_ou_continuar

		# Fecha a aplicação
		elif [ "$opcao" -eq 7 ]; then
			sair
		else
			clear && echo "Opção inválida" && sleep 0.5 && clear
			aplicacao
		fi
	else
		clear && echo "Opção inválida" && sleep 0.5 && clear
		aplicacao
	fi
}

sair_ou_continuar(){
	### Limpando o Terminal
	sleep 2
	clear
	### Escrevendo menu na tela
	echo 'Deseja realmente sair?'
	echo ' 1 -> Sim'
	echo ' 2 -> Não'

	### Aguardando a opção ser selecionada
	read -p 'Escolha a opção e pressione [ENTER]: ' opcao_para_fechar

	if [[ -n "$opcao_para_fechar" ]]; then
		if [ "$opcao_para_fechar" -eq 2 ]; then
			aplicacao
		elif [ "$opcao_para_fechar" -eq 1 ]; then
			# Fecha aplicação
			sair
		else
			sair_ou_continuar
		fi
	fi
}

sair(){
	### Limpando o Terminal
	clear && echo "Fechando a aplicação..." && sleep 1 && clear
	exit
}
am_i_root(){
	# Am I root?
	if [ "x$(id -u)" != 'x0' ]; then
		echo 'Erro: este script só pode ser executado pelo usuário root'
		exit 1
	fi
}

aplicacao(){
	am_i_root
	menu
	opcoes
}

aplicacao
