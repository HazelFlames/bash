setAutoMount() {
  if [[ "$EUID" == 0 ]]
  then
    if [[ -d /media/netkeychain ]] 
    then
      true
    else
      shoutAndLog "Criando diretório /media/netkeychain..."
      sudo mkdir -p /media/netkeychain
      shoutAndLog "Feito!"  
    fi

    shoutAndLog "Criando cópia de segurança do esquema atual..."
    shoutAndLog "$(sudo cp -i /etc/fstab /etc/fstab.backup 2>&1)"
    shoutAndLog "Cópia de segurança do arquivo /etc/fstab realizada."
    shoutAndLog "Alterando configurações de montagem..."
    cat << _E_O_F_ >> /etc/fstab
kpc:/home/keepass-serv/.Raiz.children /media/netkeychain fuse.sshfs port=22,defaults,_netdv 0 0
_E_O_F_
    shoutAndLog "Feito!"
  else
    shoutAndLog "Este roteiro necessita da permissão de super usuário para alterar as configurações de montagem de disco!"
    sudo "setAutoMount"
  fi   
}
