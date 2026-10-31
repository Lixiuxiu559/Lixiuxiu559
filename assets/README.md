# 个人主页素材

主页保留柔和配色、终端与机器人插画。中英文 README 使用各自语言的头图和项目卡片。

| 素材 | 中文 | English |
|---|---|---|
| 6 秒循环头图 | [hello.zh-CN.gif](hello.zh-CN.gif) | [hello.en.gif](hello.en.gif) |
| 静态头图 | [hello.zh-CN.png](hello.zh-CN.png) | [hello.en.png](hello.en.png) |
| 项目卡片 | `*.zh-CN.svg` | `portunus.svg`、`agentforge.svg`、`ssh-mcp.svg`、`db-mcp.svg` |

动画仅包含机器人轻微浮动、眨眼、终端光标闪动和贴纸浮动。SVG 源文件不包含脚本或动画；发布的 GIF 可直接在 GitHub README 显示，不依赖第三方动态图服务。读者也可以打开静态版。

头图源文件为 [hello.svg](hello.svg)，动画逻辑与中文文案在 [render-hero.swift](../scripts/render-hero.swift)。在 macOS 仓库根运行以下命令，可同时生成两套头图（需要 Xcode Command Line Tools，无第三方依赖）：

```bash
swift -module-cache-path /tmp/profile-swift-cache scripts/render-hero.swift
```

中文项目卡片为独立 SVG，修改项目名称或描述时同步两套对应卡片，并检查中英文 README。
