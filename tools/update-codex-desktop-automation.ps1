<#
.SYNOPSIS
Updates a Codex Desktop automation.toml prompt.

.DESCRIPTION
Installs a prompt markdown file directly into the Codex Desktop automation
configuration at $CODEX_HOME/automations/<automation_id>/automation.toml.

The tool creates a timestamped backup before writing. It updates the top-level
prompt key and refreshed updated_at when present. It does not edit hosted
services, does not click inside the desktop UI, and does not upload data.

.PARAMETER AutomationId
Automation id under $CODEX_HOME/automations. Defaults to codex.

.PARAMETER SourcePath
Prompt file to install. Defaults to ./automation_prompt_next.md.

.PARAMETER CodexHome
Codex home directory. Defaults to $env:CODEX_HOME, then $USERPROFILE/.codex.

.PARAMETER DryRun
Print what would change without writing files.

.PARAMETER Force
Rewrite automation.toml even when the prompt content is already installed.

.PARAMETER SyncPromptFile
Also write the same prompt to prompt.md beside automation.toml.

.EXAMPLE
.\tools\update-codex-desktop-automation.ps1 -AutomationId codex -SourcePath .\automation_prompt_next.md

.EXAMPLE
.\tools\update-codex-desktop-automation.ps1 -AutomationId codex -DryRun
#>

param(
  [string]$AutomationId = "codex",
  [string]$SourcePath = ".\automation_prompt_next.md",
  [string]$CodexHome = $env:CODEX_HOME,
  [switch]$DryRun,
  [switch]$Force,
  [switch]$SyncPromptFile
)

$ErrorActionPreference = "Stop"

function ConvertTo-TomlBasicString {
  param([string]$Value)

  $builder = New-Object System.Text.StringBuilder
  foreach ($char in $Value.ToCharArray()) {
    $code = [int][char]$char
    switch ($code) {
      8 { [void]$builder.Append("\b"); break }
      9 { [void]$builder.Append("\t"); break }
      10 { [void]$builder.Append("\n"); break }
      12 { [void]$builder.Append("\f"); break }
      13 { [void]$builder.Append("\r"); break }
      34 { [void]$builder.Append('\"'); break }
      92 { [void]$builder.Append("\\"); break }
      default {
        if ($code -lt 32) {
          [void]$builder.Append(("\u{0:x4}" -f $code))
        } else {
          [void]$builder.Append($char)
        }
      }
    }
  }

  return $builder.ToString()
}

function Get-CodexHome {
  param([string]$RequestedCodexHome)

  if (![string]::IsNullOrWhiteSpace($RequestedCodexHome)) {
    return $RequestedCodexHome
  }

  if ([string]::IsNullOrWhiteSpace($env:USERPROFILE)) {
    Write-Error "Cannot infer Codex home. Set -CodexHome or CODEX_HOME."
    exit 2
  }

  return (Join-Path $env:USERPROFILE ".codex")
}

if ([string]::IsNullOrWhiteSpace($AutomationId)) {
  Write-Error "-AutomationId cannot be empty."
  exit 2
}

$CodexHome = Get-CodexHome $CodexHome

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
$automationToml = Join-Path $automationRoot "automation.toml"
$promptFile = Join-Path $automationRoot "prompt.md"
$backupRoot = Join-Path $automationRoot "backups"
$memoryPath = Join-Path $automationRoot "memory.md"

if (!(Test-Path -LiteralPath $automationToml)) {
  Write-Error "Codex Desktop automation config not found: $automationToml"
  exit 2
}

$tomlContent = Get-Content -LiteralPath $automationToml -Raw -Encoding UTF8
$idPattern = '(?m)^id\s*=\s*"' + [regex]::Escape($AutomationId) + '"\s*$'
if ($tomlContent -notmatch $idPattern) {
  Write-Error "Automation id mismatch or missing in: $automationToml"
  exit 4
}

if ($tomlContent -notmatch '(?m)^prompt\s*=') {
  Write-Error "No top-level prompt key found in: $automationToml"
  exit 4
}

$encodedPrompt = ConvertTo-TomlBasicString $sourceContent
$newPromptLine = 'prompt = "' + $encodedPrompt + '"'
$newTomlContent = [regex]::Replace($tomlContent, '(?m)^prompt\s*=.*$', [System.Text.RegularExpressions.MatchEvaluator]{ param($m) $newPromptLine }, 1)

$updatedAt = [DateTimeOffset]::Now.ToUnixTimeMilliseconds()
if ($newTomlContent -match '(?m)^updated_at\s*=') {
  $newTomlContent = [regex]::Replace($newTomlContent, '(?m)^updated_at\s*=.*$', "updated_at = $updatedAt", 1)
}

$sameContent = ($newTomlContent -eq $tomlContent)
if ($sameContent -and -not $Force) {
  Write-Host "Already up to date: $automationToml"
  exit 0
}

$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$backupPath = Join-Path $backupRoot "automation-$timestamp.toml"

Write-Host "Automation id: $AutomationId"
Write-Host "Source prompt: $($sourceItem.FullName)"
Write-Host "Target config: $automationToml"
Write-Host "Backup path: $backupPath"
Write-Host "Updated_at: $updatedAt"
if ($SyncPromptFile) {
  Write-Host "Prompt mirror: $promptFile"
}

if ($DryRun) {
  Write-Host "Dry run only. No files were changed."
  exit 0
}

New-Item -ItemType Directory -Path $backupRoot -Force | Out-Null
Copy-Item -LiteralPath $automationToml -Destination $backupPath -Force
Set-Content -LiteralPath $automationToml -Value $newTomlContent -Encoding UTF8

if ($SyncPromptFile) {
  Set-Content -LiteralPath $promptFile -Value $sourceContent -Encoding UTF8
}

$runTime = Get-Date -Format "yyyy-MM-ddTHH:mm:sszzz"
$memoryEntry = @"

## $runTime

- Updated Codex Desktop automation config for `$AutomationId`.
- Source: `$($sourceItem.FullName)`.
- Target config: `$automationToml`.
- Backup: `$backupPath`.
- Updated_at: `$updatedAt`.
"@

Add-Content -LiteralPath $memoryPath -Value $memoryEntry -Encoding UTF8

Write-Host "Updated Codex Desktop automation config: $automationToml"
