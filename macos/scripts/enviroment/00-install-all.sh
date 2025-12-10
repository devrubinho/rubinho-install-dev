#!/usr/bin/env bash

set -e

# ────────────────────────────────────────────────────────────────
# Load Logging Module
# ────────────────────────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../" && pwd)"

# Source logging module if available
if [ -f "$PROJECT_ROOT/lib/logging.sh" ]; then
    # shellcheck source=lib/logging.sh
    source "$PROJECT_ROOT/lib/logging.sh"
    init_logging
else
    # Fallback logging functions if module not available
    log_info() {
        echo "[INFO] $*" >&2 || true
    }
    log_error() {
        echo "[ERROR] $*" >&2 || true
    }
    log_warning() {
        echo "[WARNING] $*" >&2 || true
    }
fi

echo "=============================================="
echo "========= COMPLETE INSTALLATION =============="
echo "=============================================="
echo ""
echo "This script will install and configure your development environment."
echo ""

ENV_FILE="$PROJECT_ROOT/.env"
ENV_EXAMPLE="$PROJECT_ROOT/.env.example"

# Mark that install-all is running (prevents direct execution of module scripts)
export INSTALL_ALL_RUNNING=true

# Load environment variables from .env file if it exists
if [ -f "$ENV_FILE" ]; then
    echo "📝 Loading configuration from .env file..."
    # Source the .env file, ignoring comments and empty lines
    set -a
    while IFS= read -r line || [ -n "$line" ]; do
        # Skip comments and empty lines
        [[ "$line" =~ ^[[:space:]]*# ]] && continue
        [[ -z "${line// }" ]] && continue
        # Export the variable
        eval "export $line" 2>/dev/null || true
    done < "$ENV_FILE"
    set +a
    echo "✓ Configuration loaded from .env"
else
    echo "❌ .env file not found"
    echo ""
    if [ -f "$ENV_EXAMPLE" ]; then
        echo "📝 Please create a .env file manually:"
        echo "   1. Copy .env.example to .env:"
        echo "      cp $ENV_EXAMPLE $ENV_FILE"
        echo ""
        echo "   2. Edit .env with your information:"
        echo "      nano $ENV_FILE"
        echo ""
        echo "   3. Run this script again"
    else
        echo "   Please create a .env file in the project root: $PROJECT_ROOT"
        echo "   You can use .env.example as a template if available"
    fi
    exit 1
fi

# Validate required configuration from .env
echo "📝 Validating configuration from .env file..."
echo ""

# Check Git user name
if [ -z "$GIT_USER_NAME" ] || [ "$GIT_USER_NAME" = "Your Name" ]; then
    echo "❌ GIT_USER_NAME is required in .env file"
    echo "   Please set GIT_USER_NAME in: $ENV_FILE"
    exit 1
fi

# Check Git email
if [ -z "$GIT_USER_EMAIL" ] || [ "$GIT_USER_EMAIL" = "your.email@example.com" ]; then
    echo "❌ GIT_USER_EMAIL is required in .env file"
    echo "   Please set GIT_USER_EMAIL in: $ENV_FILE"
    exit 1
fi

# Export variables for child scripts
export GIT_USER_NAME
export GIT_USER_EMAIL

echo ""
echo "=============================================="
echo "Configuration summary:"
echo "  Git Name: $GIT_USER_NAME"
echo "  Git Email: $GIT_USER_EMAIL"
echo "=============================================="
echo ""
echo "⚠️  ATTENTION:"
echo "   - After Docker installation, you may need to"
echo "     restart Docker Desktop (macOS)."
echo ""

# ────────────────────────────────────────────────────────────────
# Helper Function: Check and Confirm Installation
# ────────────────────────────────────────────────────────────────

check_and_confirm_installation() {
    local tool_name="$1"
    local check_command="$2"
    local version_command="${3:-}"
    local skip_if_installed="${4:-false}"

    # If skip_if_installed is true, skip without asking
    if [ "$skip_if_installed" = true ]; then
        echo "Skipping $tool_name installation..."
        log_info "$tool_name installation skipped"
        return 1
    fi

    # In force mode, always install
    if [ "${FORCE_MODE:-false}" = "true" ]; then
        echo "Force mode: $tool_name will be installed"
        log_info "Force mode: $tool_name will be installed"
        return 0
    fi

    # Prompt user for installation
    echo ""
    read -p "Deseja instalar $tool_name? [Y/n]: " -n 1 -r
    echo ""

    # Check response (default to yes)
    if [[ $REPLY =~ ^[Nn]$ ]]; then
        echo "  Pulando instalação de $tool_name..."
        log_info "$tool_name installation skipped by user"
        return 1
    fi

    echo "  Instalando $tool_name..."
    log_info "$tool_name installation confirmed by user"
    return 0
}

# Wrapper function to run script with installation check
run_script_with_check() {
    local script_name="$1"
    local tool_name="$2"
    local check_command="$3"
    local version_command="${4:-}"
    local skip_if_installed="${5:-false}"

    echo ""
    echo "Running script: $script_name"
    echo "=============================================="

    # Check and confirm installation
    if check_and_confirm_installation "$tool_name" "$check_command" "$version_command" "$skip_if_installed"; then
        # Execute script
        bash "$SCRIPT_DIR/$script_name"
    else
        echo "Script $script_name skipped."
    fi
}

# Part 1: Initial setup (01-02)
echo ""
echo "=============================================="
echo "PHASE 1: Initial Setup"
echo "=============================================="

# Git configuration
run_script_with_check "01-configure-git.sh" "Git Configuration" "true" "" "false"

# Zsh installation check
run_script_with_check "02-install-zsh.sh" "Zsh" "command -v zsh" "zsh --version 2>&1 | head -1"

echo ""
echo "=============================================="
echo "PHASE 2: Environment Configuration"
echo "=============================================="

# Part 2: Environment setup (03-04)
# Zinit check (check if directory exists)
run_script_with_check "03-install-zinit.sh" "Zinit" "[ -d \"\$HOME/.zinit/bin\" ]" "" "false"

# Starship check
run_script_with_check "04-install-starship.sh" "Starship" "command -v starship" "starship --version 2>&1 | head -1"

# Load NVM (it will be available in .zshrc after restart)
echo ""
echo "Loading NVM configuration..."
export NVM_DIR="$HOME/.nvm"
if [ -s "$NVM_DIR/nvm.sh" ]; then
  \. "$NVM_DIR/nvm.sh"
  echo "✓ NVM loaded"
else
  echo "⚠️  NVM not found yet, will be available after restart"
fi

echo ""
echo "=============================================="
echo "PHASE 3: Development Tools"
echo "=============================================="

# Part 3: Development tools (05-08)
# Node/NVM check
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" || true
run_script_with_check "05-install-node-nvm.sh" "Node.js" "command -v node" "node --version 2>&1 | head -1"

# Yarn check
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" || true
run_script_with_check "06-install-yarn.sh" "Yarn" "command -v yarn" "yarn --version 2>&1 | head -1"

# Tools installation
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" || true
run_script_with_check "07-install-tools.sh" "Development Tools" "true" "" "false"

# Font installation
run_script_with_check "08-install-font-jetbrains.sh" "JetBrains Font" "true" "" "false"

echo ""
echo "=============================================="
echo "PHASE 4: Application Setup"
echo "=============================================="

# Part 4: Applications and configuration
# Cursor check
run_script_with_check "09-install-cursor.sh" "Cursor" "[ -d \"/Applications/Cursor.app\" ] || command -v cursor" "[ -d \"/Applications/Cursor.app\" ] && defaults read /Applications/Cursor.app/Contents/Info.plist CFBundleShortVersionString 2>/dev/null || echo 'unknown'"

# Claude Code CLI check (requires Node.js)
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" || true
run_script_with_check "10-install-claude.sh" "Claude Code CLI" "command -v claude || npm list -g @anthropic-ai/claude-code &>/dev/null" "claude --version 2>&1 | head -1 || npm list -g @anthropic-ai/claude-code 2>&1 | grep claude-code | head -1"

# Configuration scripts
run_script_with_check "11-configure-terminal.sh" "Terminal Configuration" "true" "" "false"

run_script_with_check "12-configure-ssh.sh" "SSH Configuration" "true" "" "false"

run_script_with_check "13-configure-file-watchers.sh" "File Watchers Configuration" "true" "" "false"

# Task Master check
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" || true
run_script_with_check "14-install-task-master.sh" "Task Master" "command -v task-master-ai" "task-master-ai --version 2>&1 | head -1"

# Cursor configuration
run_script_with_check "15-configure-cursor.sh" "Cursor Configuration" "true" "" "false"

# Docker check
run_script_with_check "16-install-docker.sh" "Docker" "command -v docker" "docker --version 2>&1 | head -1"

# Insomnia check
run_script_with_check "17-install-insomnia.sh" "Insomnia" "command -v insomnia" "insomnia --version 2>&1 | head -1"

# TablePlus check (macOS only)
run_script_with_check "18-install-tableplus.sh" "TablePlus" "command -v tableplus || [ -d \"/Applications/TablePlus.app\" ]" "[ -d \"/Applications/TablePlus.app\" ] && defaults read /Applications/TablePlus.app/Contents/Info.plist CFBundleShortVersionString 2>/dev/null || echo 'unknown'"

echo ""
echo "=============================================="
echo "🎉 INSTALLATION COMPLETE!"
echo "=============================================="
echo "All scripts have been executed successfully!"
echo ""
echo "⚠️  IMPORTANT:"
echo "   - Close and reopen your terminal to ensure"
echo "     all configurations are loaded."
echo ""
echo "After restarting, verify installations:"
echo "  node -v"
echo "  yarn -v"
echo "  docker --version"
echo ""
