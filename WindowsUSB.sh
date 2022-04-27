#!/bin/bash
# Criador de discos de instalação do Windows.

DIREX=$(cd "$(dirname "${BASH_SOURCE[0]}")"; pwd)

if type parted &> /dev/null
then
  true
else
  echo "Este roteiro necessita do parted para funcionar corretamente!"
  exit 1
fi

if type rsync &>/dev/null
then
  true
else
  echo "Este roteiro necessita do rsync para funcionar corretamente!"
  exit 1
fi

if type "wimlib-imagex" &> /dev/null
then
  true
else
  echo "Este roteiro necessita do wimtools para funcionar corretamente!"
  exit 1
fi

if [[ "$EUID" = 0 ]]
then
  true
else
  echo "Esse roteiro necessita de permissão de super usuário para executar!"
  exit 1
fi

if [[ -f "$DIREX/Windows.iso" ]]
then
  ISOFILE="$DIREX/Windows.iso"
else
  echo -e "Arquivo .iso de instalação do Windows não encontrado!\n(Ele deve estar no mesmo diretório do programa e nomeado como \"Windows.iso\".)"
  exit 1
fi

externalDevice() {
  read -r -p "Digite o caminho absoluto para o arquivo do dispositivo USB: " USBDEVICE
  echo -e "\n‼️ ATENÇÃO! TODOS OS DADOS DESTE DISPOSITIVO SERÃO DELETADOS!!\n"
  read -r -p "⁉️ Confirma que é o dispositvo $USBDEVICE? [S/[N]]: " CHOICE
  case $CHOICE in
    N|n)
      externalDevice ;;
    S|s)
      ;;
    *)
      externalDevice ;;
  esac
  sudo umount "$USBDEVICE"?*
}

installation() {
  echo -e "✅ Programas instalados!\n✅ Imagem de instalação do Windows presente!\n✅ USB selecionado!"
  read -r -p "❔️ Iniciar instalação? [S/[N]]: " CHOICE
  case $CHOICE in
    N|n)
      echo -e "\nAbortado!"
      exit 1 ;;
    S|s)
      ;;
    *)
      echo -e "\nAbortado!"
      exit 1 ;;
  esac

  TEMPDIR="$(mktemp -d winimage-XXXXXX)"
  SOURCE="source"
  TARGET="target"
  mkdir "${SOURCE}"
  mkdir "${TARGET}"

# Create GPT partition table, one FAT32 partition that uses 100% of available space
# first create msdos table to ensure that existing table is purged
  parted --script "${USBDEVICE}" mklabel msdos
  parted --script "${USBDEVICE}" mklabel gpt
  parted --script "${USBDEVICE}" mkpart primary fat32 1 100%
  parted --script "${USBDEVICE}" set 1 msftdata on

# Just to make sure that partition is correctly formatted as FAT32
  mkfs.vfat "${USBDEVICE}1"

# Mount Windows ISO image for file copying
  mount -oloop "${ISOFILE}" "${SOURCE}"

# Mount USB stick, partition 1
  mount "${USBDEVICE}1" "${TARGET}"

# Copy all files from ISO image to temporary directory
  rsync -avh --no-o --no-g "${SOURCE}/" "${TEMPDIR}/"

# Split the install.wim file to smaller parts, to temporary directory
  wimlib-imagex split \
    "${TEMPDIR}/sources/install.wim" \
    "${TEMPDIR}/sources/install.swm" \
    1024

# Finally, copy resulting data structure, without large file (install.wim) to
# the USB stick
  rsync -avh --no-o --no-g --exclude="install.wim" "${TEMPDIR}/" "${TARGET}/"

# Ensure that everything has been written to disk
  sync

# Unmount, your stick is ready now
  umount "${SOURCE}"
  umount "${TARGET}"
  rm -rf "${TEMPDIR}"
  rm -rf "${SOURCE}"
  rm -rf "${TARGET}"

  exit 0
}

externalDevice
installation
