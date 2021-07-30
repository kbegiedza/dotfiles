#!/usr/bin/env bash

TXT_GREEN=`tput setaf 2`
TXT_NORMAL=`tput sgr0`

function copyToHome() {
    rsync --exclude ".osx" \
            --exclude ".git/" \
            --exclude ".DS_Store" \
            --exclude "README.md" \
            --exclude "install.sh" \
            -avh --no-perms . ~;
    source ~/.bash_profile;
}

function startInstallation() {
    START_PWD=$(pwd);
    cd "$(dirname "${BASH_SOURCE}")";

    copyToHome;

    cd $START_PWD;
    printf "${TXT_GREEN}\nInstallation completed!\nReady to hack!\n${TXT_NORMAL}";
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