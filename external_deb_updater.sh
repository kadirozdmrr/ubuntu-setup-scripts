#!/bin/bash
set -euo pipefail

# ==========================================
# External .deb Updater
#   Updates the following manually-installed .deb packages:
#     - Zoom
#     - Discord
#     - Heroic Games Launcher
#     - Minecraft Launcher
# ==========================================

TMP_DIR="/tmp/app-updates"
mkdir -p "$TMP_DIR"
cd "$TMP_DIR"

echo "🚀 External .deb Updater started..."
echo

# --- Helper: check if package is installed ---
is_installed() {
    dpkg -s "$1" &>/dev/null
}

# Check multiple possible package names
is_installed_any() {
    for name in "$@"; do
        if is_installed "$name"; then
            return 0
        fi
    done
    return 1
}

# --- Helper: download + update ---
update_deb() {
    local pkg_name="$1"
    local pkg_pretty="$2"
    local url="$3"

    if [[ -z "$url" ]]; then
        echo "❌ $pkg_pretty: No download URL found."
        return 1
    fi

    if ! is_installed "$pkg_name"; then
        echo "⚠️  $pkg_pretty is not installed — skipping."
        echo "   (Install it manually, then rerun this script to keep it updated.)"
        echo
        return 0
    fi

    echo "🔄 Updating $pkg_pretty..."
    local outfile="${TMP_DIR}/${pkg_name}.deb"

    echo "⬇️  Downloading latest $pkg_pretty..."
    if wget -q --show-progress -O "$outfile" "$url"; then
        echo "📦 Installing updated $pkg_pretty..."
        if sudo dpkg -i "$outfile" >/dev/null 2>&1; then
            echo "✅ $pkg_pretty updated successfully."
        else
            echo "⚠️  $pkg_pretty: fixing dependencies..."
            sudo apt-get -f install -y >/dev/null
        fi
    else
        echo "❌ Failed to download $pkg_pretty."
        return 1
    fi
    echo
}

# --- Fetch functions ---
fetch_zoom() {
    update_deb "zoom" "Zoom" "https://zoom.us/client/latest/zoom_amd64.deb"
}

fetch_discord() {
    local URL
    URL=$(curl -sI "https://discord.com/api/download?platform=linux&format=deb" \
        | tr -d '\r' | grep -i '^location:' | awk '{print $2}')
    update_deb "discord" "Discord" "$URL"
}

fetch_heroic() {
    local URL
    URL=$(curl -s https://api.github.com/repos/Heroic-Games-Launcher/HeroicGamesLauncher/releases/latest \
        | grep browser_download_url | grep '\.deb' | cut -d '"' -f 4 | head -n 1 || true)
    update_deb "heroic" "Heroic Games Launcher" "$URL"
}

fetch_minecraft() {
    update_deb "minecraft-launcher" "Minecraft Launcher" "https://launcher.mojang.com/download/Minecraft.deb"
}

# --- Main process ---
fetch_zoom
fetch_discord
fetch_heroic
fetch_minecraft

# Cleanup
rm -rf "$TMP_DIR"


