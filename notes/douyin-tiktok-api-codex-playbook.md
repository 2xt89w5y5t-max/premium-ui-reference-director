# Douyin/TikTok Download API - Codex 可复用笔记

## 来源

- 仓库：<https://github.com/Evil0ctal/Douyin_TikTok_Download_API>
- 本地副本：`external-skills/Douyin_TikTok_Download_API`
- 许可证：Apache-2.0

## 这个仓库适合做什么

它是一个基于 FastAPI、HTTPX、PyWebIO 的抖音、TikTok、Bilibili 数据解析和下载服务。适合接入 Codex 工具链做三类任务：

1. 给定抖音/TikTok 分享链接，解析视频基础数据、作者、标题、封面和媒体地址。
2. 给定用户、作品、评论、直播间等 ID，拉取公开接口数据。
3. 搭建一个本地 API 中转层，让其他自动化项目只调用统一 HTTP 接口。

不要把它当成万能稳定爬虫。抖音端会受 Cookie、风控、接口变动影响；演示站也明确不保证长期可用。

## Codex 使用原则

1. 优先使用本地自部署 API，而不是压测公共 demo。
2. 不在 prompt、脚本、仓库、日志里写 Cookie。
3. Cookie 只从本机环境变量或本地未提交配置读取。
4. 只处理用户提供的链接或公开页面，不绕登录、不批量采集、不碰私密收藏。
5. 失败时输出「未验证/无法访问/需要 Cookie」，不要编造解析结果。

## 最小部署路径

### 方式 A：直接 Python 运行

```powershell
cd C:\Users\Administrator\Documents\技能和插件学习\external-skills\Douyin_TikTok_Download_API
python -m venv .venv
.\.venv\Scripts\python -m pip install -r requirements.txt
.\.venv\Scripts\python start.py
```

默认配置在 `config.yaml`：

- `API.Host_IP`: `0.0.0.0`
- `API.Host_Port`: `80`
- API 文档：`/docs`
- 所有 API 路由前缀：`/api`

如果 80 端口被占用，先把 `config.yaml` 里的 `Host_Port` 改成 `8000`。

### 方式 B：Docker

仓库提供 `docker-compose.yml`，镜像为 `evil0ctal/douyin_tiktok_download_api`。它默认使用 `network_mode: host`，Windows Docker Desktop 上可能需要按实际网络模式调整。

## 最常用接口

统一解析单个视频：

```text
GET /api/hybrid/video_data?url=<share-url>&minimal=true
```

抖音细分接口：

```text
GET /api/douyin/web/fetch_one_video?aweme_id=<id>
GET /api/douyin/web/fetch_user_post_videos?sec_user_id=<id>&count=20
GET /api/douyin/web/fetch_video_comments?aweme_id=<id>&cursor=0&count=20
GET /api/douyin/web/get_aweme_id?url=<share-url>
GET /api/douyin/web/get_sec_user_id?url=<user-url>
```

TikTok 细分接口：

```text
GET /api/tiktok/web/fetch_one_video?item_id=<id>
GET /api/tiktok/web/fetch_user_post?sec_user_id=<id>&count=35
GET /api/tiktok/web/fetch_post_comment?aweme_id=<id>&cursor=0&count=20
```

下载接口：

```text
GET /api/download?url=<share-url>
```

更新 Cookie：

```text
POST /api/hybrid/update_cookie
Body: {"service":"douyin","cookie":"..."}
```

注意：更新 Cookie 的接口只适合本地可信网络使用，不要暴露到公网。

## 本地工具链接入方式

新增脚本：

```powershell
.\tools\douyin-api-smoke.ps1 -Url "https://v.douyin.com/xxxx/"
```

可选环境变量：

```powershell
$env:DOUYIN_API_BASE = "http://127.0.0.1:8000"
```

如果只想临时试公共 API：

```powershell
.\tools\douyin-api-smoke.ps1 -UsePublicDemo -Url "https://v.douyin.com/xxxx/"
```

公共 demo 不保证可用，只能做临时验证。

## 可封装成 Codex 技能的流程

触发词：

- 抖音链接解析
- TikTok 链接解析
- 无水印视频元数据
- 作者作品列表
- 评论/直播间/商品信息分析

输入：

- 一个或多个用户提供的分享链接
- 可选：`DOUYIN_API_BASE`
- 可选：本机已配置 Cookie

步骤：

1. 先检查链接平台：抖音短链、抖音网页链接、TikTok 链接。
2. 调用 `/api/hybrid/video_data` 做最小解析。
3. 如果需要更多信息，再按平台调用细分接口。
4. 把返回 JSON 归一化为：标题、作者、发布时间、互动数、封面、媒体 URL、原始数据路径。
5. 对失败项标记原因：接口 400、Cookie 失效、风控、链接不可访问。

输出：

- 简短摘要
- 原始 JSON 保存路径
- 可继续分析的字段
- 风险说明

## 落地项目建议

### 1. 内容素材归档器

把抖音/TikTok 链接解析成结构化素材卡：标题、作者、标签、封面、视频地址、发布时间、互动数据。适合接到 `market-demand-radar` 或 AI 电商素材库。

### 2. 竞品短视频拆解器

输入 10 个竞品视频链接，输出脚本结构、卖点、镜头节奏、评论痛点。需要注意只分析公开内容，不做批量抓取。

### 3. 电商视频素材预处理器

对用户授权的商品视频做下载、抽帧、转写、卖点提取，再交给 Agnes/视频生成流程做二创提示词。

### 4. 趋势种子收集器

只保存轻量元数据，不保存大文件；按关键词/作者手工提供链接，避免无边界爬取。

## 风险点

- 抖音 Cookie 失效会导致解析失败。
- 公共 demo 关闭下载功能，不适合作为生产依赖。
- 接口参数会随平台调整变化，先读 `/docs` 再写集成。
- 不要把 Cookie 写入 `config.yaml` 后提交。
- 下载/转载内容需要确认授权和平台规则。
