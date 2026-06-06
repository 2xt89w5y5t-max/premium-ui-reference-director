# Automation Updater Example

这个示例展示如何把本仓库生成的 `automation_prompt_next.md` 安装到本机 Codex 自动化目录，并写入 Codex Desktop 使用的 `automation.toml`。它只写本地文件，不会调用 GitHub API 或任何外部服务。

## 安装更新工具

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\tools\install-automation-updater.ps1 -AutomationId codex -Force
```

安装位置：

```text
$CODEX_HOME/automations/codex/tools/update-automation-prompt.ps1
$CODEX_HOME/automations/codex/tools/update-codex-desktop-automation.ps1
```

如果未设置 `CODEX_HOME`，脚本会使用：

```text
$USERPROFILE/.codex
```

## 安装下一版提示词

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\tools\update-automation-prompt.ps1 -AutomationId codex -SourcePath .\automation_prompt_next.md
```

输出文件：

```text
$CODEX_HOME/automations/codex/prompt.md
```

旧版本会备份到：

```text
$CODEX_HOME/automations/codex/backups/prompt-YYYYMMDD-HHMMSS.md
```

## 一步安装工具并应用提示词

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\tools\install-automation-updater.ps1 -AutomationId codex -ApplyPrompt -ApplyDesktopConfig -Force
```

## 只更新 Codex Desktop 配置

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\tools\update-codex-desktop-automation.ps1 -AutomationId codex -SourcePath .\automation_prompt_next.md
```

## 注意边界

- 这个工具维护的是本地自动化提示词文件。
- `update-codex-desktop-automation.ps1` 会备份并更新 `$CODEX_HOME/automations/<id>/automation.toml`。
- 工具不会提交 Git、不会 push、不会上传抖音素材。
