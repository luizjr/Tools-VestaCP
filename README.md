# VestaCP FileManager Free

## Configurando Tarefa no VestaCP Panel
``cd /usr/local/scripts && sudo ./filemanager.sh && cd ~/``

##Criando script
####Faça login no ssh como root * (Obrigatório)
``ssh root@your.server``

## Instalação automática
``bash <(curl -s https://raw.githubusercontent.com/luizjrdeveloper/filemanager-vestacp/master/install.sh)``

## Instalação Manual
### Criando Diretório scripts
``mkdir /usr/local/scripts/``
``cd /usr/local/scripts/``

### copiando este repositório
``git clone https://github.com/luizjrdeveloper/filemanager-vestacp.git``
``cd filemanager-vestacp``

### copiando script para dentro do diretório
``echo "FILEMANAGER_KEY=''" >> /usr/local/vesta/conf/vesta.conf``
``cp filemanager.sh /usr/local/scripts/``
``chmod a+x /usr/local/scripts/filemanager.sh``
``chown admin:admin /usr/local/scripts/filemanager.sh && echo "admin   ALL=NOPASSWD:/usr/local/scripts/*" >> /etc/sudoers.d/admin``

### Limpando instalação
``cd .. && rm -rf filemanager-vestacp``
