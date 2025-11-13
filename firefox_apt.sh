#!/bin/bash
set -euo pipefail

echo "🚀 Starting Firefox APT setup..."

# --- Remove Snap Firefox if it exists ---
if command -v snap &>/dev/null && snap list 2>/dev/null | grep -q '^firefox'; then
  echo "⚠️  Snap version of Firefox detected. Removing..."
  sudo snap remove --purge firefox
  echo "✅ Snap Firefox removed successfully."
else
  echo "ℹ️  No Snap Firefox installation found, skipping removal."
fi

#last check
sudo apt purge -y firefox

# --- Create APT keyrings directory ---
sudo install -d -m 0755 /etc/apt/keyrings

# --- Import the Mozilla APT repository signing key ---
wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O- | \
  sudo tee /etc/apt/keyrings/packages.mozilla.org.asc > /dev/null

# --- Verify key fingerprint ---
echo -e "\nVerifying key fingerprint..."
fingerprint=$(gpg -n -q --import --import-options import-show /etc/apt/keyrings/packages.mozilla.org.asc \
  | awk '/pub/{getline; gsub(/^ +| +$/,""); print $0}')

if [[ "$fingerprint" == "35BAA0B33E9EB396F59CA838C0BA5CE6DC6315A3" ]]; then
  echo "✅ The key fingerprint matches ($fingerprint)."
else
  echo "❌ Verification failed: fingerprint ($fingerprint) does not match expected one."
  exit 1
fi

# --- Add the Mozilla repository ---
cat <<EOF | sudo tee /etc/apt/sources.list.d/mozilla.sources > /dev/null
Types: deb
URIs: https://packages.mozilla.org/apt
Suites: mozilla
Components: main
Signed-By: /etc/apt/keyrings/packages.mozilla.org.asc
EOF

# --- Prioritize the repository ---
cat <<EOF | sudo tee /etc/apt/preferences.d/mozilla > /dev/null
Package: *
Pin: origin packages.mozilla.org
Pin-Priority: 1000
EOF

echo -e "\n✅ Mozilla APT repository added and prioritized successfully."

# --- Update and install Firefox from APT ---
echo -e "\n🚀 Installing Firefox from Mozilla APT repo..."
sudo apt update -y
sudo apt install -y firefox
echo "✅ Firefox (APT version) installed successfully."
