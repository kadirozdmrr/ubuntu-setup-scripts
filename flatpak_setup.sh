#!/bin/bash

set -euo pipefail

# --- Flatpak setup ---
echo -e "\n🚀 Starting Flatpak setup..."
sudo apt install -y flatpak gnome-software-plugin-flatpak
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
echo -e "\n🎉 Flatpak and Flathub setup completed successfully, restart your PC when possible."