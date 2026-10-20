#!/bin/bash

source "$(dirname "${BASH_SOURCE[0]}")/xdg.sh"

yay -S --needed --noconfirm lastpass-cli

if ! lpass status; then
  export LPASS_AGENT_TIMEOUT=0
  lpass login "$(git config get user.email)"

  echo "$(lpass show --notes .authinfo)" >$HOME/.authinfo
fi

mkdir -p $HOME/.ssh
if [[ ! -f "$HOME/.ssh/id_archibald" ]]; then
  echo "$(lpass show ssh/id_archibald --field="Public Key")" > $HOME/.ssh/id_archibald.pub
  echo "$(lpass show ssh/id_archibald --field="Private Key")" > $HOME/.ssh/id_archibald
  chmod 0600 $HOME/.ssh/id_archibald
  eval $(ssh-agent -s)
  ssh-add $HOME/.ssh/id_archibald
fi

if [[ $(ssh git@github.com 2>&1 | grep denied) ]]; then
  eval $(ssh-agent -s)
  ssh-add $HOME/.ssh/id_archibald
fi

if ! pass; then
  sudo pacman -S --needed --noconfirm pass
  echo "$(lpass show gpg/jake@jakeprime.com --field="Public Key")" | gpg --import
  echo "$(lpass show gpg/jake@jakeprime.com --field="Private Key")" | gpg --import
  # set to ultimate trust level (5)
  printf 'trust\n5\ny\nsave\n' |
    gpg --batch --yes --no-tty --command-fd 0 --status-fd 2 --edit-key jake@jakeprime.com

  mkdir -p $PASSWORD_STORE_DIR
  git clone git@github.com:jakeprime/secrets $PASSWORD_STORE_DIR
fi
