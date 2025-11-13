#!/bin/bash
set -euo pipefail

REPO_URL="https://raw.githubusercontent.com/kadirozdmrr/ubuntu-setup-scripts/main"
WORKDIR="$HOME/.ubuntu-setup-scripts"
MAIN_SCRIPT="main.sh"
cd "$WORKDIR" || { echo "❌ Scripts folder not found."; exit 1; }

# Check for --silent flag
SILENT=false
if [[ "${1:-}" == "--silent" ]]; then
    SILENT=true
fi

SCRIPTS=("docker.sh" "mssql.sh" "firefox_flatpak.sh" "devtools_terminal.sh" "app_installer.sh" "external_deb_updater.sh" "main.sh")

for script in "${SCRIPTS[@]}"; do
    echo "🔄 Updating $script..."
    curl -fsSL "$REPO_URL/$script" -o "$WORKDIR/$script"
    chmod +x "$WORKDIR/$script"
done

echo -e "\n✅ All scripts updated successfully!"

# Relaunch main.sh unless --silent is passed
if ! $SILENT; then
    if [[ -f "$WORKDIR/$MAIN_SCRIPT" ]]; then
        echo "🚀 Relaunching main script..."
        exec bash "$WORKDIR/$MAIN_SCRIPT"
    else
        echo "⚠️ Main script not found. You can run it manually: $WORKDIR/$MAIN_SCRIPT"
    fi
fi
