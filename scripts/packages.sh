#!/bin/bash

sudo pacman -S --needed --noconfirm \
  bc \
  cliphist \
  evtest \
  foot \
  git-delta \
  isync \
  keychain \
  pass \
  tmux \
  wdiff

CC=gcc-14 yay -S --needed --noconfirm \
  lastpass-cli \
  mu
