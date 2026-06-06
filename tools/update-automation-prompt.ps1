<#
.SYNOPSIS
Installs the next automation prompt into a local Codex automation folder.

.DESCRIPTION
Copies a prompt markdown file, usually automation_prompt_next.md, into
$CODEX_HOME/automations/<automation_id>/prompt.md with a timestamped backup.

This is a local filesystem updater. It does not call the Codex Desktop app,
does not change a hosted scheduler, and does not use any external API.

.PARAMETER AutomationId
Automation id under $CODEX_HOME/automations. Defaults to codex.

.PARAMETER SourcePath
Prompt file to install. Defaults to ./automation_prompt_next.md.

.PARAMETER CodexHome
Codex home directory. Defaults to $env:CODEX_HOME, then $USERPROFILE/.codex.

.PARAMETER DryRun
Print what would change without writing files.

.PARAMETER Force
Rewrite prompt.md even when source content is already installed.

.EXAMPLE
.\tools\update-automation-prompt.ps1 -AutomationId codex

.EXAMPLE
.\tools\update-automation-prompt.ps1 -SourcePath .\automation_prompt_next.md -DryRun
#>

param(
  [string]$AutomationId = "codex",
  [string]$SourcePath = ".\automation_prompt_next.md",
  [string]$CodexHome = $env:CODEX_HOME,
  [switch]$DryRun,
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

if (!(Test-Path -LiteralPath $SourcePath)) {
  Write-Error "Source prompt not found: $SourcePath"
  exit 2
}

$sourceItem = Get-Item -LiteralPath $SourcePath
$sourceContent = Get-Content -LiteralPath $sourceItem.FullName -Raw -Encoding UTF8
if ([string]::IsNullOrWhiteSpace($sourceContent)) {
  Write-Error "Source prompt is empty: $($sourceItem.FullName)"
  exit 2
}

$automationRoot = Join-Path (Join-Path $CodexHome "automations") $AutomationId
$toolRoot = Join-Path $automationRoot "tools"
$backupRoot = Join-Path $automationRoot "backups"
$targetPrompt = Join-Path $automationRoot "prompt.md"
$memoryPath = Join-Path $automationRoot "memory.md"

$sameContent = $false
if (Test-Path -LiteralPath $targetPrompt) {
  $currentContent = Get-Content -LiteralPath $targetPrompt -Raw -Encoding UTF8
  $sameContent = ($currentContent -eq $sourceContent)
}

if ($sameContent -and -not $Force) {
  Write-Host "Already up to date: $targetPrompt"
  exit 0
}

$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$backupPath = Join-Path $backupRoot "prompt-$timestamp.md"

Write-Host "Automation id: $AutomationId"
Write-Host "Source prompt: $($sourceItem.FullName)"
Write-Host "Target prompt: $targetPrompt"
if (Test-Path -LiteralPath $targetPrompt) {
  Write-Host "Backup path: $backupPath"
}

if ($DryRun) {
  Write-Host "Dry run only. No files were changed."
  exit 0
}

New-Item -ItemType Directory -Path $automationRoot -Force | Out-Null
New-Item -ItemType Directory -Path $toolRoot -Force | Out-Null
New-Item -ItemType Directory -Path $backupRoot -Force | Out-Null

if (Test-Path -LiteralPath $targetPrompt) {
  Copy-Item -LiteralPath $targetPrompt -Destination $backupPath -Force
}

Set-Content -LiteralPath $targetPrompt -Value $sourceContent -Encoding UTF8

$runTime = Get-Date -Format "yyyy-MM-ddTHH:mm:sszzz"
$backupSummary = "none"
if (Test-Path -LiteralPath $backupPath) {
  $backupSummary = $backupPath
}

$memoryEntry = @"

## $runTime

- Installed automation prompt for `$AutomationId`.
- Source: `$($sourceItem.FullName)`.
- Target: `$targetPrompt`.
- Backup: `$backupSummary`.
- Note: local prompt file updated; Codex Desktop automation schedule may still require manual prompt paste if no app-level update tool is available.
"@

Add-Content -LiteralPath $memoryPath -Value $memoryEntry -Encoding UTF8

Write-Host "Installed automation prompt: $targetPrompt"
