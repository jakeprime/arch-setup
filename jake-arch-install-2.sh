# now we have ch-rooted into the system
echo "Setting locale to London..."
ln -sf /usr/share/zoneinfo/Europe/London /etc/localtime
hwclock --systohc
sed -i 's/#en_GB.UTF-8/en_GB.UTF-8/g' /etc/locale.gen
locale-gen
echo LANG=en_GB.UTF-8 > /etc/local.conf

echo "Setting hostname"
echo archibald > /etc/hostname

echo "Set root password..."
passwd

echo "Initialising GRUB boot manager..."
default_boot_disk="nvme0n1p2"
read -p "Boot disk? ($default_boot_disk): " boot_disk
if [[ -z $boot_disk ]]; then boot_disk=$default_boot_disk; fi
pacman -Syu --needed grub efibootmgr
mount /dev/$boot_disk /boot
grub-install --efi-directory=/boot --target=x86_64-efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg


