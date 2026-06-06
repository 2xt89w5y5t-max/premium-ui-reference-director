param(
  [string]$Url,
  [string]$ApiBase = $env:DOUYIN_API_BASE,
  [switch]$UsePublicDemo
)

$ErrorActionPreference = "Stop"

if ([string]::IsNullOrWhiteSpace($ApiBase)) {
  if ($UsePublicDemo) {
    $ApiBase = "https://api.douyin.wtf"
  } else {
    $ApiBase = "http://127.0.0.1:80"
  }
}

$ApiBase = $ApiBase.TrimEnd("/")

if ([string]::IsNullOrWhiteSpace($Url)) {
  Write-Host "Usage:"
  Write-Host "  .\tools\douyin-api-smoke.ps1 -Url 'https://v.douyin.com/xxxx/'"
  Write-Host ""
  Write-Host "Optional:"
  Write-Host "  .\tools\douyin-api-smoke.ps1 -ApiBase 'http://127.0.0.1:8000' -Url 'https://v.douyin.com/xxxx/'"
  Write-Host "  `$env:DOUYIN_API_BASE='http://127.0.0.1:8000'"
  Write-Host "  .\tools\douyin-api-smoke.ps1 -UsePublicDemo -Url 'https://v.douyin.com/xxxx/'"
  Write-Host ""
  Write-Host "Notes:"
  Write-Host "  Default local base: http://127.0.0.1:80"
  Write-Host "  Public demo base: https://api.douyin.wtf"
  Write-Host "  Smoke endpoint: /api/hybrid/video_data?minimal=true"
  Write-Host "  Public demo is for temporary checks only; do not treat it as a stable dependency."
  Write-Host ""
  Write-Host "Current API base: $ApiBase"
  exit 2
}

$encodedUrl = [uri]::EscapeDataString($Url)
$endpoint = "$ApiBase/api/hybrid/video_data?url=$encodedUrl&minimal=true"

Write-Host "GET $endpoint"

try {
  $response = Invoke-RestMethod -Method Get -Uri $endpoint -TimeoutSec 30
  $response | ConvertTo-Json -Depth 12
} catch {
  Write-Error "Request failed: $($_.Exception.Message)"
  if ($_.ErrorDetails -and $_.ErrorDetails.Message) {
    Write-Host $_.ErrorDetails.Message
  }
  exit 1
}
