#!/usr/bin/env bash
set -e

# IMPORTANT: this script considers that you mounted nix on /mnt

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOST_NAME="barti"
NIX_DIRECTORY="$SCRIPT_DIR/../"
HARDWARE_FILE="$SCRIPT_DIR/../modules/hosts/my-machine/hardware.nix"

# write the current system hardware to the hardware.nix file
echo "writing hardware config..."
sudo nixos-generate-config --show-hardware-config >"$HARDWARE_FILE"
echo "hardware config created successfully!"

# add the file to git(might be pointless)
echo "adding the hardware file to git..."
git -C "$NIX_DIRECTORY" add "$HARDWARE_FILE"
echo "added the hardware file to git!"

# actually perform the install
echo "installing nixos..."
sudo nixos-install --root /mnt --flake "$NIX_DIRECTORY#$HOST_NAME"
echo "nix install successful! reboot your system to boot to your new nixos!"
