#!/bin/bash

sudo pacman -S --needed --noconfirm \
  1password-beta \
  1password-cli \
  aws-cli-v2

yay -S --needed --noconfirm \
  android-tools \
  android-sdk \
  android-studio \
  awsvpnclient \
  heroku-cli

if [[ -z "$HOMEBREW_GITHUB_API_TOKEN" ]]; then
  echo "We need to set a Github access token to get access to the Cleo CLI."
  echo "If you don't already have one create one now:"
  echo "  https://github.com/settings/tokens/new?scopes=repo&description=Homebrew%20token"
  echo ""
  read -p $'Enter your github token:\n' TOKEN
  export HOMEBREW_GITHUB_API_TOKEN=$TOKEN
  echo "export HOMEBREW_GITHUB_API_TOKEN=$TOKEN" >>$HOME/.zshrc
fi

brew tap meetcleo/cleo
brew install meetcleo/cleo/cleo
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
mise plugin i yarn >/dev/null 2>&1
mise install
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

if ! cat $HOME/.aws/config | grep "\[profile Engineer-878877078763\]"; then
  mkdir -p $HOME/.aws
  echo "[profile Engineer-878877078763]
sso_start_url = https://meetcleo.awsapps.com/start/#
sso_region = us-east-1
sso_account_id = 878877078763
sso_role_name = Engineer
region = us-east-1
" >>$HOME/.aws/config
fi

if [[ -z "$(echo $AWS_DEFAULT_PROFILE)" ]]; then
  echo "export AWS_DEFAULT_PROFILE=Engineer-878877078763" >>$HOME/.zshrc
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

echo "$(lpass show "Cleo SSH" --field="Public Key")" >$HOME/.ssh/id_cleo.pub
echo "$(lpass show "Cleo SSH" --field="Private Key")" >$HOME/.ssh/id_cleo
chmod 0600 ~/.ssh/id_cleo

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
