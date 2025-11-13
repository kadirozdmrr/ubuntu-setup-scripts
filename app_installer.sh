#!/bin/bash
set -euo pipefail

echo "🚀 Starting App Installer..."

# --- Check if Flatpak exists ---
if ! command -v flatpak &> /dev/null; then
    echo "⚠️ Flatpak not found. It's highly recommended to run the Flatpak setup script first."
fi


# --- Helper functions ---
install_deb() {
    local url="$1"
    local name="$2"
    local tmp="/tmp/${name// /_}.deb"  

    echo "⬇️ Installing $name..."
    wget -q --show-progress -O "$tmp" "$url"
    sudo apt install -y "$tmp"
    rm "$tmp"
    echo "✅ $name installed!"
}

install_flatpak() {
    local name="$1"
    local ref="$2"

    if flatpak list | grep -q "$ref"; then
        echo "🔄 $name (Flatpak) already installed — skipping..."
    else
        echo "🆕 Installing $name via Flatpak..."
        flatpak install -y flathub "$ref"
        echo "✅ $name installed!"
    fi
}

install_snap() {
    local name="$1"
    local ref="$2"

    if snap list | grep -q "$ref"; then
        echo "🔄 $name (Snap) already installed — skipping..."
    else
        echo "🆕 Installing $name via Snap..."
        sudo snap install "$ref"
        echo "✅ $name installed!"
    fi
}

# --- App menu ---
apps=(
"Steam (.deb) — Official"
"Discord (.deb) — Official but No Auto-Updates, It Will Just Tell You When There's An Update"
"Discord (Flatpak) — Community/Partially Official and Auto Updates"
"Spotify (Flatpak) — Community Maintained"
"Spotify (Snap) — Official"
"Visual Studio Code (.deb) — Official, Microsoft Repo Added"
"Google Chrome (.deb) — Official, Google Repo Added"
"OBS Studio (Flatpak) — Official"
"OBS Studio (PPA) — Official"
"Heroic Games Launcher (.deb) — Official"
"Heroic Games Launcher (Flatpak) — Official, Recommended by Devs"
"Prism Launcher (Flatpak) — Community Project but Highly Recommended"
"Zoom (.deb) — Official"
"Minecraft Launcher (.deb) — Official from Mojang"
"qBittorrent — Official in repo"
"qBittorrent (Flatpak) — Official, Newer Version Than Repo"
"GIMP — Official in repo"
"GIMP (Flatpak) — Official, Newer Version Than Repo"
"VLC (Flatpak) — Community Maintained"
"VLC (Snap) — Official"
"Mission Center (Flatpak) - Windows task manager like resource monitor"
"LibreOffice — Official in repo (older than Flatpak/Snap versions)"
"LibreOffice (Flatpak) — Official"
"LibreOffice (Snap) — Official (launches a bit slow)"
)

echo "Select apps to install (numbers separated by space):"
for i in "${!apps[@]}"; do
    printf "%2d) %s\n" "$((i+1))" "${apps[$i]}"
done

read -rp "Enter numbers: " -a selections

# --- Process selected apps ---
for num in "${selections[@]}"; do
    case "$num" in
        1) install_deb "https://steamcdn-a.akamaihd.net/client/installer/steam.deb" "Steam" ;;
        2)
            URL=$(curl -sI "https://discord.com/api/download?platform=linux&format=deb" \
                | tr -d '\r' | grep -i '^location:' | awk '{print $2}')
            install_deb "$URL" "Discord"
            ;;
        3) install_flatpak "Discord" "com.discordapp.Discord" ;;
        4) install_flatpak "Spotify" "com.spotify.Client" ;;
        5) install_snap "Spotify" "spotify" ;;
        6) #adds the repo automatically
            echo "code code/add-microsoft-repo boolean true" | sudo debconf-set-selections 
            URL="https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"
            install_deb "$URL" "Visual Studio Code"
            ;;
            
        7) install_deb "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb" "Google Chrome" ;;
        8) install_flatpak "OBS Studio" "com.obsproject.Studio" ;;
        9) sudo add-apt-repository -y ppa:obsproject/obs-studio
            sudo apt update
            sudo apt install -y obs-studio
            ;;
        10)
            URL=$(curl -s https://api.github.com/repos/Heroic-Games-Launcher/HeroicGamesLauncher/releases/latest \
                  | grep browser_download_url | grep '\.deb' | cut -d '"' -f 4 | head -n 1)
            install_deb "$URL" "Heroic Games Launcher"
            ;;
        11) install_flatpak "Heroic Games Launcher" "com.heroicgameslauncher.hgl" ;;
        12) install_flatpak "Prism Launcher" "net.prismlauncher.PrismLauncher" ;;
        13) install_deb "https://zoom.us/client/latest/zoom_amd64.deb" "Zoom" ;;
        14) install_deb "https://launcher.mojang.com/download/Minecraft.deb" "Minecraft Launcher" ;;
        15) sudo apt install -y qbittorrent ;;
        16) install_flatpak "qBittorrent" "org.qbittorrent.qBittorrent" ;;
        17) sudo apt install -y gimp ;;
        18) install_flatpak "GIMP" "org.gimp.GIMP" ;;
        19) install_flatpak "VLC" "org.videolan.VLC" ;;
        20) install_snap "VLC" "vlc" ;;
        21) install_flatpak "Mission Center" "io.missioncenter.MissionCenter" ;;
        22) sudo apt install -y libreoffice ;;
        23) install_flatpak "LibreOffice" "org.libreoffice.LibreOffice" ;;
        24) install_snap "LibreOffice" "libreoffice" ;;
        *) echo "⚠️ Invalid selection: $num" ;;
    esac
done

echo -e "\n🎉 Selected apps installed! Do not forget to use 'Update the System' option in main menu for updating them!"
