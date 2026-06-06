# 自动化提示词优化说明

日期：2026-06-06

## 本次修改了什么

- 增加“运行前记忆”要求，明确每次先读写 `$CODEX_HOME/automations/codex/memory.md`。
- 增加避免重复上次方向的规则，防止每周反复新增同类通用技能。
- 明确 README/CHANGELOG 出现乱码时应优先修复。
- 明确个人抖音素材必须写入 `output/douyin-release/YYYY-MM-DD/`，且不得提交到 GitHub。
- 明确新增脚本必须包含用途、参数、错误处理和本地安全边界。
- 明确 detached HEAD 下可以本地提交，但要报告 push 限制。
- 明确最终报告需要包含 commit hash、push 状态、素材目录和提示词更新方式。
- 增加 `tools/update-codex-desktop-automation.ps1` 的使用方式，让下一次自动化可优先更新 Codex Desktop 的 `automation.toml`。
- 保留本地 `tools/update-automation-prompt.ps1` 的使用方式，作为提示词镜像文件 fallback。
- 增加技能与工具路由规则：涉及浏览器、桌面 UI、文件选择器、截图、页面验证或发布流程时，必须先读取 `skills/browser-desktop-orchestrator/SKILL.md`。
- 明确不能在未读取路由技能和底层技能前，直接声称“没有工具”或“无法点击”。

## 为什么修改

本次运行发现：

- 上次已新增通用周更技能，本次需要避免重复建设。
- `README.md` 和 `CHANGELOG.md` 存在中文乱码，说明提示词需要强调发布入口文档质量。
- 当前环境没有可用的自动化任务更新工具，因此需要稳定生成可手动复制的下一版提示词。
- 用户要求安装自动化更新工具后，已补充本地提示词更新脚本和安装器。
- 用户继续要求 app-level 更新后，已补充直接更新 Codex Desktop `automation.toml` 的工具。
- 本次对话暴露了技能调用流程问题：仓库已有 `browser-desktop-orchestrator`，但助手没有第一时间按技能路由，导致对工具能力描述不准确。
- 抖音素材与开源提交边界需要更明确，避免误把个人运营素材提交到 GitHub。

## 下一次会变得更好的地方

- 自动化会先读取记忆，减少重复方向。
- 遇到文档乱码、坏链接、坏示例会优先修复。
- 新增工具脚本会更稳定地包含安全说明和失败处理。
- 抖音素材会更贴近本次真实更新，而不是泛泛宣传。
- 最终报告会更容易确认 Git、push、素材和提示词状态。

## 仍然存在的风险

- 当前环境可能处于 detached HEAD，push 可能需要外部工作流接管。
- 网络或 GitHub 凭据不可用时，push 会失败但本地提交仍会保留。
- 自动化任务本身暂时无法由当前会话直接更新，需要用户手动复制 `automation_prompt_next.md`。
- 如果未来生成图片或视频文件，仍需依赖 `.gitignore` 和提交前检查避免误提交。
