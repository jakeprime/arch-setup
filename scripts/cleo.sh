#!/bin/bash

source "$(dirname "${BASH_SOURCE[0]}")/xdg.sh"

sudo pacman -S --needed --noconfirm \
  1password-beta \
  1password-cli \
  aws-cli-v2

yay -S --needed --noconfirm \
  android-tools \
  android-sdk \
  android-studio \
  awsvpnclient

export PATH="$PATH:/home/linuxbrew/.linuxbrew/bin"
if [[ -z "$(which brew)" ]]; then
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if [[ -z "$HOMEBREW_GITHUB_API_TOKEN" ]]; then
  export HOMEBREW_GITHUB_API_TOKEN="$(pass github/homebrew 2>/dev/null)"
fi

brew tap meetcleo/cleo
brew install --yes meetcleo/cleo/cleo
cleo config tunnel port 3064
# maybe later we can get the port automatically, we can load the file with:
# gh api repos/meetcleo/ansible-nginx-devproxy/contents/onboard_engineer/vars/main.yml --jq '.content' | base64 -d

EMAIL=jake@meetcleo.com
# read -p $'What is your Cleo email adress?\n' EMAIL

if ! op account list | grep $EMAIL >/dev/null; then
  echo "Setting up 1password cli access"
  read -p $'You will need your 1password creds for this. This will be easiest if you have the desktop application already authenticated. You can do that now and come back when ready\nPress any key to continue...\n'

  echo "Your Secret Key you can be found in the application:"
  echo "  Cleo Ai (top left of screen)"
  echo "    > Set up another device..."
  echo "    > Other options"
  echo "    > View account details"
  echo ""

  op account add --email $EMAIL --address cleoai.1password.com
fi
while ! op read "op://Tech/663renc3kvn5rgtb2zs6nmngpe/username" >/dev/null 2>&1; do
  eval $(op signin --account cleoai)
done

CLEO_DIR=$HOME/work/cleo

if [[ ! -d "$CLEO_DIR/meetcleo" ]]; then
  mkdir -p $CLEO_DIR
  pushd $CLEO_DIR
  git clone -b main git@github.com:meetcleo/meetcleo
  popd
fi

pushd $CLEO_DIR/meetcleo
git pull
bundle config set gems.contribsys.com $(op read "op://Tech/663renc3kvn5rgtb2zs6nmngpe/username"):$(op read "op://Tech/663renc3kvn5rgtb2zs6nmngpe/password")
echo "$(op read op://Tech/afbvozval6hukgqkbe2gqv62sm/env.development.local)" >.env.development.local
docker compose --profile deps create
popd

if [[ ! -d "$CLEO_DIR/mobile-app" ]]; then
  mkdir -p $CLEO_DIR
  pushd $CLEO_DIR
  git clone -b main git@github.com:meetcleo/mobile-app
  popd
fi

pushd $CLEO_DIR/mobile-app
git pull
mise install
popd

if ! cat $AWS_CONFIG_FILE 2>/dev/null | grep "\[profile Engineer-878877078763\]"; then
  echo "[profile Engineer-878877078763]
sso_start_url = https://meetcleo.awsapps.com/start/#
sso_region = us-east-1
sso_account_id = 878877078763
sso_role_name = Engineer
region = us-east-1
" >>$AWS_CONFIG_FILE
fi

if [[ -z "$(echo $AWS_DEFAULT_PROFILE)" ]]; then
  export AWS_DEFAULT_PROFILE="Engineer-878877078763"
fi

echo "Authenticating with AWS..."
AWS_DEFAULT_PROFILE=Engineer-878877078763 aws sso login

echo "Once successfully logged in get the VPN config file from here:"
echo "  https://self-service.clientvpn.amazonaws.com/endpoints/cvpn-endpoint-0922da5e8dbda9f8c"
echo ""
# Could actually do this programatically by putting the config into
# ~/.config/AWSVPNClient/OpenVpnConfigs/, but I fear any automated attempt to
# deal with the downloading of the file from a browser will be brittle AF, so
# we'll leave it like this
echo "Then start the AWS VPN Client app and import this as a profile called \"Cleo\"."
read -p $'Press any key to continue\n'

# now make it work (fuck you amazoooooooon)
# ref: https://www.notion.so/meetcleo/Connecting-to-AWS-VPN-9f4c4ee8c1da446fad7af489f2cf08a6?source=copy_link#ba4993a9f19e49518e787d6aaa4f6cea
sudo systemctl enable --now awsvpnclient
sudo systemctl enable --now systemd-resolved
sudo ln -rsf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
VPN_FILE=$HOME/.config/AWSVPNClient/OpenVpnConfigs/Cleo
echo "dhcp-option DOMAIN-ROUTE .
$(cat $VPN_FILE)" >$VPN_FILE

if ! grep cleo_development_proxy $HOME/.ssh/config >/dev/null 2>&1; then
  echo "Host cleo_development_proxy
  Hostname ip-172-31-24-153.eu-west-2.compute.internal
  User engineer
  ServerAliveInterval 5
" >>$HOME/.ssh/config
fi

echo "Launching Android Studio for the first time with wayland options."
echo "This will be remembered for future launches."
echo ""
JAVA_TOOL_OPTIONS='-Dawt.toolkit.name=WLToolkit' android-studio &
