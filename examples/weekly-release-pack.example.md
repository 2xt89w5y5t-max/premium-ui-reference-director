# Codex 周更发布包示例

这个示例展示如何把一次 Codex 技能插件更新整理成 GitHub 与抖音都能复用的发布材料。

## 命令

```powershell
.\tools\new-weekly-release-pack.ps1 -Date 2026-06-06 -Title "Codex 技能插件周更：发布运营包"
```

## 适用场景

- 每周维护 Codex skills 仓库。
- 给开源项目生成 GitHub Release 摘要。
- 给抖音、小红书、视频号生成封面提示词和发布文案。
- 记录本周新增脚本、技能、插件和文档。

## 输出文件

```text
output/weekly-release-2026-06-06.md
```

## 最小检查清单

- `README.md` 已说明新增能力。
- `CHANGELOG.md` 已记录日期和变更。
- 新增脚本可在本地运行。
- Git 状态清楚，不包含密钥、Cookie、Token 或账号凭据。
- 如需推送，先确认 remote 和凭据可用。
