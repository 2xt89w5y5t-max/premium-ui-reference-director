# 全局长期记忆系统（Global Long-Term Memory）

================================================================================
# AUTO-LOAD（每轮对话启动时自动执行）
================================================================================

按以下顺序执行。任何一步失败不影响后续。

## 第1步：加载全局记忆
如果以下文件存在，读取内容作为上下文：
- C:\Users\Administrator\.codex\global-memory\current_session.md
- C:\Users\Administrator\.codex\global-memory\long_term\preferences.md
- C:\Users\Administrator\.codex\global-memory\long_term\knowledge.md
- C:\Users\Administrator\.codex\global-memory\long_term\projects.md
- C:\Users\Administrator\.codex\global-memory\todo.md

## 第2步：确定项目根目录
依次尝试，命中即止：
1. CWD 所在目录包含 .git → 该目录为项目根
2. CWD 所在目录包含 AGENTS.md → 该目录为项目根
3. CWD 所在目录包含 .memory → 该目录为项目根
4. 以上都不满足 → CWD 本身即为项目根
项目根 = [PROJECT_ROOT]

## 第3步：初始化项目 .memory（如不存在）
检查 [PROJECT_ROOT]\.memory\ 是否存在。
不存在则创建标准结构，写入初始化标记。
标准结构：
├── current_session.md
├── long_term\knowledge.md
├── long_term\projects.md
├── todo.md
└── sessions\

## 第4步：加载项目记忆
如果以下文件存在，读取内容作为上下文：
- [PROJECT_ROOT]\.memory\current_session.md
- [PROJECT_ROOT]\.memory\long_term\knowledge.md
- [PROJECT_ROOT]\.memory\long_term\projects.md
- [PROJECT_ROOT]\.memory\todo.md

## 第5步：合并记忆
- 全局记忆提供：用户偏好、通用知识、跨项目上下文
- 项目记忆提供：该项目特有上下文、进展
- 项目记忆优先于全局记忆（同名信息以项目为准）
- 在回复中**不需要**向用户报告记忆加载过程

================================================================================
# AUTO-SAVE（对话过程中自动触发）
================================================================================

以下行为触发写入。写入使用 shell_command，只追加不覆盖。

## 触发条件 + 写入目标
- 用户明确告知偏好/习惯 → 追加到 global-memory\long_term\preferences.md
  （格式：`- YYYY-MM-DD [发现来源] 偏好内容`）
- 做出重要技术决策 → 追加到 [PROJECT_ROOT]\.memory\long_term\knowledge.md
  （格式：`- YYYY-MM-DD 决策：[简明描述]`）
- 用户提到跨上下文通用事实 → 追加到 global-memory\long_term\knowledge.md
- 项目状态有变化 → 更新 [PROJECT_ROOT]\.memory\current_session.md
- 用户提到待办 → 追加到 [PROJECT_ROOT]\.memory\todo.md
  （格式：`- [ ] 待办描述（YYYY-MM-DD）`）

## 更新 current_session.md 的规则
current_session.md 结构固定为以下区块。每次更新只替换区块内容，不破坏文件结构：
```
## 会话目标
- ...

## 工作笔记
- ...

## 本次会话关键决策
- ...
```
用 Select-String 确定各区块位置，再替换内容。如果文件不存在则创建。

================================================================================
# SESSION ARCHIVE（用户说"结束"/"归档"/关闭对话时）
================================================================================

1. 读取全局 current_session.md → 写入 C:\Users\Administrator\.codex\global-memory\sessions\YYYY-MM-DD-HHmm.md
2. 读取项目 current_session.md → 写入 [PROJECT_ROOT]\.memory\sessions\YYYY-MM-DD-HHmm.md
3. 清空两个 current_session.md（保留区块标题，只清内容）
4. 确保所有新知识已持久化到 long_term/ 文件

================================================================================
# 故障恢复
================================================================================
- 如果某个记忆文件损坏（无法解析），跳过它，不影响其他步骤
- 如果 .memory\ 目录被删除，下次自动重建
- 如果两个 current_session.md 内容矛盾，以项目级为准
