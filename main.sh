#!/bin/bash
set -euo pipefail

# Change to the path of main script
cd "$(dirname "$0")" || exit 1

# Paths to your scripts
DOCKER_SCRIPT="docker.sh"
MSSQL_SCRIPT="mssql.sh"
FF_FIREFOX_SCRIPT="firefox_flatpak.sh"
DEV_TERMINAL_SCRIPT="devtools_terminal.sh"
APPS_SCRIPT="postinstall_apps.sh"

while true; do
    echo "🚀 Master Setup Script Menu"
    echo "--------------------------"
    echo "1) Firefox + Flatpak setup"
    echo "2) Devtools & Terminal setup"
    echo "3) Postinstall apps"
    echo "4) Docker Engine"
    echo "5) MSSQL Server 2022"
    echo "0) Exit"
    echo -n "Choose an option: "
    read -r choice

    case "$choice" in
        1)
            bash "$FF_FIREFOX_SCRIPT"
            ;;
        2)
            bash "$DEV_TERMINAL_SCRIPT"
            ;;
        3)
            bash "$APPS_SCRIPT"
            ;;
        4)
            bash "$DOCKER_SCRIPT"
            ;;
        5)
            bash "$MSSQL_SCRIPT"
            ;;
        0)
            echo -e "\n👋 Exiting master setup."
            break
            ;;
        *)
            echo "⚠️ Invalid option, please try again."
            ;;
    esac

    echo -e "✅ Script finished. Returning to menu...\n"
done
