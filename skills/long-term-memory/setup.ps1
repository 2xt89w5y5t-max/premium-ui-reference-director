<#
.SYNOPSIS
    Setup Long-Term Memory from GitHub clone
.DESCRIPTION
    One-click setup for new users who cloned this repo.
#>

$HomeDir = $env:USERPROFILE
$ScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host "=== Codex Long-Term Memory Setup ===" -ForegroundColor Cyan

# Copy AGENTS.md
Copy-Item (Join-Path $ScriptRoot "references\AGENTS.md") (Join-Path $HomeDir "AGENTS.md") -Force
Write-Host "✅ AGENTS.md installed to $HomeDir\AGENTS.md" -ForegroundColor Green

# Create global memory
$MemoryDir = Join-Path $HomeDir ".codex\global-memory"
@("long_term", "sessions") | ForEach-Object {
    New-Item -ItemType Directory -Path (Join-Path $MemoryDir $_) -Force | Out-Null
}

# Init files
@{
    "current_session.md" = "# 当前会话记忆`r`n`r`n## 会话目标`r`n- "
    "todo.md" = "# 待办事项`r`n"
    "long_term\preferences.md" = "# 用户偏好`r`n`r`n## 语言`r`n- 用户说中文时，优先用中文回复`r`n"
    "long_term\knowledge.md" = "# 积累知识`r`n- "
    "long_term\projects.md" = "# 项目追踪`r`n- "
} | ForEach-Object {
    $path = Join-Path $MemoryDir $_.Key
    if (-not (Test-Path $path)) {
        Set-Content -Path $path -Value $_.Value -Encoding UTF8
    }
}

Write-Host ""
Write-Host "✅ Setup complete!" -ForegroundColor Green
Write-Host "Restart your Codex sessions to activate." -ForegroundColor Cyan
