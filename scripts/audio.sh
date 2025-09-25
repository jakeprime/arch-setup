#!/bin/bash

sudo pacman -S --needed --noconfirm pipewire-zeroconf

sudo systemctl enable --now avahi-daemon.service
