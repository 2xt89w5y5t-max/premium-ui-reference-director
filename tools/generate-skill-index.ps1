param(
  [string]$OutputPath = "docs\全部技能索引.md"
)

$ErrorActionPreference = "Stop"

function Get-FrontmatterValue {
  param(
    [string[]]$Lines,
    [string]$Key
  )

  $pattern = "^" + [regex]::Escape($Key) + "\s*:\s*(.*)$"
  foreach ($line in $Lines) {
    if ($line -match $pattern) {
      $value = $Matches[1].Trim()
      if (($value.StartsWith('"') -and $value.EndsWith('"')) -or ($value.StartsWith("'") -and $value.EndsWith("'"))) {
        $value = $value.Substring(1, $value.Length - 2)
      }
      return $value
    }
  }

  return ""
}

function Escape-MarkdownCell {
  param([string]$Text)

  if ($null -eq $Text) {
    return ""
  }

  return (($Text -replace "\|", "\|") -replace "`r?`n", " ").Trim()
}

function Get-SkillCategory {
  param(
    [string]$Name,
    [string]$Description,
    [string]$Path
  )

  $signal = ($Name + " " + $Description + " " + $Path).ToLowerInvariant()

  if ($signal -match "browser|chrome|playwright|screenshot|devtools|computer-use|tiktok|douyin|instagram|facebook|reddit|linkedin|google-search|google-image|maps") {
    return "浏览器/桌面/采集自动化"
  }

  if ($signal -match "figma|ui|frontend|react|ios|swift|web-app|shadcn|product-design|hyperframes|remotion|creative|image-to-code") {
    return "设计/前端/视频创作"
  }

  if ($signal -match "github|git|commit|ci|cd|deploy|netlify|vercel|cloudflare|render|review|debug|test|security|performance|migration|api|mcp|cli") {
    return "开发/Git/API/工程化"
  }

  if ($signal -match "data|analytics|dashboard|report|kpi|market|commerce|ecommerce|amazon|sku|product|notion|linear|sentry") {
    return "数据/商业/电商/知识库"
  }

  if ($signal -match "agnes|openai|text|image|video|speech|transcribe|model|prompt") {
    return "AI模型/生成/多模态"
  }

  return "通用方法/流程/规划"
}

$repoRoot = (Resolve-Path ".").Path
$resolvedOutput = Join-Path $repoRoot $OutputPath
$outputDir = Split-Path -Parent $resolvedOutput
if (!(Test-Path -LiteralPath $outputDir)) {
  New-Item -ItemType Directory -Force -Path $outputDir | Out-Null
}

$roots = @(
  @{ Label = "user-codex"; Path = "$env:USERPROFILE\.codex\skills" },
  @{ Label = "user-agents"; Path = "$env:USERPROFILE\.agents\skills" },
  @{ Label = "openai-bundled"; Path = "$env:USERPROFILE\.codex\plugins\cache\openai-bundled" },
  @{ Label = "openai-curated"; Path = "$env:USERPROFILE\.codex\plugins\cache\openai-curated" },
  @{ Label = "openai-curated-remote"; Path = "$env:USERPROFILE\.codex\plugins\cache\openai-curated-remote" }
)

$skills = New-Object System.Collections.Generic.List[object]

foreach ($root in $roots) {
  if (!(Test-Path -LiteralPath $root.Path)) {
    continue
  }

  Get-ChildItem -LiteralPath $root.Path -Recurse -Filter "SKILL.md" -File -ErrorAction SilentlyContinue | ForEach-Object {
    $fullPath = $_.FullName
    $head = Get-Content -LiteralPath $fullPath -TotalCount 80 -Encoding UTF8
    $frontmatter = @()

    if ($head.Count -gt 0 -and $head[0] -eq "---") {
      for ($index = 1; $index -lt $head.Count; $index += 1) {
        if ($head[$index] -eq "---") {
          break
        }
        $frontmatter += $head[$index]
      }
    }

    $name = Get-FrontmatterValue -Lines $frontmatter -Key "name"
    $description = Get-FrontmatterValue -Lines $frontmatter -Key "description"

    if (!$name) {
      $name = Split-Path -Leaf (Split-Path -Parent $fullPath)
    }

    $shortPath = $fullPath
    if ($shortPath.StartsWith($env:USERPROFILE)) {
      $shortPath = "~" + $shortPath.Substring($env:USERPROFILE.Length)
    }

    $skills.Add([pscustomobject]@{
      Name = $name
      Description = $description
      Source = $root.Label
      Path = $shortPath
      Category = Get-SkillCategory -Name $name -Description $description -Path $fullPath
    }) | Out-Null
  }
}

$skills = $skills | Sort-Object Category, Name, Source, Path
$now = Get-Date -Format "yyyy-MM-dd HH:mm:ss zzz"
$lines = New-Object System.Collections.Generic.List[string]

$lines.Add("# 全部技能索引")
$lines.Add("")
$lines.Add("生成时间：$now")
$lines.Add("")
$lines.Add('这份索引用来先建立全量技能地图，再按任务自动调用对应技能。它只记录技能入口、用途和路由建议；执行时仍应按需读取具体 `SKILL.md`，避免一次性加载全部上下文。')
$lines.Add("")
$lines.Add("## 总览")
$lines.Add("")
$lines.Add("- 技能总数：$($skills.Count)")
foreach ($group in ($skills | Group-Object Source | Sort-Object Name)) {
  $lines.Add("- $($group.Name)：$($group.Count)")
}
$lines.Add("")
$lines.Add("## 自动调用路由")
$lines.Add("")
$lines.Add("| 任务信号 | 优先技能/插件 |")
$lines.Add("|---|---|")
$routes = @(
  @('网页打开、localhost、本地前端、页面点击、截图验证', '`browser-desktop-orchestrator` -> Browser plugin / `playwright`'),
  @('Windows 桌面、文件选择窗口、微信、剪映、抖音客户端', '`browser-desktop-orchestrator` -> Computer Use plugin'),
  @('JS 渲染网页采集、滚动加载、XHR/HAR、批量浏览', '`browser-desktop-orchestrator` -> `browser-act`'),
  @('可复用浏览器测试、前端回归、脚本化截图', '`playwright` / `browser-testing-with-devtools`'),
  @('网站、App、UI、落地页、产品界面', '`premium-ui-reference-director` + `beautiful-ui-designer` + `frontend-ui-engineering`'),
  @('Figma 生成、Figma 修改、设计稿转代码', '`figma-*` / `product-design:image-to-code`'),
  @('GitHub、PR、CI、提交、发布开源仓库', '`github:*` + `git-workflow-and-versioning` + `ci-cd-and-automation`'),
  @('API、MCP、CLI、插件/技能创建', '`api-and-interface-design` + `mcp-builder` + `cli-creator` + `skill-creator`'),
  @('数据看板、KPI、市场机会、报告', '`data-analytics:*` + `market-demand-radar-run`'),
  @('电商、SKU、Amazon、商品图/视频', '`ecommerce-*` + `ai-model-sku-prompting` + `china-commerce-*`'),
  @('图片/视频/语音/转写/Agnes 免费模型', '`agnes-free-*` + `imagegen` + `speech` + `transcribe`'),
  @('代码审查、调试、测试、安全、性能', '`code-review-and-quality` + `systematic-debugging` + `test-driven-development` + `security-*`')
)
foreach ($route in $routes) {
  $lines.Add("| $($route[0]) | $($route[1]) |")
}
$lines.Add("")
$lines.Add("## 使用规则")
$lines.Add("")
$lines.Add('1. 先读用户任务和当前仓库 `AGENTS.md`。')
$lines.Add("2. 从下方索引按关键词选择 1-3 个最相关技能。")
$lines.Add('3. 只读取被选中技能的 `SKILL.md`，必要时再读取其 references/scripts。')
$lines.Add('4. 多技能协作时指定主技能：浏览器/桌面任务由 `browser-desktop-orchestrator` 主控，UI 任务由 `premium-ui-reference-director` 主控。')
$lines.Add("5. 需要外部副作用时遵守确认/安全边界：发布、提交表单、上传个人文件、发送消息、删除数据都要特别谨慎。")
$lines.Add("")

foreach ($category in ($skills | Group-Object Category | Sort-Object Name)) {
  $lines.Add("## $($category.Name)")
  $lines.Add("")
  $lines.Add("| 技能 | 来源 | 路径 | 用途 |")
  $lines.Add("|---|---|---|---|")

  foreach ($skill in ($category.Group | Sort-Object Name, Source, Path)) {
    $lines.Add('| `' + (Escape-MarkdownCell $skill.Name) + '` | ' + (Escape-MarkdownCell $skill.Source) + ' | `' + (Escape-MarkdownCell $skill.Path) + '` | ' + (Escape-MarkdownCell $skill.Description) + ' |')
  }

  $lines.Add("")
}

while ($lines.Count -gt 0 -and $lines[$lines.Count - 1] -eq "") {
  $lines.RemoveAt($lines.Count - 1)
}

Set-Content -LiteralPath $resolvedOutput -Value $lines -Encoding UTF8
Write-Output "Generated $OutputPath with $($skills.Count) skills."
