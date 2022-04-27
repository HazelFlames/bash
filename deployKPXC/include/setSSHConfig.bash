setSSHConfig() {
  shoutAndLog "Verificando a presença da chave..."
  if [[ -f "$CLIENTKEY" ]] 
  then
    shoutAndLog "Chave encontrada."
  else
    shoutAndLog "Chave Alpine-I.keepass-client.pri.key não encontrada! Adicione-a junto do executável e tente novamente."
    exit 1
  fi

  shoutAndLog "Checando se existe o diretório .ssh e o local para chaves na pasta do usuário..."
  if [[ -d "$SSHPKDIR" ]]
  then
    shoutAndLog "Existe! Copiando chave..."
    cp "$CLIENTKEY" "$SSHPKDIR"
    shoutAndLog "Copiada."
  else
    shoutAndLog "Não encontrado! Criando diretório e copiando a chave..."
    mkdir -p "$SSHPKDIR"
    cp "$CLIENTKEY" "$SSHPKDIR"
    shoutAndLog "Copiada."
  fi

  if [[ -f "$SSHDIR/config" ]]
  then
      shoutAndLog "Salvando cópia das conexões do SSH..."
      shoutAndLog "$(cp -i "$SSHDIR/config" "$SSHDIR/config.backup" 2>&1)"
      shoutAndLog "Copiada."
  fi
  shoutAndLog "Criando/atualizando arquivo de conexões do SSH..."
  cat "$DIREX/include/config" >> "$SSHDIR/config"
  shoutAndLog "Feito!"
}
