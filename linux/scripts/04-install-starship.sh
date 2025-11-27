#!/usr/bin/env bash

set -e

echo "=============================================="
echo "========= [04] INSTALLING STARSHIP ==========="
echo "=============================================="

echo "Installing Starship prompt..."
curl -sS https://starship.rs/install.sh | sh

echo "Copying starship.toml..."
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
mkdir -p ~/.config
cp "$SCRIPT_DIR/../config/starship.toml" ~/.config/starship.toml

echo "Updating .zshrc with Prezto + Starship + custom config..."
# Copy the complete zsh-config which already includes Prezto and Starship
if [ -f "$SCRIPT_DIR/../config/zsh-config" ]; then
  cp "$SCRIPT_DIR/../config/zsh-config" ~/.zshrc
  echo "✓ zsh-config copied successfully"
else
  echo "⚠ zsh-config not found, using fallback configuration"
  # Fallback if file doesn't exist
  cat > ~/.zshrc << 'EOF'
#
# Final ZSH configuration (Prezto + Starship)
#

# Load Prezto
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Disable Prezto default prompt to use Starship
zstyle ':prezto:module:prompt' theme 'off'

# Load Starship prompt
eval "$(starship init zsh)"
EOF
fi

echo "=============================================="
echo "============== [04] DONE ===================="
echo "=============================================="
echo "👉 Run: source ~/.zshrc"
echo "▶ Next, run: bash 05-install-docker.sh"

