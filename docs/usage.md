# 使用指南

本仓库用于沉淀 Codex 技能、插件路由、自动化脚本和内容发布包。推荐按“安装技能、运行工具、生成发布材料”的顺序使用。

## 安装技能

把需要的技能目录复制到本机 Codex 技能目录：

```powershell
Copy-Item -Recurse -Force .\skills\premium-ui-reference-director "$env:USERPROFILE\.codex\skills\premium-ui-reference-director"
Copy-Item -Recurse -Force .\skills\browser-desktop-orchestrator "$env:USERPROFILE\.codex\skills\browser-desktop-orchestrator"
Copy-Item -Recurse -Force .\skills\codex-weekly-release-operator "$env:USERPROFILE\.codex\skills\codex-weekly-release-operator"
```

安装后重启 Codex 或开启新会话，让技能索引重新加载。

## 生成周更发布包

```powershell
.\tools\new-weekly-release-pack.ps1 -Title "Codex 技能插件周更：发布运营包"
```

常用参数：

| 参数 | 说明 |
|---|---|
| `-Date` | 发布日期，格式为 `yyyy-MM-dd`。默认使用当天日期。 |
| `-Title` | 发布包标题，不能为空。 |
| `-OutputDir` | 输出目录，默认是 `.\output`。 |
| `-Force` | 覆盖同日期已存在的发布包。 |

脚本只生成本地 Markdown 文件，不会自动提交、推送、上传或调用外部 API。

## 运行抖音 API smoke test

```powershell
.\tools\douyin-api-smoke.ps1 -ApiBase "http://127.0.0.1:8000" -Url "https://v.douyin.com/xxxx/"
```

这个脚本用于快速验证 `Evil0ctal/Douyin_TikTok_Download_API` 风格的 `/api/hybrid/video_data` 端点是否可用。不要把公开 demo 当成稳定生产依赖。

## 安全边界

- 不提交 Token、Cookie、API Key、账号密码或浏览器会话文件。
- 不自动点击最终发布、支付、授权、删除等不可逆操作。
- 推送 GitHub 前先检查 `git status` 和 remote 配置。
- 桌面端上传流程遇到扫码、验证码、风控或二次确认时必须暂停。
