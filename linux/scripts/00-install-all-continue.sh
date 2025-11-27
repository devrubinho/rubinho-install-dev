#!/usr/bin/env bash

set -e

echo "=============================================="
echo "========= CONTINUING INSTALLATION ==========="
echo "=============================================="

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

scripts=(
  "03-install-prezto.sh"
  "04-install-starship.sh"
  "05-install-docker.sh"
  "06-install-node-nvm.sh"
  "07-install-yarn.sh"
  "08-install-font-jetbrains.sh"
  "09-install-cursor.sh"
  "10-configure-keyboard.sh"
  "11-configure-terminal.sh"
  "12-configure-ssh.sh"
  "13-configure-inotify.sh"
  "14-install-cursor-extensions.sh"
  "15-configure-cursor.sh"
)

for script in "${scripts[@]}"; do
  echo ""
  echo "=============================================="
  echo "Running: $script"
  echo "=============================================="
  bash "$SCRIPT_DIR/$script"
  
  # Special pause after script 05
  if [ "$script" == "05-install-docker.sh" ]; then
    echo ""
    echo "=============================================="
    echo "⚠️  IMPORTANT: Logout/login now!"
    echo "=============================================="
    echo "Then, continue with:"
    echo "  bash 00-install-all-continue.sh"
    echo ""
    exit 0
  fi
done

echo ""
echo "=============================================="
echo "🎉 INSTALLATION COMPLETE!"
echo "=============================================="
echo "All scripts have been executed successfully!"
echo "Restart the terminal to apply all changes."

