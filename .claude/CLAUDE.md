# Global Claude Rules

## Behavior

- Be concise. Explain the "why" briefly, then provide code.
- If unsure, ask for clarification before acting.
- Provide a summary of changes made at the end of your response and the reason behind them when applicable, but be concise.
- When planning, don't mention testing or migration strategy unless explicitly asked or highly relevant.
- Provide constructive criticism when you spot issues
- Push back on flawed logic or problematic approaches
- When asked to implement a feature, always look thoroughly for existing code examples to make sure you follow existing patterns. When you come across different patterns, point them out and ask which one to follow. This applies to everything: architecture, code style, naming conventions, folder structure, testing, design, etc.
- Be THOROUGH when gathering information. Make sure you have the FULL picture before replying. Use additional tool calls or clarifying questions as needed.
- If you've performed an edit that may partially fulfill the USER's query, but you're not confident, gather more information or use more tools before ending your turn.
- Bias towards not asking the user for help if you can find the answer yourself.
- When asked for help to understand a problem, don't finish by asking the user what to do next. Just reply with the clear explanation. and end your turn. The user will ask for next steps or follow-up questions. if they need them.
- Efficiency is key — you have a time limit. Be meticulous in planning, tool calling, and verification so you don't waste time. Exit excessively long-running processes and optimize for speed.
- Routinely verify your code works as you go. Don't hand back until you're sure the problem is solved.
- When asking for permission to run a command, briefly mention why. Don't assume I have been reading all your chain of thought activity messages.

## Code Style

- Prefer writing clear code over comments. Avoid comments that just restate obvious code.
- Use constants for magic numbers or strings, such as query param keys, limits, etc.
- Be EXTRA careful of not repeating code. DRY is very important.

## Testing & Workflow

- Before finishing, run tests and lints to verify changes.

## Git

- Don't add commit descriptions.
- Don't prefix with feat:, fix:, etc. Just "<short description>", capitalized.
- Never mention Claude in commit messages.
- Do not use emojis in commit messages or code comments.
- Don't git push unless explicitly asked.

@~/.claude/work.md

## Machine Setup & Tooling

My dotfiles and config files live in `~/.macsetup` (a git repo), symlinked into place from their expected locations. The philosophy: anything worth keeping across a laptop replacement lives in `~/.macsetup` and is symlinked to wherever the tool expects it. This keeps everything version-controlled and portable.

**When asked to create or modify a config file that should persist across machines, move it into `~/.macsetup` (mirroring the expected path) and symlink it back.** Never write directly to a symlink path — resolve the real target first (`readlink` if unsure).

**This repo is public.** Never put anything sensitive in it — no credentials, internal URLs, company-specific tooling, work infrastructure details, or anything RevenueCat-related.

**Never commit or push to this repo automatically.** Always ask before staging or committing anything here.

### mise

I use [mise](https://mise.jdx.dev) to manage all runtime versions (Node, Python, Ruby, etc.) and CLI tools. Do not suggest `brew install`, `nvm`, `pyenv`, `rbenv`, `asdf`, or any other version manager for things mise handles.

- To install or switch a runtime: `mise use <tool>@<version>` or `mise install`
- mise shims live at `~/.local/share/mise/shims/` — use those paths when a tool isn't on PATH
- If a tool is missing, check `mise list` before assuming it needs installing

## Context About Me

- I am a developer working on the RevenueCat codebase, relatively new to the company and the codebase so I may need extra context or explanations.
- I am new to React, TypeScript, and Python tooling — explain things clearly when relevant and reference documentation when possible.
