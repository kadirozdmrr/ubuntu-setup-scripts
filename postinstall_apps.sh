#!/bin/bash
set -euo pipefail

echo "🚀 Starting postinstall app setup..."

# --- Check if Flatpak exists ---
if ! command -v flatpak &> /dev/null; then
    echo "⚠️ Flatpak not found. It's highly recommended to run the Flatpak setup script first."
fi

# --- Helper Functions ---

# Ask yes/no question
ask_install() {
    local prompt="$1"
    while true; do
        read -rp "$prompt [y/n]: " yn
        case $yn in
            [Yy]*) return 0 ;;
            [Nn]*) return 1 ;;
            *) echo "Please answer y or n." ;;
        esac
    done
}

# Install .deb from URL
install_deb() {
    local url="$1"
    local name="$2"
    local tmp="/tmp/$(basename "$url")"

    echo "⬇️ Installing $name..."
    wget -O "$tmp" "$url"
    sudo apt install -y "$tmp"
    rm "$tmp"
    echo "✅ $name installed!"
    echo ""
}

# --- Steam ---
if ! command -v steam &> /dev/null && ask_install "❓Install Steam?"; then
    install_deb "https://steamcdn-a.akamaihd.net/client/installer/steam.deb" "Steam"
fi

# --- Discord ---
if ! flatpak list | grep -q com.discordapp.Discord && ask_install "❓Install Discord (Flatpak)?"; then
    echo "⬇️ Installing Discord..."
    flatpak install -y flathub com.discordapp.Discord
    echo "✅ Discord installed!"
    echo ""
fi

# --- Spotify ---
if ! command -v spotify >/dev/null 2>&1; then
    if ask_install "❓Install Spotify?"; then
        echo "Select installation method:"
        PS3="Choose 1 or 2: "
        options=("Flatpak (Community Maintained Open Source)" "Snap (Officially Supported Closed Source)")
        select opt in "${options[@]}"; do
            case $REPLY in
                1)
                    echo "⬇️ Installing Spotify via Flatpak..."
                    flatpak install -y flathub com.spotify.Client
                    echo "✅ Spotify installed via Flatpak!"
                    break
                    ;;
                2)
                    echo "⬇️ Installing Spotify via Snap..."
                    sudo snap install spotify
                    echo "✅ Spotify installed via Snap!"
                    break
                    ;;
                *)
                    echo "Please choose 1 or 2."
                    ;;
            esac
        done
    fi
fi

# --- VSCode ---
if ! command -v code &> /dev/null && ask_install "❓Install VSCode?"; then
    sudo apt install -y software-properties-common apt-transport-https wget
    wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/microsoft.gpg
    sudo add-apt-repository "deb [arch=$(dpkg --print-architecture)] https://packages.microsoft.com/repos/code stable main"
    sudo apt update
    sudo apt install -y code
    echo "✅ Visual Studio Code installed!"
    echo ""
fi

# --- Google Chrome ---
if ! command -v google-chrome &> /dev/null && ask_install "❓Install Google Chrome?"; then
    install_deb "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb" "Google Chrome"
fi

# --- OBS ---
if ! flatpak list | grep -q com.obsproject.Studio && ask_install "❓Install OBS Studio (Flatpak)?"; then
    echo "⬇️ Installing OBS Studio..."
    flatpak install -y flathub com.obsproject.Studio
    echo "✅ OBS installed!"
    echo ""
fi

# --- Heroic Games Launcher ---
if ! flatpak list | grep -q com.heroicgameslauncher.hgl && ask_install "❓Install Heroic Games Launcher (Flatpak)?"; then
    echo "⬇️ Installing Heroic Games Launcher..."
    flatpak install -y flathub com.heroicgameslauncher.hgl
    echo "✅ Heroic Games Launcher installed!"
    echo ""
fi

# --- Prism Launcher ---
if ! flatpak list | grep -q net.prismlauncher.PrismLauncher && ask_install "❓Install Prism Launcher (Flatpak)?"; then
    echo "⬇️ Installing Prism Launcher..."
    flatpak install -y flathub net.prismlauncher.PrismLauncher
    echo "✅ Prism Launcher installed!"
    echo ""
fi

# --- Zoom ---
if ! command -v zoom &> /dev/null && ask_install "❓Install Zoom?"; then
    install_deb "https://zoom.us/client/latest/zoom_amd64.deb" "Zoom"
fi

# --- qBittorrent ---
if ! command -v qbittorrent &> /dev/null && ask_install "❓Install qBittorrent?"; then
    echo "⬇️ Installing qBittorrent..."
    sudo apt install -y qbittorrent
    echo "✅ qBittorrent installed!"
    echo ""
fi

# --- GIMP ---
if ! command -v gimp &> /dev/null && ask_install "❓Install GIMP?"; then
    echo "⬇️ Installing GIMP..."
    sudo apt install -y gimp
    echo "✅ GIMP installed!"
    echo ""
fi

# --- VLC ---
if ! flatpak list | grep -q org.videolan.VLC && ask_install "❓Install VLC (Flatpak)?"; then
    echo "⬇️ Installing VLC..."
    flatpak install -y org.videolan.VLC
    echo "✅ VLC installed!"
    echo ""
fi

# --- JetBrains Toolbox ---
if [ ! -f "$HOME/.local/share/applications/jetbrains-toolbox.desktop" ]; then
    if ask_install "❓Do you want to install JetBrains Toolbox?"; then
        echo "⬇️ Downloading JetBrains Toolbox..."
        TOOLBOX_URL=$(curl -s "https://data.services.jetbrains.com/products/releases?code=TBA&latest=true&type=release" \
            | sed -n 's/.*linux":{"link":"\([^"]*\)".*/\1/p')
        TOOLBOX_TMP="/tmp/jetbrains-toolbox.tar.gz"
        curl -L -o "$TOOLBOX_TMP" "$TOOLBOX_URL"

        echo "⬇️ Extracting JetBrains Toolbox..."
        mkdir -p "$HOME/jetbrains-toolbox"
        tar -xzf "$TOOLBOX_TMP" -C "$HOME/jetbrains-toolbox" --strip-components=1
        rm "$TOOLBOX_TMP"

        echo "⬇️ Creating desktop entry..."
        DESKTOP_FILE="$HOME/.local/share/applications/jetbrains-toolbox.desktop"
        mkdir -p "$(dirname "$DESKTOP_FILE")"
        cat > "$DESKTOP_FILE" <<EOF
[Desktop Entry]
Icon=$HOME/jetbrains-toolbox/bin/toolbox.svg
Exec=$HOME/jetbrains-toolbox/bin/jetbrains-toolbox %u
Version=1.0
Type=Application
Categories=Development
Name=JetBrains Toolbox
StartupWMClass=jetbrains-toolbox
Terminal=false
MimeType=x-scheme-handler/jetbrains;
X-GNOME-Autostart-enabled=true
StartupNotify=false
EOF

        echo "✅ JetBrains Toolbox installed and desktop entry created!"
    fi
fi

echo -e "\n🎉 App installation script completed!"
