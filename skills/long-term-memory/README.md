# Codex Long-Term Memory

跨会话持久化记忆系统。每次对话自动加载历史记忆，项目间严格隔离。

## ✨ 特性

| 特性 | 说明 |
|------|------|
| **自动加载** | 每轮对话自动读取历史记忆作为上下文 |
| **两层隔离** | 全局记忆（偏好）+ 项目记忆（.memory/）互不干扰 |
| **零配置** | 安装后即生效，新项目自动创建 .memory/ |
| **自动归档** | 会话结束自动归档，不会丢失上下文 |
| **纯本地** | 所有数据存储在本地文件，不依赖任何服务 |

## 🚀 快速安装

**方式一：Codex 内安装**
```
$long-term-memory 安装
```

**方式二：命令行安装**
```powershell
# 下载项目后执行
.\setup.ps1
```

## 📁 记忆结构

```
~/.codex/global-memory/          ← 全局记忆（所有项目共享）
├── current_session.md
├── long_term/
│   ├── preferences.md           ← 你的偏好
│   ├── knowledge.md             ← 通用知识
│   └── projects.md
├── sessions/                    ← 会话归档
└── todo.md

[项目根]/.memory/                 ← 项目记忆（每个项目独立）
├── current_session.md
├── long_term/
│   ├── knowledge.md
│   └── projects.md
├── sessions/
└── todo.md
```

## ⚙️ 工作原理

1. **AGENTS.md** 放在 `C:\Users\你的用户名\` 目录
2. Codex 每次启动对话自动搜索该文件并执行指令
3. 指令要求 AI 加载两层记忆 → 合并 → 作为回复上下文
4. 对话中自动保存新信息到对应文件
5. 会话结束自动归档

## 📦 需求

- Codex CLI / Codex Desktop
- Windows（暂未适配 macOS/Linux，欢迎 PR）

## 📄 许可证

MIT
