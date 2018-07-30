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
echo 'Escolha a opção e pressione [ENTER]: '
read opcao

if [ "$opcao" -eq 1 ]; then
	echo "Vamos começar a atualização do php7.0 para o php7.1"
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

		if grep -Fxq "$a" /usr/local/vesta/conf/vesta.conf
		then
		# code if found
			sed -i -e "s/$a/$b/g" /usr/local/vesta/conf/vesta.conf
		elif grep -Fxq "$b" /usr/local/vesta/conf/vesta.conf
		then

		else
			echo $b >> /usr/local/vesta/conf/vesta.conf
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

		if grep -Fxq "$a" /usr/local/vesta/conf/vesta.conf
		then
		# code if found
			sed -i -e "s/$a/$b/g" /usr/local/vesta/conf/vesta.conf
		elif grep -Fxq "$b" /usr/local/vesta/conf/vesta.conf
		then

		else
			echo $b >> /usr/local/vesta/conf/vesta.conf
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
