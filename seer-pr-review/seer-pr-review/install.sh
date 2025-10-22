#!/bin/bash
#
# seer-pr-review Installation Script
# Installs the skill to ~/.claude/skills/seer-pr-review/
#

set -e

SKILL_NAME="seer-pr-review"
INSTALL_DIR="$HOME/.claude/skills/$SKILL_NAME"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  seer-pr-review Installation"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Check if Claude skills directory exists
if [ ! -d "$HOME/.claude/skills" ]; then
    echo "Creating Claude skills directory..."
    mkdir -p "$HOME/.claude/skills"
fi

# Check if skill already exists
if [ -d "$INSTALL_DIR" ]; then
    echo "⚠️  Skill already exists at: $INSTALL_DIR"
    read -p "Overwrite existing installation? [y/N] " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Installation cancelled."
        exit 0
    fi
    echo "Removing existing installation..."
    rm -rf "$INSTALL_DIR"
fi

# Copy skill files
echo "Installing skill to: $INSTALL_DIR"
mkdir -p "$INSTALL_DIR"

# Copy required files
cp "$SCRIPT_DIR/SKILL.md" "$INSTALL_DIR/"
cp "$SCRIPT_DIR/README.md" "$INSTALL_DIR/"
cp "$SCRIPT_DIR/QUICKREF.md" "$INSTALL_DIR/"

echo "✓ Skill files installed"

# Verify installation
if [ -f "$INSTALL_DIR/SKILL.md" ]; then
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "✅ Installation successful!"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "Installed files:"
    ls -lh "$INSTALL_DIR/"
    echo ""
    echo "Next steps:"
    echo "  1. Restart Claude Code (if running)"
    echo "  2. Try: 'Review seer comments on PR #X'"
    echo ""
    echo "Documentation:"
    echo "  • Usage guide: $INSTALL_DIR/README.md"
    echo "  • Quick reference: $INSTALL_DIR/QUICKREF.md"
    echo "  • Examples: See EXAMPLES.md in this directory"
    echo ""
else
    echo "❌ Installation failed - SKILL.md not found"
    exit 1
fi
