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
	sleep 5
	exit 2
else
	echo "Opção inválida"
	exit
fi

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
# code if found
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
	sed -i -e "s/$permission/$permission/g" /etc/sudoers.d/admin
else
	echo "admin   ALL=NOPASSWD:/usr/local/scripts/*" >> /etc/sudoers.d/admin
fi

# Limpando arquivos da ativação
cd ..
rm -rf filemanager-vestacp
echo "Ativado com Sucesso!"

# Saindo
sleep 3
exit 2
