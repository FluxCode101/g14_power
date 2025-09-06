#!/bin/bash
# install.sh
# Installs g14_power scripts to /usr/local/bin

# Exit on any error
set -e

# Destination directory
DEST="/usr/local/bin"

# Scripts to install
SCRIPTS=("g14-ac-mode.sh" "g14-battery-mode.sh")

echo "Installing g14_power scripts to $DEST ..."

for script in "${SCRIPTS[@]}"; do
    if [[ -f "$script" ]]; then
        sudo cp "$script" "$DEST/"
        sudo chmod +x "$DEST/$script"
        echo "Installed $script"
    else
        echo "Warning: $script not found, skipping."
    fi
done

echo "✅ Installation complete."
echo "You can now run 'g14-ac-mode.sh' or 'g14-battery-mode.sh' from anywhere."
