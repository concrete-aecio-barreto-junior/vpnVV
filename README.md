# OpenVPN Client

> Premissa: Obter pacote de arquivos contendo arquivos (configuração, certificado e key).

## Linux  (Ubuntu 18.04 LTS)

#### Instalar requerimentos
```
$ sudo apt update
$ sudo apt install openvpn openvpn-systemd-resolved -y
```

#### Extrair certificado
Extrair os arquivos de configuração/credencais e garantir o root como owner
```
sudo unzip csspgw01-UDP4-53-*-config.zip -d /etc/openvpn/
sudo chown -R root:root /etc/openvpn/ 
```

#### Garantir arquivo de credenciais (opcicional)
Esta definição é útil p/ conectar sem a necessidade de digitar login/senha:

* Criar arquivo com duas linhas contendo usuario e senha, nas linhas 1 e 2, respectivamente
```
vim /etc/openvpn/vpnlogin
```

* Acrescentar o arquivo de credenciais criado, no arquivo `/etc/openvpn/*/*.ovpn`, na linha que contém `auth-user-pass` conforme segue:
```
vim /etc/openvpn/*/*.ovpn
auth-user-pass /etc/openvpn/vpnlogin
```

* Assegurar leitura apenas p/ root:
```
chmod 400 /etc/openvpn/vpnlogin
```

#### Habilitar o script Update/DNS
No arquivo de configuração `/etc/openvpn/*/*.ovpn` acrescentar as seguintes linhas:

```
script-security 2
up /etc/openvpn/update-systemd-resolved
down /etc/openvpn/update-systemd-resolved
down-pre
```

#### Script de inicialização (opcional)
```
sudo wget https://raw.githubusercontent.com/concrete-aecio-barreto-junior/vpnVV/master/vpnVV.sh -O /etc/init.d/vpnVV.sh
sudo chmod 755 /etc/init.d/vpnVV.sh
```

#### Iniciar o client:

* Opção 1: Executar o binário mencionando o arquivo de configuracao ".ovpn" como argumento:
```
$ sudo openvpn /etc/openvpn/*/*.ovpn
```

* Opção 2: Utilizar o script de inicialização (vide item anterior):
```
sudo /etc/init.d/vpnVV start
```

#### Validando

* Verificar interface de tunel e endereçamento IP:
```
$ sudo ip addr
```

* Verificar rotas adicionadas:
```
$ sudo netstat -nr 
```

* Verificar DNS:
```
$ nslookup bitbucket.viavarejo.com.br
```

#### Parar o cliente
Na shell onde foi iniciado o cliente, pressionar `"Ctrl+C"` ou através do script `sudo /etc/init.d/vpnVV stop`