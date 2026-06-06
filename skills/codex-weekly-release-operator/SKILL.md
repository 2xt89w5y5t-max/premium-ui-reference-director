---
name: codex-weekly-release-operator
description: "Use when maintaining or publishing Codex skill/plugin repositories on a weekly cadence: inspect repository changes, add reusable skills/scripts/examples, update README/CHANGELOG/docs, prepare GitHub release notes, create Douyin/Xiaohongshu creator copy, and decide whether to commit or push safely."
---

# Codex Weekly Release Operator

Use this skill to turn a Codex skills/plugins repository into a repeatable weekly open-source release.

## Workflow

1. Inspect the repository before editing:
   - `git status --short --branch`
   - recent commits from the last 7 days
   - top-level directories such as `README.md`, `CHANGELOG.md`, `docs/`, `tools/`, `skills/`, `plugins/`, `examples/`, and `output/`
2. Identify one small, useful improvement:
   - a new Codex skill
   - a helper script
   - a usage example
   - a missing documentation page
   - a cleanup that makes installation or publishing clearer
3. Keep changes publishable:
   - prefer reusable assets over one-off notes
   - do not delete existing user content
   - avoid changing unrelated style or formatting
   - include usage notes and failure handling for every new script
4. Update release-facing docs:
   - `README.md` for project positioning and quick start
   - `CHANGELOG.md` for the dated update
   - `docs/usage.md` or `docs/examples.md` when the new workflow needs more space
5. Verify with the smallest reliable checks:
   - parse or validate modified skills when possible
   - run new scripts in a dry-run or example mode
   - inspect `git diff --stat`
6. Commit and push only when safe:
   - commit valid local changes with a clear message
   - push only if remote and credentials are available
   - never expose tokens, cookies, API keys, or account secrets
   - stop before irreversible external publishing unless the user explicitly confirms

## Release Pack Contents

Generate a compact release pack with:

- GitHub release summary
- CHANGELOG entry
- vertical Douyin cover prompt, 9:16
- horizontal cover prompt, 16:9
- Douyin title, body copy, tags, comment prompt, and 30-60 second voiceover
- blockers and next actions

Use `tools/new-weekly-release-pack.ps1` when present. If it is missing, create the release pack manually under `output/weekly-release-YYYY-MM-DD.md`.

## Decision Rules

- If the repository has no `CHANGELOG.md`, add it before creating a release pack.
- If there is no `examples/` directory, add one useful example rather than an empty placeholder.
- If `plugins/` is missing, document that no standalone plugin bundle exists yet instead of inventing a fake plugin.
- If Git is in detached `HEAD`, local commit is allowed only when requested by the automation flow, but report that branch/PR workflow is externally managed.
- If push fails because remote or credentials are unavailable, keep the local commit and report the exact blocker.

## Quality Bar

The weekly update should be:

- installable or copyable by another Codex user
- understandable from GitHub without private context
- useful for at least one real automation, browser, publishing, UI, or creator workflow
- concise enough to read quickly
- specific enough to avoid becoming generic content marketing
