#!/bin/bash

export PATH="$PATH:/home/linuxbrew/.linuxbrew/bin"
if [[ -z "$(which brew)" ]]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
