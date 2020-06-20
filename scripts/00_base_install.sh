#!/bin/bash

###################################
#### 1. Internet connection    ####
###################################

# to check:
ip a
# there should be IP address set

# In case WiFi card is set, use:
wifi-menu
# choose wifi network, set login, password.

# ping some site:
ping https://archlinux.org

###################################
#### 2. Set mirror list        ####
###################################

# synchronize repositories
pacman -Syyy

# install reflector
pacman -S reflector

# update mirror list
reflector -l 100 -f 20 -c UA -c DE -c CH -c AT --sort rate --verbose --save  /etc/pacman.d/mirrorlist

 # alternatively
pacman -S curl
curl -o /etc/pacman.d/mirrorlist https://www.archlinux.org/mirrorlist/all/https
# uncomment some servers
pacman -Syu pacman-mirrorlist

pacman -Syyy

###################################
#### 3. Update system clock    ####
###################################

timedatectl set-ntp true
timedatectl status

###################################
#### 4. Disk partitioning      ####
###################################

# to get information about disk
lsblk

cfdisk /dev/nvme0n1p # path to SSD disk

###################################
#### 5. Disk formatting        ####
###################################

mkfs.ext4 /dev/nvme0n1pXXX # path to Arch partition

###################################
#### 6. Mounting               ####
###################################

mount /dev/nvme0n1pXXX /mnt # mount root

mkdir -p /mnt/boot/efi
mount /dev/nvme0n1pYYY /mnt/boot/efi # mount EFI partition

mkdir /mnt/windows
mount /dev/nmve0n1pZZZ /mnt/windows # mount Windows partition

lsblk

###################################
#### 7. Base install           ####
###################################

pacstrap /mnt base linux linux-firmware nano

###################################
#### 8. FSTAB                  ####
###################################

genfstab -U /mnt >> /mnt/etc/fstab

###################################
#### 9. Chroot                 ####
###################################

arch-chroot /mnt

###################################
#### 10. SWAP file             ####
###################################

# allocate XGb to swap
fallocate -l 8GB /swapfile
# change permission to swapfile
chmod 600 /swapfile
# format swapfile
mkswap /swapfile # as a result there will be UUID of the swap space
# activate swap
swapon --discard /swapfile

# To enable this swap partition on boot, add an entry to /etc/fstab:

UUID=device_UUID none swap defaults 0 0
# or 
/swapfile none swap defaults 0 0

###################################
#### 11. TimeZone              ####
###################################

timedatectl list-timezones | grep Kiev # list Kyiv timezone

ln -sf /usr/share/zoneinfo/Europe/Kiev /etc/localtime
# synchronize
hwclock --systohc

###################################
#### 12. Localization          ####
###################################

# Edit /etc/locale.gen
nano /etc/locale.gen
# uncomment en_US.UTF-8 UTF-8 and uk_UA.UTF-8 UTF-8
locale-gen

echo "LANG=en_US.UTF-8" >> /etc/locale.conf

###################################
#### 13. Network configuration ####
###################################

echo "carbon" >> /etc/hostname

# Edit /etc/hosts
nano /etc/hosts
# add
127.0.0.1	localhost
::1			localhost
127.0.1.1	carbon.localdomain	carbon

###################################
#### 14. Root password         ####
###################################

passwd

###################################
#### 14. GRUB                  ####
###################################

# install packages
pacman -S grub efibootmgr networkmanager network-manager-applet wireless_tools wpa_supplicant \
 dialog os-prober mtools dosfstools base-devel linux-headers git ntfs-3g openssh  

# Bluetooth:
# https://wiki.archlinux.org/index.php/bluetooth
pacman -S bluez bluez-utils pulseaudio-bluetooth

grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
# generate config file
grub-mkconfig -o /boot/grub/grub.cfg

###################################
#### 14. Enable services       ####
###################################

systemctl enable NetworkManager
systemctl enable sshd
systemctl enable bluetooth

###################################
#### 15. User settings         ####
###################################

useradd -mG wheel vyeve
passwd vyeve
# enter password
EDITOR=nano visudo
# uncomment %wheel ALL=(ALL) ALL

###################################
#### 16. Update keys           ####
###################################

#update keys
pacman-key --init
pacman-key --populate archlinux

###################################
#### 17. Reboot                ####
###################################

exit

umount -a

reboot