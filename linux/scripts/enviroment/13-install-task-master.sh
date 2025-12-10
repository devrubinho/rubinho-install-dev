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
echo "===== [13] INSTALLING TASK MASTER ==========="
echo "=============================================="

# Load NVM if available
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" || true

# Check if Node.js/npm is available
if ! command -v npm &> /dev/null; then
    echo "⚠️  npm not found. Task Master requires Node.js/npm."
    echo "   Please install Node.js first (script 05-install-node-nvm.sh)"
    echo "   Task Master will be installed when Node.js is available."
    exit 0
fi

echo "Installing Task Master globally..."

# Check if already installed
if command -v task-master-ai &> /dev/null; then
    VERSION=$(task-master-ai --version 2>/dev/null || echo "unknown")
    echo "✓ Task Master is already installed"
    echo "  Version: $VERSION"
else
    echo "→ Installing task-master-ai..."
    if npm install -g task-master-ai; then
        echo "✓ Task Master installed successfully"

        # Verify installation
        if command -v task-master-ai &> /dev/null; then
            echo "✓ Task Master command is available"
            task-master-ai --version 2>/dev/null || echo "⚠️  Version check failed, but Task Master is installed"
        else
            echo "⚠️  Task Master command not found in PATH"
            echo "   You may need to restart your terminal or add npm global bin to PATH"
        fi
    else
        echo "❌ Failed to install Task Master"
        exit 1
    fi
fi

echo "=============================================="
echo "============== [13] DONE ===================="
echo "=============================================="
echo "▶ Next, run: bash 14-configure-cursor.sh"
