#! /bin/bash

## should check that the fathom msi was passed as argument ($1 ??)

. /etc/os-release

case $ID_LIKE in
  debian)
    pkgman="apt"
    ;;
  arch)
    pkgman="pacman"
    ;;
esac




if [[ "$pkgman" == "pacman" ]]; then
  # check if installed?
  # resp="$(pacman -Qi wine 2>&1)"
  # if [[ $? -ne 0 ]]; then
  #   echo "install"
  # fi

  # add multilib repository
  # echo -e "[multilib]\nInclude = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf
  
  # update registry
  pacman -Syu --noconfirm
  
  # download/install wine and winetricks (for the .NET frameworks)
  #   https://archlinux.org/packages/extra/x86_64/wine/
  #   https://archlinux.org/packages/multilib/x86_64/winetricks/

  pacman -S extra/wine multilib/winetricks --noconfirm
fi

if [[ "$pkgman" == "apt" ]]; then
  # update registry
  apt update && sudo apt upgrade -y

  # download/install wine
  #   https://packages.ubuntu.com/noble/wine
  #   https://packages.ubuntu.com/noble/winetricks
  apt -y install wine winetricks
fi



# initiate wine
wineboot

# tell wine that you are using Windows 10 (needed to run/install)
winetricks -q win10

# install .NET v 4.5.2 (needed to install) and
#   .NET 4.8 (needed to run)
winetricks -q dotnet452 dotnet48


# Install Fathom Connect
# $1 is the fathom msi
# args are the same for Windows msiexec
#   https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/msiexec
# /i = normal install
# /qb = no user input, but there are boxes that need to be "okayed"
wine msiexec /i $1 /qb

# Installation location
FATHOM_DIR="$HOME/.wine/drive_c/Program Files/Innovasea/Fathom Connect"

# Run Fathom Connect
WINEDEBUG=fixme-all wine ".$FATHOM_DIR/FathomConnect.exe"


#dpkg --add-architecture i386 && apt-get update &&
# apt-get install wine32:i386

#WINEPREFIX="$HOME/prefix32" WINEARCH=win32