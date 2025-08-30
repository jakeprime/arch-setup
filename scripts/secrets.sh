#!/bin/bash

export LPASS_AGENT_TIMEOUT=0
lpass login "$(git config get user.email)"

echo "$(lpass show --notes .authinfo)" > $HOME/.authinfo

# TODO: set up `pass` here too, and import individual secrets
