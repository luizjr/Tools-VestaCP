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
	echo "Entrando na pasta já existente"
else
	mkdir /usr/local/scripts
	cd /usr/local/scripts
	echo "diretório inexistente"
	exit
fi

echo "Trabalhando na ativação"
git clone https://github.com/luizjrdeveloper/filemanager-vestacp.git
cd filemanager-vestacp

# Verificando se já tem FILEMANAGER_KEY se não tiver adiciona linha
a="FILEMANAGER_KEY=''"
b="FILEMANAGER_KEY='ILOVEREO'"

if grep -Fxq "$a" /usr/local/vesta/conf/vesta.conf
then
# code if found
sed -i -e "s/$a/$b/g" /usr/local/vesta/conf/vesta.conf
else
	echo "FILEMANAGER_KEY=''" >> /usr/local/vesta/conf/vesta.conf
fi

# Copiando para a pasta de scripts
cp filemanager.sh /usr/local/scripts/
chmod a+x /usr/local/scripts/filemanager.sh
chown admin:admin /usr/local/scripts/filemanager.sh

# Verificando sudoers.d
sudoers="admin   ALL=NOPASSWD:/usr/local/scripts/*"

if grep -Fxq "$sudoers" /usr/local/vesta/conf/vesta.conf
then
# code if found
	echo "Sudoers já configurado"
else
	echo "admin   ALL=NOPASSWD:/usr/local/scripts/*" >> /etc/sudoers.d/admin
fi

cd ..
rm -rf filemanager-vestacp
echo "Ativado com Sucesso!"
sleep 5
exit 2
