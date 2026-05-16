Generate a PR title and description based on all changes on the current branch.

Steps:
1. Run `git branch --show-current` to get the current branch name
2. Run `git log main..HEAD --oneline` to see all commits on this branch
3. Run `git diff main...HEAD --stat` to see file change summary
4. Run `git diff main...HEAD` to see the full diff

Based on this information, generate:

## PR Title
A concise, descriptive title following conventional commit format:
- `feat:` for new features
- `fix:` for bug fixes
- `refactor:` for code restructuring
- `docs:` for documentation
- `chore:` for maintenance tasks

## PR Description
Using this format:

```markdown
## Summary
<2-3 bullet points summarizing the key changes>

## Changes
<List of specific changes made>

## Test Plan
<How to verify these changes work>
```

Present the title and description in a code block so it can be easily copied.
