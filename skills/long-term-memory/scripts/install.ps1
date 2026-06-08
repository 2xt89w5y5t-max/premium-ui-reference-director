<#
.SYNOPSIS
    Install Long-Term Memory System for Codex
.DESCRIPTION
    Installs the global AGENTS.md and initializes memory directories.
#>

$ErrorActionPreference = "Stop"
$HomeDir = $env:USERPROFILE

Write-Host "=== Codex Long-Term Memory Installer ===" -ForegroundColor Cyan

# Step 1: Install global AGENTS.md
$AgentSrc = Join-Path $PSScriptRoot "..\references\AGENTS.md"
$AgentDst = Join-Path $HomeDir "AGENTS.md"

if (Test-Path $AgentDst) {
    Write-Host "⚠ AGENTS.md already exists at $AgentDst" -ForegroundColor Yellow
    $overwrite = Read-Host "Overwrite? (y/n)"
    if ($overwrite -ne "y") {
        Write-Host "Skipping AGENTS.md install" -ForegroundColor Yellow
    } else {
        Copy-Item $AgentSrc $AgentDst -Force
        Write-Host "✅ AGENTS.md installed" -ForegroundColor Green
    }
} else {
    Copy-Item $AgentSrc $AgentDst -Force
    Write-Host "✅ AGENTS.md installed" -ForegroundColor Green
}

# Step 2: Create global memory directories
$GlobalMemory = Join-Path $HomeDir ".codex\global-memory"
@(
    Join-Path $GlobalMemory "long_term"
    Join-Path $GlobalMemory "sessions"
) | ForEach-Object {
    if (-not (Test-Path $_)) {
        New-Item -ItemType Directory -Path $_ -Force | Out-Null
    }
}

# Step 3: Init memory files
$InitFiles = @{
    "$GlobalMemory\current_session.md"   = "# 当前会话记忆`r`n`r`n## 会话目标`r`n- `r`n`r`n## 工作笔记`r`n- `r`n`r`n## 本次会话关键决策`r`n- "
    "$GlobalMemory\todo.md"              = "# 待办事项`r`n"
    "$GlobalMemory\long_term\preferences.md" = "# 用户偏好`r`n`r`n## 语言`r`n- 用户说中文时，优先用中文回复`r`n`r`n## 沟通风格`r`n- "
    "$GlobalMemory\long_term\knowledge.md"   = "# 积累知识`r`n- "
    "$GlobalMemory\long_term\projects.md"    = "# 项目追踪`r`n- "
}

foreach ($path in $InitFiles.Keys) {
    $fullPath = [System.Environment]::ExpandEnvironmentVariables($path)
    if (-not (Test-Path $fullPath)) {
        Set-Content -Path $fullPath -Value $InitFiles[$path] -Encoding UTF8
        Write-Host "  Created: $fullPath" -ForegroundColor Gray
    }
}

Write-Host ""
Write-Host "✅ Install complete!" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "  1. Restart any active Codex sessions"
Write-Host "  2. Memory will auto-load on every turn"
Write-Host "  3. Each project gets its own .memory/ dir automatically"
