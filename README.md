# Tools VestaCP (Canivete Suíço)

Este script foi criado para facilitar e agilizar a vida de quem trabalha com **VestaCP** no dia a dia e quer atualizar a **Versão do PHP** ou instalar **templates** para o bom funcionamento de frameworks como: *Laravel, CodeIgniter e ReactJS*. Existe também a opção para habilitar o SSL para o Painel do **VestaCP** fazendo com que os e-mails sejam enviados com criptografia.

Para solicitar mais **templates** basta iniciar um [Issue no GitHub](https://github.com/luizjr/Tools-VestaCP/issues/new).

## Primeiro faça login no servidor via ssh como root * (Obrigatório)
Exemplo:
`ssh root@your.server`

# Instalação Automática

`bash <(curl -s https://raw.githubusercontent.com/luizjr/Tools-VestaCP/master/install.sh)`

# Instalação Manual

#### Copiando este Repositório

`git clone https://github.com/luizjr/Tools-VestaCP.git`  
`cd tools-vestacp`  
`bash install.sh`

#### Limpando instalação

`cd .. && rm -rf Tools-VestaCP`
