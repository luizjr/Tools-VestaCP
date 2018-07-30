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
	sleep 2
	echo -n "Digite o dominio(url) do VestaCP e pressione [ENTER]: "
	read dominio_vesta
	sleep 1
	echo "Gerando Certificado SSL para o Dominío..."
	/usr/local/vesta/bin/v-add-letsencrypt-domain admin $dominio_vesta
	sleep 1
	echo $dominio_vesta
	if [ -d /usr/local/scripts ]
	then
		echo "Entrando na pasta de scripts existente"
		rm /etc/cron.daily/vesta_ssl
		echo '		cert_src="/home/admin/conf/web/ssl.' >> /etc/cron.daily/vesta_ssl
		echo $dominio_vesta >> /etc/cron.daily/vesta_ssl
		echo '.pem"
		key_src="/home/admin/conf/web/ssl.' >> /etc/cron.daily/vesta_ssl
		echo $dominio_vesta >> /etc/cron.daily/vesta_ssl
		echo '.key"
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
		fi' >> /etc/cron.daily/vesta_ssl
		chmod +x /etc/cron.daily/vesta_ssl
		echo "Ativando SSL para o Dominío..."
		bash /etc/cron.daily/vesta_ssl
	else
		echo '		cert_src="/home/admin/conf/web/ssl.' >> /etc/cron.daily/vesta_ssl
		echo $dominio_vesta >> /etc/cron.daily/vesta_ssl
		echo '.pem"
		key_src="/home/admin/conf/web/ssl.' >> /etc/cron.daily/vesta_ssl
		echo $dominio_vesta >> /etc/cron.daily/vesta_ssl
		echo '.key"
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
		fi' >> /etc/cron.daily/vesta_ssl
		chmod +x /etc/cron.daily/vesta_ssl
		echo "Ativando SSL para o Dominío..."
		bash /etc/cron.daily/vesta_ssl
	fi
	sleep 3
	exit


# Ativacao do FileManager
elif [ "$opcao" -eq 3 ]; then
	if [ -d /usr/local/scripts ]
	then
		cd /usr/local/scripts
		echo "Entrando na pasta de scripts existente"
	else
		mkdir /usr/local/scripts
		cd /usr/local/scripts
		sleep 3
		echo "Criando pasta para o script..."
	fi

	echo "Trabalhando na Ativação..."
	sleep 2

	if [ -d /usr/local/scripts/filemanager-vestacp ]
	then
		rm -rf /usr/local/scripts/filemanager-vestacp
		echo "Removendo pasta para poder começar o clone do git"
		git clone https://github.com/luizjrdeveloper/filemanager-vestacp.git
		cd filemanager-vestacp
	else
		git clone https://github.com/luizjrdeveloper/filemanager-vestacp.git
		cd filemanager-vestacp
	fi
	sleep 1

	# Verificando se já tem FILEMANAGER_KEY se não tiver adiciona linha
	a="FILEMANAGER_KEY=''"
	b="FILEMANAGER_KEY='ILOVEREO'"

	if grep -Fxq "$a" /usr/local/vesta/conf/vesta.conf
	then
		sed -i -e "s/$a/$b/g" /usr/local/vesta/conf/vesta.conf
	elif grep -Fxq "$b" /usr/local/vesta/conf/vesta.conf
	then
		sed -i -e "s/$b/$b/g" /usr/local/vesta/conf/vesta.conf
	else
		echo "FILEMANAGER_KEY=''" >> /usr/local/vesta/conf/vesta.conf
	fi

	# Copiando para a pasta de scripts
	cp filemanager.sh /usr/local/scripts/
	chmod a+x /usr/local/scripts/filemanager.sh
	chown admin:admin /usr/local/scripts/filemanager.sh

	sleep 1

	# Verificando sudoers.d
	permission="admin   ALL=NOPASSWD:/usr/local/scripts/*"

	if grep -Fxq "$permission" /etc/sudoers.d/admin
	then
	# code if found
		echo "Arquivo de sudoers já configurado"
		#sed -i -e "s/$permission/$permission/g" /etc/sudoers.d/admin
	else
		echo "admin   ALL=NOPASSWD:/usr/local/scripts/*" >> /etc/sudoers.d/admin
	fi

	# Limpando arquivos da ativação
	cd ..
	rm -rf filemanager-vestacp
	echo "Ativado com Sucesso!"

	# Saindo
	sleep 2
	exit 2

elif [ "$opcao" -eq 4 ]; then
	echo "Cancelando a ativação..."
	sleep 5
	exit 2
else
	echo "Opção inválida"
	exit
fi
