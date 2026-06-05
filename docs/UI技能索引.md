# UI 技能索引

这是当前整理出来的高质量 UI 设计技能路由表，优先级按“最能直接产出可用 UI”排序。

## 第一梯队

### `github-primer-ui-designer`
- 作用：GitHub / Primer 风格的产品 UI、后台、仪表盘、列表页、设置页
- 适用：网页、SaaS、运营台、开发者工具
- 关键词：`GitHub 风格`、`Primer`、`后台`、`仪表盘`、`产品界面`

### `frontend-ui-engineering`
- 作用：生产级前端 UI 实现
- 适用：需要真正写代码、做组件、改布局、修交互和状态
- 关键词：`实现页面`、`生产级`、`组件`、`响应式`、`UX 修正`

### `figma-use`
- 作用：直接操作 Figma 文件里的节点、变量、组件
- 适用：改 Figma、建组件、绑变量、查结构
- 关键词：`Figma 写入`、`改设计稿`、`组件/变量`、`Figma 自动化`

### `figma-generate-design`
- 作用：从代码或描述生成完整 Figma 页面
- 适用：做整屏、整页、分区布局
- 关键词：`生成 Figma`、`页面`、`屏幕`、`设计系统`

### `figma-implement-design`
- 作用：把 Figma 设计翻成生产代码
- 适用：按设计稿 1:1 落地到项目
- 关键词：`按 Figma 实现`、`像素级还原`、`设计转代码`

## 第二梯队

### `figma-create-design-system-rules`
- 作用：为项目沉淀设计系统规则
- 适用：要把 UI 规范写进 AGENTS/CLAUDE 或团队规则

### `figma-create-new-file`
- 作用：新建 Figma 文件和结构化画布
- 适用：从零搭 Figma 设计文件

### `figma-code-connect-components`
- 作用：做设计系统和代码组件映射
- 适用：设计系统对齐代码库

### `playwright`
- 作用：浏览器里验 UI、截图、走流程
- 适用：需要真实页面验证、看布局问题、做交互检查

### `screenshot`
- 作用：快速抓图做视觉审查
- 适用：UI 对比、布局检查、问题定位

### `browser-testing-with-devtools`
- 作用：更细的前端调试和 UI 观察
- 适用：复杂页面、样式问题、交互排查

## 辅助技能

### `product-design:get-context`
- 作用：收集产品、设计、品牌上下文
- 适用：先把项目背景和参考源整理清楚

### `product-design:ideate`
- 作用：做产品方向和 UI 方向探索
- 适用：需要多方案、创意方向、页面架构

### `product-design:image-to-code`
- 作用：从视觉图转成实现思路或代码
- 适用：截图/参考图驱动的 UI 还原

### `data-analytics:build-dashboard`
- 作用：做数据仪表盘和分析型 UI
- 适用：指标面板、图表、报告页

### `build-web-apps:react-best-practices`
- 作用：React 前端实现规范
- 适用：需要稳妥的 React 组件和架构

### `build-web-apps:shadcn`
- 作用：shadcn/ui 风格组件实现
- 适用：现代产品 UI、快速搭界面

### `build-web-apps:frontend-app-builder`
- 作用：通用 Web 应用构建
- 适用：从零到一做完整前端应用

## 我会优先自动使用的组合

1. `github-primer-ui-designer` + `frontend-ui-engineering`
2. `figma-use` + `figma-generate-design`
3. `figma-implement-design` + `playwright`
4. `product-design:get-context` + `product-design:ideate`

## 当前结论

对你这种“做网页、做软件、希望 UI 能自动调用”的场景，最实用的是：

- 视觉体系：`github-primer-ui-designer`
- 实现体系：`frontend-ui-engineering`
- Figma 体系：`figma-use` / `figma-generate-design` / `figma-implement-design`
- 验证体系：`playwright` / `screenshot`

