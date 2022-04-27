updateHosts() {
  if [[ "$EUID" == 0 ]]
  then
    shoutAndLog "Verificando resolução de nomes..."
    grep -i "172.20.0.101" /etc/hosts || {
      shoutAndLog "Não encontrada a relação nome-endereço."
      shoutAndLog "Atualizando arquivo /etc/hosts"
      cat "$DIREX/include/hosts" >> /etc/hosts
      shoutAndLog "Feito!"
    }
    shoutAndLog "Verificação e atualização concluída!"
  else
    shoutAndLog "Este roteiro necessita de permissões de super usuário para modificar os hostnames conhecidos."
    sudo "updateHosts"
  fi
}
