#!/bin/bash

eval $(ssh-agent -s)
ssh-add $HOME/.ssh/id_archibald

if [[ $(ssh git@github.com 2>&1 | grep denied) ]]; then
  sudo pacman -S --needed --noconfirm magic-wormhole

  export SSH_KEY=id_$(hostname)

  echo "Generating SSH key"
  mkdir -p $HOME/.ssh
  chmod 0700 $HOME/.ssh

  if [ ! -f "$HOME/.ssh/$SSH_KEY" ]; then
    ssh-keygen -t ed25519 -C "$(git config get user.email)" -f "$HOME/.ssh/$SSH_KEY" -N ""
  fi

  # we need to add this to Github, which will require another computer
  set pipefail +E
  echo "$(tput bold)Add this key to Github using wormhole$(tput sgr0)"
  /usr/bin/wormhole send --hide-progress --no-qr $HOME/.ssh/$SSH_KEY.pub
  set pipefail +E

  echo ""
  read -n1 -s -r -p "Press enter when key has been added to Github..." </dev/tty

  # add fingerprint
  echo "github.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl
  " >>$HOME/.ssh/known_hosts

  eval $(ssh-agent -s)
  ssh-add $HOME/.ssh/$SSH_KEY
fi
