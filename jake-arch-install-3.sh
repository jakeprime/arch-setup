read -p "Connect to wifi? (Y/n): " confirm_wifi
if [[ $confirm_wifi == [Yy] || -z "$confirm_wifi" ]];
then
	default_ssid="Henry V"
	read -p "Network? ($default_ssid): " ssid
        if [[ -z $ssid ]]; then ssid=$default_ssid; fi

	read -p "WiFi password: " wifi_password
	echo "Connecting to $ssid..."
	systemctl --now enable NetworkManager
	nmcli device wifi connect "$ssid" password "$wifi_pasword"
fi

pacman -Syu --needed base-devel git man-db man-pages sudo vim which

read -p "Create user? (Y/n): " confirm_user
if [[ $confirm_user == [Yy] || -z "$confirm_user" ]];
then
	read -p "User name? (jake): " user_name
	if [[ -z $user_name ]]; then user_name="jake"; fi
	
	useradd -m "$user_name"
	passwd "$user_name"
	printf "Press any key to edit the sudoers file and add the following:\n\n$user_name ALL=(ALL:ALL) ALL\n"
	read -p "..."
	EDITOR=vim visudo
	su "$user_name";
fi

echo "Installing yay..."
git clone https://aur.archlinux.org/yay.git /tmp/yay
cd /tmp/yay
makepkg -si



