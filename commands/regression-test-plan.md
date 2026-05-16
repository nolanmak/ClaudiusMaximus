---
description: Analyze all changes on this branch, find regression test gaps, and plan fixes
allowed-tools: Bash(git:*), Read(**), Grep(**), Glob(**)
argument-hint: "[base-branch]"
---

## Git Branch Analysis

**Arguments provided:** $ARGUMENTS

**Instructions:** If no base branch argument provided above, use `main` as the default.

Run these git commands to analyze the branch:

1. Show current branch: `git branch --show-current`
2. Show commits since base: `git log <base-branch>..HEAD --oneline`
3. Show files changed: `git diff <base-branch>...HEAD --stat`
4. Show full diff: `git diff <base-branch>...HEAD`

Replace `<base-branch>` with the argument above, or `main` if none provided.

## Your Task

Analyze ALL changes on this branch. Look for gaps in regression test coverage. If you find any, plan a fix.

### Step 1: Understand What Changed
Read the full diff and classify changes by area (UI, state management, data flow, API, utils, etc.).

### Step 2: Find Existing Tests
For each changed file, check whether corresponding tests exist:
- Search for test files matching the changed modules
- Read existing tests to understand current coverage
- Note any changed code paths that have zero test coverage

### Step 3: Identify Gaps
For each changed file/function, answer:
- Is there a test that exercises this change?
- Could this change break an existing feature that isn't tested?
- Are there edge cases in the new code that aren't covered?

### Step 4: Report Findings
Present a clear summary:

**Covered**: Changes that have adequate test coverage (list them briefly)

**Gaps Found**: Changes lacking test coverage, with:
- What's missing and why it matters
- Risk level (HIGH / MEDIUM / LOW)
- Which existing features could regress

### Step 5: Plan Fixes (if gaps found)
For each gap, provide a concrete fix plan:
- Which test file to create or modify
- What test cases to add (description + expected behavior)
- Priority order for writing them
