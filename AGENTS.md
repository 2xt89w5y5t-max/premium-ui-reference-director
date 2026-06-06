# Learned Skill And Plugin Rules

Use these local skills and plugin indexes when the request matches their trigger.

## Skill routing

- Use `docs/全部技能索引.md` as the local skill map when a task mentions skills, reusable workflows, browser automation, desktop automation, UI work, GitHub publishing, API integration, data analysis, ecommerce, AI generation, or code review.
- Route from the task signal to the smallest useful skill set, then read only the selected `SKILL.md` and the directly needed references/scripts.
- Do not load every installed skill into context at once.

## Plugin routing

- Use `docs/全部插件索引.md` as the local plugin map when a task mentions plugins, Browser, Computer Use, Figma, GitHub, deployment, data analytics, creative production, office connectors, or OpenAI developer tooling.
- Route at the plugin layer first, then read only the specific `SKILL.md` or plugin instruction needed for the task.
- Prefer Browser for in-app browser, localhost, file URL, DOM inspection, page clicks, and page screenshots.
- Prefer Computer Use for Windows desktop apps, file pickers, Douyin desktop publishing, native dialogs, and non-browser software.
- For mixed web/desktop flows, use `browser-desktop-orchestrator` as the coordinator and let Browser, Computer Use, `browser-act`, and Playwright split work by surface.
- Re-run `tools/generate-plugin-index.ps1` after Codex/plugin updates.

## Agnes free model skills

- Use `agnes-free-text` when the user asks for Agnes text, free text model calls, chat completions, streaming text, coding help through a free model, or OpenAI-compatible free text API use.
- Use `agnes-free-image` when the user asks for Agnes image, free image generation, text-to-image, image-to-image, or downloadable generated images.
- Use `agnes-free-video` when the user asks for Agnes video, free video generation, text-to-video, image-to-video, keyframes, async video task polling, or video downloads.
- Read API keys only from `AGNES_API_KEY`, with `AGNES_TOKEN` as fallback. Never put keys in prompts, scripts, files, commits, logs, or shell history.
- Prefer each skill's helper script. Use `--dry-run` before complex calls. For video, remember generation is asynchronous and status polling may be required.

## Codex development norms

- Use `codex-dev-norms` for coding work, implementation plans, bug fixes, refactors, repository analysis, code reviews, development rules, testing guidance, and final code-change responses.
- Load only the reference files relevant to the task. Start with `references/code-change-boundary.md` for narrow bug fixes or feature edits.
- Apply the minimal-change rule first: make only edits directly required by the task and avoid unrelated refactors, formatting churn, renames, or architectural cleanup.
- Protect user work in dirty worktrees. Do not revert, delete, reset, or overwrite unrelated changes unless explicitly requested.
- For API work, read actual API definitions and existing types/usages. Do not guess field names, response structures, or fallback aliases.
- For dependencies, prefer existing project capabilities and add packages only when there is clear value.
- For tests, cover changed behavior and meaningful edge cases; avoid tests that only assert mocks or chase coverage numbers.
- For reviews, lead with concrete risks and file references. Do not invent weak findings.
- For final responses, state the result, verification, and any uncertainty concisely.

## Local source copies

- Offline copies of the studied repositories are under `external-skills/`.
- Installed skill copies are under `C:\Users\Administrator\.codex\skills\`.
