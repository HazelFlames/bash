#!/bin/bash
# Roteiro de implementação do KeePassXC

DIREX=$(cd "$(dirname "${BASH_SOURCE[0]}")" || exit; pwd)

CLIENTKEY="$DIREX/Alpine-I.keepass-client.pri.key"
CLIENTPUBKEY="$DIREX/Alpine-I.keepass-client.pub.key"
LOG="$DIREX/deployKPXC.log"

SSHDIR="$HOME/.ssh"
SSHPKDIR="$HOME/.ssh/keys/private"

source "$DIREX/include/checkStart.bash"
source "$DIREX/include/exportKeys.bash"
source "$DIREX/include/setAutoMount.bassh"
source "$DIREX/include/setSSHConfig.bash"
source "$DIREX/include/shoutAndLog.bash"
source "$DIREX/include/updateHosts.bash"

if type flatpak &>/dev/null
then
  true
else
  shoutAndLog "Este roteiro necessita do flatpak para funcionar corretamente!"
  exit 1
fi

if type sshpass &>/dev/null
then
  true
else
  shoutAndLog "Este roteiro necessita do sshpass para funcionar corretamente!"
  exit 1
fi

shoutAndLog "Iniciando instalação do KeePassXC...
"
if flatpak install -y flathub org.keepassxc.KeePassXC 
then 
  shoutAndLog "
Instalação concluída!"
  checkStart
else
  shoutAndLog "
Falha na instalação via Flatpak!"
  shoutAndLog "Tente a instalação manual (flatpak install -y flathub org.keepassxc.KeePassXC) e execute o roteiro novamente."
  exit 1
fi
