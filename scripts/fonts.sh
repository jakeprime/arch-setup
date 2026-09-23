#!/bin/bash

sudo pacman -S --needed --noconfirm \
     awesome-terminal-fonts \
     fontconfig \
     otf-monaspace-nerd \
     nerd-fonts \
     noto-fonts \
     noto-fonts-emoji \
     powerline-fonts

mkdir -p ~/.local/share/fonts
curl -L https://raw.githubusercontent.com/jakeprime/arch-setup/main/fonts/SourceSans3-VariableFont_wght.ttf > ~/.local/share/fonts/SourceSans3-VariableFont_wght.ttf
curl -L https://raw.githubusercontent.com/jakeprime/arch-setup/main/fonts/SourceSans3-Italic-VariableFont_wght.ttf > ~/.local/share/fonts/SourceSans3-Italic-VariableFont_wght.ttf
curl -L https://raw.githubusercontent.com/jakeprime/arch-setup/main/fonts/Baumans-Regular.ttf > ~/.local/share/fonts/Baumans-Regular.ttf
fc-cache -f -v
