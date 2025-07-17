#!/bin/sh

set -e

set_system_preferences() {
  echo "[set_system_preferences] Setting up system preferences"

  scutil --set HostName ulfmac
  scutil --set ComputerName ulfmac
  scutil --set LocalHostName ulfmac

  echo "[set_system_preferences] Installing fonts"
  brew install --cask font-jetbrains-mono
}

initialize_git() {
  echo "[initialize_git] Initializing git configuration"

  git config --global user.name "Krzysztof Begiedza"
  git config --global user.email "contact@kbegiedza.eu"
  git config --global init.defaultBranch master
}

echo "[dotfiles] Installation started"

set_system_preferences
initialize_git

brew install gpg


echo "[dotfiles] Installation done"
echo "^^Happy hacking^^"