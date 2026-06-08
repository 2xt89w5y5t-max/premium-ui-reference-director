# Long-Term Memory Skill

**跨会话持久化记忆系统 | Cross-session Persistent Memory System**

当用户提到记忆、持久化、跨会话、项目上下文、memory、长期记忆时自动触发。

---

## 概述

这是一个两层记忆系统：
1. **全局记忆** — 用户偏好、通用知识（`~/.codex/global-memory/`）
2. **项目记忆** — 每个工作区独立的 `.memory/` 目录

## 安装方式

### 方式一：自动安装（推荐）
在任意 Codex 对话中说：
> `$long-term-memory 安装`
>
> 或
>
> `帮我安装长期记忆系统`

### 方式二：手动安装
执行以下命令安装 AGENTS.md：

```powershell
# 复制全局 AGENTS.md
Copy-Item "$env:USERPROFILE\.codex\skills\long-term-memory\references\AGENTS.md" "$env:USERPROFILE\AGENTS.md" -Force
Write-Host "✅ 全局 AGENTS.md 已安装，所有 Codex 对话将自动加载记忆"
```

### 方式三：完整安装（包含初始化）
执行安装脚本：

```powershell
& "$env:USERPROFILE\.codex\skills\long-term-memory\scripts\install.ps1"
```

## 工作原理

| 层次 | 位置 | 说明 |
|------|------|------|
| 全局记忆 | `~/.codex/global-memory/` | 所有项目共享（偏好、通用知识） |
| 项目记忆 | `[项目根]/.memory/` | 每个项目独立（项目上下文、决策） |
| 加载机制 | `~/.codex/AGENTS.md` | 每轮对话自动读取两层记忆 |

## 记忆文件结构

### 全局 (`~/.codex/global-memory/`)
```
├── current_session.md       ← 当前会话笔记
├── long_term/
│   ├── preferences.md       ← 用户偏好
│   ├── knowledge.md         ← 通用知识
│   └── projects.md          ← 项目追踪
├── sessions/                ← 会话归档
└── todo.md                  ← 待办事项
```

### 项目 (`[项目根]/.memory/`)
```
├── current_session.md
├── long_term/
│   ├── knowledge.md         ← 项目特有知识
│   └── projects.md          ← 项目进展
├── sessions/
└── todo.md
```

## 卸载

```powershell
Remove-Item "$env:USERPROFILE\AGENTS.md" -Force
Remove-Item "$env:USERPROFILE\.codex\global-memory\" -Recurse -Force
Write-Host "✅ 已卸载"
```

## 开源

GitHub: https://github.com/你的用户名/codex-long-term-memory
