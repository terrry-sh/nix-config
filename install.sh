#!/usr/bin/env bash

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Get the current user
USER="${USER:-$(whoami)}"
HOME_DIR="${HOME:-/Users/$USER}"

echo -e "${GREEN}Home Manager Configuration Setup${NC}"
echo -e "${GREEN}================================${NC}"
echo ""

# Check if running on macOS
if [[ "$(uname)" != "Darwin" ]]; then
    echo -e "${RED}Error: This script is designed for macOS only${NC}"
    exit 1
fi

# Check if Nix is installed
if ! command -v nix &> /dev/null; then
    echo -e "${RED}Error: Nix is not installed${NC}"
    echo "Please install Nix first: https://nixos.org/download.html"
    exit 1
fi

# Check if home-manager is installed
if ! command -v home-manager &> /dev/null; then
    echo -e "${YELLOW}Warning: home-manager is not installed${NC}"
    echo "It will be installed when you run the initialization command."
    echo ""
fi

# Create config directories
CONFIG_DIR="$HOME_DIR/.config/home-manager"
NIX_CONFIG_DIR="$HOME_DIR/.config/nix"
echo -e "${YELLOW}Creating configuration directories${NC}"
mkdir -p "$CONFIG_DIR"
mkdir -p "$NIX_CONFIG_DIR"

# Process flake template and create flake.nix
echo -e "${YELLOW}Processing flake template for user: $USER${NC}"
sed "s/<USER>/$USER/g" flake-template.nix > flake.nix

# Symlink flake.nix to home-manager config
echo -e "${YELLOW}Symlinking flake.nix to $CONFIG_DIR${NC}"
if [ -e "$CONFIG_DIR/flake.nix" ] || [ -L "$CONFIG_DIR/flake.nix" ]; then
    echo -e "${YELLOW}Backing up existing flake.nix to flake.nix.backup${NC}"
    mv "$CONFIG_DIR/flake.nix" "$CONFIG_DIR/flake.nix.backup" 2>/dev/null || true
fi
ln -sf "$(pwd)/flake.nix" "$CONFIG_DIR/flake.nix"
echo -e "${GREEN}Symlinked flake.nix to $CONFIG_DIR/flake.nix${NC}"

# Symlink nix.conf
echo -e "${YELLOW}Setting up nix.conf with experimental features${NC}"
if [ -e "$NIX_CONFIG_DIR/nix.conf" ] || [ -L "$NIX_CONFIG_DIR/nix.conf" ]; then
    echo -e "${YELLOW}Backing up existing nix.conf to nix.conf.backup${NC}"
    mv "$NIX_CONFIG_DIR/nix.conf" "$NIX_CONFIG_DIR/nix.conf.backup" 2>/dev/null || true
fi
ln -sf "$(pwd)/nix.conf" "$NIX_CONFIG_DIR/nix.conf"
echo -e "${GREEN}Symlinked nix.conf to $NIX_CONFIG_DIR/nix.conf${NC}"

echo ""
echo -e "${GREEN}Setup complete!${NC}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "1. cd $CONFIG_DIR"
echo "2. Review and customize the configuration in flake.nix"
echo "3. Run: nix run home-manager/master -- init --switch"
echo ""
echo -e "${YELLOW}To apply changes after editing:${NC}"
echo "   home-manager switch --flake ."
echo ""
echo -e "${GREEN}Note:${NC} Experimental features (nix-command and flakes) have been enabled in ~/.config/nix/nix.conf"
