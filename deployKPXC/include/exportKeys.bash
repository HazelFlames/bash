exportKeys() {
  if [[ -f "$CLIENTKEY" ]]
  then
    true
  else  
    shoutAndLog "Chave privada não encontrada. Gerando uma nova..."
    shoutAndLog "$(ssh-keygen -f "$CLIENTKEY" -N "" 2>&1)"
    shoutAndLog "Feito!"
    mv "$CLIENTKEY.pub" "$CLIENTPUBKEY"
  fi

  shoutAndLog "$(sshpass -p "N8M%UEu6rtTMWL$" ssh -o StrictHostKeyChecking=accept-new keepass-client@alpine "echo 'Conexão estabelecida!'")"
  shoutAndLog "Copiando chave pública para o servidor..."
  
  if sshpass -p "N8M%UEu6rtTMWL$" scp "$CLIENTPUBKEY" keepass-client@alpine:~
  then
    shoutAndLog "Copiada."
    shoutAndLog "Autorizando acesso com a chave copiada..."
    sshpass -p "N8M%UEu6rtTMWL$" ssh keepass-client@alpine "cat ~/Alpine-I.keepass-client.pub.key >> ~/.ssh/authorized_keys"
    shoutAndLog "Feito!"
  else
    shoutAndLog "Falha na cópia da chave para o servidor! Tente novamente ou instale-a manualmente!"
  fi
}
