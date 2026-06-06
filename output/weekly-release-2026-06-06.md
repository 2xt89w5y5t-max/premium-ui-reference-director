# Codex 技能插件周更：发布运营包

更新日期：2026-06-06

## 1. GitHub 发布摘要

### 本周更新了什么

- 新增 `codex-weekly-release-operator` 技能，沉淀每周 Codex 技能插件维护、GitHub 发布和短视频运营流程。
- 新增 `tools/new-weekly-release-pack.ps1`，一键生成本地周更发布包 Markdown。
- 新增 `docs/usage.md`、`examples/weekly-release-pack.example.md` 和 `plugins/README.md`，补齐安装、示例和插件目录说明。
- 更新 `README.md`，把项目定位、适合人群、技能清单、脚本用法和安全边界整理成 GitHub 首页。
- 新增顶层 `CHANGELOG.md`，为后续自动化发布提供稳定记录入口。

### 解决了什么问题

- 仓库缺少顶层 CHANGELOG，周更发布没有固定记录入口。
- `plugins/` 和 `examples/` 没有明确说明，外部读者难以理解项目扩展方向。
- 每周发布内容需要手工重复整理，缺少可复用模板和脚本。

### 新增了哪些能力

- Codex 可按固定流程检查仓库、选择小而有价值的更新点、生成发布材料。
- 开发者可本地生成 GitHub + 抖音发布包，不依赖外部 API。
- 项目可以同时服务开源展示和短视频内容运营。

### 如何使用

```powershell
.\tools\new-weekly-release-pack.ps1 -Title "Codex 技能插件周更：发布运营包"
```

安装本周新增技能：

```powershell
Copy-Item -Recurse -Force .\skills\codex-weekly-release-operator "$env:USERPROFILE\.codex\skills\codex-weekly-release-operator"
```

### 下一步计划

- 增加 GitHub Release 草稿生成脚本。
- 增加插件包安装模板和 MCP 配置示例。
- 把抖音/小红书发布包扩展成多平台内容矩阵模板。

## 2. CHANGELOG 条目

```markdown
## 2026-06-06

### Added

- 新增 `codex-weekly-release-operator` 技能，用于每周检查、更新并发布 Codex 技能插件仓库。
- 新增 `tools/new-weekly-release-pack.ps1`，可生成 GitHub 发布摘要、CHANGELOG 条目和抖音发布素材模板。
- 新增 `examples/weekly-release-pack.example.md`，展示周更发布包的最小使用方式。
- 新增 `docs/usage.md`，整理技能安装、脚本运行和安全边界。

### Changed

- 更新 README，补充项目定位、技能清单、工具脚本、使用方式和适合人群。

### Fixed

- 补齐缺失的顶层 `CHANGELOG.md`，让后续自动化发布有稳定记录入口。

### Docs

- 增加面向 GitHub 开源展示和短视频运营的周更发布说明。
```

## 3. 抖音竖向封面图提示词

- 比例：9:16 竖版。
- 中文大标题：让 Codex 每周自动维护开源技能库。
- 画面描述：深色科技工作台上，Codex 终端、GitHub 提交线、AI Agent 节点、技能卡片和抖音发布面板同时展开，像一条自动化流水线从左下流向右上。
- 字体风格：中文粗黑体大标题，副标题用窄体科技字体，标题必须醒目，手机信息流 1 秒内可读。
- 颜色风格：黑灰底色，青绿色主高光，白色代码线框，少量 GitHub 蓝和霓虹紫点缀。
- 构图建议：上方 30% 放大标题，中部放 Codex + GitHub 自动化流程，底部放“技能 / 插件 / 发布包 / 抖音文案”四个标签。

## 4. 抖音横向封面图提示词

- 比例：16:9 横版。
- 中文大标题：Codex 技能插件周更发布包。
- 画面描述：横向 AI 自动化流水线，从左侧的 `skills/`、`tools/`、`docs/` 文件夹流向右侧 GitHub Release 和短视频封面面板，画面中有发光代码轨迹和开源徽章。
- 字体风格：左侧大标题，右侧小标签展示 GitHub、AI Agent、Browser Automation、Douyin。
- 颜色风格：深灰黑背景，青绿高光，白色 UI 线框，局部紫蓝边缘光，整体克制、科技、开源。
- 构图建议：左文右图，保留 10% 安全边距，标题不贴边，适合视频首帧、合集封面、B 站和视频号同步。

## 5. 抖音发布文案

### 爆款标题

我让 Codex 每周自动维护自己的技能插件库

### 正文

这周我把 Codex 技能、工具脚本、GitHub 发布摘要和抖音文案做成了一个周更发布包。它会先检查仓库，再补齐可复用技能、脚本、README 和 CHANGELOG，最后生成适合开源传播的发布材料。适合做 AI Agent、自动化浏览器、开源工具链和自媒体运营的人参考。

### 话题标签

#Codex #AI自动化 #开源项目 #GitHub #AI工具

### 评论区引导语

你最想让 Codex 自动维护哪类项目？

### 口播稿

这周我做了一个 Codex 周更发布包。它不是简单写一段总结，而是把仓库检查、技能更新、脚本生成、README 和 CHANGELOG 更新、GitHub 发布摘要、抖音封面提示词和发布文案串成一个流程。以后每周跑一次，就能把 AI Agent 项目的维护、发布和内容运营变成可复用动作。做开源、自动化浏览器、电商视频或者 AI 工具链的朋友，可以直接拿这个结构改成自己的版本。

## 6. 阻塞问题

- Git：当前工作区是 detached HEAD，由自动化工作区管理，不是命名开发分支。
- Remote/push：需要在提交后检查 remote 和凭据；不可假设可推送。
- API/账号：本次脚本不调用外部 API，不需要账号或模型凭据。
- 需要人工确认：如果后续要真正发布到抖音、GitHub Release 或其他平台，最终发布按钮仍需人工确认。
