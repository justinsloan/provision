#!/bin/bash
# +------------------------------------------------------------------------+
# | This provisioning script is specifically designed to work with BASH    |
# | under Pop!_OS by System76, although it may work equally well under any |
# | Debian-based dristribution.                                            |
# +------------------------------------------------------------------------+
# | This is free and unencumbered software released into the public domain.|
# |                                                                        |
# | Anyone is free to copy, modify, publish, use, compile, sell, or        |
# | distribute this software, either in source code form or as a compiled  |
# | binary, for any purpose, commercial or non-commercial, and by any      |
# | means.                                                                 |
# |                                                                        |
# | In jurisdictions that recognize copyright laws, the author or authors  |
# | of this software dedicate any and all copyright interest in the        |
# | software to the public domain. We make this dedication for the benefit |
# | of the public at large and to the detriment of our heirs and           |
# | successors. We intend this dedication to be an overt act of            |
# | relinquishment in perpetuity of all present and future rights to this  |
# | software under copyright law.                                          |
# |                                                                        |
# | THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,        |
# | EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF     |
# | MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. |
# | IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR      |
# | OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,  |
# | ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR  |
# | OTHER DEALINGS IN THE SOFTWARE.                                        |
# +------------------------------------------------------------------------+

# Superuser permission required.
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

echo "==> Starting provisioning."

# Check for curl
if exists curl; then 
    echo "==> curl already installed"
else
    sudo apt -y install curl
fi

# Install Additional Repositories
## Microsoft Edge (I keep this here because I use Edge for work))
# curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
# sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
# sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/edge stable main" > /etc/apt/sources.list.d/microsoft-edge.list'
# rm microsoft.gpg

## Microsoft Debian Bulls Eye
curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-debian-bullseye-prod bullseye main" > /etc/apt/sources.list.d/microsoft.list'

## VS Codium
curl https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg | gpg --dearmor > vscodium.gpg
sudo install -o root -g root -m 644 vscodium.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64] https://download.vscodium.com/debs vscodium main" > /etc/apt/sources.list.d/vscodium.list'
rm -f vscodium.gpg

## OneDriver
### Client for Microsoft OneDrive
echo 'deb http://download.opensuse.org/repositories/home:/jstaf/xUbuntu_22.04/ /' | sudo tee /etc/apt/sources.list.d/home:jstaf.list
curl -fsSL https://download.opensuse.org/repositories/home:jstaf/xUbuntu_22.04/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/home_jstaf.gpg > /dev/null

## Brave Browser
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list

# Update the System
sudo apt update 

# Install the Nala apt manager
sudo apt install nala

# Purge/Remove Unneeded Default Packages
sudo nala -y purge firefox 
sudo nala -y purge chromium 
sudo nala -y purge evolution 
sudo nala -y purge epiphany-browser

# Install pending updates
sudo nala -y upgrade
sudo nala -y autoremove

# Install Packages
sudo nala -y install brave-browser
sudo nala -y install gnupg 
sudo nala -y install gthumb
sudo nala -y install gdu
sudo nala -y install iperf3
sudo nala -y install apt-transport-https
sudo nala -y install cabextract
sudo nala -y install htop 
sudo nala -y install ncdu
sudo nala -y install tmux 
sudo nala -y install git 
sudo nala -y install nmap
sudo nala -y install foliate
sudo nala -y install codium 
sudo nala -y install python3-pip 
sudo nala -y install twine 
sudo nala -y install remmina
sudo nala -y install inetutils-traceroute
sudo nala -y install traceroute
sudo nala -y install cmatrix 
sudo nala -y install neofetch
sudo nala -y install figlet
sudo nala -y install linuxlogo
sudo nala -y install cowsay
sudo nala -y install taskwarrior
sudo nala -y install curtail 
sudo nala -y install imagemagick 
sudo nala -y install nautilus-image-converter
sudo nala -y install gnome-tweaks 
sudo nala -y install powershell
sudo nala -y install onedriver
sudo nala -y install heif-gdk-pixbuf
sudo nala -y install gnome-sushi
sudo nala -y install flameshot
sudo nala -y install autokey-gtk
sudp nala -y install glances
sudo nala -y install fzf
sudo nala -y install virtualbox
sudo nala -y install virtualbox-guest-additions-iso
sudo nala -y install system76-keyboard-configurator

## Install SSH server
sudo nala -y install openssh-server
### SSH is enabled by default, so let's stop it
sudo systemctl stop ssh

# Install 1Password
curl https://downloads.1password.com/linux/debian/amd64/stable/1password-latest.deb --output 1password.deb
sudo dpkg -i ./1password.deb

# Install Python Packages
pip3 install quantumdiceware
pip3 install pyoath
pip3 install pyotp
pip3 install jrnl

# Install Codium Extensions
sudo -u $SUDO_USER codium - --install-extension sleistner.vscode-fileutils
sudo -u $SUDO_USER codium - --install-extension streetsidesoftware.code-spell-checker
sudo -u $SUDO_USER codium - --install-extension ms-python.python
#sudo -u $SUDO_USER codium - --install-extension janisdd.vscode-edit-csv
sudo -u $SUDO_USER codium - --install-extension ms-vscode.powershell
sudo -u $SUDO_USER codium - --install-extension pajoma.vscode-journal
sudo -u $SUDO_USER codium - --install-extension mads-hartmann.bash-ide-vscode
sudo -u $SUDO_USER codium - --install-extension timonwong.shellcheck
sudo -u $SUDO_USER codium - --install-extension GrapeCity.gc-excelviewer

# Install Microsoft Fonts
sudo -u $SUDO_USER mkdir /home/$SUDO_USER/.fonts 
sudo -u $SUDO_USER curl https://raw.githubusercontent.com/justinsloan/pop-provision/main/fonts.sh | sudo -u $SUDO_USER bash
wget http://ftp.de.debian.org/debian/pool/contrib/m/msttcorefonts/ttf-mscorefonts-installer_3.6_all.deb -P ~/Downloads
sudo nala -y install ~/Downloads/ttf-mscorefonts-installer_3.6_all.deb
rm ~/Downloads/ttf-mscorefonts-installer_3.6_all.deb

# Add user Home to PATH
PATHA='export PATH=$PATH'
PATHB="/home/$SUDO_USER/.local/bin"
echo " " >> /home/$SUDO_USER/.bashrc
echo "$PATHA:$PATHB" >> /home/$SUDO_USER/.bashrc

# Create some handy bash aliases
echo "alias myip='curl checkip.amazonaws.com | figlet'" >> /home/$SUDO_USER/.bash_aliases
echo "alias update='sudo nala update && sudo nala -y upgrade && sudo nala -y autoremove'" >> /home/$SUDO_USER/.bash_aliases
echo "alias whichupdates='sudo nala update && nala list --upgradeable'" >> /home/$SUDO_USER/.bash_aliases
echo "alias calc='bc -l'" >> /home/$SUDO_USER/.bash_aliases
echo "alias size='pwd && find ./ -type f -exec du -Sh {} + | sort -rh | head -n 15'" >> /home/$SUDO_USER/.bash_aliases
echo "alias storage='ncdu'" >> /home/$SUDO_USER/.bash_aliases
echo "alias untar='tar -zxvf '" >> /home/$SUDO_USER/.bash_aliases
echo "alias ports='sudo netstat -tulanp'" >> /home/$SUDO_USER/.bash_aliases
echo "alias clearall='clear && history -c && history -w'" >> /home/$SUDO_USER/.bash_aliases
echo "alias gs='git pull && git push'" >> /home/$SUDO_USER/.bash_aliases
echo "alias ..='cd ..'" >> /home/$SUDO_USER/.bash_aliases
echo "alias ~='cd ~/'" >> /home/$SUDO_USER/.bash_aliases
echo "alias flush-dns='resolvectl flush-caches'" >> /home/$SUDO_USER/.bash_aliases
echo "alias showdns='resolvectl status | grep '\''DNS Server'\'' -A2'" >> /home/$SUDO_USER/.bash_aliases
echo "alias fstop='ps aux | fzf'" >> /home/$SUDO_USER/.bash_aliases
echo "alias showtime='date +%T | figlet'" >> /home/$SUDO_USER/.bash_aliases

# Reload the .bashrc file
source /home/$SUDO_USER/.bashrc

echo "==> Provisioning of this system is complete."

exit 0
