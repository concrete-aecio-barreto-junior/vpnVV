# OpenVPN Client

## Linux  (Ubuntu 18.04 LTS)

### Instalação

```
$ sudo apt update && sudo apt install openvpn
```

### Configuração

Extrair e ajustar atributos/owner dos arquivos de configuração/credencais

```
sudo unzip csspgw01-UDP4-53-*-config.zip -d /etc/openvpn/
chown -R root:root /etc/openvpn/*
```

### Script de inicialização

```
sudo wget https://raw.githubusercontent.com/concrete-aecio-barreto-junior/vpnVV/master/vpnVV.sh -O /etc/init.d/vpnVV.sh
sudo chmod 755 /etc/init.d/vpnVV.sh
```