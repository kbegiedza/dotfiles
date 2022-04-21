#!/bin/bash

function ban_snap() {
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
}

function generate_ssh_gpg() {
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
}

function install_dependencies() {
    sudo apt update &&
    sudo apt install -y \
        vim \
        apt-transport-https \
        ca-certificates \
        lsb-release \
        curl \
        gnupg2 \
        xclip \
        net-tools \
        gnome-sushi
}

function install_dev_tools() {
    ## install vs code
    VS_CODE_TMP='/tmp/vscode_deb_x64'
    VS_CODE_URL='https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64'
    curl -L $VS_CODE_URL -o $VS_CODE_TMP &&
    sudo dpkg -i $VS_CODE_TMP &&
    sudo rm $VS_CODE_TMP &&

    ## install docker
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
         $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    sudo apt-get update &&
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io &&
    sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose &&
    sudo chmod +x /usr/local/bin/docker-compose

    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

    sudo groupadd docker
    sudo usermod -aG docker $USER
    newgrp docker
}

function install_extras() {
    wget -O- https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor > signal-desktop-keyring.gpg cat signal-desktop-keyring.gpg | sudo tee -a /usr/share/keyrings/signal-desktop-keyring.gpg > /dev/null
    echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main' |\
    sudo tee -a /etc/apt/sources.list.d/signal-xenial.list
    sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
    sudo apt update
    sudo apt install brave-browser signal-desktop
}

install_dependencies &&
ban_snap &&
generate_ssh_gpg &&
install_dev_tools &&
install_extras &&
bash "`dirname $0`/install.sh"
