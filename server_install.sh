#!/bin/bash

TXT_GREEN=`tput setaf 2`
TXT_NORMAL=`tput sgr0`

function copyToHome() {
    rsync --exclude ".osx" \
            --exclude ".git/" \
            --exclude ".DS_Store" \
            --exclude "README.md" \
            --exclude "install.sh" \
            --exclude ".gitconfig" \
            --exclude "README_FRESH.md" \
            --exclude "fresh_install.sh" \
            --exclude "server_install.sh" \
            -avh --no-perms "$(dirname "${BASH_SOURCE}")" ~;
    source ~/.bash_profile;
    source ~/.bashrc;
}

function startInstallation() {
    copyToHome
    install_dependencies

    printf "${TXT_GREEN}\nServer installation completed!\n${TXT_NORMAL}";
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
	net-tools &&
    rm /usr/share/keyrings/docker-archive-keyring.gpg &&
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg &&
    echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null &&
    sudo apt update &&
    sudo apt install -y \
        docker-ce \
        docker-ce-cli \
        containerd.io
}

set -e;

if [ "$1" == "--force" -o "$1" == "-f" ]; then
	startInstallation;
else
    read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
    printf "\n";

    if [[ $REPLY =~ ^[Yy]$ ]]; then
        startInstallation
    fi;
fi;
