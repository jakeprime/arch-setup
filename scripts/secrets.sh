#!/bin/bash

if ! lpass status; then
  export LPASS_AGENT_TIMEOUT=0
  lpass login "$(git config get user.email)"

  echo "$(lpass show --notes .authinfo)" >$HOME/.authinfo
fi

if ! pass; then
  echo "$(lpass show gpg/jake@jakeprime.com --field="Public Key")" | gpg --import
  echo "$(lpass show gpg/jake@jakeprime.com --field="Private Key")" | gpg --import
  # set to ultimate trust level (5)
  printf 'trust\n5\ny\nsave\n' |
    gpg --batch --yes --no-tty --command-fd 0 --status-fd 2 --edit-key jake@jakeprime.com

  mkdir $HOME/.password-store
  cd $HOME/.password-store
  git clone git@github.com:jakeprime/secrets .
fi
