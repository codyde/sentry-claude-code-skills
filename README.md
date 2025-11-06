# Sentry Claude Code Skills

A collection of Claude Code skills for enhancing your development workflow with Sentry and related tools.

## What are Claude Code Skills?

Skills are extensions that enhance Claude Code's capabilities by providing specialized workflows, domain knowledge, and automated processes. They're automatically loaded by Claude when relevant to your task.

Learn more: [Claude Code Skills Documentation](https://docs.claude.com/claude-code/skills)

## Why not just make more MCP tools?

**Skills and MCP tools serve different purposes.** MCP tools connect Claude to external services and data sources (databases, APIs, monitoring platforms), while Skills package domain expertise and workflows directly into Claude's decision-making process. **Skills are automatically invoked by Claude when contextually relevant, whereas MCP tools require explicit calls—think of Skills as "teaching Claude how to think about a problem" versus MCP tools as "giving Claude access to external systems."**

## Available Skills

### 🔍 Seer-PR-Review

Systematically analyze, validate, and fix issues identified by the sentry automated code review bot in GitHub Pull Requests.

**Features:**
- Fetch and parse bot comments from PRs
- Validate whether issues are real or false positives
- Assess severity and confidence scores
- Implement fixes for verified issues
- Provide detailed analysis reports

**Use cases:**
- "Review seer comments on PR #38"
- "Fix the issues identified by seer on PR #42"
- "Is the seer comment about the build path actually a problem?"

[📖 Full Documentation](./seer-pr-review/seer-pr-review/README.md) | [📋 Examples](./seer-pr-review/seer-pr-review/EXAMPLES.md)

## Installation

### Quick Start: Install All Skills

Install all available skills at once:

```bash
# Clone the repository
cd ~/.claude/skills/
git clone https://github.com/codyde/sentry-claude-code-skills.git

# Run the installation script
cd sentry-claude-code-skills
./install-all.sh
```

The script will:
- Check for prerequisites
- Install each skill to `~/.claude/skills/`
- Verify installation success
- Provide next steps

### Individual Skill Installation

To install a specific skill:

```bash
# Clone the repository
git clone https://github.com/codyde/sentry-claude-code-skills.git
cd sentry-claude-code-skills

# Navigate to the skill directory
cd seer-pr-review/seer-pr-review

# Run the skill's install script
./install.sh
```

Or manually:

```bash
# Copy skill to Claude skills directory
cp -r seer-pr-review/seer-pr-review ~/.claude/skills/seer-pr-review
```

## Usage

Once installed, skills are automatically invoked by Claude when relevant to your request. Simply mention topics related to the skill:

```
"Review the sentry comments on PR #38"
"Check if the seer feedback on this PR is valid"
"Check recent PRs for seer comments"
```

## Skill Structure

Each skill follows this structure:

```
skill-name/
├── skill-name/
│   ├── SKILL.md          # Required: Skill definition
│   ├── README.md         # Usage documentation
│   ├── INSTALL.md        # Installation guide
│   ├── EXAMPLES.md       # Real-world examples
│   ├── QUICKREF.md       # Quick reference
│   ├── install.sh        # Installation script
│   └── LICENSE           # License file
└── README.md             # Repository info
```

## Verifying Installation

After installation, verify that skills are loaded:

```bash
# Check installed skills
ls -la ~/.claude/skills/

# You should see:
# - seer-pr-review/
```

Then test in Claude Code:

```
"Review seer comments on PR #[number]"
```

## Updating Skills

### Update All Skills

```bash
cd ~/.claude/skills/sentry-claude-code-skills
git pull origin main
./install-all.sh
```

### Update Individual Skill

```bash
cd sentry-claude-code-skills
git pull origin main
cd [skill-name]/[skill-name]
./install.sh
```

## Uninstallation

### Remove All Skills

```bash
# Remove the repository
rm -rf ~/.claude/skills/sentry-claude-code-skills

# Remove individual skills
rm -rf ~/.claude/skills/seer-pr-review
```

### Remove Individual Skill

```bash
rm -rf ~/.claude/skills/[skill-name]
```

## Contributing

We welcome contributions! Here's how to get started:

1. **Fork the repository**
2. **Create a new skill** or improve an existing one
3. **Follow the skill structure** outlined above
4. **Test thoroughly** with Claude Code
5. **Submit a pull request**

### Creating a New Skill

```bash
# Create skill directory structure
mkdir -p my-skill/my-skill
cd my-skill/my-skill

# Create required files
touch SKILL.md README.md INSTALL.md EXAMPLES.md QUICKREF.md install.sh

# Follow existing skills as templates
```

 **Documentation**: [Claude Code Docs](https://docs.claude.com/claude-code/skills)

## Changelog

### v1.0.0 (2025-10-22)

- Initial release
- Added seer-pr-review skill
- Created repository structure
- Added install-all.sh script

---

**Ready to get started?**

```bash
cd ~/.claude/skills/
git clone https://github.com/codyde/sentry-claude-code-skills.git
cd sentry-claude-code-skills
./install-all.sh
```

Then try: `"Review seer comments on PR #[number]"`
