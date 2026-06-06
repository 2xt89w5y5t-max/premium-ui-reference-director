<#
.SYNOPSIS
Creates a dated Codex weekly release pack markdown file.

.DESCRIPTION
Generates a reusable GitHub and Douyin publishing pack for Codex skill/plugin repositories.
The script is intentionally local-only: it does not commit, push, upload, or call external APIs.

.PARAMETER Date
Release date in yyyy-MM-dd format. Defaults to today's local date.

.PARAMETER Title
Short release title shown in the generated pack.

.PARAMETER OutputDir
Directory for generated release packs. Defaults to ./output.

.PARAMETER Force
Overwrite an existing release pack for the same date.

.EXAMPLE
.\tools\new-weekly-release-pack.ps1 -Title "Codex 周更发布运营包"

.EXAMPLE
.\tools\new-weekly-release-pack.ps1 -Date 2026-06-06 -OutputDir .\output -Force

.NOTES
If the script fails, check that:
1. The date uses yyyy-MM-dd.
2. The output directory is writable.
3. The target file is not already open or locked.
#>

param(
  [string]$Date = (Get-Date -Format "yyyy-MM-dd"),
  [string]$Title = "Codex 周更发布包",
  [string]$OutputDir = ".\output",
  [switch]$Force
)

$ErrorActionPreference = "Stop"

try {
  $parsedDate = [datetime]::ParseExact($Date, "yyyy-MM-dd", $null)
} catch {
  Write-Error "Invalid -Date '$Date'. Use yyyy-MM-dd, for example 2026-06-06."
  exit 2
}

try {
  if ([string]::IsNullOrWhiteSpace($Title)) {
    Write-Error "-Title cannot be empty."
    exit 2
  }

  if (!(Test-Path -LiteralPath $OutputDir)) {
    New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null
  }

  $safeDate = $parsedDate.ToString("yyyy-MM-dd")
  $target = Join-Path $OutputDir "weekly-release-$safeDate.md"

  if ((Test-Path -LiteralPath $target) -and -not $Force) {
    Write-Error "Target already exists: $target. Re-run with -Force to overwrite."
    exit 3
  }

  $template = @'
# {TITLE}

更新日期：{DATE}

## 1. GitHub 发布摘要

### 本周更新了什么

- 新增或优化：
- 文档更新：
- 工具脚本：

### 解决了什么问题

-

### 新增了哪些能力

-

### 如何使用

```powershell
.\tools\new-weekly-release-pack.ps1 -Title "{TITLE}"
```

### 下一步计划

-

## 2. CHANGELOG 条目

```markdown
## {DATE}

### Added

### Changed

### Fixed

### Docs
```

## 3. 抖音竖向封面图提示词

- 比例：9:16 竖版
- 中文大标题：
- 画面描述：科技感 Codex 工作台、AI Agent 自动编排、GitHub 提交轨迹、开源技能卡片悬浮展示
- 字体风格：粗黑体标题，高对比副标题，适合手机信息流快速识别
- 颜色风格：深色科技底色，青绿色与白色高光，少量 GitHub 蓝点缀
- 构图建议：标题占上 30%，中部展示 Codex 自动化流程，底部放开源发布与抖音运营关键词

## 4. 抖音横向封面图提示词

- 比例：16:9 横版
- 中文大标题：
- 画面描述：横向 Codex 自动化流水线，从技能、插件、脚本到 GitHub Release 和短视频发布
- 字体风格：左侧大标题，右侧用小标签展示 GitHub、AI Agent、自动化浏览器、Douyin
- 颜色风格：深灰黑背景，青绿高光，白色代码线框，少量紫蓝渐变边缘光
- 构图建议：左文右图，保留安全边距，适合视频首帧、合集封面和 B 站同步

## 5. 抖音发布文案

### 爆款标题

我让 Codex 每周自动维护自己的技能插件库

### 正文

这次我把 Codex 技能、工具脚本、GitHub 发布摘要和抖音文案做成了一个周更发布包。它会先检查仓库，再补齐可复用技能、脚本、README 和 CHANGELOG，最后生成适合开源传播的发布材料。适合做 AI Agent、自动化浏览器、开源工具链和自媒体内容运营的人参考。

### 话题标签

#Codex #AI自动化 #开源项目 #GitHub #AI工具

### 评论区引导语

你最想让 Codex 自动维护哪类项目？

### 口播稿

这周我做了一个 Codex 周更发布包。它不是简单写一段总结，而是把仓库检查、技能更新、脚本生成、README 和 CHANGELOG 更新、GitHub 发布摘要、抖音封面提示词和发布文案串成一个流程。以后每周跑一次，就能把 AI Agent 项目的维护、发布和内容运营变成可复用动作。做开源、自动化浏览器、电商视频或者 AI 工具链的朋友，可以直接拿这个结构改成自己的版本。

## 6. 阻塞问题

- Git：
- Remote/push：
- API/账号：
- 需要人工确认：
'@

  $content = $template.Replace("{TITLE}", $Title).Replace("{DATE}", $safeDate)

  Set-Content -LiteralPath $target -Value $content -Encoding UTF8
  Write-Host "Created release pack: $target"
} catch {
  Write-Error "Failed to create weekly release pack: $($_.Exception.Message)"
  exit 1
}
