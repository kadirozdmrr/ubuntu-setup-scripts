#!/bin/bash
set -euo pipefail

REPO_URL="https://raw.githubusercontent.com/kadirozdmrr/ubuntu-setup-scripts/main"
WORKDIR="$HOME/.ubuntu-setup-scripts"
MAIN_SCRIPT="main.sh"
cd "$WORKDIR" || { echo "❌ Scripts folder not found."; exit 1; }

echo -e "\n🔄 Updating the scripts...\n"

# --- Robust flag check ---
SILENT=false
for arg in "$@"; do
    case "$arg" in
        --silent) SILENT=true ;;
    esac
done

SCRIPTS=("docker.sh" "mssql.sh" "firefox_apt.sh" "devtools_terminal.sh" "app_installer.sh" "external_deb_updater.sh" "main.sh" "flatpak_setup.sh" "script_updater.sh")

for script in "${SCRIPTS[@]}"; do
    echo "\n🔄 Updating $script..."
    curl -fsSL "$REPO_URL/$script" -o "$WORKDIR/$script"
    chmod +x "$WORKDIR/$script"
done

echo -e "\n✅ All scripts updated successfully!"

# Relaunch main.sh unless --silent is passed
if [ "$SILENT" = false ]; then
    if [[ -f "$WORKDIR/$MAIN_SCRIPT" ]]; then
        echo "🚀 Relaunching main script..."
        exec bash "$WORKDIR/$MAIN_SCRIPT"
    else
        echo "⚠️ Main script not found. You can run it manually: $WORKDIR/$MAIN_SCRIPT"
    fi
fi
