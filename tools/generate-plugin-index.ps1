param(
  [string]$OutputPath = "docs\全部插件索引.md"
)

$ErrorActionPreference = "Stop"

function Escape-MarkdownCell {
  param([string]$Text)

  if ($null -eq $Text) {
    return ""
  }

  return (($Text -replace "\|", "\|") -replace "`r?`n", " ").Trim()
}

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

function Get-SkillMeta {
  param([string]$SkillPath)

  $head = Get-Content -LiteralPath $SkillPath -TotalCount 80 -Encoding UTF8
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
    $name = Split-Path -Leaf (Split-Path -Parent $SkillPath)
  }

  return [pscustomobject]@{
    Name = $name
    Description = $description
  }
}

function Shorten-Text {
  param(
    [string]$Text,
    [int]$Max = 150
  )

  if ($null -eq $Text) {
    return ""
  }

  $clean = ($Text -replace "\s+", " ").Trim()
  if ($clean.Length -le $Max) {
    return $clean
  }

  return $clean.Substring(0, [Math]::Max(0, $Max - 3)).TrimEnd() + "..."
}

function Convert-ToShortPath {
  param([string]$FullPath)

  if ($FullPath.StartsWith($env:USERPROFILE, [System.StringComparison]::OrdinalIgnoreCase)) {
    return "~" + $FullPath.Substring($env:USERPROFILE.Length)
  }

  return $FullPath
}

function Get-FileCountSkippingCommonDirs {
  param([string]$Path)

  if (!(Test-Path -LiteralPath $Path)) {
    return 0
  }

  $count = 0
  $stack = New-Object System.Collections.Generic.Stack[string]
  $stack.Push((Resolve-Path -LiteralPath $Path).Path)

  while ($stack.Count -gt 0) {
    $current = $stack.Pop()
    foreach ($item in Get-ChildItem -LiteralPath $current -Force -ErrorAction SilentlyContinue) {
      if ($item.PSIsContainer) {
        if ($item.Name -notin @("node_modules", ".git", ".next", "dist", "build")) {
          $stack.Push($item.FullName)
        }
      } else {
        $count += 1
      }
    }
  }

  return $count
}

function Get-PluginCategory {
  param(
    [string]$Name,
    [string]$DisplayName,
    [string]$Description,
    [string[]]$Keywords
  )

  $signal = (@($Name, $DisplayName, $Description) + $Keywords) -join " "
  $signal = $signal.ToLowerInvariant()
  $nameKey = $Name.ToLowerInvariant()

  switch -Regex ($nameKey) {
    "^(browser|chrome|computer-use)$" {
      return "浏览器/桌面自动化"
    }
    "^(build-ios-apps|build-web-apps|cloudflare|github|netlify|render|sentry|supabase|superpowers|vercel)$" {
      return "开发/Git/部署"
    }
    "^(build-web-data-visualization|data-analytics)$" {
      return "数据/可视化"
    }
    "^(creative-production|heygen|hyperframes|remotion)$" {
      return "视频/创意生产"
    }
    "^(biorender|canva|figma|picsart|product-design)$" {
      return "设计/原型/视觉"
    }
    "^(fal|hugging-face|nvidia|openai-developers)$" {
      return "AI模型/生成服务"
    }
    "^(atlassian-rovo|gmail|google-calendar|google-drive|linear|notion|outlook-calendar|outlook-email|sharepoint|slack|teams)$" {
      return "协作/办公/知识库"
    }
    "^latex$" {
      return "文档/排版"
    }
  }

  if ($signal -match "hugging|nvidia|fal|openai|\bai\b|model|gpu") {
    return "AI模型/生成服务"
  }

  if ($signal -match "\bdata\b|analytics|visualization|dashboard|chart|report|dataset") {
    return "数据/可视化"
  }

  if ($signal -match "video|creative|hyperframes|remotion|heygen|shot|scene|moodboard") {
    return "视频/创意生产"
  }

  if ($signal -match "figma|\bdesign\b|prototype|\bui\b|\bux\b|canva|picsart|image|biorender") {
    return "设计/原型/视觉"
  }

  if ($signal -match "github|vercel|netlify|cloudflare|render|supabase|sentry|deploy|ci|developer|code|ios|swift|swiftui|web-app|frontend|react|stripe|mcp|worker|xcode") {
    return "开发/Git/部署"
  }

  if ($signal -match "computer-use|desktop-control|windows|in-app browser|browser-use|control chrome|chrome") {
    return "浏览器/桌面自动化"
  }

  if ($signal -match "gmail|calendar|drive|notion|linear|slack|teams|outlook|sharepoint|atlassian|rovo") {
    return "协作/办公/知识库"
  }

  if ($signal -match "latex|pdf|document") {
    return "文档/排版"
  }

  return "通用插件"
}

$repoRoot = (Resolve-Path ".").Path
$resolvedOutput = Join-Path $repoRoot $OutputPath
$outputDir = Split-Path -Parent $resolvedOutput
if (!(Test-Path -LiteralPath $outputDir)) {
  New-Item -ItemType Directory -Force -Path $outputDir | Out-Null
}

$roots = @(
  @{ Label = "openai-bundled"; Path = "$env:USERPROFILE\.codex\plugins\cache\openai-bundled" },
  @{ Label = "openai-curated"; Path = "$env:USERPROFILE\.codex\plugins\cache\openai-curated" },
  @{ Label = "openai-curated-remote"; Path = "$env:USERPROFILE\.codex\plugins\cache\openai-curated-remote" }
)

$plugins = New-Object System.Collections.Generic.List[object]
$skippedNestedPluginJson = 0

foreach ($root in $roots) {
  if (!(Test-Path -LiteralPath $root.Path)) {
    continue
  }

  $rootPath = (Resolve-Path -LiteralPath $root.Path).Path
  Get-ChildItem -LiteralPath $rootPath -Recurse -Filter "plugin.json" -File -ErrorAction SilentlyContinue | ForEach-Object {
    $pluginJsonPath = $_.FullName
    $pluginJsonDir = Split-Path -Parent $pluginJsonPath
    if ((Split-Path -Leaf $pluginJsonDir) -ne ".codex-plugin") {
      return
    }

    $versionRoot = Split-Path -Parent $pluginJsonDir
    $relative = $versionRoot.Substring($rootPath.Length).TrimStart("\", "/")
    $segments = $relative -split "[\\/]"

    if ($segments.Count -ne 2) {
      $skippedNestedPluginJson += 1
      return
    }

    $pluginFolderName = $segments[0]
    $versionFolderName = $segments[1]

    try {
      $pluginJson = Get-Content -LiteralPath $pluginJsonPath -Raw -Encoding UTF8 | ConvertFrom-Json
    } catch {
      Write-Warning "Cannot parse $pluginJsonPath"
      return
    }

    $skillsPath = Join-Path $versionRoot "skills"
    $skillMetas = @()
    if (Test-Path -LiteralPath $skillsPath) {
      $skillMetas = @(Get-ChildItem -LiteralPath $skillsPath -Recurse -Filter "SKILL.md" -File -ErrorAction SilentlyContinue | ForEach-Object {
        Get-SkillMeta -SkillPath $_.FullName
      })
    }

    $appPath = Join-Path $versionRoot ".app.json"
    $mcpPath = Join-Path $versionRoot ".mcp.json"
    $commandsPath = Join-Path $versionRoot "commands"
    $scriptsPath = Join-Path $versionRoot "scripts"
    $uiPath = Join-Path $versionRoot "ui"
    $templatesPath = Join-Path $versionRoot "templates"
    $assetsPath = Join-Path $versionRoot "assets"
    $agentsPath = Join-Path $versionRoot "agents"

    $keywords = @($pluginJson.keywords | ForEach-Object { [string]$_ })
    $capabilities = @($pluginJson.interface.capabilities | ForEach-Object { [string]$_ })
    $displayName = [string]$pluginJson.interface.displayName
    if (!$displayName) {
      $displayName = [string]$pluginJson.name
    }

    $description = [string]$pluginJson.interface.shortDescription
    if (!$description) {
      $description = [string]$pluginJson.description
    }

    $plugins.Add([pscustomobject]@{
      Name = [string]$pluginJson.name
      DisplayName = $displayName
      Version = if ($pluginJson.version) { [string]$pluginJson.version } else { $versionFolderName }
      VersionFolder = $versionFolderName
      Source = $root.Label
      Folder = $pluginFolderName
      Category = Get-PluginCategory -Name ([string]$pluginJson.name) -DisplayName $displayName -Description ([string]$pluginJson.description) -Keywords $keywords
      Description = Shorten-Text -Text $description -Max 180
      LongDescription = Shorten-Text -Text ([string]$pluginJson.interface.longDescription) -Max 320
      Developer = [string]$pluginJson.interface.developerName
      Author = if ($pluginJson.author.name) { [string]$pluginJson.author.name } else { "" }
      License = [string]$pluginJson.license
      Homepage = [string]$pluginJson.homepage
      Repository = [string]$pluginJson.repository
      Keywords = $keywords
      Capabilities = $capabilities
      DefaultPrompts = @($pluginJson.interface.defaultPrompt | ForEach-Object { [string]$_ })
      Skills = $skillMetas
      SkillCount = $skillMetas.Count
      HasApp = (Test-Path -LiteralPath $appPath) -or [bool]$pluginJson.apps
      HasMcp = (Test-Path -LiteralPath $mcpPath) -or [bool]$pluginJson.mcp
      CommandCount = if (Test-Path -LiteralPath $commandsPath) { @(Get-ChildItem -LiteralPath $commandsPath -File -ErrorAction SilentlyContinue).Count } else { 0 }
      ScriptCount = Get-FileCountSkippingCommonDirs -Path $scriptsPath
      UiCount = Get-FileCountSkippingCommonDirs -Path $uiPath
      TemplateCount = Get-FileCountSkippingCommonDirs -Path $templatesPath
      AssetCount = Get-FileCountSkippingCommonDirs -Path $assetsPath
      AgentCount = if (Test-Path -LiteralPath $agentsPath) { @(Get-ChildItem -LiteralPath $agentsPath -File -ErrorAction SilentlyContinue).Count } else { 0 }
      Path = Convert-ToShortPath -FullPath $versionRoot
    }) | Out-Null
  }
}

$plugins = $plugins | Sort-Object Category, DisplayName, Source, Version
$now = Get-Date -Format "yyyy-MM-dd HH:mm:ss zzz"
$lines = New-Object System.Collections.Generic.List[string]

$lines.Add("# 全部插件索引")
$lines.Add("")
$lines.Add("生成时间：$now")
$lines.Add("")
$lines.Add('这份索引用来补齐“插件层”的全量地图。插件是能力包，通常包含一个或多个 `SKILL.md`、app 连接、MCP 配置、commands、scripts、UI、assets 或 templates；执行任务时先选插件包，再按需读取具体技能入口。')
$lines.Add("")
$lines.Add("## 总览")
$lines.Add("")
$lines.Add("- 插件版本数：$($plugins.Count)")
$lines.Add("- 插件内技能入口：$(($plugins | Measure-Object -Property SkillCount -Sum).Sum)")
$lines.Add("- 带 App 连接的插件：$(($plugins | Where-Object { $_.HasApp }).Count)")
$lines.Add("- 带 MCP 配置的插件：$(($plugins | Where-Object { $_.HasMcp }).Count)")
$lines.Add("- 带命令文件的插件：$(($plugins | Where-Object { $_.CommandCount -gt 0 }).Count)")
$lines.Add("- 跳过的嵌套/暂存 plugin.json：$skippedNestedPluginJson")
foreach ($group in ($plugins | Group-Object Source | Sort-Object Name)) {
  $lines.Add("- $($group.Name)：$($group.Count)")
}
$lines.Add("")
$lines.Add("## 插件优先路由")
$lines.Add("")
$lines.Add("| 任务信号 | 优先插件 | 落地能力 |")
$lines.Add("|---|---|---|")
$routes = @(
  @('打开/检查 localhost、本地网页点击、截图、文件 URL', '`Browser`', 'in-app browser 交互、读取、写入；常和 Playwright/前端测试联动'),
  @('Windows 桌面软件、系统文件选择器、抖音/剪映客户端', '`Computer Use`', '桌面截图、点击、键入、原生窗口控制'),
  @('Figma 设计稿、设计系统、Figma 到代码', '`Figma` + `Product Design`', 'Figma app 连接、设计生成、Code Connect、原型探索'),
  @('GitHub issue/PR/CI、发布开源仓库', '`GitHub`', '仓库检查、评论处理、CI 修复、发布工作流'),
  @('Vercel/Netlify/Cloudflare/Render 部署', '`Vercel` / `Netlify` / `Cloudflare` / `Render`', '部署、存储、函数、队列、Workers、Pages、平台配置'),
  @('Web App、React、Stripe、Supabase、前端调试', '`Build Web Apps`', '前端构建、React/shadcn/Stripe/Supabase 最佳实践和测试调试'),
  @('iOS/SwiftUI、模拟器、性能/内存问题', '`Build iOS Apps`', 'SwiftUI、Simulator、App Intents、性能审计、内存泄漏分析'),
  @('数据看板、图表、报表、PDF/Slides 自动化', '`Data Analytics` + `Build Web Data Visualization`', '数据分析、可视化、dashboard、报告导出'),
  @('短视频、动效、脚本、分镜、风格探索', '`Creative Production` + `Hyperframes` + `Remotion`', '创意探索、视频/动效生成、字幕、音频反应、动态页面'),
  @('办公知识库、项目协作、邮件日历', '`Notion` / `Linear` / `Slack` / `Teams` / `Gmail` / `Google Drive`', '知识检索、任务管理、消息、日程、文件协作'),
  @('AI 模型、图像/视频生成、GPU/推理服务', '`fal` / `Hugging Face` / `NVIDIA` / `OpenAI Developers`', '模型调用、生成服务、开发者文档与示例')
)
foreach ($route in $routes) {
  $lines.Add("| $($route[0]) | $($route[1]) | $($route[2]) |")
}
$lines.Add("")
$lines.Add("## 使用规则")
$lines.Add("")
$lines.Add('1. 先从插件索引选能力包，再从 `docs/全部技能索引.md` 精确选择 `SKILL.md`。')
$lines.Add("2. 显式点名插件时优先用对应插件能力；没点名时根据任务信号选择最小插件集合。")
$lines.Add("3. Browser 负责 in-app browser，本机 Windows 软件交给 Computer Use，重复浏览器流程再用 Playwright 或 browser-act。")
$lines.Add("4. 需要登录、授权、扫码、付款、删除、发布、发送消息时暂停让用户确认。")
$lines.Add("5. 插件缓存可能随 Codex 更新变化；周更时重新运行生成脚本。")
$lines.Add("")
$lines.Add("## 插件总表")
$lines.Add("")
$lines.Add("| 插件 | 来源 | 版本 | 类别 | 能力 | 技能 | 连接 | 路径 | 用途 |")
$lines.Add("|---|---|---|---|---|---:|---|---|---|")

foreach ($plugin in $plugins) {
  $connections = New-Object System.Collections.Generic.List[string]
  if ($plugin.HasApp) { $connections.Add("App") | Out-Null }
  if ($plugin.HasMcp) { $connections.Add("MCP") | Out-Null }
  if ($plugin.CommandCount -gt 0) { $connections.Add("Commands:$($plugin.CommandCount)") | Out-Null }
  if ($plugin.UiCount -gt 0) { $connections.Add("UI:$($plugin.UiCount)") | Out-Null }
  if ($plugin.TemplateCount -gt 0) { $connections.Add("Templates:$($plugin.TemplateCount)") | Out-Null }

  $lines.Add('| `' + (Escape-MarkdownCell $plugin.DisplayName) + '` | ' + (Escape-MarkdownCell $plugin.Source) + ' | `' + (Escape-MarkdownCell $plugin.Version) + '` | ' + (Escape-MarkdownCell $plugin.Category) + ' | ' + (Escape-MarkdownCell (($plugin.Capabilities | Sort-Object) -join ", ")) + ' | ' + $plugin.SkillCount + ' | ' + (Escape-MarkdownCell (($connections | Sort-Object) -join ", ")) + ' | `' + (Escape-MarkdownCell $plugin.Path) + '` | ' + (Escape-MarkdownCell $plugin.Description) + ' |')
}

$lines.Add("")

foreach ($category in ($plugins | Group-Object Category | Sort-Object Name)) {
  $lines.Add("## $($category.Name)")
  $lines.Add("")

  foreach ($plugin in ($category.Group | Sort-Object DisplayName, Source, Version)) {
    $lines.Add("### ``$($plugin.DisplayName)``")
    $lines.Add("")
    $lines.Add('- 包名/版本：`' + $plugin.Name + '` / `' + $plugin.Version + '`')
    $lines.Add('- 来源/路径：' + $plugin.Source + ' / `' + $plugin.Path + '`')
    if ($plugin.Capabilities.Count -gt 0) {
      $lines.Add("- 能力边界：$(($plugin.Capabilities | Sort-Object) -join '、')")
    }

    $parts = New-Object System.Collections.Generic.List[string]
    $parts.Add("技能 $($plugin.SkillCount)") | Out-Null
    if ($plugin.HasApp) { $parts.Add("App") | Out-Null }
    if ($plugin.HasMcp) { $parts.Add("MCP") | Out-Null }
    if ($plugin.CommandCount -gt 0) { $parts.Add("commands $($plugin.CommandCount)") | Out-Null }
    if ($plugin.ScriptCount -gt 0) { $parts.Add("scripts $($plugin.ScriptCount)") | Out-Null }
    if ($plugin.UiCount -gt 0) { $parts.Add("ui $($plugin.UiCount)") | Out-Null }
    if ($plugin.TemplateCount -gt 0) { $parts.Add("templates $($plugin.TemplateCount)") | Out-Null }
    if ($plugin.AssetCount -gt 0) { $parts.Add("assets $($plugin.AssetCount)") | Out-Null }
    if ($plugin.AgentCount -gt 0) { $parts.Add("agents $($plugin.AgentCount)") | Out-Null }
    $lines.Add("- 组成：$(($parts | Sort-Object) -join '、')")

    if ($plugin.Skills.Count -gt 0) {
      $skillNames = @($plugin.Skills | Sort-Object Name | Select-Object -ExpandProperty Name)
      $visibleSkills = @($skillNames | Select-Object -First 16)
      $skillLine = ($visibleSkills | ForEach-Object { "``$_``" }) -join "、"
      if ($skillNames.Count -gt $visibleSkills.Count) {
        $skillLine += "、等 $($skillNames.Count) 个"
      }
      $lines.Add("- 技能入口：$skillLine")
    }

    if ($plugin.DefaultPrompts.Count -gt 0) {
      $promptLine = (@($plugin.DefaultPrompts | Select-Object -First 3) | ForEach-Object { '"' + (Shorten-Text -Text $_ -Max 80) + '"' }) -join "；"
      $lines.Add("- 默认提示：$promptLine")
    }

    if ($plugin.LongDescription) {
      $lines.Add("- 说明：$($plugin.LongDescription)")
    }

    $lines.Add("")
  }
}

while ($lines.Count -gt 0 -and $lines[$lines.Count - 1] -eq "") {
  $lines.RemoveAt($lines.Count - 1)
}

Set-Content -LiteralPath $resolvedOutput -Value $lines -Encoding UTF8
Write-Output "Generated $OutputPath with $($plugins.Count) plugins and $(($plugins | Measure-Object -Property SkillCount -Sum).Sum) plugin skills."
