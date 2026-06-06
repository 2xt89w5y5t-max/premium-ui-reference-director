# GitHub Release Draft Example

这个示例展示如何在发布前生成本地 GitHub Release 草稿。草稿文件只保存在 `output/`，脚本不会创建 tag、push、上传附件或调用 GitHub API。

## 生成默认草稿

```powershell
.\tools\new-github-release-draft.ps1 -Title "Codex 技能插件周更"
```

输出：

```text
output/github-release-draft-YYYY-MM-DD.md
```

## 指定日期、标签和提交范围

```powershell
.\tools\new-github-release-draft.ps1 `
  -Date 2026-06-06 `
  -Title "Codex 技能插件周更：Release 草稿自动化" `
  -Tag "v2026.06.06" `
  -Since "7 days ago" `
  -Force
```

## 发布前检查重点

- 草稿中的 tag、目标分支和时间是否正确。
- `CHANGELOG.md` 是否已有对应日期条目。
- Release 文案是否只包含开源项目内容。
- 是否误包含抖音封面图、短视频脚本、账号信息或密钥。
- 如果远程 push 失败，先保留本地 commit，再单独处理凭据或网络问题。
