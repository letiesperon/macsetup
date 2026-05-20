---
name: fix-code-review
description: Use when the user asks to fix code review comments, address PR feedback, fix CR comments, resolve review comments, or any variation of "fix PR review comments". Walks through each comment one at a time, applying fixes and committing per comment only after the user approves.
---

# Fix Code Review Comments

Follow this procedure strictly. Do not batch comments — one comment per commit, approved by the user before committing.

## Step 1: List all unresolved comments

Use `gh` to fetch every comment on the PR.

```
gh pr view <pr_number> --repo <owner>/<repo> --comments
gh api repos/<owner>/<repo>/pulls/<pr_number>/comments
```

Present the user with a numbered list of every comment, including the file and line each one points to. Confirm the list is complete before continuing.

## Step 2: For each comment, in order

For comment N:

1. **Understand the comment.** Quote it back and identify the file/line. Read the surrounding code and look for related examples elsewhere in the repo to make sure the fix matches existing patterns.
2. **Ask if unclear.** If the comment is ambiguous, or if there are multiple reasonable interpretations, ask the user before changing anything.
3. **Apply the fix.**
4. **Check for the same issue elsewhere in the PR.** Look at every other changed file in the PR. If the same problem applies, fix it there too as part of this same comment.
5. **Run tests and lints** for the changed files. Make sure they pass.
6. **Ask the user to review.** Show the diff. Link to the original PR comment you're addressing. Cite any code examples you used as reference. Wait for explicit approval.
7. **On approval, commit.** A single commit with a short description (no body, no message body). Then move to the next comment.

Do not move to the next comment until the previous one is committed and approved.

## Notes

- Don't add `Co-Authored-By: Claude` lines.
- Don't prefix commits with `fix:`, `feat:`, etc. — just a short capitalized description.
- Don't push unless the user explicitly asks.
