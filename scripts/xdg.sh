#!/bin/bash

export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

xdg_cache() {
  xdg_set_and_create_dir "$XDG_CACHE_HOME" "$@"
}

xdg_config() {
  xdg_set_and_create_dir "$XDG_CONFIG_HOME" "$@"
}

xdg_data() {
  xdg_set_and_create_dir "$XDG_DATA_HOME" "$@"
}

xdg_set_and_create_dir() {
  local xdg_dir=$1
  local env_name=$2
  local env_value=$3
  local dir_name=${4:-$3}

  export "$env_name"="$xdg_dir/$env_value"
  [ -d "$xdg_dir/$dir_name" ] || mkdir -p "$xdg_dir/$dir_name"
}

# some already exist and need to move
export GNUPGHOME="$XDG_DATA_HOME/gnupg"
if [[ -d "$HOME/.gnupg" ]]; then
  mv "$HOME/.gnupg" "$GNUPGHOME"
fi

xdg_cache "BUNDLE_USER_CACHE" bundle
xdg_cache "ZSH_COMPDUMP" "zsh/zcompdump-$ZSH_VERSION" zsh

xdg_config "AWS_CONFIG_FILE" aws/config aws
xdg_config "AWS_SHARED_CREDENTIALS_FILE" aws/credentials aws
xdg_config "BUNDLE_USER_HOME" bundle
xdg_config "KUBECONFIG" kube/config.yml kube
xdg_config "NPM_CONFIG_USERCONFIG" npm/npmrc npm
xdg_config "SPACEMACSDIR" spacemacs

# xdg_data "CLAUDE_CONFIG_DIR" claude
# xdg_data "CODEX_HOME" codex
xdg_data "GNUPGHOME" gnupg
xdg_data "HISTFILE" zsh/history zsh
xdg_data "HOMESICKDIR" homesick
xdg_data "PASSWORD_STORE_DIR" pass
# xdg_data "PI_CODING_AGENT_DIR" pi/agent pi
xdg_data "PSQL_HISTORY" pg/history pg
xdg_data "ZSH" oh-my-zsh
xdg_data "ZSHZ_DATA" zsh/z zsh

# NPM paths are configured from its rc file
[ -f "$XDG_CONFIG_HOME/npm/npmrc" ] || echo 'prefix=${XDG_DATA_HOME}/npm
cache=${XDG_CACHE_HOME}/npm
init-module=${XDG_CONFIG_HOME}/npm/config/npm-init.js
logs-dir=${XDG_STATE_HOME}/npm/logs' > "$XDG_CONFIG_HOME/npm/npmrc"

# isync
alias mbsync="mbsync -c $XDG_CONFIG_HOME/isync/mbsyncrc"

export MISE_SHIMS="$XDG_DATA_HOME/mise/shims"
