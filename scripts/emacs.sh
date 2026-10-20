#!/bin/bash

source "$(dirname "${BASH_SOURCE[0]}")/xdg.sh"

mkdir -p /tmp/arch-install

if [[ ! -f "/tmp/arch-install/emacs" ]]; then
  sudo pacman -S --needed --noconfirm \
    libgccjit libxpm tree-sitter

  DIR=/tmp/$(uuidgen)
  mkdir -p $DIR
  pushd $DIR

  git init
  git remote add origin https://github.com/jakeprime/emacs
  git fetch origin jakeprime --depth=1
  git checkout jakeprime

  ./autogen.sh
  ./configure --with-native-compilation --with-pgtk --with-tree-sitter
  sudo make install -j $(nproc)

  popd

  rm -rf ~HOME/.emacs.d

#  git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs
#  ~/.config/emacs/bin/doom install

  git clone https://github.com/syl20bnr/spacemacs $XDG_CONFIG_HOME/emacs
  mkdir -p $XDG_CONFIG_HOME/emacs/autosaves

  touch /tmp/arch-install/emacs
fi
