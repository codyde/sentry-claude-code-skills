# Seer-Reviewer Quick Reference

## Invocation
```
"Review seer comments on PR #X"
"Check seer-by-sentry feedback"
"Fix seer bot issues"
```

## Priority Matrix
```
Severity × Confidence = Action
━━━━━━━━━━━━━━━━━━━━━━━━━━━━
High × High    = FIX NOW ⚠️
High × Low     = INVESTIGATE 🔍
Low × High     = FIX LATER ⏰
Low × Low      = LIKELY SKIP ⏭️
```

## Severity Scale
- **≥ 0.8**: Critical - Blocks functionality
- **0.5-0.7**: Medium - Causes issues
- **< 0.5**: Low - Minor improvements

## Confidence Scale
- **≥ 0.9**: Very likely correct
- **0.7-0.8**: Probably correct
- **< 0.7**: May be false positive

## 5-Phase Workflow

### 1️⃣ Fetch & Parse
```bash
gh api repos/owner/repo/pulls/PR#/comments
```

### 2️⃣ Validate
- Read surrounding code
- Verify paths/line numbers
- Check if issue exists
- Assess actual impact

### 3️⃣ Test
- Trace execution flow
- Check for edge cases
- Create reproduction if possible

### 4️⃣ Fix
```bash
git fetch origin pull/PR#/head:branch
git checkout branch
# Make changes
git add . && git commit
git push origin branch
git checkout main
```

### 5️⃣ Report
- Issue summary
- Validation result
- Action taken
- Impact analysis

## Common Issues
- 🛤️ Path resolution errors
- 🚨 Missing error handling
- ⏱️ Race conditions
- 📝 Type mismatches
- ⚙️ Config issues
- 🔒 Security vulnerabilities

## Do's ✅
- Verify before fixing
- Check both severity AND confidence
- Read code context
- Document decisions
- Use clear commit messages

## Don'ts ❌
- Blindly implement suggestions
- Fix low-confidence issues without investigation
- Ignore high-severity warnings
- Push to main/master
- Make unrelated changes

## Quick Commands
```bash
# View PR
gh pr view PR#

# Get diff
gh pr diff PR#

# View comments
gh api repos/owner/repo/pulls/PR#/comments

# Checkout PR
git fetch origin pull/PR#/head:branch && git checkout branch

# Push fix
git push origin branch

# Back to main
git checkout main
```

## Commit Template
```
fix: address seer-by-sentry comment - <brief>

<detailed explanation>

Resolves issue identified by seer-by-sentry bot.
Severity: X.X, Confidence: X.X

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
```

## Bot Identifier
- **Login**: `seer-by-sentry[bot]`
- **ID**: 157164994
- **Type**: Automated code review bot
