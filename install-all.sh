#!/bin/bash
#
# Sentry Claude Code Skills - Install All Script
# Installs all available skills to ~/.claude/skills/
#

set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_DIR="$HOME/.claude/skills"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Sentry Claude Code Skills - Installation"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Check if Claude skills directory exists
if [ ! -d "$SKILLS_DIR" ]; then
    echo "Creating Claude skills directory..."
    mkdir -p "$SKILLS_DIR"
    echo "✓ Created $SKILLS_DIR"
    echo ""
fi

# Check prerequisites
echo "Checking prerequisites..."
echo ""

# Check for gh CLI
if ! command -v gh &> /dev/null; then
    echo "⚠️  Warning: GitHub CLI (gh) is not installed"
    echo "   Some skills require it. Install with:"
    echo "   • macOS: brew install gh"
    echo "   • Linux: sudo apt install gh"
    echo "   • Windows: winget install --id GitHub.cli"
    echo ""
else
    echo "✓ GitHub CLI installed"

    # Check if authenticated
    if gh auth status &> /dev/null; then
        echo "✓ GitHub CLI authenticated"
    else
        echo "⚠️  Warning: GitHub CLI not authenticated"
        echo "   Run: gh auth login"
    fi
    echo ""
fi

# Find all skills
echo "Discovering skills..."
echo ""

SKILL_DIRS=()
for dir in "$REPO_DIR"/*/; do
    # Skip if not a directory
    [ -d "$dir" ] || continue

    # Get directory name
    skill_name=$(basename "$dir")

    # Skip hidden directories, node_modules, etc.
    [[ "$skill_name" =~ ^\. ]] && continue
    [[ "$skill_name" == "node_modules" ]] && continue

    # Look for nested skill directory (e.g., seer-pr-review/seer-pr-review/)
    if [ -d "$dir$skill_name" ] && [ -f "$dir$skill_name/SKILL.md" ]; then
        SKILL_DIRS+=("$dir$skill_name")
        echo "  • Found: $skill_name"
    fi
done

if [ ${#SKILL_DIRS[@]} -eq 0 ]; then
    echo "❌ No skills found in repository"
    exit 1
fi

echo ""
echo "Found ${#SKILL_DIRS[@]} skill(s) to install"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Track installation results
INSTALLED=0
FAILED=0
SKIPPED=0

# Install each skill
for skill_path in "${SKILL_DIRS[@]}"; do
    skill_name=$(basename "$skill_path")
    install_script="$skill_path/install.sh"

    echo "Installing: $skill_name"
    echo "─────────────────────────────────────────────────────────"

    if [ -f "$install_script" ]; then
        # Make install script executable
        chmod +x "$install_script"

        # Run the install script
        if bash "$install_script"; then
            ((INSTALLED++))
            echo ""
        else
            echo "❌ Failed to install $skill_name"
            ((FAILED++))
            echo ""
        fi
    else
        echo "⚠️  No install.sh found for $skill_name"
        echo "   Attempting manual installation..."

        # Manual installation fallback
        dest_dir="$SKILLS_DIR/$skill_name"

        if [ -d "$dest_dir" ]; then
            echo "   Skill already exists at: $dest_dir"
            read -p "   Overwrite? [y/N] " -n 1 -r
            echo
            if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                echo "   Skipped"
                ((SKIPPED++))
                echo ""
                continue
            fi
            rm -rf "$dest_dir"
        fi

        # Copy required files
        mkdir -p "$dest_dir"
        cp "$skill_path/SKILL.md" "$dest_dir/" 2>/dev/null || true
        cp "$skill_path/README.md" "$dest_dir/" 2>/dev/null || true
        cp "$skill_path/QUICKREF.md" "$dest_dir/" 2>/dev/null || true

        if [ -f "$dest_dir/SKILL.md" ]; then
            echo "   ✓ Manually installed to $dest_dir"
            ((INSTALLED++))
        else
            echo "   ❌ Failed - SKILL.md not found"
            ((FAILED++))
        fi
        echo ""
    fi
done

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Installation Summary"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "  ✅ Installed: $INSTALLED"
if [ $FAILED -gt 0 ]; then
    echo "  ❌ Failed:    $FAILED"
fi
if [ $SKIPPED -gt 0 ]; then
    echo "  ⏭️  Skipped:   $SKIPPED"
fi
echo ""
echo "  Total:       ${#SKILL_DIRS[@]}"
echo ""

if [ $INSTALLED -gt 0 ]; then
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "🎉 Installation complete!"
    echo ""
    echo "Installed skills:"
    ls -1 "$SKILLS_DIR" | grep -v "^\\." | sed 's/^/  • /'
    echo ""
    echo "Next steps:"
    echo "  1. Restart Claude Code (if running)"
    echo "  2. Try a skill:"
    echo "     \"Review seer comments on PR #X\""
    echo ""
    echo "Documentation:"
    echo "  • Main README: $REPO_DIR/README.md"
    echo "  • Skill docs:  $SKILLS_DIR/[skill-name]/README.md"
    echo ""
fi

if [ $FAILED -gt 0 ]; then
    echo "⚠️  Some skills failed to install"
    echo "   Check the output above for details"
    echo ""
    exit 1
fi

exit 0
