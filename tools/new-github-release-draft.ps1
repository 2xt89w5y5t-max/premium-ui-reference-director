<#
.SYNOPSIS
Creates a local GitHub Release draft markdown file.

.DESCRIPTION
Generates a GitHub Release draft from local repository data. The script reads
recent git commits and the matching date section from CHANGELOG.md when present.
It is intentionally local-only: it does not create tags, publish releases, push,
upload assets, or call external APIs.

.PARAMETER Date
Release date in yyyy-MM-dd format. Defaults to today's local date.

.PARAMETER Title
Human-readable release title.

.PARAMETER Tag
Release tag name. Defaults to vYYYY.MM.DD.

.PARAMETER Since
Optional git log lower bound, for example "7 days ago" or "2026-06-01".

.PARAMETER OutputDir
Directory for generated drafts. Defaults to ./output.

.PARAMETER Force
Overwrite an existing draft for the same date.

.EXAMPLE
.\tools\new-github-release-draft.ps1 -Title "Codex weekly update"

.EXAMPLE
.\tools\new-github-release-draft.ps1 -Date 2026-06-06 -Tag v2026.06.06 -Since "7 days ago" -Force

.NOTES
Review the generated file before copying it into GitHub Releases. The script
does not inspect binary assets or external account state.
#>

param(
  [string]$Date = (Get-Date -Format "yyyy-MM-dd"),
  [string]$Title = "Codex weekly update",
  [string]$Tag,
  [string]$Since,
  [string]$OutputDir = ".\output",
  [switch]$Force
)

$ErrorActionPreference = "Stop"

function Invoke-GitText {
  param([string[]]$GitArgs)

  $result = & git @GitArgs 2>$null
  if ($LASTEXITCODE -ne 0) {
    return ""
  }

  return ($result -join [Environment]::NewLine).Trim()
}

try {
  $parsedDate = [datetime]::ParseExact($Date, "yyyy-MM-dd", $null)
} catch {
  Write-Error "Invalid -Date '$Date'. Use yyyy-MM-dd, for example 2026-06-06."
  exit 2
}

if ([string]::IsNullOrWhiteSpace($Title)) {
  Write-Error "-Title cannot be empty."
  exit 2
}

$safeDate = $parsedDate.ToString("yyyy-MM-dd")
if ([string]::IsNullOrWhiteSpace($Tag)) {
  $Tag = "v" + $parsedDate.ToString("yyyy.MM.dd")
}

$repoRoot = Invoke-GitText @("rev-parse", "--show-toplevel")
if ([string]::IsNullOrWhiteSpace($repoRoot)) {
  Write-Error "This script must run inside a Git repository."
  exit 2
}

if (!(Test-Path -LiteralPath $OutputDir)) {
  New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null
}

$target = Join-Path $OutputDir "github-release-draft-$safeDate.md"
if ((Test-Path -LiteralPath $target) -and -not $Force) {
  Write-Error "Target already exists: $target. Re-run with -Force to overwrite."
  exit 3
}

$branch = Invoke-GitText @("branch", "--show-current")
if ([string]::IsNullOrWhiteSpace($branch)) {
  $branch = "detached HEAD"
}

$status = Invoke-GitText @("status", "--short")
if ([string]::IsNullOrWhiteSpace($status)) {
  $statusSummary = "clean"
} else {
  $statusSummary = "local changes present"
}

$logArgs = @("log", "--pretty=format:- %s (%h)")
if (![string]::IsNullOrWhiteSpace($Since)) {
  $logArgs += "--since=$Since"
} else {
  $logArgs += "-n"
  $logArgs += "12"
}

$gitLog = Invoke-GitText $logArgs
if ([string]::IsNullOrWhiteSpace($gitLog)) {
  $gitLog = "- No commits found for the selected range."
}

$changelogSection = "_No matching CHANGELOG section found for $safeDate._"
$changelogPath = Join-Path $repoRoot "CHANGELOG.md"
if (Test-Path -LiteralPath $changelogPath) {
  $lines = Get-Content -LiteralPath $changelogPath -Encoding UTF8
  $start = -1
  for ($i = 0; $i -lt $lines.Count; $i++) {
    if ($lines[$i] -match "^##\s+$([regex]::Escape($safeDate))\s*$") {
      $start = $i
      break
    }
  }

  if ($start -ge 0) {
    $end = $lines.Count
    for ($i = $start + 1; $i -lt $lines.Count; $i++) {
      if ($lines[$i] -match "^##\s+") {
        $end = $i
        break
      }
    }

    $changelogSection = ($lines[$start..($end - 1)] -join [Environment]::NewLine).Trim()
  }
}

$generatedAt = Get-Date -Format "yyyy-MM-dd HH:mm:ss zzz"

$template = @'
# GitHub Release Draft: {TITLE}

- Tag: `{TAG}`
- Target branch: `{BRANCH}`
- Generated: {GENERATED_AT}
- Repository state: {STATUS_SUMMARY}

## Summary

This release focuses on repository maintainability, release automation, and open-source presentation quality. Review the title, tag, target branch, and any media assets before publishing.

## Changes From Git

{GIT_LOG}

## CHANGELOG Section

```markdown
{CHANGELOG_SECTION}
```

## Publish Checklist

- [ ] Checked `git status` and confirmed no personal materials or secrets are staged.
- [ ] Confirmed `README.md`, `CHANGELOG.md`, and examples are readable.
- [ ] Confirmed tag `{TAG}` is correct and not already used by mistake.
- [ ] Confirmed the release content contains no tokens, cookies, API keys, account data, or browser sessions.
- [ ] If short-video platforms are involved, personal materials stay under local `output/douyin-release/`.

## Suggested GitHub Release Copy

{TITLE}

This update improves the Codex skill/plugin publishing flow: repository docs are easier to read, release drafts can be generated locally, and the boundary between open-source content and personal creator materials is clearer.
'@

$content = $template
$content = $content.Replace("{TITLE}", $Title)
$content = $content.Replace("{TAG}", $Tag)
$content = $content.Replace("{BRANCH}", $branch)
$content = $content.Replace("{GENERATED_AT}", $generatedAt)
$content = $content.Replace("{STATUS_SUMMARY}", $statusSummary)
$content = $content.Replace("{GIT_LOG}", $gitLog)
$content = $content.Replace("{CHANGELOG_SECTION}", $changelogSection)

Set-Content -LiteralPath $target -Value $content -Encoding UTF8
Write-Host "Created GitHub Release draft: $target"
