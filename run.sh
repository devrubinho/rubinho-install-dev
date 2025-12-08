#!/usr/bin/env bash

#
# Rubinho Scripts - Main Entry Point
#
# Simplified interface for managing development environment and system resources.
# Automatically detects platform and provides three core options:
#   1. Install development tools
#   2. Analyze disk space
#   3. Clean up unnecessary files
#

set -eo pipefail

# ────────────────────────────────────────────────────────────────
# Script Directory and Initialization
# ────────────────────────────────────────────────────────────────

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Parse command-line arguments
FORCE_MODE=false
for arg in "$@"; do
    case $arg in
        --force)
            FORCE_MODE=true
            shift
            ;;
        -h|--help)
            echo "Usage: $0 [--force]"
            echo ""
            echo "Options:"
            echo "  --force    Skip all confirmation prompts"
            echo "  --help     Show this help message"
            exit 0
            ;;
        *)
            echo "Unknown option: $arg"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

# Export FORCE_MODE for use in other scripts
export FORCE_MODE

# ────────────────────────────────────────────────────────────────
# Platform Detection
# ────────────────────────────────────────────────────────────────

# Source platform detection module
if [ ! -f "$SCRIPT_DIR/lib/platform.sh" ]; then
    echo "ERROR: Platform detection module not found at $SCRIPT_DIR/lib/platform.sh"
    exit 1
fi

# shellcheck source=lib/platform.sh
source "$SCRIPT_DIR/lib/platform.sh"

# ────────────────────────────────────────────────────────────────
# Welcome Banner
# ────────────────────────────────────────────────────────────────

clear
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║         🚀 Rubinho Scripts - System Manager 🚀                ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""
print_platform_info
echo ""

# ────────────────────────────────────────────────────────────────
# Handler Functions (Placeholders for future implementation)
# ────────────────────────────────────────────────────────────────

install_tools() {
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "📦 Install Development Tools"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "This will install:"
    echo "  • Task Master AI"
    echo "  • Claude Code CLI"
    echo "  • Cursor IDE configuration"
    echo "  • Development tools and utilities"
    echo ""

    if [ "$FORCE_MODE" = false ]; then
        read -p "Continue with installation? [y/N]: " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "Installation cancelled."
            return 0
        fi
    fi

    echo "⚠️  Tool installation not yet implemented."
    echo "This will be implemented in RUB-12."
    echo ""
}

analyze_disk() {
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "📊 Analyze Disk Space"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "Analyzing disk usage..."
    echo ""

    echo "⚠️  Disk analysis not yet implemented."
    echo "This will be implemented in RUB-14."
    echo ""
}

cleanup_files() {
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "🧹 Clean Up Unnecessary Files"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "This will clean up:"
    echo "  • Cache files"
    echo "  • Temporary files"
    echo "  • Log files"
    echo "  • Old downloads"
    echo ""

    if [ "$FORCE_MODE" = false ]; then
        read -p "Continue with cleanup? [y/N]: " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "Cleanup cancelled."
            return 0
        fi
    fi

    echo "⚠️  Cleanup not yet implemented."
    echo "This will be implemented in RUB-10."
    echo ""
}

# ────────────────────────────────────────────────────────────────
# Main Menu
# ────────────────────────────────────────────────────────────────

main_menu() {
    while true; do
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "What would you like to do?"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo ""
        echo "  1) 📦 Install development tools"
        echo "  2) 📊 Analyze disk space"
        echo "  3) 🧹 Clean up unnecessary files"
        echo ""
        echo "  0) ❌ Exit"
        echo ""

        # Read user choice
        read -p "Enter your choice [0-3]: " choice
        echo ""

        case $choice in
            1)
                install_tools
                ;;
            2)
                analyze_disk
                ;;
            3)
                cleanup_files
                ;;
            0)
                echo "Goodbye!"
                exit 0
                ;;
            *)
                echo "❌ Invalid choice. Please enter a number between 0 and 3."
                echo ""
                ;;
        esac

        # Ask if user wants to do something else
        if [ "$FORCE_MODE" = false ]; then
            echo ""
            read -p "Do you want to perform another action? [Y/n]: " -n 1 -r
            echo ""
            if [[ $REPLY =~ ^[Nn]$ ]]; then
                echo "Goodbye!"
                exit 0
            fi
            echo ""
        else
            # In force mode, exit after completing one action
            echo "Force mode: Exiting after completing action."
            exit 0
        fi
    done
}

# ────────────────────────────────────────────────────────────────
# Entry Point
# ────────────────────────────────────────────────────────────────

# Trap Ctrl+C for graceful exit
trap 'echo ""; echo "Interrupted by user. Exiting..."; exit 2' INT

# Start main menu
main_menu
