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
echo "========= [09] INSTALLING VS CODE ==========="
echo "=============================================="

echo "Installing Visual Studio Code via Homebrew..."

if command -v brew &> /dev/null; then
    # Reinstall if already installed
    if brew list --cask visual-studio-code &> /dev/null; then
        echo "Reinstalling Visual Studio Code..."
        brew reinstall --cask visual-studio-code
    else
        brew install --cask visual-studio-code
    fi

    echo "✓ Visual Studio Code installed successfully via Homebrew"

    # Wait a moment for the app to be fully available
    sleep 2

    if [ -d "/Applications/Visual Studio Code.app" ]; then
        echo "✓ Visual Studio Code.app found in Applications"
    fi

    # Check for command-line tool
    if command -v code &> /dev/null; then
        echo "✓ VS Code command-line tool is available"
        code --version 2>/dev/null || echo "⚠️  Version check failed, but VS Code is installed"
    else
        echo "⚠️  VS Code command-line tool not found in PATH"
        echo "   This is normal - the app is installed, but CLI may need manual setup"
    fi
else
    echo "⚠️  Homebrew not found"
    echo ""
    echo "Please install Visual Studio Code manually:"
    echo "  1. Visit: https://code.visualstudio.com"
    echo "  2. Click 'Download' and select macOS"
    echo "  3. Drag Visual Studio Code.app to Applications folder"
    echo ""
    echo "Or install Homebrew first, then run this script again"
    exit 1
fi

echo "=============================================="
echo "============== [09] DONE ===================="
echo "=============================================="
echo "▶ Next, run: bash 10-install-cursor.sh"
