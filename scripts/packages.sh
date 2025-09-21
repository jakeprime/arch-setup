#!/bin/bash

sudo pacman -S --needed --noconfirm \
  bc \
  cliphist \
  evtest \
  git-delta \
  intel-media-driver \
  isync \
  keychain \
  pass \
  tmux \
  wdiff

CC=gcc-14 yay -S --needed --noconfirm \
  lastpass-cli \
  mu
