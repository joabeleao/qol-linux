#!/bin/bash

#
# Basic app/tools/themes installer
#

# username for setting tweaks to user
USERNAME='INSERUSERNAME'

# Basic apps for system, filesystem and network management; development and utility tools 
APPS=("curl" "wget" "vim" "neovim" "nmap" "tcpdump" "lsof" "rsync" "iftop" "whois" "bmon" "htop" "net-tools" "sngrep" "openvpn" "python3" "python3-pip" "flatpak" "gnome-software-plugin-flatpak" "gnome-shell-extensions" "gnome-tweaks" "fonts-powerline")

# Basic flatpak apps for office suite, graphic, communication, audio, utility apps, \
# development and database tools
FLATPAKAPPS=("com.wps.Office" "org.glimpse_editor.Glimpse" "org.inkscape.Inkscape" "org.audacityteam.Audacity" "com.discordapp.Discord" "com.spotify.Client" "com.microsoft.Edge" "app/org.telegram.desktop/x86_64/stable" "rest.insomnia.Insomnia" "com.visualstudio.code" "app.resp.RESP" "app/io.dbeaver.DBeaverCommunity/x86_64/stable")

# Icons themes
THEMES[0]='https://github.com/yeyushengfan258/Reversal-icon-theme'
THEMES[1]='https://github.com/cbrnix/Flatery.git'
THEMES[2]='https://github.com/vinceliuice/Tela-icon-theme'
THEMES[3]='https://github.com/bikass/kora'
# Shell themes
THEMES[4]='https://github.com/vinceliuice/Fluent-gtk-theme'
THEMES[5]='https://github.com/vinceliuice/WhiteSur-gtk-theme'
THEMES[6]='https://github.com/vinceliuice/Orchis-theme'
THEMES[7]='https://github.com/andresgongora/synth-shell'
# Vim themes
THEMES[8]='https://github.com/joabeleao/qol-vim'

# Wallpaper download
curl --output /home/"${USERNAME}"/Downloads/wallpaper.jpg \
	    https://images.pexels.com/photos/691668/pexels-photo-691668.jpeg?\
	    cs=srgb&dl=pexels-eberhard-grossgasteiger-691668.jpg&fm=jpg

function qol_apps() {

	# Update and install apps
	apt update -y && sudo apt upgrade -y
	apt install -y "${APPS[@]}"

	# Install apps via flatpak
	flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
	for app in "${FLATPAKAPPS[@]}"; do
	        flatpak install -y "${app}"
	done
	
	# update after install
	apt update -y && sudo apt upgrade -y

}

function qol_bashrc() {

	# bashrc tweaks for better aliases and history
	echo -e "
	# better settings
	alias ls='ls -lahtr --color'
	alias grep='grep --color'
	# optional
	alias vim='nvim'
	# better history
	export HISTSIZE=50000
	export HISTFILESIZE=\$HISTSIZE
	export HISTTIMEFORMAT="%d/%m/%y"
	export editor='nvim'" >> /home/"${USERNAME}"/.bashrc

}

function qol_ssh() {

	# Generate rsa key with password
	ssh-keygen -t ed25519 && ssh-keygen -t rsa -b 4096

}

function qol_themes() {

	for theme in "${THEMES[@]}"; do

        # get project name
		IFS=/ read protocol bar1 bar2 user project <<< "${theme}"

		# Download and install
		cd /home/"${USERNAME}"
		git clone "${theme}"
		cd "${project}"

		# specific tweaks
        if [ "${project}" == "kora" ]; then
			cp -rv kora* /usr/share/icons
        elif [ "${project}" == "Fluent-gtk-theme" ]; then
			./install.sh --tweaks blur
        elif [ "${project}" == "WhiteSur-gtk-theme" ]; then
			killall firefox
			./install.sh -i ubuntu
			./tweaks.sh -f monterey
			./tweaks.sh -g -b "/home/${USERNAME}/Downloads/walllpaper.jpg"   
        elif [ "${project}" == "Orchis-theme" ]; then
			./install.sh -l
        elif [ "${project}" == "synth-shell" ]; then
			chmod +x synth-shell/setup.sh
			./setup.sh
		else
			./install.sh
		fi

	done
	
}

qol_apps
qol_bashrc
qol_ssh
qol_themes
