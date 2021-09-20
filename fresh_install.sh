#!/bin/bash

sudo apt update &&
sudo apt install -y vim \
		    apt-transport-https \
		    curl &&

echo
read -p "Ban snap? (y/N)" -n 1 -r REPLY
echo

if [[ $REPLY =~ ^[Yy]$ ]]
then
	sudo rm -rf /var/cache/snapd/ &&
	sudo apt autoremove --purge snapd gnome-software-plugin-snap &&
	rm -fr ~/snap &&
	sudo apt-mark hold snapd
fi

echo
read -p "Configure ssh & gpg? (y/N)" -n 1 -r REPLY
echo

if [[ $REPLY =~ ^[Yy]$ ]]
then
	ssh-keygen -t ed25519 -C contact@kbegiedza.eu &&
	eval "$(ssh-agent -s)" &&
	gpg --full-generate-key &&
	gpg --list-secret-keys --keyid-format=long

	printf "\n\n===\nSSH\n===\n"
	cat ~/.ssh/id_ed25519.pub
	printf "\nPaste gpg keyid to command below\n gpg --armor --export <keyid>"
fi

printf "\nInstalling Visual Studio Code\n"

VS_CODE_TMP='/tmp/vscode_deb_x64'
VS_CODE_URL='https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64'
curl -L $VS_CODE_URL -o $VS_CODE_TMP &&
sudo dpkg -i $VS_CODE_TMP &&
sudo rm $VS_CODE_TMP

sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo apt update
sudo apt install brave-browser

bash "`dirname $0`/install.sh"