#! /bin/bash
#created luizjrdeveloper@gmail.com
#author Luiz Jr
#created 10/03/2018

# Iniciando instalação
mkdir /usr/local/scripts/
cd /usr/local/scripts/

# Copiando este repositório
git clone https://github.com/luizjrdeveloper/filemanager-vestacp.git
cd filemanager-vestacp

# Copiando script para dentro do diretório
echo "FILEMANAGER_KEY=''" >> /usr/local/vesta/conf/vesta.conf
cp filemanager.sh /usr/local/scripts/
chmod a+x /usr/local/scripts/filemanager.sh
chown admin:admin /usr/local/scripts/filemanager.sh && echo "admin   ALL=NOPASSWD:/usr/local/scripts/*" >> /etc/sudoers.d/admin

# Limpando instalação
cd .. && rm -rf filemanager-vestacp
