#!/bin/bash

source "$(dirname "${BASH_SOURCE[0]}")/xdg.sh"

sudo pacman -S --needed --noconfirm \
  zsh zsh-autosuggestions


mkdir -p /tmp/arch-setup

if [[ ! -f "/tmp/arch-install/zsh" ]]; then
  rm -r $ZSH
  CHSH=no RUNZSH=no KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH/custom/plugins/zsh-autosuggestions
  touch /tmp/arch-setup/zsh
fi

sudo chsh -s $(which zsh) $(whoami)
