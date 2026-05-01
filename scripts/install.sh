#!/usr/bin/env bash

NIX_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
HOST="barti"

echo ">> detecting hardware..."

# direct the hardware-configuration.nix to the host folder
if ! sudo nixos-generate-config --show-hardware-config | sudo tee "$NIX_DIR/modules/hosts/$HOST/hardware.nix" >/dev/null; then
    echo "!! failed to generate hardware config :("
    exit 1
fi

echo ">>  initial rebuild..."
# use boot instead of switch or the system would be turbo bombarded
sudo nixos-rebuild boot --flake "$NIX_DIR#$HOST" --accept-flake-config

echo ">> installation complete! reboot your system to log into your nixos environment!"
