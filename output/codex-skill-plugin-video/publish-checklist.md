# 发布检查清单

## GitHub 上传

当前阻塞：本仓库没有配置 `git remote`。

检查命令：

```powershell
cd C:\Users\Administrator\Documents\技能和插件学习
git remote -v
```

需要你提供或配置：

```powershell
git remote add origin <你的开源仓库 URL>
git push -u origin master
```

之后每周自动化才可以在凭据可用时自动 push。

## 抖音发布

当前阻塞：没有官方或已授权的抖音发布通道。

允许执行的方式：

1. 手动上传 HeyGen 生成的视频。
2. 使用你提供的官方发布 API 或已授权发布工具。
3. 使用你明确确认的浏览器发布流程，并且不绕过登录、验证码、风控或平台限制。

不执行：

- 不保存抖音账号密码。
- 不绕验证码。
- 不模拟规避风控。
- 不自动发布未确认的视频内容。

## 视频生成

HeyGen 会话：

```text
https://app.heygen.com/video-agent/729fbfcb48854bc8a97d890cca71860b
```

视频生成完成后，把成品下载或复制链接，再按 `douyin-post.md` 上传发布。
