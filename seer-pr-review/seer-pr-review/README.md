# Seer-by-Sentry PR Comment Reviewer Skill

A Claude Code skill for systematically analyzing, validating, and fixing issues identified by the seer-by-sentry automated code review bot in GitHub Pull Requests.

## Overview

This skill provides a structured workflow for handling automated PR review comments from seer-by-sentry, including:
- Fetching and parsing bot comments
- Validating whether issues are real or false positives
- Assessing severity and confidence scores
- Implementing fixes for verified issues
- Providing detailed reports on findings

## Installation

The skill is already installed at:
```
~/.claude/skills/seer-pr-review/
```

Claude Code will automatically load this skill when relevant.

## How to Use

### Automatic Invocation

Claude will automatically use this skill when you mention seer-by-sentry or PR reviews:

```
"Can you review the seer comments on PR #38?"
"Check if the seer-by-sentry feedback on this PR is valid"
"Apply fixes for seer bot comments"
"Check recent PRs for seer comments"
"Review any seer feedback on the latest PRs"
```

### Manual Invocation

You can explicitly invoke the skill:

```
/skill seer-pr-review
```

## Example Usage

### Review Specific PR
```
User: Review the seer-by-sentry comments on PR #38
Claude: [Automatically uses seer-pr-review skill to fetch, analyze, and validate comments]
```

### Review Recent PRs (No PR Number Required)
```
User: Check recent PRs for seer comments
Claude: [Lists recent PRs, finds those with seer comments, and provides options]
```

```
User: Review any seer feedback on the latest PRs
Claude: [Checks last 10 PRs, identifies PRs with seer comments, and reviews them]
```

```
User: Are there any seer issues I should look at?
Claude: [Scans recent PRs for seer-by-sentry comments and reports findings]
```

### Implement Fixes
```
User: Fix the issues identified by seer on PR #42
Claude: [Uses skill to validate issues, checkout branch, apply fixes, and push]
```

### Validate Specific Comment
```
User: Is the seer comment about the build path actually a problem?
Claude: [Uses skill to analyze that specific comment and provide assessment]
```

## What This Skill Does

1. **Fetches PR comments** using GitHub CLI
2. **Parses bot comments** to extract issue details, severity, and confidence
3. **Validates issues** by checking actual code and context
4. **Assesses risk** using severity × confidence matrix
5. **Implements fixes** for verified issues
6. **Creates commits** with detailed messages
7. **Provides reports** summarizing findings and actions

## Key Features

### Priority Matrix
- High Severity × High Confidence = Fix Immediately
- High Severity × Low Confidence = Investigate Thoroughly
- Low Severity × High Confidence = Fix If Time Permits
- Low Severity × Low Confidence = Likely Ignore

### Validation Steps
- ✅ Verify file paths and line numbers
- ✅ Check surrounding code context
- ✅ Trace execution flow
- ✅ Test the bot's analysis
- ✅ Assess actual impact

### Best Practices
- Never blindly implement suggestions
- Always verify before fixing
- Document false positives
- Use clear commit messages
- Switch back to main branch after pushing

## Common Issue Types Handled

- **Path Resolution Errors**: Build scripts, file movements
- **Missing Error Handling**: Uncaught exceptions
- **Race Conditions**: Async/await issues
- **Type Mismatches**: TypeScript errors
- **Configuration Issues**: Missing or incorrect configs
- **Security Vulnerabilities**: Exposed secrets, injections

## Output Format

The skill provides structured reports:

```markdown
## Seer-by-Sentry Comment Review

### Comment Analysis
- Location: file.ts:42
- Issue: Build script moves tarball to wrong directory
- Severity: 0.8 (Critical)
- Confidence: 1.0 (High)

### Validation Result
✅ VALID - Path resolution confirmed incorrect

### Action Taken
✅ FIXED - Corrected path in build script

### Impact
Without fix, CI verification would fail and block releases
```

## Requirements

- GitHub CLI (`gh`) installed and authenticated
- Git access to the repository
- Appropriate branch permissions

## Customization

You can modify the skill by editing:
```
~/.claude/skills/seer-pr-review/SKILL.md
```

Add custom rules, change priority thresholds, or adjust the workflow to match your team's needs.

## Tips

1. **Start with high-severity issues** - These are most likely to break things
2. **Check confidence scores** - Low confidence may indicate false positives
3. **Read the context** - Don't just look at the flagged line
4. **Test when possible** - Run builds or tests to verify fixes
5. **Document decisions** - Explain why you fixed or skipped issues

## Example Session

```bash
User: Review seer comments on PR #38

Claude: I'll analyze the seer-by-sentry comments on PR #38.

[Fetches comments...]
[Analyzes 1 comment found...]

## Comment Analysis
- Location: .github/workflows/release-cli.yml:34
- Issue: build:agent-core script moves tarball to wrong path
- Severity: 0.8 (Critical)
- Confidence: 1.0 (High)

✅ VALID - Verified path resolution issue

[Checking out branch...]
[Applying fix...]
[Committing changes...]
[Pushing to PR...]

✅ FIXED - Updated package.json build:agent-core script
PR has been updated with the fix.
```

## Troubleshooting

**Skill not loading?**
- Check that SKILL.md exists in `~/.claude/skills/seer-pr-review/`
- Restart Claude Code if needed

**Can't fetch PR comments?**
- Verify GitHub CLI is authenticated: `gh auth status`
- Check you have access to the repository

**Branch checkout fails?**
- Ensure no uncommitted changes: `git status`
- Verify PR branch exists: `gh pr view <number>`

## Learn More

- [Claude Skills Documentation](https://www.anthropic.com/news/skills)
- [Skills Repository](https://github.com/anthropics/skills)
- [GitHub CLI Documentation](https://cli.github.com/manual/)

## Version

**Version**: 1.0.0
**Created**: 2025-10-18
**Compatibility**: Claude Code with skills support
