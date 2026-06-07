# 美术素材替换指南

这份文档说明后续如何把当前占位图形替换成正式美术，同时尽量不改玩法代码。

## 当前原则

- 先替换视觉，不改核心逻辑。
- 保留已有节点名，例如 `Cushion`、`MilkBowl`、`Leaf`、`CatActor`。
- 交互节点暂时不要从 `ColorRect` 改成 `Sprite2D` 或 `TextureRect`，除非同时做“视觉节点和交互节点分离”。
- 正式素材优先使用透明背景 PNG，方便叠在 Godot 场景里。
- 文件名使用英文小写和下划线，避免路径兼容问题。

## 当前主风格参考

当前主风格以 `docs/art/style_reference_main.png` 为准。

关键词：

- 清新治愈
- 简单偏卡通
- 柔和绘本感
- 低饱和雨天蓝
- 暖黄色窗光
- 轻量水彩质感
- 不要过度写实，不要沉重悲伤

后续生成背景、小猫、坐垫、牛奶碗、落叶时，优先匹配这张图的清新度、线条复杂度和色彩明度。

## 推荐素材目录

```text
game/assets/backgrounds/
game/assets/animals/kitten/
game/assets/props/
game/assets/keepsakes/
game/assets/ui/
game/assets/audio/
```

## 第一批替换优先级

1. `shelter_rainy_night.png`
   替换收容所主场景背景。推荐 1920x1080。

2. `kitten_wet_idle.png`
   替换当前小猫占位色块。推荐透明背景，主体约 320x220。

3. `cushion_red_dry.png` 和 `milk_bowl_empty.png`
   替换坐垫和牛奶碗视觉。保留原交互区域。

4. `leaf_first_keepsake.png`
   替换落叶纪念品。推荐透明背景，主体约 160x120。

5. UI 装饰素材
   可选，例如纸片底纹、雨滴小图标、按钮纹理。

## 替换方式建议

短期最稳方式：

- 保留原来的交互节点。
- 在交互节点下面增加视觉子节点。
- 让视觉子节点显示图片，交互节点继续负责点击、拖拽、信号。

例如坐垫：

```text
Cushion                # 继续负责拖拽
  CushionArt           # 新增，负责显示正式图片
  CushionLabel         # 可删除或隐藏
```

这样即使以后换图片，拖拽逻辑也不会受影响。

当前约定的视觉子节点：

- `Cushion/CushionArt`
- `MilkBowl/MilkBowlArt`
- `Leaf/LeafArt`

这些视觉子节点必须忽略鼠标输入，避免抢走父节点的拖拽或点击事件。

## 不要轻易改的节点名

这些节点已经被脚本通过 `%NodeName` 或信号引用：

- `RainLabel`
- `PromptLabel`
- `ObjectiveLabel`
- `Cushion`
- `MilkBowl`
- `AdvanceButton`
- `TransitionTimer`
- `WeatherController`
- `CareController`
- `CatActor`
- `Leaf`
- `FinishButton`
- `BackButton`

需要改名时，先同步修改脚本和测试。

## 风格样张建议

正式美术开始前，先做一张完整样张：

```text
雨天屋檐 + 小猫 + 坐垫 + 牛奶碗 + 暖光 + 一片落叶
```

样张确认后，再拆成背景、动物、道具、纪念品等独立素材。
