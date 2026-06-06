# Codex Skill And Plugin Playbook

一个面向 Codex 的技能、插件路由、自动化脚本和发布运营素材库。它把 AI Agent 工作流沉淀成可安装的 `skills/`、可执行的 `tools/`、可复用的 `examples/`，并配套 GitHub 与抖音/小红书内容发布材料。

## 项目亮点

- **Codex 技能沉淀：** 提供高端 UI 参考、浏览器/桌面自动化编排、每周发布运营等技能。
- **自动化浏览器与桌面协作：** 帮助 Codex 在 Browser、Computer Use、`browser-act` 和 Playwright 之间选择合适工具。
- **GitHub 发布运营闭环：** 支持从仓库检查、README/CHANGELOG 更新到发布摘要生成。
- **短视频内容资产：** 为抖音、小红书、视频号、B 站同步生成封面提示词、标题、正文和口播稿。
- **电商与视频工具链探索：** 包含 Douyin/TikTok API smoke test 和视频发布包示例。

## 适合人群

- 想维护个人 Codex 技能库的 AI Agent 用户。
- 做自动化浏览器、桌面发布、GitHub 自动化的开发者。
- 做 AI 电商、短视频、电商脚本、ComfyUI 或 API 工具链的独立开发者。
- 想把开源项目变成可持续内容资产的创作者。

## 技能清单

### `premium-ui-reference-director`

面向网站、App、落地页、电商页面和产品 UI 的高端视觉参考导演技能。它结合 Muzli、Awwwards、Pageflows 和 cinematic luxury commerce 方向，帮助 Codex 避免普通模板感，先建立审美方向，再进入实现。

### `browser-desktop-orchestrator`

一个轻量路由技能，用于在 Browser、Computer Use、`browser-act` 和 Playwright 之间选择正确自动化表面。适合本地 Web 验证、桌面文件选择器、抖音发布、渲染页面提取和脚本化截图。

### `codex-weekly-release-operator`

本周新增。用于每周维护 Codex 技能插件仓库：检查最近变更，新增可复用技能/脚本/示例，更新 README 和 CHANGELOG，生成 GitHub 发布摘要与抖音发布文案，并安全处理 Git 提交/推送。

## 工具脚本

### 生成周更发布包

```powershell
.\tools\new-weekly-release-pack.ps1 -Title "Codex 技能插件周更：发布运营包"
```

输出：

```text
output/weekly-release-YYYY-MM-DD.md
```

脚本只生成本地 Markdown 文件，不会自动提交、推送、上传或调用外部 API。

### 抖音 API smoke test

```powershell
.\tools\douyin-api-smoke.ps1 -ApiBase "http://127.0.0.1:8000" -Url "https://v.douyin.com/xxxx/"
```

用于快速验证 Douyin/TikTok 下载 API 的 `/api/hybrid/video_data` 端点是否可用。

## 安装

复制需要的技能到 Codex 技能目录：

```powershell
Copy-Item -Recurse -Force .\skills\premium-ui-reference-director "$env:USERPROFILE\.codex\skills\premium-ui-reference-director"
Copy-Item -Recurse -Force .\skills\browser-desktop-orchestrator "$env:USERPROFILE\.codex\skills\browser-desktop-orchestrator"
Copy-Item -Recurse -Force .\skills\codex-weekly-release-operator "$env:USERPROFILE\.codex\skills\codex-weekly-release-operator"
```

如果技能没有立即出现，重启 Codex 或开启新会话。

## 使用示例

```text
Use $premium-ui-reference-director to design a luxury AI fashion commerce app.
```

```text
Use $browser-desktop-orchestrator to upload a video through a web page, handle the Windows file picker, then verify the page-side detection result.
```

```text
Use $codex-weekly-release-operator to inspect this repository, add one reusable asset, update README/CHANGELOG, and generate this week's GitHub and Douyin release pack.
```

更多说明见 [docs/usage.md](./docs/usage.md) 和 [examples/weekly-release-pack.example.md](./examples/weekly-release-pack.example.md)。

## 仓库结构

```text
skills/
  premium-ui-reference-director/
  browser-desktop-orchestrator/
  codex-weekly-release-operator/

tools/
  douyin-api-smoke.ps1
  new-weekly-release-pack.ps1

docs/
  usage.md
  UI参考源规则.md
  UI技能索引.md

examples/
  weekly-release-pack.example.md

plugins/
  README.md

output/
  codex-skill-plugin-video/
```

## 发布与安全边界

- 推送 GitHub 前检查 `git status`、remote 和凭据状态。
- 不提交 Token、Cookie、API Key、账号密码或浏览器会话文件。
- 自动化发布遇到登录、扫码、验证码、风控、授权或最终发布按钮时必须暂停。
- 本项目提供工作流和素材生成，不绕过平台限制，也不代替人工确认外部发布动作。

## 本周更新

详见 [CHANGELOG.md](./CHANGELOG.md)。

## License

MIT
