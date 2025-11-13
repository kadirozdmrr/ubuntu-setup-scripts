#!/bin/bash
set -euo pipefail

WORKDIR="$HOME/.ubuntu-setup-scripts"
cd "$WORKDIR" || { echo "❌ Scripts folder not found. Run downloader.sh first."; exit 1; }

# Scripts
DOCKER_SCRIPT="docker.sh"
MSSQL_SCRIPT="mssql.sh"
FIREFOX_SCRIPT="firefox_apt.sh"
FLATPAK_SETUP_SCRIPT="flatpak_setup.sh"
DEV_TERMINAL_SCRIPT="devtools_terminal.sh"
APPS_SCRIPT="app_installer.sh"
APP_UPDATER_SCRIPT="external_deb_updater.sh"
SCRIPT_UPDATER_SCRIPT="script_updater.sh"


# Menu loop
while true; do
    echo "🚀 Master Setup Script Menu"
    echo "--------------------------"
    echo "1) Firefox From Mozilla's Apt Repo Setup"
    echo "2) Flatpak Setup"
    echo "3) Devtools & Terminal Setup"
    echo "4) App Installer"
    echo "5) Docker Engine"
    echo "6) MSSQL Server 2022"
    echo "7) Only Update Scripts"
    echo "8) Update the System (Including External .deb Packages and Scripts)"
    echo "0) Exit"
    read -rp "Choose an option: " choice

    case "$choice" in
        1) bash "$FIREFOX_SCRIPT" ;;
        2) bash "$FLATPAK_SETUP_SCRIPT" ;;
        3) bash "$DEV_TERMINAL_SCRIPT" ;;
        4) bash "$APPS_SCRIPT" ;;
        5) bash "$DOCKER_SCRIPT" ;;
        6) bash "$MSSQL_SCRIPT" ;;
        7) exec bash "$SCRIPT_UPDATER_SCRIPT" ;;
        8) 
    echo -e "🔄 Updating the system packages...\n"
    sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y
    echo -e "\n✅ System packages are updated!\n"

    echo -e "\n🔄 Updating the flatpak packages...\n"
    if command -v flatpak &> /dev/null; then
        flatpak update -y
        echo -e "\n✅ Flatpak packages are updated!\n"
    else
        echo "\n⚠️ Flatpak not installed — skipping Flatpak updates."
    fi

    echo -e "\n🔄 Updating snap packages...\n"
    if command -v snap &> /dev/null; then
        sudo snap refresh
        echo -e "\n✅ Snap packages are updated!\n"
    else
        echo "\n⚠️ Snap not installed — skipping Snap updates."
    fi

    echo -e "\n🔄 Updating scripts...\n"
    bash "$HOME/.ubuntu-setup-scripts/script_updater.sh" --silent
    echo -e "\n✅ Scripts are updated!\n"

    echo -e "\n🔄 Updating external .deb packages...\n"
    bash "$HOME/.ubuntu-setup-scripts/external_deb_updater.sh"
    echo -e "\n✅ External .deb packages are updated!\n"

    echo -e "\n🎉 System updates completed! A reboot is recommended."
    ;;

        0) echo "👋 Exiting."; break ;;
        *) echo "⚠️ Invalid option." ;;
    esac
    echo
done
