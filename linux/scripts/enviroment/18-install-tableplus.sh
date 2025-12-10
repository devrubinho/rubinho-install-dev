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

# Function to install TablePlus via AppImage
install_tableplus_appimage() {
    # Create local bin directory if it doesn't exist
    mkdir -p "$HOME/.local/bin"
    mkdir -p "$HOME/.local/share/applications"

    # Download TablePlus AppImage
    TABLEPLUS_PATH="$HOME/.local/bin/tableplus"

    echo "📥 Installing TablePlus via AppImage..."
    echo ""
    echo "Please visit https://tableplus.com/download to download the Linux AppImage"
    echo "After downloading, place it in: $TABLEPLUS_PATH"
    echo ""
    read -p "Press Enter after you have downloaded and placed the AppImage, or type 'skip' to exit: " response

    if [ "$response" = "skip" ]; then
        echo "⚠️  Installation skipped"
        return 0
    fi

    # Check if file exists
    if [ -f "$TABLEPLUS_PATH" ]; then
        chmod +x "$TABLEPLUS_PATH"
        echo "✓ TablePlus found and made executable"

        # Create desktop entry
        cat > "$HOME/.local/share/applications/tableplus.desktop" <<EOF
[Desktop Entry]
Name=TablePlus
Comment=Modern database client
Exec=$TABLEPLUS_PATH
Icon=tableplus
Type=Application
Categories=Development;Database;
EOF

        # Verify installation
        if [ -f "$TABLEPLUS_PATH" ] && [ -x "$TABLEPLUS_PATH" ]; then
            echo "✓ TablePlus installed successfully"
            echo ""
            echo "📝 TablePlus is available at: $TABLEPLUS_PATH"
            echo "   You can run it with: tableplus"
            echo ""
            echo "💡 To make it available system-wide, add to PATH:"
            echo "   export PATH=\"\$HOME/.local/bin:\$PATH\""
            echo "   (This is usually already in your .zshrc)"
        else
            echo "⚠️  TablePlus file found but is not executable"
        fi
    else
        echo "❌ TablePlus AppImage not found at: $TABLEPLUS_PATH"
        echo ""
        echo "Please download TablePlus manually:"
        echo "  1. Visit: https://tableplus.com/download"
        echo "  2. Download the Linux AppImage"
        echo "  3. Make it executable: chmod +x TablePlus.AppImage"
        echo "  4. Move to: mv TablePlus.AppImage ~/.local/bin/tableplus"
        echo "  5. Run this script again"
        return 1
    fi
}

echo "=============================================="
echo "========= [18] INSTALLING TABLEPLUS =========="
echo "=============================================="

echo "Installing TablePlus for Linux..."
echo ""

# Detect architecture
ARCH=$(uname -m)
if [ "$ARCH" = "x86_64" ]; then
    echo "Detected architecture: x86_64"
    echo ""

    # Try installing via snap first (easiest method)
    if command -v snap &> /dev/null; then
        echo "📥 Installing TablePlus via Snap..."
        echo ""
        # Remove if already installed, then reinstall
        if sudo snap list tableplus &> /dev/null; then
            echo "Reinstalling TablePlus..."
            sudo snap remove tableplus || true
        fi
        if sudo snap install tableplus; then
            echo "✓ TablePlus installed successfully via Snap"
            echo ""
            echo "📝 TablePlus is now available. Run it with: tableplus"
        else
            echo "⚠️  Snap installation failed, trying alternative method..."
            install_tableplus_appimage
        fi
    else
        echo "📥 Snap not available, installing TablePlus via AppImage..."
        echo ""
        install_tableplus_appimage
    fi
else
    echo "❌ Unsupported architecture: $ARCH"
    echo "   TablePlus Linux version is currently only available for x86_64"
    echo ""
    echo "You can try installing manually from:"
    echo "  https://tableplus.com/download"
    exit 1
fi

echo "=============================================="
echo "============== [18] DONE ===================="
echo "=============================================="
echo ""
echo "📝 TablePlus is a modern database management tool for:"
echo "   - MySQL, MariaDB, PostgreSQL, SQLite, Redis, and many more"
echo "   - Beautiful native interface"
echo "   - Cross-platform support"
echo ""
echo "🎉 All development tools installation complete!"
