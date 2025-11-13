#!/bin/bash
set -euo pipefail

# ------------------------------
# Ubuntu Setup - Master Menu Script
# ------------------------------

REPO_URL="https://raw.githubusercontent.com/kadirozdmrr/ubuntu-setup-scripts/main"
WORKDIR="$HOME/.ubuntu-setup-scripts"

# Script names
DOCKER_SCRIPT="docker.sh"
MSSQL_SCRIPT="mssql.sh"
FF_FIREFOX_SCRIPT="firefox_flatpak.sh"
DEV_TERMINAL_SCRIPT="devtools_terminal.sh"
APPS_SCRIPT="app_installer.sh"

SCRIPTS=("$DOCKER_SCRIPT" "$MSSQL_SCRIPT" "$FF_FIREFOX_SCRIPT" "$DEV_TERMINAL_SCRIPT" "$APPS_SCRIPT")

# Create working dir
mkdir -p "$WORKDIR"
cd "$WORKDIR" || exit 1

echo "📦 Checking and downloading setup scripts from GitHub if missing..."

# Download scripts if not found
for script in "${SCRIPTS[@]}"; do
    if [[ ! -f "$WORKDIR/$script" ]]; then
        echo "⬇️  Downloading $script..."
        curl -fsSL "$REPO_URL/$script" -o "$WORKDIR/$script"
        chmod +x "$WORKDIR/$script"
    else
        echo "✅ $script already exists, skipping download."
    fi
done

echo -e "\n✅ All required setup scripts are ready.\n"

# Main menu loop
while true; do
    echo "🚀 Master Setup Script Menu"
    echo "--------------------------"
    echo "1) Firefox + Flatpak setup"
    echo "2) Devtools & Terminal setup"
    echo "3) App Installer"
    echo "4) Docker Engine"
    echo "5) MSSQL Server 2022"
    echo "6) Update scripts"
    echo "0) Exit"
    echo -n "Choose an option: "
    read -r choice

    case "$choice" in
        1) bash "$FF_FIREFOX_SCRIPT" ;;
        2) bash "$DEV_TERMINAL_SCRIPT" ;;
        3) bash "$APPS_SCRIPT" ;;
        4) bash "$DOCKER_SCRIPT" ;;
        5) bash "$MSSQL_SCRIPT" ;;
        6)
            echo "🔄 Updating all scripts from GitHub..."
            for script in "${SCRIPTS[@]}"; do
                curl -fsSL "$REPO_URL/$script" -o "$WORKDIR/$script"
                chmod +x "$WORKDIR/$script"
                echo "✅ Updated $script"
            done
            echo "✅ All scripts updated successfully!"
            ;;
        0)
            echo -e "\n👋 Exiting master setup."
            break
            ;;
        *)
            echo "⚠️ Invalid option, please try again."
            ;;
    esac

    echo -e "\n✅ Script finished. Returning to menu...\n"
done
