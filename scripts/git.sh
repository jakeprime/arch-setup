#!/bin/bash

source "$(dirname "${BASH_SOURCE[0]}")/xdg.sh"

sudo pacman -S --needed --noconfirm git-delta gitleaks

git config --global user.name "Jake Prime"
git config --global user.email "jake@jakeprime.com"
