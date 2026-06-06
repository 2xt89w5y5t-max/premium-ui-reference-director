# Changelog

## 2026-06-06

### Added

- 新增 `codex-weekly-release-operator` 技能，用于每周检查、更新并发布 Codex 技能插件仓库。
- 新增 `tools/new-weekly-release-pack.ps1`，可生成 GitHub 发布摘要、CHANGELOG 条目和抖音发布素材模板。
- 新增 `tools/new-github-release-draft.ps1`，从本地 Git log 和 `CHANGELOG.md` 生成 GitHub Release 草稿。
- 新增 `tools/install-automation-updater.ps1` 和 `tools/update-automation-prompt.ps1`，用于安装本地自动化提示词更新工具并备份旧提示词。
- 新增 `tools/update-codex-desktop-automation.ps1`，可直接备份并更新 Codex Desktop 自动化目录中的 `automation.toml`。
- 新增 `examples/weekly-release-pack.example.md`、`examples/github-release-draft.example.md` 和 `examples/automation-updater.example.md`，展示发布材料和自动化提示词更新的最小使用方式。
- 新增 `docs/usage.md`，整理技能安装、脚本运行和安全边界。

### Changed

- 更新 README，补充项目定位、技能清单、工具脚本、使用方式、仓库结构和安全规则。
- 将个人抖音发布素材目录 `output/douyin-release/` 加入 `.gitignore`，避免把运营素材提交到开源仓库。

### Fixed

- 修复 README 和 CHANGELOG 中的中文乱码，确保 GitHub 页面可读。
- 补齐缺失的顶层 `CHANGELOG.md` 维护入口，方便后续自动化发布持续记录。

### Docs

- 增加面向 GitHub 开源展示和短视频运营的周更发布说明。
