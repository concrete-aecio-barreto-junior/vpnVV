#!/bin/bash
#
# Title       : vpnVV.sh 
# Author      : Aecio Junior <aecio.barreto.junior@concrete.com.br>
# Description : Script inicializacao do OpenVPN client 
#
# Versao      : v1.0 - Criado o script
#
# Notes       : 1. Este script deve ser mantido no "/etc/init.d/"
#             
#             : 2. [ Opcional ] Mencionar no arquivo de configuracoes um segundo arquivo com credenciais
#                  na linha que se incia com "auth-user-pass"
#                  Ex: auth-user-pass /etc/openvpn/vpnlogin
#
## --- Variaveis de configuracao --- ##
ArquivoConfiguracao=/etc/openvpn/csspgw01-UDP4-53-raphaelalencar/csspgw01-UDP4-53-raphaelalencar.ovpn
InterfaceTunel="tun0"
DNS="10.200.4.18"

## --- Variaveis do script --- ##
ArquivoLog=/var/log/openvpn.log
ArquivoStatus=/run/openvpn/client.status

## --- Funcoes --- ##

_Status(){
   local RC=0
   pgrep --list-full openvpn || local RC=$?
   ip addr show ${InterfaceTunel} || local RC=$?
   netstat -nr | grep -v grep | grep "$InterfaceTunel"  || local RC=$?
   # grep "$DNS" /etc/resolv.conf || local RC=$?
   return $RC
}

_Stop(){
   local RC=0
   pkill --signal SIGTERM openvpn || local RC=$?
   [ $RC -eq 0 ] && echo vpn parada > $ArquivoStatus
   return $RC
}

_Start(){
   local RC=0
   _Status > /dev/null 2>&1 || local RC=$?
   if [ $RC -eq 0 ]
   then
      echo Openvpn ja em execucao
      cat $ArquivoStatus
   else
      {
         /usr/sbin/openvpn \
         --daemon openvpn \
         --status $ArquivoStatus 10 \
         --log-append $ArquivoLog \
         --config $ArquivoConfiguracao \
        # --auth-nocache
      } || local RC=$?
   fi
   if [ $RC -eq 0 ]
   then
      _Status
   fi
   return $?
}

_Restart(){
   local RC=0
   { _Stop || local RC=$?; } && { _Start || local RC=$?; }
   return $RC
}

_Log(){
  tail -f $ArquivoLog
}

## --- Inicio do Script --- ## 

if [ $# -eq 1 ]
then
   Comando=$1
   case $Comando in
      status)  { _Status;  } ;;
      start)   { _Start;   } ;;
      stop)    { _Stop;    } ;;
      restart) { _Restart; } ;;
      log)     { _Log;     } ;;
      *) { echo Use corretamente os params; } ;;
   esac
else
   echo "Use corretamente os params {start|stop|status}"
fi

# --- Fim do script --- #