#!/bin/bash
set -euo pipefail

REPO_URL="https://raw.githubusercontent.com/kadirozdmrr/ubuntu-setup-scripts/main"
WORKDIR="$HOME/.ubuntu-setup-scripts"
MAIN_SCRIPT="main.sh"
mkdir -p "$WORKDIR"
cd "$WORKDIR" || exit 1

# Script list
SCRIPTS=("docker.sh" "mssql.sh" "firefox_flatpak.sh" "devtools_terminal.sh" "app_installer.sh" "external_deb_updater.sh" "main.sh" "script_updater.sh")

for script in "${SCRIPTS[@]}"; do
    echo "⬇️ Downloading $script..."
    curl -fsSL "$REPO_URL/$script" -o "$WORKDIR/$script"
    chmod +x "$WORKDIR/$script"
done

echo -e "\n✅ All scripts downloaded."

# Launch main script
if [[ -f "$WORKDIR/$MAIN_SCRIPT" ]]; then
    exec bash "$WORKDIR/$MAIN_SCRIPT"
else
    echo "⚠️ Main script not found. You can run it manually: $WORKDIR/$MAIN_SCRIPT"
fi
