#!/bin/bash

sudo pacman -S --needed --noconfirm \
  zsh zsh-autosuggestions

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  ZSH="$HOME/.oh-my-zsh" CHSH=no RUNZSH=no KEEP_ZSHRC=yes \
     sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi

MISE_SHIMS=$HOME/.local/share/mise/shims
if [ -f $MISE_SHIMS/homesick ]; then
  $MISE_SHIMS/homesick link arch --force
fi

sudo chsh -s $(which zsh) $(whoami)
