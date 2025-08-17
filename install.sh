#!/bin/bash
# Installing Linux Dependencies and Packages
# Arch Linux

echo "Update sys."
sudo pacman -Syu --noconfirm

echo "multilib"
sudo sed -i 's/#$multilib$/$multilib$/' /etc/pacman.conf
sudo pacman -Sy --noconfirm

sudo pacman -S --noconfirm \
	mesa \
	lib32-mesa \
	vulkan-radeon \
	amdgpu_top \
	lact \
	nvtop \
	base-devel \
	git \
	vim \
	nvim \
	wget \
	curl \
	net-tools \
	yay \
	discord \
	steam \
	jetbrains-toolbox \
	kitty \
	obsidian \
	amd-ucode \
	firefox-developer-edition \
	sdl3 \
	os-prober \



yay -S spotify
yay -S lmstudio


sudo usermod -aG wheel $USER  # if not already added
sudo usermod -aG audio $USER
sudo usermod -aG video $USER
sudo usermod -aG input $USER

