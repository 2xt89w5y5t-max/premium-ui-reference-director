# Douyin_TikTok_Download_API：Codex 接入与使用手册

## 本轮上下文

- 来源仓库：`external-skills/Douyin_TikTok_Download_API`
- 本轮可见本地提交：`42784ff`（2025-10-12）
- 远端同步状态：已检测到 `origin`，但当前自动化会话缺少 Git HTTPS 凭据，`fetch` 被 `SEC_E_NO_CREDENTIALS` 阻塞，因此以下内容基于当前本地副本与代码路由核对结果。

## 这个仓库在 Codex 里最适合承担什么角色

它更适合做“本地解析与下载中转层”，而不是通用爬虫平台。

推荐角色：

1. 把抖音/TikTok/Bilibili 的公开视频链接转成结构化 JSON。
2. 为后续技能提供稳定的统一入口，例如素材卡、竞品拆解、评论痛点提取。
3. 在需要时补一层受控下载能力，但默认仍以元数据解析优先。

不建议的角色：

- 长时间依赖公共 demo。
- 无边界批量抓取。
- 在仓库、日志、文档里保存 Cookie。

## 代码级核对后的关键事实

本轮基于 `app/main.py`、`app/api/router.py` 和各端点文件核对到：

- FastAPI 文档地址来自 `config.yaml`，默认是 `/docs`。
- 所有 API 都通过 `app.include_router(api_router, prefix="/api")` 挂到 `/api` 前缀下。
- 默认监听地址来自 `config.yaml`：`Host_IP=0.0.0.0`、`Host_Port=80`。
- 下载接口是否可用取决于 `API.Download_Switch`，当前本地配置为 `true`。
- 下载文件默认落到 `API.Download_Path`，当前本地配置为 `./download`。
- 下载文件名前缀来自 `API.Download_File_Prefix`，当前本地配置为 `douyin.wtf_`。

## 最小启动方式

### 方式 A：本地 Python

```powershell
cd C:\Users\Administrator\Documents\技能和插件学习\external-skills\Douyin_TikTok_Download_API
python -m venv .venv
.\.venv\Scripts\python -m pip install -r requirements.txt
.\.venv\Scripts\python start.py
```

默认访问：

- API 文档：`http://127.0.0.1/docs`
- API 前缀：`http://127.0.0.1/api`

如果端口 `80` 被占用：

- 把 `config.yaml` 里的 `API.Host_Port` 改为 `8000`
- 然后通过 `http://127.0.0.1:8000/docs` 和 `http://127.0.0.1:8000/api` 访问

### 方式 B：Docker

仓库提供 `docker-compose.yml`。但本仓库的 Codex 接入笔记默认按“本地 Python 启动”写法维护，因为最利于脚本联调和排障。

## 推荐的最小调用面

### 1. 统一视频解析

```text
GET /api/hybrid/video_data?url=<share-url>&minimal=true
```

用途：

- 输入用户给出的分享链接或分享文本。
- 快速拿到平台、视频基础元数据和后续可追踪字段。

适用场景：

- 素材归档
- 链接健康检查
- 短视频拆解前的最小解析

### 2. 抖音路由

```text
GET /api/douyin/web/get_aweme_id?url=<share-or-video-url>
GET /api/douyin/web/get_sec_user_id?url=<user-url>
GET /api/douyin/web/fetch_one_video?aweme_id=<id>
GET /api/douyin/web/fetch_user_post_videos?sec_user_id=<id>&max_cursor=0&count=20
GET /api/douyin/web/fetch_video_comments?aweme_id=<id>&cursor=0&count=20
```

代码核对结论：

- `fetch_user_post_videos` 实际参数名是 `max_cursor`，不是 README 中常见的简写示例。
- `get_aweme_id` 和 `get_sec_user_id` 都在当前本地副本里存在，可以先做 ID 提取，再走细分接口。

### 3. TikTok 路由

```text
GET /api/tiktok/web/fetch_one_video?itemId=<id>
GET /api/tiktok/web/fetch_user_profile?uniqueId=<name>
GET /api/tiktok/web/fetch_user_post?secUid=<id>&cursor=0&count=35&coverFormat=2
GET /api/tiktok/web/fetch_post_comment?aweme_id=<id>&cursor=0&count=20
```

代码核对结论：

- 当前代码里 TikTok 路由参数采用 `itemId`、`secUid`、`uniqueId` 这组命名。
- 因此在 Codex 工具链里，不要把抖音的 `sec_user_id` 直接套到 TikTok 路由上。

### 4. 下载路由

```text
GET /api/download?url=<share-url>&prefix=true&with_watermark=false
```

代码核对结论：

- 下载路由不带额外子前缀，最终路径就是 `/api/download`。
- 是否允许下载由 `config.yaml` 的 `API.Download_Switch` 决定。
- 下载输出目录和命名前缀都受配置项控制。
- 更适合本地可信环境调用，不建议对公网暴露。

### 5. Cookie 更新路由

```text
POST /api/hybrid/update_cookie
Body: {"service":"douyin","cookie":"..."}
```

代码核对结论：

- 当前本地副本里，`douyin` 的更新逻辑已实现。
- `tiktok` 和 `bilibili` 当前返回的是“会更新但尚未实现”的占位响应。
- 因此文档里不要把它们写成完整可用能力。

## `tools/douyin-api-smoke.ps1` 的正确用法

脚本路径：`tools/douyin-api-smoke.ps1`

默认行为：

- 若未传 `-ApiBase` 且未设置 `DOUYIN_API_BASE`：
  - 本地模式默认请求 `http://127.0.0.1:80`
  - `-UsePublicDemo` 模式默认请求 `https://api.douyin.wtf`
- 请求接口固定为：`/api/hybrid/video_data?url=...&minimal=true`

推荐命令：

```powershell
.\tools\douyin-api-smoke.ps1 -Url "https://v.douyin.com/xxxx/"
```

如果本地 API 跑在 `8000` 端口：

```powershell
$env:DOUYIN_API_BASE = "http://127.0.0.1:8000"
.\tools\douyin-api-smoke.ps1 -Url "https://v.douyin.com/xxxx/"
```

如果只想临时试公共 demo：

```powershell
.\tools\douyin-api-smoke.ps1 -UsePublicDemo -Url "https://v.douyin.com/xxxx/"
```

返回预期：

- 成功时输出接口 JSON。
- 失败时输出错误，并附带服务端返回的明细（若有）。

推荐使用边界：

- 用它做连通性检查、最小解析验证。
- 不要把它当批量采集器。
- 不要在命令历史里拼接敏感 Cookie。

## 适合封装成 Codex 技能的标准流程

触发词：

- 抖音链接解析
- TikTok 链接解析
- 公开短视频素材卡
- 短视频评论痛点提取

输入：

- 一条或多条用户明确提供的公开视频链接
- 可选：`DOUYIN_API_BASE`
- 可选：本地环境里已配置的 Cookie

步骤：

1. 先调用 `/api/hybrid/video_data` 做统一最小解析。
2. 根据平台和任务决定是否继续提取 `aweme_id`、`sec_user_id`、`itemId`、`secUid`。
3. 仅在确有需求时再拉评论、作者主页作品或下载媒体。
4. 把结果归一为统一结构：平台、标题、作者、发布时间、互动、封面、媒体链接、原始 JSON 路径。
5. 对失败项明确标记原因：无凭据、Cookie 失效、风控、链接不可访问、接口字段变化。

输出：

- 一份短摘要
- 原始响应保存路径
- 下一步可用字段
- 风险说明

## 对当前仓库最有价值的衍生用法

### 1. 公开视频素材卡生成器

输入链接，输出：

- 标题
- 作者
- 发布时间
- 评论关键词
- 可复刻镜头/卖点备注

### 2. 竞品视频拆解前置层

先用该 API 做字段归一，再交给其他技能做脚本拆解、评论聚类、卖点提取。

### 3. 发布包素材准备器

只保留元数据与封面信息，不默认下载大文件，减少版权和存储风险。

## 风险边界

- 抖音端解析能力受 Cookie 和风控影响较大。
- 公共 demo 站不适合作为长期自动化依赖。
- 接口命名和字段可能随 upstream 变动；写集成前应优先对照当前本地代码或 `/docs`。
- `update_cookie` 目前只有 `douyin` 分支真正实现，不应对 `tiktok`/`bilibili` 做可用性承诺。
- 不要把 Cookie 写进 `config.yaml` 后提交到 Git。
- 下载或转载内容前必须确认授权与平台规则。

## 本轮结论

- 这个项目最适合被 Codex 当作“受控 API 中转层”。
- 最稳的入口仍然是 `/api/hybrid/video_data`。
- 文档和脚本说明必须以代码路由为准，尤其要区分抖音与 TikTok 的参数命名。
