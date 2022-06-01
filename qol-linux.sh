#!/usr/bin/env bash

#
# Basic app/tools/themes installer
#

# username for setting tweaks to user
USERNAME='myname'
# Basic apps for system, filesystem and network management and development 
APPS=("git" "curl" "wget" "vim" "neovim" "nmap" "tcpdump" "lsof" "rsync" "iftop" "whois" "bmon" "htop" "net-tools" "sngrep" "openvpn" "python3" "python3-pip" "flatpak" "gnome-software-plugin-flatpak" "gnome-shell-extensions" "gnome-tweaks" "fonts-powerline")
# log
LOG='/var/log/qol-linux'

function qol_apps() {

    # Update and install apps
    apt update -y && sudo apt upgrade -y
    apt install -y "${APPS[@]}"
    
    # Install telgram-desktop
    flatpak install --from \
        https://flathub.org/repo/appstream/org.telegram.desktop.flatpakref
    
    # update after install
    apt update -y && sudo apt upgrade -y

}

function qol_bashrc() {

    # bashrc tweaks for better aliases and history
    echo -e "
    # better settings
    alias ls=\'ls -lahtr\'
    alias grep=\'grep --color\'
    # optional
    alias vim=\'nvim\'
    # better history
    export HISTSIZE=50000
    export HISTFILESIZE=\$HISTSIZE
    export HISTTIMEFORMAT="%d/%m/%y %T "
    export editor=\'nvim\'" >> /home/"${USERNAME}"/.bashrc

}

function qol_ssh() {

    # Generate rsa key with password
    ssh-keygen -t ed25519 && ssh-keygen -t rsa -b 4096

}

function qol_themes() {

    # Wallpaper
    curl --output /home/"${USERNAME}"/Downloads/wallpaper.jpg \
        https://images.pexels.com/photos/691668/pexels-photo-691668.jpeg?\
        cs=srgb&dl=pexels-eberhard-grossgasteiger-691668.jpg&fm=jpg

    # Reversal icon theme
    git clone https://github.com/yeyushengfan258/Reversal-icon-theme
    cd Reversal-icon-theme/
    ./install.sh
    
    # Flatery icons
    git clone https://github.com/cbrnix/Flatery.git
    cd Flatery/
    ./install.sh
    
    # Tela icons
    git clone https://github.com/vinceliuice/Tela-icon-theme
    cd Tela-icon-theme
    ./install.sh
    
    # Kora icons
    git clone https://github.com/bikass/kora
    cd kora
    cp -rv kora* /usr/share/icons

    # Fluent gnome shell theme
    git clone https://github.com/vinceliuice/Fluent-gtk-theme.git
    cd Fluent-gtk-theme/
    ./install.sh --tweaks blur
    
    # Whitesur gnome shell theme
    git clone https://github.com/vinceliuice/WhiteSur-gtk-theme.git
    cd WhiteSur-gtk-theme
    ./install.sh
    ./install.sh -i ubuntu
    ./install.sh --nautilus-style -N glassy
    ./tweaks.sh -f monterey
    ./tweaks.sh -g -b '~/Downloads/walllpaper.jpg'   

    # Orchis gnome shell theme
    git clone https://github.com/vinceliuice/Orchis-theme
    cd Orchis-theme
    ./install.sh -l

    # qol-vim neovim theme, tweak and tools
    git clone https://github.com/joabeleao/qol-vim.git
    cd qol-vim
    ./install.sh

    # Synth-shell shell theme
    git clone --recursive https://github.com/andresgongora/synth-shell.git
    chmod +x synth-shell/setup.sh
    cd synth-shell
    ./setup.sh

}

qol_apps 2>&1&>> "${LOG}"
qol_bashrc 2>&1&>> "${LOG}"
qol_ssh 2>&1&>> "${LOG}"
qol_themes 2>&1&>> "${LOG}"
