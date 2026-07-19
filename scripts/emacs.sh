#!/bin/bash

if [[ -z "$(which emacs)" ]]; then
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

  git clone https://github.com/syl20bnr/spacemacs $HOME/.emacs.d
  mkdir -p $HOME/.emacs.d/autosaves
fi
