# Codex 技能插件讲解视频发布包

生成时间：2026-06-05

## 状态

- HeyGen 视频生成会话已启动：<https://app.heygen.com/video-agent/729fbfcb48854bc8a97d890cca71860b>
- 本地发布包已准备：脚本、分镜、标题、标签、封面文案、发布检查清单。
- 抖音电脑端发布流程已补充：可使用你已登录的浏览器或 PC 客户端准备上传，最终发布默认等待人工确认。

## 文件

- `script.md`：60 秒中文口播稿。
- `storyboard.md`：分镜和屏幕文字。
- `douyin-post.md`：抖音标题、简介、标签、封面文案。
- `publish-checklist.md`：发布前检查和阻塞项。
- `desktop-douyin-publish.md`：电脑端抖音上传与发布确认流程。

## 自动化关联

每周一 09:00 的 Codex 自动化：`codex`

自动化会更新：

- `external-skills/Douyin_TikTok_Download_API`
- `external-skills/chinese-independent-developer`
- `notes/douyin-tiktok-api-codex-playbook.md`
- `notes/chinese-indie-dev-opportunity-map.md`
- `tools/douyin-api-smoke.ps1`

如果当前仓库配置了 Git remote 和凭据，自动化会尝试 commit 和 push；否则只生成本地更新并报告阻塞。
