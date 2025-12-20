#!/usr/bin/env bash

# ────────────────────────────────────────────────────────────────
# Module Guard - Prevent Direct Execution
# ────────────────────────────────────────────────────────────────
# This script should only be executed by 00-install-all.sh
if [ -z "$INSTALL_ALL_RUNNING" ]; then
    SCRIPT_NAME=$(basename "$0")
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    INSTALL_SCRIPT="$SCRIPT_DIR/00-install-all.sh"

    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "⚠️  This script should not be executed directly"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "The script \"$SCRIPT_NAME\" is a module and should only be"
    echo "executed as part of the complete installation process."
    echo ""
    echo "To run the complete installation, use:"
    echo "  bash $INSTALL_SCRIPT"
    echo ""
    echo "Or from the project root:"
    echo "  bash run.sh"
    echo ""
    exit 1
fi


set -e

echo "=============================================="
echo "========= [08] INSTALLING CASKAYDIA COVE FONT"
echo "=============================================="

# Install required packages via Homebrew
if ! command -v brew &> /dev/null; then
  echo "❌ Homebrew is required. Please install it first."
  exit 1
fi

if ! command -v wget &> /dev/null; then
  echo "Installing wget..."
  brew install wget
fi

FONT_DIR="$HOME/Library/Fonts"
mkdir -p "$FONT_DIR"

# Check if font is already installed
if ls "$FONT_DIR/CaskaydiaCove"*.ttf 2>/dev/null | head -1 > /dev/null; then
    echo "✓ CaskaydiaCove Nerd Font is already installed"
    echo "  Skipping download and installation"
else
echo "Downloading CaskaydiaCove Nerd Font..."
cd /tmp
wget -q https://github.com/ryanoasis/nerd-fonts/releases/latest/download/CascadiaCode.zip

echo "Extracting font..."
unzip -o CascadiaCode.zip -d "$FONT_DIR" > /dev/null
rm CascadiaCode.zip

    echo "✓ Font installed successfully."
    echo "  You may need to restart your terminal/editor to see the font."
fi

echo "=============================================="
echo "============== [08] DONE ===================="
echo "=============================================="
echo "▶ Next, run: bash 09-install-vscode.sh"
