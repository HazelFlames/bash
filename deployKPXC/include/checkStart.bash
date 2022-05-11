checkStart() { 
  read -p -r "Iniciar deploy do chaveiro Zeus via KeePassXC? [S/[N]] => " ESCOLHA
  ESCOLHA=${ESCOLHA:-N}
  case $ESCOLHA in
    N|n)
      shoutAndLog "Abortado."
      exit 1 ;;
    S|s)
      shoutAndLog "Iniciando configuração do acesso ao chaveiro via SSH..."
      updateHosts
      exportKeys 
      setSSHConfig
      setAutoMount
      shoutAndLog "Configuração concluída! Reinicie o computador pra fazer efeito."
      exit 0 ;;
    *)
      echo "
Opção inválida!"
      sleep 1s
      checkStart ;;
  esac
}
