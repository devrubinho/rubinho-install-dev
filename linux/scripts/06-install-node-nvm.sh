#!/usr/bin/env bash

set -e

echo "=============================================="
echo "========= [06] INSTALLING NODE + NVM ========="
echo "=============================================="

export NVM_DIR="$HOME/.nvm"

if [ ! -d "$NVM_DIR" ]; then
  echo "Installing NVM..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
else
  echo "NVM already installed."
fi

# Load NVM
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

echo "Installing Node 22..."
if command -v nvm &> /dev/null || [ -s "$NVM_DIR/nvm.sh" ]; then
  nvm install 22
  nvm alias default 22
  nvm use 22
  
  echo "Node  -> $(node -v 2>/dev/null || echo 'not available')"
  echo "NPM   -> $(npm -v 2>/dev/null || echo 'not available')"
else
  echo "⚠️  NVM not loaded properly. Please restart your terminal and run:"
  echo "   source ~/.nvm/nvm.sh"
  echo "   nvm install 22"
fi

echo "=============================================="
echo "============== [06] DONE ===================="
echo "=============================================="
echo "▶ Next, run: bash 07-install-yarn.sh"

