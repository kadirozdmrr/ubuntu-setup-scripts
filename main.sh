#!/bin/bash
set -euo pipefail

WORKDIR="$HOME/.ubuntu-setup-scripts"
cd "$WORKDIR" || { echo "❌ Scripts folder not found. Run downloader.sh first."; exit 1; }

# Scripts
DOCKER_SCRIPT="docker.sh"
MSSQL_SCRIPT="mssql.sh"
FF_FIREFOX_SCRIPT="firefox_flatpak.sh"
DEV_TERMINAL_SCRIPT="devtools_terminal.sh"
APPS_SCRIPT="app_installer.sh"
APP_UPDATER_SCRIPT="external_deb_updater.sh"
SCRIPT_UPDATER_SCRIPT="script_updater.sh"


# Menu loop
while true; do
    echo "🚀 Master Setup Script Menu"
    echo "--------------------------"
    echo "1) Firefox + Flatpak setup"
    echo "2) Devtools & Terminal setup"
    echo "3) App Installer"
    echo "4) Docker Engine"
    echo "5) MSSQL Server 2022"
    echo "6) Update Scripts"
    echo "7) Update External .deb Packages"
    echo "0) Exit"
    read -rp "Choose an option: " choice

    case "$choice" in
        1) bash "$FF_FIREFOX_SCRIPT" ;;
        2) bash "$DEV_TERMINAL_SCRIPT" ;;
        3) bash "$APPS_SCRIPT" ;;
        4) bash "$DOCKER_SCRIPT" ;;
        5) bash "$MSSQL_SCRIPT" ;;
        6) bash "$SCRIPT_UPDATER_SCRIPT" ;;
        7) bash "$APP_UPDATER_SCRIPT" ;;    
        0) echo "👋 Exiting."; break ;;
        *) echo "⚠️ Invalid option." ;;
    esac
    echo
done
