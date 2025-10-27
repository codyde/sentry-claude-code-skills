# seer-pr-review Examples

Real-world examples of using the seer-pr-review skill.

## Example 1: Review Recent PRs Without Specifying Number

### Scenario
User wants to check if any recent PRs have sentry-io bot comments, without knowing specific PR numbers.

### User Input
```
"Check recent PRs for sentry comments"
```

### Skill Execution

#### Phase 1: List Recent PRs
```bash
gh pr list --limit 10 --json number,title,author,updatedAt,headRefName
```

Results:
- PR #47: "Add user authentication" (updated 2 hours ago)
- PR #42: "Fix database connection" (updated 5 hours ago)
- PR #38: "Update build script" (updated 1 day ago)
- PR #35: "Refactor API endpoints" (updated 3 days ago)
- ...

#### Phase 2: Check Each PR for Sentry Comments
```bash
# Check PR #47
gh api repos/codyde/sentryvibe/pulls/47/comments
# Result: No sentry comments

# Check PR #42
gh api repos/codyde/sentryvibe/pulls/42/comments
# Result: 2 sentry comments found (severity: 0.7, 0.5)

# Check PR #38
gh api repos/codyde/sentryvibe/pulls/38/comments
# Result: 1 sentry comment found (severity: 0.8)

# Check PR #35
gh api repos/codyde/sentryvibe/pulls/35/comments
# Result: No sentry comments
```

#### Phase 3: Present Options
```markdown
Found sentry-io bot comments on recent PRs:

• PR #38: "Update build script" (1 comment, severity: 0.8)
  - Critical path resolution bug in build script

• PR #42: "Fix database connection" (2 comments)
  - Missing error handling (severity: 0.7)
  - Inefficient query (severity: 0.5)

Would you like me to:
1. Review PR #38 first (highest severity)
2. Review all PRs with sentry comments
3. Review a specific PR
```

#### Phase 4: User Chooses & Review Proceeds
```
User: Review PR #38 first

Claude: I'll analyze the sentry-io bot comment on PR #38...
[Continues with standard review workflow from Example 2]
```

### Alternative: Auto-Review Single PR
If only one PR has sentry comments, automatically proceed:

```
User: Check recent PRs for sentry comments

Claude: Found 1 sentry-io bot comment on PR #38...
[Automatically begins review without asking]
```

### Alternative: No Comments Found
```
User: Are there any sentry issues I should look at?

Claude: I checked the 10 most recent PRs and found no sentry-io bot comments.
All recent PRs are clear! ✅
```

---

## Example 2: Critical Path Resolution Bug

### Scenario
Sentry-io bot identifies that a build script moves a tarball to the wrong directory, which will break CI.

### User Input
```
"Review the sentry comments on PR #38"
```

### Skill Execution

#### Phase 1: Fetch & Parse
```bash
gh api repos/codyde/sentryvibe/pulls/38/comments
```

Found comment:
- **File**: `.github/workflows/release-cli.yml`
- **Line**: 34
- **Severity**: 0.8 (Critical)
- **Confidence**: 1.0 (High)
- **Issue**: `build:agent-core` script moves tarball to `../../vendor/` instead of `../../apps/runner/vendor/`

#### Phase 2: Validate
```javascript
// Current script in package.json:
"build:agent-core": "cd packages/agent-core && pnpm build && pnpm pack && mv *.tgz ../../vendor/"

// Path resolution from packages/agent-core/:
// ../../vendor/ = /vendor/ (repository root)

// CI expects file at:
// apps/runner/vendor/sentryvibe-agent-core-0.1.0.tgz
```

✅ **Validation Result**: VALID - Path is definitely wrong

#### Phase 3: Test
- Traced path: `packages/agent-core/` → `../../vendor/` = `/vendor/`
- CI workflow checks: `apps/runner/vendor/*.tgz`
- **Impact**: CI will fail with "Required vendor file not found!"

#### Phase 4: Fix
```bash
# Checkout PR branch
git fetch origin pull/38/head:fix/linux-pnpm-opentelemetry
git checkout fix/linux-pnpm-opentelemetry

# Edit package.json
# Change: mv *.tgz ../../vendor/
# To:     mv *.tgz ../../apps/runner/vendor/

# Commit
git commit -m "fix(build): correct agent-core tarball destination path

Fix build:agent-core script to move tarball to correct location.
The script was moving to ../../vendor/ (repo root) instead of
../../apps/runner/vendor/ where CI expects it.

Resolves issue identified by sentry-io bot.
Severity: 0.8, Confidence: 1.0

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>"

# Push
git push origin fix/linux-pnpm-opentelemetry
```

#### Phase 5: Report
```markdown
## Sentry-io Bot Comment Review

### Comment Analysis
- **Location**: .github/workflows/release-cli.yml:34
- **Issue**: Build script moves tarball to incorrect path
- **Severity**: 0.8 (Critical)
- **Confidence**: 1.0 (High)

### Validation Result
✅ VALID

**Analysis**: Traced path resolution from working directory. Script runs
from `packages/agent-core/` and moves to `../../vendor/` which resolves to
repository root, not `apps/runner/vendor/` where CI expects it.

### Action Taken
✅ FIXED

**Details**: Updated package.json line 10 to change destination path from
`../../vendor/` to `../../apps/runner/vendor/`. Committed and pushed to PR branch.

### Impact
Without this fix, the CI release workflow would fail at the verification
step with "Required vendor file not found!" error, completely blocking
CLI releases.
```

---

## Example 3: False Positive Detection

### Scenario
Sentry-io bot flags potential race condition, but code is actually safe.

### User Input
```
"Check if that sentry comment about the async issue is valid"
```

### Skill Execution

#### Comment Details
- **Severity**: 0.6 (Medium)
- **Confidence**: 0.7 (Medium)
- **Issue**: "Async function may execute before dependency is ready"

#### Validation
```typescript
// Flagged code:
async function processItems() {
  const items = await fetchItems();
  return items.map(item => transform(item)); // Flagged here
}

// Analysis:
// - fetchItems() is awaited before map() executes
// - transform() is synchronous function
// - No race condition exists
```

✅ **Validation Result**: FALSE POSITIVE

#### Report
```markdown
## Sentry Comment Analysis

### Validation Result
❌ FALSE POSITIVE

**Reasoning**:
- The async function properly awaits `fetchItems()` before processing
- `transform()` is a synchronous function (no async operations)
- The array map executes only after data is fully fetched
- No race condition can occur in this code path

### Action Taken
⏭️ SKIPPED - No fix needed

**Explanation**: The bot likely flagged this due to the async function
containing a map operation, but the map itself doesn't introduce any
race conditions since it operates on already-fetched data.

Commented on PR to document this false positive.
```

---

## Example 4: Multiple Issues, Prioritized

### Scenario
PR has 3 sentry-io bot comments with different priorities.

### User Input
```
"Fix all sentry issues on PR #47"
```

### Comments Found

1. **High Priority** (Severity: 0.9, Confidence: 0.95)
   - Missing error handling in database query
   - **Action**: FIX IMMEDIATELY

2. **Medium Priority** (Severity: 0.5, Confidence: 0.9)
   - Inefficient loop that could be optimized
   - **Action**: FIX IF TIME

3. **Low Priority** (Severity: 0.3, Confidence: 0.6)
   - Style inconsistency
   - **Action**: SKIP

### Execution Order

#### Issue #1: Missing Error Handling
```typescript
// Before:
async function getUser(id: string) {
  const user = await db.query('SELECT * FROM users WHERE id = ?', [id]);
  return user;
}

// After:
async function getUser(id: string) {
  try {
    const user = await db.query('SELECT * FROM users WHERE id = ?', [id]);
    return user;
  } catch (error) {
    logger.error('Failed to fetch user', { id, error });
    throw new Error(`User lookup failed: ${error.message}`);
  }
}
```
✅ **FIXED**

#### Issue #2: Inefficient Loop
```typescript
// Before:
items.forEach(item => {
  if (item.active) {
    processItem(item);
  }
});

// After:
items.filter(item => item.active).forEach(processItem);
```
✅ **FIXED**

#### Issue #3: Style Inconsistency
⏭️ **SKIPPED** - Low severity × medium confidence = not critical

### Final Report
```markdown
## Multiple Sentry-io Bot Issues - PR #47

### Summary
- Total Comments: 3
- Fixed: 2
- Skipped: 1

### Issue #1 - Missing Error Handling ✅ FIXED
- Severity: 0.9 | Confidence: 0.95
- Added try/catch with logging and user-friendly error message

### Issue #2 - Inefficient Loop ✅ FIXED
- Severity: 0.5 | Confidence: 0.9
- Refactored to use filter/forEach for cleaner code

### Issue #3 - Style Inconsistency ⏭️ SKIPPED
- Severity: 0.3 | Confidence: 0.6
- Low priority, can be addressed in future PR if needed

All critical and medium issues resolved. PR updated.
```

---

## Example 5: Investigation Required

### Scenario
High severity but low confidence - needs thorough investigation.

### User Input
```
"What's this sentry warning about the memory leak?"
```

### Comment Details
- **Severity**: 0.8 (Critical)
- **Confidence**: 0.5 (Low)
- **Issue**: "Potential memory leak in event listener"

### Investigation Process

1. **Read the code**
2. **Check for cleanup**
3. **Trace component lifecycle**
4. **Test manually if needed**

### Finding
```javascript
// Flagged code:
useEffect(() => {
  window.addEventListener('resize', handleResize);
}, []);

// Issue: Missing cleanup!
// Should be:
useEffect(() => {
  window.addEventListener('resize', handleResize);
  return () => window.removeEventListener('resize', handleResize);
}, []);
```

✅ **Validation Result**: VALID - Bot was correct despite low confidence

### Report
```markdown
## Investigation Complete

### Initial Assessment
- High severity (0.8) but low confidence (0.5)
- Required thorough investigation before acting

### Finding
✅ VALID - Despite low confidence, the issue is real

**Details**: The useEffect hook adds an event listener but never removes it.
Each time the component unmounts and remounts, a new listener is added,
causing a memory leak over time.

### Action Taken
✅ FIXED - Added cleanup function to useEffect

This demonstrates why high-severity issues should be investigated even
with low confidence scores. The bot correctly identified a subtle bug.
```

---

## Tips from These Examples

1. **Always validate high-severity issues**, even with low confidence
2. **Don't blindly trust low-confidence warnings** - investigate first
3. **Prioritize by severity × confidence** - the matrix works
4. **Document false positives** - helps improve the process
5. **Test your fixes** - don't just apply suggested changes
6. **Use clear commit messages** - future you will thank you

---

## Command Patterns

### Review Specific PR
```
"Review sentry comments on PR #X"
"Check sentry feedback on PR #X"
"What did sentry-io bot say about PR #X?"
```

### Review Recent PRs (No PR Number)
```
"Check recent PRs for sentry comments"
"Review any sentry feedback on the latest PRs"
"Are there any sentry issues I should look at?"
"Find PRs with sentry-io bot comments"
"What recent PRs have sentry comments?"
```

### Validate Specific Issue
```
"Is that sentry comment about [topic] actually valid?"
"Check if the sentry warning about [file] is a real problem"
```

### Implement Fixes
```
"Fix the sentry issues on PR #X"
"Apply the sentry-io bot suggestions to PR #X"
"Implement fixes for sentry comments"
```

### Investigation Mode
```
"Investigate the sentry warning about [topic]"
"Why is sentry flagging [file]?"
"Explain the sentry comment on line X"
```
