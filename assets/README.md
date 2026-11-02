# 个人主页素材

主页保留柔和配色、终端与机器人插画。中英文 README 使用各自语言的头图和项目卡片。

| 素材 | 中文 | English |
|---|---|---|
| 6 秒循环头图 | [hello.zh-CN.gif](hello.zh-CN.gif) | [hello.en.gif](hello.en.gif) |
| 静态头图 | [hello.zh-CN.png](hello.zh-CN.png) | [hello.en.png](hello.en.png) |
| 项目卡片 | `*.zh-CN.svg` | `portunus.svg`、`agentforge.svg`、`ssh-mcp.svg`、`db-mcp.svg` |

动画仅包含机器人轻微浮动、眨眼、终端光标闪动和贴纸浮动。SVG 源文件不包含脚本或动画；发布的 GIF 可直接在 GitHub README 显示，不依赖第三方动态图服务。静态 PNG 仅作素材预览，主页不提供静态版切换入口。

头图源文件为 [hello.svg](hello.svg)，动画逻辑与中文文案在 [render-hero.swift](../scripts/render-hero.swift)。在 macOS 仓库根运行以下命令，可同时生成两套头图（需要 Xcode Command Line Tools，无第三方依赖）：

```bash
swift -module-cache-path /tmp/profile-swift-cache scripts/render-hero.swift
```

中文项目卡片为独立 SVG，修改项目名称或描述时同步两套对应卡片，并检查中英文 README。

## 项目卡片排版

项目名称、简介、能力标签、技术栈与入口提示统一放入 SVG 卡片，README 项目区仅保留整卡链接。桌面卡片为 `880 × 456`，移动卡片为 `480 × 580`；通过 `<picture>` 在屏幕宽度不超过 `600px` 时选用 `*.mobile.svg`。所有卡片均为自包含矢量素材，无外部字体、脚本或图片依赖。

更新文案时同步中英文和桌面／移动四个版本，并保留 SVG 的 `title`、`desc` 和 README 图片的 `alt`。整卡链接进入对应仓库，图内入口提示不作为独立按钮。
