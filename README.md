# VestaCP Tools(Canivete Suíço)
Este script foi criado para facilitar e agilizar a vida de quem trabalha com VestaCP no dia a dia e quer atualizar a Versão do PHP ou instalar TEMPLATES para o bom funcionamento de frameworks como: Laravel, CodeIgniter e ReactJS.
Tempos também a opção de instalar o SSL para o Painel do VestaCP fazendo com que os e-mails sejam enviados com criptografia.

Para solicitar mais TEMPLATES basta iniciar um Issue no GitHub.

### Faça login no ssh como root * (Obrigatório)
``ssh root@your.server``

## Instalação Automática
``bash <(curl -s https://raw.githubusercontent.com/luizjrdeveloper/tools-vestacp/master/install.sh)``

## Instalação Manual
### Copiando este Repositório
``git clone https://github.com/luizjrdeveloper/tools-vestacp.git``  
``cd tools-vestacp``  
``bash install.sh``  

### Limpando instalação
``cd .. && rm -rf tools-vestacp``
