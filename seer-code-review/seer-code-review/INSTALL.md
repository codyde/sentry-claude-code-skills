# Installation Guide

## Prerequisites

- Claude Code with skills support
- GitHub CLI (`gh`) installed and authenticated
- Git installed and configured
- Access to repositories with seer-by-sentry bot

## Installation Methods

### Method 1: Manual Installation (Recommended)

1. **Copy skill to Claude skills directory**
   ```bash
   cp -r seer-reviewer ~/.claude/skills/
   ```

2. **Verify installation**
   ```bash
   ls -la ~/.claude/skills/seer-reviewer/
   ```

   You should see:
   - `SKILL.md` (required)
   - `README.md`
   - `QUICKREF.md`

3. **Test the skill**
   Open Claude Code and try:
   ```
   "Review seer comments on PR #[number]"
   ```

### Method 2: Symlink (For Development)

If you want to edit the skill and have changes immediately available:

```bash
# Remove if already exists
rm -rf ~/.claude/skills/seer-reviewer

# Create symlink
ln -s /path/to/seer-reviewer ~/.claude/skills/seer-reviewer
```

This allows you to edit files in your repo and have them instantly available in Claude.

### Method 3: Git Clone (Future)

Once the repository is published:

```bash
cd ~/.claude/skills/
git clone https://github.com/yourusername/seer-reviewer.git
```

## Verify GitHub CLI Setup

The skill requires GitHub CLI to fetch PR comments:

```bash
# Check if gh is installed
gh --version

# Check authentication
gh auth status

# Login if needed
gh auth login
```

## Configuration

No additional configuration is required. The skill works out of the box.

### Optional: Customize the Skill

Edit `~/.claude/skills/seer-reviewer/SKILL.md` to:

- Adjust severity thresholds
- Modify commit message templates
- Add custom validation rules
- Change priority matrix

## Testing Your Installation

1. **Find a PR with seer-by-sentry comments**
   ```bash
   gh pr list --repo yourorg/yourrepo
   ```

2. **Ask Claude to review it**
   ```
   "Review seer-by-sentry comments on PR #X in yourorg/yourrepo"
   ```

3. **Expected behavior**
   - Claude fetches comments using `gh api`
   - Analyzes each comment
   - Validates issues
   - Provides structured report

## Troubleshooting

### Skill Not Loading

**Problem**: Claude doesn't recognize seer-reviewer commands

**Solutions**:
1. Verify SKILL.md exists at `~/.claude/skills/seer-reviewer/SKILL.md`
2. Check file permissions: `chmod 644 ~/.claude/skills/seer-reviewer/SKILL.md`
3. Restart Claude Code
4. Try explicit mention: "Use the seer-reviewer skill to check PR #X"

### GitHub CLI Errors

**Problem**: `gh: command not found`

**Solution**: Install GitHub CLI
```bash
# macOS
brew install gh

# Linux (Debian/Ubuntu)
sudo apt install gh

# Other systems
# See: https://cli.github.com/manual/installation
```

**Problem**: `gh: authentication required`

**Solution**: Authenticate with GitHub
```bash
gh auth login
# Follow prompts to authenticate
```

**Problem**: `gh: forbidden` or permission errors

**Solution**: Ensure you have access to the repository
```bash
gh repo view owner/repo
```

### Git Errors

**Problem**: Can't checkout PR branch

**Solution**:
```bash
# Ensure clean working directory
git status

# Stash changes if needed
git stash

# Then try again
```

**Problem**: Can't push to PR branch

**Solution**: Verify you have write permissions to the repository

### Skill Execution Issues

**Problem**: Skill starts but fails to validate issues

**Solution**:
1. Check that files mentioned in comments exist
2. Verify you're in the correct repository
3. Ensure PR branch is up to date

## Updating the Skill

### Manual Updates

```bash
# Backup current version
cp -r ~/.claude/skills/seer-reviewer ~/.claude/skills/seer-reviewer.backup

# Copy new version
cp -r /path/to/new/seer-reviewer ~/.claude/skills/

# Restart Claude Code
```

### Git Updates (Future)

```bash
cd ~/.claude/skills/seer-reviewer
git pull origin main
```

## Uninstallation

To remove the skill:

```bash
rm -rf ~/.claude/skills/seer-reviewer
```

Claude will no longer load the skill on next restart.

## Getting Help

- Read [README.md](README.md) for usage examples
- Check [EXAMPLES.md](EXAMPLES.md) for real-world scenarios
- Review [QUICKREF.md](QUICKREF.md) for command reference
- Open an issue on GitHub (when repo is published)

## Advanced Setup

### Team Installation

Share the skill with your team:

1. **Create internal repository**
   ```bash
   git init seer-reviewer
   cd seer-reviewer
   # Add files
   git add .
   git commit -m "Initial commit"
   git remote add origin your-team-repo
   git push -u origin main
   ```

2. **Team members install**
   ```bash
   cd ~/.claude/skills/
   git clone your-team-repo/seer-reviewer.git
   ```

3. **Keep updated**
   ```bash
   cd ~/.claude/skills/seer-reviewer
   git pull
   ```

### Custom Modifications

For team-specific workflows:

1. Fork the skill
2. Modify SKILL.md with your practices
3. Share your fork with your team
4. Document changes in CHANGELOG.md

## System Requirements

- **OS**: macOS, Linux, or Windows (WSL)
- **Claude Code**: Version with skills support
- **GitHub CLI**: v2.0.0 or higher
- **Git**: v2.20.0 or higher
- **Node.js**: Not required (skill uses system tools)

## Next Steps

After installation:

1. Review [README.md](README.md) for usage guide
2. Check [EXAMPLES.md](EXAMPLES.md) for real scenarios
3. Try the skill on a test PR
4. Customize for your workflow (optional)
5. Share with your team

## Support

For issues or questions:
- Check [CONTRIBUTING.md](CONTRIBUTING.md)
- Review troubleshooting section above
- Open a GitHub issue (when available)

---

**Installation complete!** 🎉

Try: `"Review seer comments on PR #[number]"`
