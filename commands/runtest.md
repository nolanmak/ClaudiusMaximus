Run the complete test and lint suite, fixing ALL failures regardless of whether they're related to recent changes:

1. First run `npm run format` to auto-fix formatting issues (Prettier, ESLint auto-fixes, Rustfmt)
2. Then run `npm run check` to verify linting passes
3. Run `npm test` to execute the test suite
4. Run `npm run test:rust` for Rust tests

If any step fails:
- Investigate and fix the root cause
- Re-run the failing step to verify the fix
- Continue to the next step only after the current one passes

Do NOT skip or ignore failures. Fix everything until all checks pass clean.
