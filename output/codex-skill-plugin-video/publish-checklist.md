# 发布检查清单

## GitHub 上传

当前状态：本仓库已经配置 GitHub remote。

检查命令：

```powershell
cd C:\Users\Administrator\Documents\技能和插件学习
git remote -v
```

当前 remote：

```text
https://github.com/2xt89w5y5t-max/premium-ui-reference-director.git
```

之后每周自动化可以在 Git 凭据可用时自动 commit 和 push。

## 抖音发布

当前策略：通过你的电脑端已登录会话准备发布，最终发布默认等待你确认。

允许执行的方式：

1. 手动上传 HeyGen 生成的视频。
2. 使用你提供的官方发布 API 或已授权发布工具。
3. 使用你已登录的浏览器或抖音 PC 客户端上传视频、填写文案、停在最终发布确认前。
4. 如果你明确要求并现场确认账号与内容，可以继续点击最终发布。

不执行：

- 不保存抖音账号密码。
- 不绕验证码。
- 不模拟规避风控。
- 不自动发布未确认的视频内容。
- 不导出或写入 Cookie、Token。

## 视频生成

HeyGen 会话：

```text
https://app.heygen.com/video-agent/729fbfcb48854bc8a97d890cca71860b
```

视频生成完成后，把成品下载或复制链接，再按 `douyin-post.md` 上传发布。

电脑端流程见：`desktop-douyin-publish.md`。
