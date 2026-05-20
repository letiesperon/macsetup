# Work-Specific Claude Config (Manual Step on New Machine)

`~/.macsetup` is a **public** repo, so work-related Claude instructions live outside it in a file that is never committed:

```
~/.claude/work.md
```

This file contains RevenueCat-specific context: internal URLs, Mafdet MCP tool reference, repo layout, etc. It is loaded automatically by Claude Code because `~/.macsetup/.claude/CLAUDE.md` imports it at the bottom via:

```
@~/.claude/work.md
```

## When setting up a new machine

After cloning macsetup and running the install scripts, manually create `~/.claude/work.md`. Copy the content from your old machine, or recreate it from scratch — it should contain the `## RevenueCat Specific` section (see the git history of this repo for the last committed version, before it was moved out).

The file is covered by the global `~/.gitignore` (`work.md` pattern), so it will not be accidentally committed anywhere.

## Why this approach

- `CLAUDE.md` stays in the public repo and is safe to share
- `work.md` stays local and private, never tracked by git
- Claude loads both seamlessly via the `@import` syntax — no manual steps at runtime
