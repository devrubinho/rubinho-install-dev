#!/usr/bin/env bash

set -e

echo "=============================================="
echo "========= [BOOTSTRAP] INSTALLING ZSH ========="
echo "=============================================="

sudo apt update -y
sudo apt install -y zsh curl git

ZSH_BIN=$(which zsh)

echo "=============================================="
echo "===== [BOOTSTRAP] SETTING DEFAULT SHELL ======"
echo "=============================================="

if [ "$SHELL" != "$ZSH_BIN" ]; then
  chsh -s "$ZSH_BIN"
  echo "✔ Default shell changed to ZSH"
else
  echo "✔ ZSH is already the default shell"
fi

echo "=============================================="
echo "===== [BOOTSTRAP] CREATING MINIMAL .zshrc ===="
echo "=============================================="

cat > ~/.zshrc << 'EOF'
# ==========================================
#  Minimal ZSH bootstrap configuration file
# ==========================================

# Initialize completion system
autoload -Uz compinit
compinit

# Additional helper configurations will be appended below
# --------------------------------------------
EOF

echo "=============================================="
echo "===== [BOOTSTRAP] ADDING AUXILIARY CONFIG ===="
echo "=============================================="

curl -Ls https://raw.githubusercontent.com/rubensdeoliveira/rubinho-env/master/vs-code/step-1-aux-1 >> ~/.zshrc

echo "=============================================="
echo "============== [BOOTSTRAP DONE] =============="
echo "=============================================="
echo "⚠️  Please close the terminal and open it again."
echo "▶ Next, run STEP 2 in a ZSH session:"
echo ""
echo "   bash <(curl -Ls https://raw.githubusercontent.com/rubensdeoliveira/rubinho-env/master/vs-code/step-2.sh)"
echo ""

