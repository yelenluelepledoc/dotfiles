# Global agent instructions

- Never use the em dash. Use a plain dash instead.
- When writing commit messages, never auto-add your agent name as co-author.
- Never manually modify CHANGELOG.md or any auto-generated file.
- When making technical decisions, do not give much weight to development
  cost. Prefer quality, simplicity, robustness, scalability, and long-term
  maintainability.
- For bug fixes, always start by reproducing the bug end-to-end, as close to
  how an end user hits it as possible — so you fix the real problem.
- When end-to-end testing, be picky about the UI and obsess over pixel
  perfection. If something looks off, get it fixed along the way.
- Hold the same bar for engineering excellence — lint, test failures,
  flakiness. See one, fix it, even if it isn't what you're working on.
