#!/usr/bin/env bash

NIX_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
HOST_NAME="barti"
HOST="my-machine"
TARGET_DIR="/mnt" # THIS ASSUMES THAT YOU MOUNTED YOUR DRIVE IN /mnt !!! (like a normal human being)

echo ">> preparing directory structure..."
mkdir -p "$NIX_DIR/modules/hosts/$HOST"

echo ">> detecting hardware..."
# direct the hardware-configuration.nix to the host folder
if ! sudo nixos-generate-config --show-hardware-config | sudo tee "$NIX_DIR/modules/hosts/$HOST/hardware.nix" >/dev/null; then
    echo "!! failed to generate hardware config :("
    exit 1
fi

# perform the installation
if [ -d "$TARGET_DIR/etc" ]; then
    echo ">> detected target disk at $TARGET_DIR, performing initial install..."
    sudo nixos-install --flake "$NIX_DIR#$HOST_NAME" --root "$TARGET_DIR"
fi

echo ">> operation complete!"
