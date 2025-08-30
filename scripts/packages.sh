#!/bin/bash

sudo pacman -S --needed --noconfirm \
  bc \
  cliphist \
  foot \
  git-delta \
  google-chrome \
  pass \
  tmux

CC=gcc-14 yay -S --needed --noconfirm \
  lastpass-cli
