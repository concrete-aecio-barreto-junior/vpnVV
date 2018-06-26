# OpenVPN Client

> ** Premissa: ** Obter pacote de arquivos contendo arquivos (configuração, certificado e key).

## Linux  (Ubuntu 18.04 LTS)

#### Instalar requerimentos
```
$ sudo apt update
$ sudo apt install openvpn openvpn-systemd-resolved -y
```

#### Extrair certificado
Extrair e ajustar atributos/owner dos arquivos de configuração/credencais
```
sudo unzip csspgw01-UDP4-53-*-config.zip -d /etc/openvpn/
sudo chown -R root:root /etc/openvpn/ 

```

#### `*OPCIONAL*` Garantir credentials file 
Esta definição é útil p/ conectar sem a necessidade de digitar login/senha

* Criar arquivo com duas linhas contendo usuario e senha, nas linhas 1 e 2, respectivamente
```
vim /etc/openvpn/vpnlogin
```

* Acrescentar o arquivo de credenciais criado na linha que contém auth-user-pass conforme segue:
```
auth-user-pass /etc/openvpn/vpnlogin
```

* Assegurar leitura apenas p/ root
```
chmod 400 /etc/openvpn/vpnlogin
```

#### Configurar o update DNS
No inicio do script /etc/openvpn/update-resolv-conf declarar a seguinte variável
```
foreign_option_1='dhcp-option DNS 10.200.4.18'
```

#### Habilitar o script Update/DNS
No arquivo de configuração "/etc/openvpn\/*\/*.ovpn" acrescentar as seguintes linhas:
```
up /etc/openvpn/update-systemd-resolved
down /etc/openvpn/update-systemd-resolved
down-pre
```

#### `*OPCIONAL*` Script de inicialização
```
sudo wget https://raw.githubusercontent.com/concrete-aecio-barreto-junior/vpnVV/master/vpnVV.sh -O /etc/init.d/vpnVV.sh
sudo chmod 755 /etc/init.d/vpnVV.sh
```

#### Iniciar o client:
Executar o binário mencionando o arquivo de configuracao ".ovpn" como argumento
```
$ sudo openvpn /etc/openvpn/*/*.ovpn
```

#### Validando
Verificar interface de tunel e endereçamento IP

```
$ sudo ip addr
```

#### Verificar rotas adicionadas
```
$ sudo netstat -nr 
```

#### Verificar DNS adicionado
```
$ grep nameserver /etc/resolv.conf
```

#### Parar o cliente
Na shell onde foi iniciado o cliente, pressionar `"Ctrl+C"`