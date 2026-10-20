#!/bin/bash

source "$(dirname "${BASH_SOURCE[0]}")/xdg.sh"

sudo pacman -S --needed --noconfirm pipewire-zeroconf

sudo systemctl enable --now avahi-daemon.service
