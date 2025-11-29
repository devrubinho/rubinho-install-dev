#!/usr/bin/env bash

set -e

echo "=============================================="
echo "========= [09] CONFIGURING iTERM2 ==========="
echo "=============================================="

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
  echo "❌ Homebrew is required. Please install it first."
  exit 1
fi

# Check if iTerm2 is installed
ITerm2_INSTALLED=false
if [ -d "/Applications/iTerm.app" ]; then
  ITerm2_INSTALLED=true
  echo "✓ iTerm2 is already installed"
elif brew list --cask iterm2 &> /dev/null 2>&1; then
  ITerm2_INSTALLED=true
  echo "✓ iTerm2 is installed via Homebrew"
fi

# Install iTerm2 if not installed
if [ "$ITerm2_INSTALLED" = false ]; then
  echo "Installing iTerm2..."
  brew install --cask iterm2
  echo "✓ iTerm2 installed"
fi

echo ""
echo "Downloading Dracula theme for iTerm2..."

# Create directory for themes
THEMES_DIR="$HOME/.iterm2-themes"
mkdir -p "$THEMES_DIR"

# Clone Dracula theme repository
DRACULA_DIR="$THEMES_DIR/iterm"
if [ -d "$DRACULA_DIR" ]; then
  echo "✓ Dracula theme directory already exists, updating..."
  cd "$DRACULA_DIR"
  git pull 2>/dev/null || echo "⚠️  Could not update (not a git repo or no changes)"
else
  echo "Cloning Dracula theme repository..."
  cd "$THEMES_DIR"
  git clone https://github.com/dracula/iterm.git
  echo "✓ Dracula theme downloaded"
fi

DRACULA_FILE="$DRACULA_DIR/Dracula.itermcolors"
if [ ! -f "$DRACULA_FILE" ]; then
  echo "⚠️  Dracula.itermcolors not found in cloned repository"
  echo "   Checking for alternative location..."
  DRACULA_FILE=$(find "$DRACULA_DIR" -name "*.itermcolors" | head -1)
fi

if [ -f "$DRACULA_FILE" ]; then
  echo "✓ Found Dracula theme file: $DRACULA_FILE"
else
  echo "❌ Could not find Dracula theme file"
  exit 1
fi

echo ""
echo "=============================================="
echo "📝 MANUAL CONFIGURATION REQUIRED"
echo "=============================================="
echo ""
echo "Please follow these steps to configure iTerm2:"
echo ""
echo "1. Open iTerm2 → Preferences (⌘,)"
echo ""
echo "2. Go to Profiles tab"
echo ""
echo "3. Select your profile (or create a new one named 'rubinho')"
echo ""
echo "4. In the Text tab:"
echo "   • Click 'Change Font'"
echo "   • Select 'JetBrainsMono Nerd Font'"
echo "   • Set size to 16"
echo ""
echo "5. In the Colors tab:"
echo "   • Click 'Color Presets...' (bottom right)"
echo "   • Click 'Import...'"
echo "   • Navigate to: $DRACULA_FILE"
echo "   • Select the file and click 'Open'"
echo "   • Click 'Color Presets...' again"
echo "   • Select 'Dracula' from the list"
echo ""
echo "6. Click 'Other Actions...' (at the bottom)"
echo "   • Select 'Set as Default'"
echo ""
echo "7. Close Preferences and restart iTerm2 (⌘Q)"
echo ""
echo "=============================================="
echo "============== [09] DONE ===================="
echo "=============================================="
echo "▶ Next, run: bash 10-configure-ssh.sh"
