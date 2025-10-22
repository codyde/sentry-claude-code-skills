# seer-reviewer

> A Claude Code skill for analyzing, validating, and fixing issues identified by seer-by-sentry bot in GitHub Pull Requests.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Claude Code](https://img.shields.io/badge/Claude-Code-orange)]()
[![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)]()

## Overview

**seer-reviewer** is an intelligent skill for Claude Code that automates the process of reviewing, validating, and fixing issues identified by the seer-by-sentry automated code review bot. Instead of manually checking each bot comment, this skill provides a systematic workflow to assess validity, prioritize by severity, and implement fixes.

### ✨ Key Features

- 🔍 **Automatic Comment Fetching** - Pulls PR comments via GitHub CLI
- ✅ **Smart Validation** - Verifies if bot-identified issues are real
- 🎯 **Priority Matrix** - Ranks issues by severity × confidence
- 🛠️ **Automated Fixes** - Applies validated fixes to PR branches
- 📊 **Detailed Reports** - Structured analysis of findings
- 🚀 **Git Workflow** - Handles branch checkout, commit, and push

## Quick Start

### Installation

```bash
# Copy to Claude skills directory
cp -r seer-reviewer ~/.claude/skills/

# Verify
ls ~/.claude/skills/seer-reviewer/SKILL.md
```

See [INSTALL.md](INSTALL.md) for detailed installation instructions.

### Usage

Simply ask Claude to review seer comments:

```
"Review seer-by-sentry comments on PR #38"
```

Claude will automatically:
1. Fetch all bot comments from the PR
2. Analyze and validate each issue
3. Prioritize by severity and confidence
4. Apply fixes for validated issues
5. Provide a detailed report

## How It Works

### 5-Phase Workflow

```mermaid
graph LR
    A[Fetch Comments] --> B[Validate Issues]
    B --> C[Test Analysis]
    C --> D[Implement Fixes]
    D --> E[Generate Report]
```

1. **Fetch & Parse** - Gets comments via `gh api`
2. **Validate** - Checks if issues are real by reading code
3. **Test** - Traces logic and verifies bot's analysis
4. **Fix** - Applies corrections to PR branch
5. **Report** - Provides structured summary

### Priority Matrix

Issues are prioritized using this matrix:

| Severity | Confidence | Action |
|----------|-----------|---------|
| High (≥0.8) | High (≥0.9) | 🚨 **FIX IMMEDIATELY** |
| High (≥0.8) | Low (<0.7) | 🔍 **INVESTIGATE** |
| Low (<0.5) | High (≥0.9) | ⏰ **FIX IF TIME** |
| Low (<0.5) | Low (<0.7) | ⏭️ **LIKELY SKIP** |

## Examples

### Example 1: Critical Bug Fix

**User**: "Review seer comments on PR #38"

**Result**:
```markdown
## Comment Analysis
- Location: .github/workflows/release-cli.yml:34
- Issue: Build script moves tarball to wrong directory
- Severity: 0.8 (Critical) | Confidence: 1.0 (High)

✅ VALID - Path resolution confirmed incorrect
✅ FIXED - Corrected build script destination path

Impact: Without fix, CI would fail and block releases
```

### Example 2: False Positive Detection

**User**: "Is that seer comment about async actually valid?"

**Result**:
```markdown
❌ FALSE POSITIVE

The async function properly awaits data before processing.
No race condition exists. Commented on PR to document.
```

See [EXAMPLES.md](EXAMPLES.md) for more real-world scenarios.

## Documentation

- 📖 [README.md](README.md) - Complete usage guide
- ⚡ [QUICKREF.md](QUICKREF.md) - Command cheat sheet
- 📚 [EXAMPLES.md](EXAMPLES.md) - Real-world scenarios
- 🔧 [INSTALL.md](INSTALL.md) - Installation guide
- 📝 [CHANGELOG.md](CHANGELOG.md) - Version history
- 🤝 [CONTRIBUTING.md](CONTRIBUTING.md) - Contribution guide

## Requirements

- Claude Code with skills support
- GitHub CLI (`gh`) installed and authenticated
- Git configured with repository access

## What This Solves

### Before seer-reviewer ❌
- Manually review each bot comment
- Uncertain if issues are real or false positives
- Time-consuming validation process
- Inconsistent fix quality
- No systematic prioritization

### After seer-reviewer ✅
- Automated comment analysis
- Intelligent validation of issues
- Structured priority system
- Consistent, tested fixes
- Detailed audit trail

## Configuration

No configuration required! The skill works out of the box.

**Optional customization**: Edit `~/.claude/skills/seer-reviewer/SKILL.md` to:
- Adjust severity thresholds
- Modify commit message templates
- Add custom validation rules
- Change priority matrix

## Use Cases

### Individual Developer
- Review bot comments on your PRs
- Validate issues before fixing
- Learn from false positives

### Code Reviewer
- Quickly assess bot feedback
- Prioritize critical issues
- Verify fixes before approving

### Team Lead
- Ensure bot comments are addressed
- Track issue patterns
- Maintain code quality standards

### DevOps/CI Engineer
- Fix CI-blocking issues fast
- Validate build configuration
- Maintain release pipeline health

## Real-World Impact

Based on actual usage (PR #38 in sentryvibe repo):

- **Issue**: Bot identified path resolution bug (Severity: 0.8, Confidence: 1.0)
- **Validation**: Confirmed tarball would be placed in wrong directory
- **Fix**: Corrected path in build script
- **Impact**: Prevented CI failure that would have blocked all releases
- **Time saved**: ~30 minutes of debugging and investigation

## Skill Structure

```
seer-reviewer/
├── SKILL.md           # Core skill instructions (required)
├── README.md          # Usage documentation
├── QUICKREF.md        # Command reference
├── EXAMPLES.md        # Real-world examples
├── INSTALL.md         # Installation guide
├── CHANGELOG.md       # Version history
├── CONTRIBUTING.md    # Contribution guide
├── LICENSE            # MIT License
└── .gitignore         # Git ignore rules
```

## Command Reference

### Review Commands
```
"Review seer comments on PR #X"
"Check seer-by-sentry feedback on PR #X"
```

### Validation Commands
```
"Is the seer comment about [topic] valid?"
"Check if seer warning is a real problem"
```

### Fix Commands
```
"Fix seer issues on PR #X"
"Apply seer-by-sentry suggestions"
```

See [QUICKREF.md](QUICKREF.md) for complete command list.

## Contributing

Contributions welcome! See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

### Ways to Contribute
- Report bugs or false positives
- Suggest new validation techniques
- Improve documentation
- Add example scenarios
- Share custom modifications

## License

MIT License - see [LICENSE](LICENSE) for details.

## Credits

Created by [Cody De Arkland](https://github.com/codyde)

Inspired by real-world usage with seer-by-sentry bot on GitHub PRs.

## Related Projects

- [Claude Code](https://claude.ai/code) - AI-powered coding assistant
- [Anthropic Skills](https://github.com/anthropics/skills) - Official Claude skills
- [GitHub CLI](https://cli.github.com/) - GitHub command-line tool

## Support

- 📖 Read the [documentation](README.md)
- 💬 Open an [issue](../../issues)
- 🤝 Check [contributing guide](CONTRIBUTING.md)

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for version history.

## Status

**Version**: 1.0.0
**Status**: ✅ Stable
**Tested**: Claude Code with skills support
**Updated**: 2025-10-18

---

**Made with ❤️ for the Claude Code community**

🚀 Install now: `cp -r seer-reviewer ~/.claude/skills/`
