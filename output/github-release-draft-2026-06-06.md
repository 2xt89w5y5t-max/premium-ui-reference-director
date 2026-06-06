# GitHub Release Draft: Codex 技能插件周更：Release 草稿自动化

- Tag: `v2026.06.06`
- Target branch: `detached HEAD`
- Generated: 2026-06-06 23:06:41 +08:00
- Repository state: local changes present

## Summary

This release focuses on repository maintainability, release automation, and open-source presentation quality. Review the title, tag, target branch, and any media assets before publishing.

## Changes From Git

- feat(release): add weekly Codex release operator (5665063)
- feat(skills): add browser desktop orchestrator (5a55ddd)
- docs: update codex learning notes and publishing kit (3bedc64)
- Ignore generated Douyin video exports (2e7d352)
- Add desktop Douyin publishing flow (2f906c7)
- Add Codex workflow notes and video publishing kit (eceaa5f)
- Learn from anbeime skill store patterns (61b7399)
- Open source premium UI reference director skill (ffc1ad7)

## CHANGELOG Section

```markdown
## 2026-06-06

### Added

- 新增 `codex-weekly-release-operator` 技能，用于每周检查、更新并发布 Codex 技能插件仓库。
- 新增 `tools/new-weekly-release-pack.ps1`，可生成 GitHub 发布摘要、CHANGELOG 条目和抖音发布素材模板。
- 新增 `tools/new-github-release-draft.ps1`，从本地 Git log 和 `CHANGELOG.md` 生成 GitHub Release 草稿。
- 新增 `examples/weekly-release-pack.example.md` 和 `examples/github-release-draft.example.md`，展示发布材料生成的最小使用方式。
- 新增 `docs/usage.md`，整理技能安装、脚本运行和安全边界。

### Changed

- 更新 README，补充项目定位、技能清单、工具脚本、使用方式、仓库结构和安全规则。
- 将个人抖音发布素材目录 `output/douyin-release/` 加入 `.gitignore`，避免把运营素材提交到开源仓库。

### Fixed

- 修复 README 和 CHANGELOG 中的中文乱码，确保 GitHub 页面可读。
- 补齐缺失的顶层 `CHANGELOG.md` 维护入口，方便后续自动化发布持续记录。

### Docs

- 增加面向 GitHub 开源展示和短视频运营的周更发布说明。
```

## Publish Checklist

- [ ] Checked `git status` and confirmed no personal materials or secrets are staged.
- [ ] Confirmed `README.md`, `CHANGELOG.md`, and examples are readable.
- [ ] Confirmed tag `v2026.06.06` is correct and not already used by mistake.
- [ ] Confirmed the release content contains no tokens, cookies, API keys, account data, or browser sessions.
- [ ] If short-video platforms are involved, personal materials stay under local `output/douyin-release/`.

## Suggested GitHub Release Copy

Codex 技能插件周更：Release 草稿自动化

This update improves the Codex skill/plugin publishing flow: repository docs are easier to read, release drafts can be generated locally, and the boundary between open-source content and personal creator materials is clearer.
