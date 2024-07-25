echo "Creating partitions..."
default_disk="nvme0n1"

read -p "Disk name? ($default_disk): " disk_name
if [[ -z $disk_name ]]; then disk_name="$default_disk"; fi

echo "Opening fdisk. Create 3 partitions:"
echo "  Boot partition: 1G"
echo "  Swap partition: 16G"
echo "  OS partition: All remaining space"
read -p "Press any key..."

fdisk /dev/$disk_name

default_boot_p="p2"
default_swap_p="p3"
default_os_p="p4"

read -p "Boot partition? (p2): " boot_p
read -p "Swap partition? (p3): " swap_p
read -p "OS partition? (p4): " os_p

if [[ -z $boot_p ]]; then boot_p="$default_boot_p"; fi
if [[ -z $swap_p ]]; then swap_p="$default_swap_p"; fi
if [[ -z $os_p ]]; then os_p="$default_os_p"; fi

# format partitions
echo "Formatting partitions..."
# boot partition
mkfs.fat -F 32 /dev/$disk_name$boot_p
# swap
mkswap /dev/$disk_name$swap_p
# root partition
mkfs.ext4 /dev/$disk_name$os_p

# mount the drives
echo "Mounting..."
mount /dev/$disk_name$os_p /mnt
mount --mkdir /dev/$disk_name$boot_p /mnt/boot
swapon /dev/$disk_name$swap_p

# install linux!
echo "Installing linux!..."
pacstrap -K /mnt base linux linux-firmware linux-headers intel-ucode iwd networkmanager sof-firmware sudo vim

# copy the installer scripts onto new installation drive
default_usb_p="sda2"
read -p "USB partition? ($default_usb_p): " usb_p
if [[ -z $usb_p ]]; then usb_p=$default_usb_p; fi
mount --mkdir /dev/$usb_p /mnt/usb
cp /mnt/usb/jake* /mnt/usr/local/sbin/

# enter the filesystem
read -p "Confirm fstab is correct. Press any key..."
genfstab -U /mnt >> /mnt/etc/fstab
vim /mnt/etc/fstab

echo "Now chroot-ing into the installed operating system."
echo "Once there run jake-arch-install-2.sh to continue."
read -p "Press any key..."
arch-chroot /mnt
