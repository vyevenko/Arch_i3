#!/bin/bash

###################################
#### 1. Internet connection    ####
###################################

ip a
# there should be set IP address

# to connect to WiFi
nmtui 

###################################
#### 2. Graphic driver         ####
###################################

sudo pacman -S xf86-video-intel mesa vulkan-intel

###################################
#### 2. Xorg server            ####
###################################

sudo pacman -S xorg

###################################
#### 3. YAY                    ####
###################################

git clone https://aur.archlinux.org/yay.git
cd yay/
makepkg -si PKGBUILD
cd ../
rm -rf yay/