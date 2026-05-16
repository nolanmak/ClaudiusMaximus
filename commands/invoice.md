Generate an invoice summary of work done by nolanmak for the specified time period.

## Instructions

1. Parse the user's date range from arguments: $ARGUMENTS
   - "december" → 2024-12-01 to 2024-12-31
   - "12/1 - 12/20" → specific range
   - "last 2 weeks" → calculate from today
   - "january" → 2025-01-01 to 2025-01-31

2. Run git commands to find merged PRs:

```bash
git fetch origin
git log origin/main --author="nolanmak" --since="{start_date}" --until="{end_date}" --oneline --format="%as | %s" | grep -E "#[0-9]+"
```

3. Categorize each PR by analyzing the title:
   - **Features**: feat:, feature:, add, implement, new
   - **Bug Fixes**: fix:, bugfix:, hotfix:, patch
   - **Cleanup**: cleanup:, remove, delete, deprecate, chore:
   - **Refactor**: refactor:, restructure
   - **Docs**: docs:, documentation
   - **Tests**: test:, tests:
   - **Other**: anything else

4. Output in this exact format:

```
## Invoice Summary: {start_date} to {end_date}

**Features ({count})**

  - {MM/DD} | #{PR_NUMBER} | {clean_title}
  - {MM/DD} | #{PR_NUMBER} | {clean_title}

**Bug Fixes ({count})**

  - {MM/DD} | #{PR_NUMBER} | {clean_title}

**Cleanup ({count})**

  - {MM/DD} | #{PR_NUMBER} | {clean_title}

---

**Total: {total} PRs merged ({breakdown})**
```

5. Only show categories that have items
6. Sort by date within each category (newest first)
7. Extract PR number from (#123) pattern in commit message
8. Clean up titles: remove conventional commit prefix and PR number suffix
