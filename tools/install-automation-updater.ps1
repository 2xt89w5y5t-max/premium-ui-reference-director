<#
.SYNOPSIS
Installs automation updater tools into a Codex automation folder.

.DESCRIPTION
Copies tools/update-automation-prompt.ps1 into
$CODEX_HOME/automations/<automation_id>/tools/. When present, also installs
tools/update-codex-desktop-automation.ps1, which updates automation.toml.

This installer is local-only. It does not call any remote automation service.

.PARAMETER AutomationId
Automation id under $CODEX_HOME/automations. Defaults to codex.

.PARAMETER CodexHome
Codex home directory. Defaults to $env:CODEX_HOME, then $USERPROFILE/.codex.

.PARAMETER ApplyPrompt
After installing the tool, run it against automation_prompt_next.md.

.PARAMETER ApplyDesktopConfig
After installing the app-level updater, write automation_prompt_next.md into
automation.toml.

.PARAMETER PromptSource
Prompt file used when -ApplyPrompt is set.

.PARAMETER Force
Overwrite the installed tool.

.EXAMPLE
.\tools\install-automation-updater.ps1 -AutomationId codex -ApplyPrompt -Force

.EXAMPLE
.\tools\install-automation-updater.ps1 -AutomationId codex -ApplyDesktopConfig -Force
#>

param(
  [string]$AutomationId = "codex",
  [string]$CodexHome = $env:CODEX_HOME,
  [switch]$ApplyPrompt,
  [switch]$ApplyDesktopConfig,
  [string]$PromptSource = ".\automation_prompt_next.md",
  [switch]$Force
)

$ErrorActionPreference = "Stop"

if ([string]::IsNullOrWhiteSpace($AutomationId)) {
  Write-Error "-AutomationId cannot be empty."
  exit 2
}

if ([string]::IsNullOrWhiteSpace($CodexHome)) {
  if ([string]::IsNullOrWhiteSpace($env:USERPROFILE)) {
    Write-Error "Cannot infer Codex home. Set -CodexHome or CODEX_HOME."
    exit 2
  }

  $CodexHome = Join-Path $env:USERPROFILE ".codex"
}

$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$sourceTool = Join-Path $scriptRoot "update-automation-prompt.ps1"
$sourceDesktopTool = Join-Path $scriptRoot "update-codex-desktop-automation.ps1"
if (!(Test-Path -LiteralPath $sourceTool)) {
  Write-Error "Updater tool not found beside installer: $sourceTool"
  exit 2
}

$automationRoot = Join-Path (Join-Path $CodexHome "automations") $AutomationId
$toolRoot = Join-Path $automationRoot "tools"
$targetTool = Join-Path $toolRoot "update-automation-prompt.ps1"
$targetDesktopTool = Join-Path $toolRoot "update-codex-desktop-automation.ps1"

New-Item -ItemType Directory -Path $toolRoot -Force | Out-Null

if ((Test-Path -LiteralPath $targetTool) -and -not $Force) {
  Write-Error "Tool already exists: $targetTool. Re-run with -Force to overwrite."
  exit 3
}

Copy-Item -LiteralPath $sourceTool -Destination $targetTool -Force
Write-Host "Installed updater tool: $targetTool"

if (Test-Path -LiteralPath $sourceDesktopTool) {
  if ((Test-Path -LiteralPath $targetDesktopTool) -and -not $Force) {
    Write-Error "Tool already exists: $targetDesktopTool. Re-run with -Force to overwrite."
    exit 3
  }

  Copy-Item -LiteralPath $sourceDesktopTool -Destination $targetDesktopTool -Force
  Write-Host "Installed desktop updater tool: $targetDesktopTool"
}

if ($ApplyPrompt) {
  & $targetTool -AutomationId $AutomationId -SourcePath $PromptSource -CodexHome $CodexHome -Force:$Force
}

if ($ApplyDesktopConfig) {
  if (!(Test-Path -LiteralPath $targetDesktopTool)) {
    Write-Error "Desktop updater tool was not installed: $targetDesktopTool"
    exit 2
  }

  & $targetDesktopTool -AutomationId $AutomationId -SourcePath $PromptSource -CodexHome $CodexHome -Force:$Force -SyncPromptFile
}
