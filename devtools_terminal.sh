#!/bin/bash

set -euo pipefail

echo "🚀 Starting devtools and terminal setup..."

# Add PPA for Fastfetch
sudo add-apt-repository -y ppa:zhangsongcui3371/fastfetch
sudo apt update

# Install dev tools
sudo apt install -y git curl fastfetch build-essential gdb default-jdk eza

# Update hardware PCI IDs
sudo update-pciids

# Install Starship
curl -sS https://starship.rs/install.sh | sh -s -- -y

# --- Shell configuration ---

# Create ~/.bash_aliases if not exists
if [ ! -f "$HOME/.bash_aliases" ]; then
    touch "$HOME/.bash_aliases"
fi

# Add aliases (only if not already present)
declare -A aliases
aliases=(
    ["ls"]="eza -al --color=always --group-directories-first --icons"
    ["la"]="eza -a --color=always --group-directories-first --icons"
    ["ll"]="eza -l --color=always --group-directories-first --icons"
    ["lt"]="eza -aT --color=always --group-directories-first --icons"
    ["l."]="eza -a | grep -e '^\.'"
    ["fastfetch"]="fastfetch -c examples/10"
    ["update"]="sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y && flatpak update -y && sudo snap refresh && bash $HOME/.ubuntu-setup-scripts/external_deb_updater.sh"
)
for alias_name in "${!aliases[@]}"; do
    if ! grep -q "alias $alias_name=" "$HOME/.bash_aliases"; then
        echo "alias $alias_name='${aliases[$alias_name]}'" >> "$HOME/.bash_aliases"
    fi
done

# Add initialization for fastfetch
if ! grep -q "fastfetch" "$HOME/.bashrc"; then
    echo -e "\n# Initialize fastfetch welcome" >> "$HOME/.bashrc"
    echo 'fastfetch' >> "$HOME/.bashrc"
fi

# Add initialization for Starship
if ! grep -q "eval \"\$(starship init bash)\"" "$HOME/.bashrc"; then
    echo -e "\n# Initialize Starship prompt" >> "$HOME/.bashrc"
    echo 'eval "$(starship init bash)"' >> "$HOME/.bashrc"
fi

# --- JetBrains Nerd Font installation ---
echo "⬇️ Installing JetBrains Nerd Font..."

# Create fonts directory if it doesn't exist
mkdir -p "$HOME/.local/share/fonts"

# Download latest JetBrainsMono Nerd Font tar.xz
FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.tar.xz"
FONT_TMP="/tmp/JetBrainsMono.tar.xz"
FONT_TMP_DIR="/tmp/JetBrainsMono"

wget -O "$FONT_TMP" "$FONT_URL"

# Extract the font
rm -rf "$FONT_TMP_DIR"
mkdir -p "$FONT_TMP_DIR"
tar -xf "$FONT_TMP" -C "$FONT_TMP_DIR"

# Move fonts to $HOME/local/share/fonts
find "$FONT_TMP_DIR" -type f \( -iname "*.ttf" -o -iname "*.otf" \) -exec mv {} "$HOME/.local/share/fonts/" \;

# Clean up
rm -rf "$FONT_TMP_DIR" "$FONT_TMP"

# Update font cache
fc-cache -fv "$HOME/.local/share/fonts"

echo "✅ JetBrains Nerd Font installed!"

# --- Configure GNOME Terminal ---
echo "⬇️ Configuring GNOME Terminal..."

# Get default profile UUID
DEFAULT_PROFILE=$(gsettings get org.gnome.Terminal.ProfilesList default | tr -d \')

# Set the terminal font (JetBrainsMono Nerd Font Mono, 11pt)
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$DEFAULT_PROFILE/" font 'JetBrainsMono Nerd Font Mono 11'

# Set default size (columns x rows) and bold colors
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$DEFAULT_PROFILE/" default-size-columns 125
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$DEFAULT_PROFILE/" default-size-rows 45
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$DEFAULT_PROFILE/" bold-color-same-as-fg true

# Set cursor shape to underline
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$DEFAULT_PROFILE/" cursor-shape 'underline'

echo "✅ GNOME Terminal configured!"


# --- Starship configuration ---
echo "⬇️ Configuring Starship prompt..."

# Create config directory if it doesn't exist
mkdir -p "$HOME/.config"

# Write your starship.toml
STARSHIP_CONFIG="$HOME/.config/starship.toml"

cat > "$STARSHIP_CONFIG" <<'EOF'
format = """
[](#3B4252)\
$python\
$username\
[](bg:#434C5E fg:#3B4252)\
$directory\
[](fg:#434C5E bg:#4C566A)\
$git_branch\
$git_status\
[](fg:#4C566A bg:#86BBD8)\
$c\
$elixir\
$elm\
$golang\
$haskell\
$java\
$julia\
$nodejs\
$nim\
$rust\
[](fg:#86BBD8 bg:#06969A)\
$docker_context\
[](fg:#06969A bg:#33658A)\
$time\
[ ](fg:#33658A)\
"""
command_timeout = 5000
# Disable the blank line at the start of the prompt
# add_newline = false

[username]
show_always = true
style_user = "bg:#3B4252"
style_root = "bg:#3B4252"
format = '[$user ]($style)'

[directory]
style = "bg:#434C5E"
format = "[ $path ]($style)"
truncation_length = 3
truncation_symbol = "…/"

[directory.substitutions]
"Documents" = "󰈙 "
"Downloads" = " "
"Music" = " "
"Pictures" = " "

[c]
symbol = " "
style = "bg:#86BBD8"
format = '[ $symbol ($version) ]($style)'

[docker_context]
symbol = " "
style = "bg:#06969A"
format = '[ $symbol $context ]($style) $path'

[elixir]
symbol = " "
style = "bg:#86BBD8"
format = '[ $symbol ($version) ]($style)'

[elm]
symbol = " "
style = "bg:#86BBD8"
format = '[ $symbol ($version) ]($style)'

[git_branch]
symbol = ""
style = "bg:#4C566A"
format = '[ $symbol $branch ]($style)'

[git_status]
style = "bg:#4C566A"
format = '[$all_status$ahead_behind ]($style)'

[golang]
symbol = " "
style = "bg:#86BBD8"
format = '[ $symbol ($version) ]($style)'

[haskell]
symbol = " "
style = "bg:#86BBD8"
format = '[ $symbol ($version) ]($style)'

[java]
symbol = " "
style = "bg:#86BBD8"
format = '[ $symbol ($version) ]($style)'

[julia]
symbol = " "
style = "bg:#86BBD8"
format = '[ $symbol ($version) ]($style)'

[nodejs]
symbol = ""
style = "bg:#86BBD8"
format = '[ $symbol ($version) ]($style)'

[nim]
symbol = " "
style = "bg:#86BBD8"
format = '[ $symbol ($version) ]($style)'

[python]
style = "bg:#3B4252"
format = '[(\($virtualenv\) )]($style)'

[rust]
symbol = ""
style = "bg:#86BBD8"
format = '[ $symbol ($version) ]($style)'

[time]
disabled = false
time_format = "%R"
style = "bg:#33658A"
format = '[ $time ]($style)'
EOF

echo "✅ Starship configuration installed at $STARSHIP_CONFIG"

echo -e "\n🎉 Devtools and terminal setup completed, restart your terminal when possible."
echo -e "\n📝 Tip: You can now use the 'update' alias to update all your apps (including no auto-update .debs) whenever you want."

