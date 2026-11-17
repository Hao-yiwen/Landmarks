# Landmarks

[![Swift](https://img.shields.io/badge/Swift-5-F05138?logo=swift&logoColor=white)](https://www.swift.org)
[![Xcode](https://img.shields.io/badge/Xcode-15%2B-1575F9?logo=xcode&logoColor=white)](https://developer.apple.com/xcode/)
[![Platforms](https://img.shields.io/badge/platforms-iOS%2017%20%7C%20macOS%2014-blue)](Landmarks.xcodeproj)

跟着 Apple [SwiftUI 教程](https://developer.apple.com/tutorials/swiftui) 做的地标浏览学习项目。用本地 JSON 和 Asset Catalog 里的图片，展示景点列表、分类、地图和自定义绘制。工程里有 **iOS** 与 **macOS** 两个可运行的 App，没有后端、没有第三方依赖。

## 功能

界面文案以英文为主（`Featured`、`List`、`Favorites only` 等）。数据写在 `Landmarks/Resources/`，启动时由 `ModelData.load` 从主 Bundle 读入。

### iOS：`Landmarks`

`Landmarks/LandmarksApp.swift` 注入 `ModelData`，根界面是两个标签页。

| 标签 | 入口 | 实际行为 |
| --- | --- | --- |
| Featured | `CategoryHome` | 顶部轮播精选景点（`PageView` + `UIPageViewController` / `UIPageControl`），下面按类别横向滚动。右上角打开个人资料。 |
| List | `LandmarkList` | 「仅收藏」开关、按 Lakes / Rivers / Mountains 筛选，点进详情。 |

详情页（`Landmarks/Views/Landmarks/LandmarkDetail.swift`）包含 MapKit 地图、圆形头图、名称、公园、州、简介，以及收藏星标。收藏状态改在内存里的 `landmarks` 数组上，不会写回 JSON。

个人资料（`ProfileHost`）可编辑用户名、通知开关、季节配图、目标日期。摘要页展示三枚手绘徽章（First Hike、Earth Day、Tenth Hike）和第一条徒步记录的可展开图表（海拔 / 心率 / 配速）。默认用户名是 `g_kumar`。

### macOS：`MacLandmarks`

同一份 `LandmarksApp` 作为入口，窗口内容换成 `MacLandmarks/ContentView.swift`：一个最小约 700×300 的 `LandmarkList`。列表与行视图复用 iOS 源文件；详情用 `MacLandmarks/LandmarkDetail.swift`，地图右上角有 **Open in Maps**。该详情里的收藏按钮处于注释状态。

菜单栏有 **Landmark** 命令（`LandmarkCommands`）：`⇧⌥F` 在「Mark as Favorite」和「Remove as Favorite」之间切换。命令通过 `FocusedBinding(\.selectedLandmark)` 读写当前景点，而 `LandmarkList` 只做了 `List(selection:)`，没有设置 `focusedValue`，因此这项菜单在当前代码里会保持禁用。

macOS target 会编译模型、列表、地图和这条命令，不会编译分类首页、个人资料、徽章、徒步图和 UIKit 翻页控件。`hikeData.json` 仍会打进 Bundle，因为 `ModelData` 在初始化时就会加载它。

### 已编译、未挂到主界面的代码

- `Landmarks/Views/PageView/TabView.swift` 里的 `TabViewContainer` 是五行分页预览（文案为「页面 1」…「页面 5」），主流程没有引用它。
- `Landmarks/Views/Landmarks/LandmarkRow.swift` 用 `#if !os(watchOS)` 包了一行公园名。工程里没有 watchOS target；iOS target 有一个空的 **Embed Watch Content** 拷贝阶段。`xcuserdata` 里留有 `WatchLandmarks` 的 scheme 记录，仓库中没有对应源码。

### 测试

`LandmarksTests` 与 `LandmarksUITests` 仍是 Xcode 15 生成的模板：`testExample`、`testPerformanceExample`、启动截图测试，没有针对地标数据或界面的断言。两个测试 target 都挂在 iOS 的 `Landmarks` 上。

## 技术栈

工程由 Xcode 15 创建（`LastUpgradeCheck = 1500`，`CreatedOnToolsVersion = 15.0`）。`SWIFT_VERSION` 为 5.0（Swift 5 语言模式）。代码使用了 `@Observable`，需要 Xcode 15 及以上自带的 Swift 工具链。没有 Swift Package、CocoaPods 或 Carthage。

| 项目 | 取值 |
| --- | --- |
| UI | SwiftUI；iOS 翻页控件通过 `UIViewControllerRepresentable` / `UIViewRepresentable` 接 UIKit |
| 地图 | MapKit（`Map`；macOS 详情另用 `MKMapItem.openInMaps()`） |
| 数据 | `JSONDecoder` 解码 Bundle 内 JSON；`Observation` 的 `@Observable` |
| 绘制 | SwiftUI `Shape` / `GeometryReader` 画六边形徽章与徒步曲线 |
| iOS target | `Landmarks`，Bundle ID `com.yiwen.Landmarks`，部署目标 iOS 17.0，设备家族 iPhone + iPad（`TARGETED_DEVICE_FAMILY = 1,2`），版本 1.0 (1) |
| macOS target | `MacLandmarks`，Bundle ID `com.yiwen.MacLandmarks`，部署目标 macOS 14.0，开启 App Sandbox 与 Hardened Runtime，版本 1.0 (1) |
| 签名 | Automatic，工程内 `DEVELOPMENT_TEAM = 84F8R9TAQN` |

## 目录结构

```text
.
├── Landmarks.xcodeproj          # 四个 target：Landmarks、LandmarksTests、LandmarksUITests、MacLandmarks
├── Landmarks/                   # iOS App
│   ├── LandmarksApp.swift       # @main，注入 ModelData，挂上 Landmark 菜单
│   ├── Model/                   # Landmark、Hike、Profile、ModelData
│   ├── Resources/               # landmarkData.json、hikeData.json
│   ├── Assets.xcassets          # 12 张景点图、3 张精选横图、App Icon、AccentColor
│   ├── Helper/                  # MapView、CircleImage、FavoriteButton
│   ├── Badges/                  # 六边形徽章的路径与组合
│   └── Views/
│       ├── ContentView.swift    # Featured / List 标签
│       ├── Categories/          # 精选首页、分类行与卡片
│       ├── Landmarks/           # 列表、行、iOS 详情
│       ├── PageView/            # UIKit 翻页、精选卡片、未接入的 TabViewContainer
│       ├── Profiles/            # 资料摘要、编辑、宿主
│       └── Hikes/               # 徽章、动画展开、海拔/心率/配速图
├── MacLandmarks/                # macOS 窗口、macOS 详情、菜单命令、独立图标与 entitlements
├── LandmarksTests/              # 模板单元测试
└── LandmarksUITests/            # 模板 UI 测试与启动截图测试
```

仓库没有提交共享的 `.xcscheme`。用 Xcode 打开工程后，会按现有 target 自动生成 scheme。

## 示例数据

`landmarkData.json` 共 **12** 条：Lakes 6、Rivers 3、Mountains 3。`isFeatured == true` 的 3 条会出现在首页轮播，并使用 `*_feature` 图片：

| 景点 | 类别 | 地点 |
| --- | --- | --- |
| Turtle Rock | Rivers | Joshua Tree National Park，California |
| St. Mary Lake | Lakes | Glacier National Park，Montana |
| Charley Rivers | Rivers | Charley Rivers National Preserve，Alaska |

其余条目：Silver Salmon Creek、Chilkoot Trail、Twin Lake、Lake McDonald、Icy Bay、Rainbow Lake、Hidden Lake、Chincoteague、Lake Umbagog。

`hikeData.json` 共 **10** 条，名称都是 Lonesome Ridge Trail，每条 12 个采样点（距离、海拔、配速、心率）。个人资料页只渲染 `hikes[0]`。JSON 里的 `city` 字段模型没有对应属性，解码时会被忽略。

景点照片在 `Landmarks/Assets.xcassets`，由 `Image(imageName)` 加载。仓库里没有应用运行截图。部分徒步视图文件头写着 “See LICENSE folder”，仓库中没有 LICENSE 文件。

## 环境要求

- macOS，并安装 **Xcode 15 或更高版本**（含 iOS 17 与 macOS 14 SDK）
- 运行 iOS 版需要 iOS 17+ 模拟器或真机；运行 Mac 版需要 macOS 14+
- 换一台没有团队 `84F8R9TAQN` 的电脑时，在 Signing & Capabilities 里改成自己的 Team，否则自动签名会失败

本仓库在 Linux 上无法编译。下面的命令需要在装有 Xcode 的 Mac 上执行。

## 运行

用 Xcode 打开工程，在 scheme 栏选择 target，再选模拟器或 My Mac：

```bash
open Landmarks.xcodeproj
```

- **Landmarks**：任意 iOS 17+ 模拟器（例如 iPhone），或已签名的真机。
- **MacLandmarks**：My Mac。

命令行构建（不依赖未入库的共享 scheme，直接指定 target）。iOS 使用通用模拟器目的地，避免写死某台机器上的模拟器名称：

```bash
xcodebuild \
  -project Landmarks.xcodeproj \
  -target Landmarks \
  -sdk iphonesimulator \
  -destination 'generic/platform=iOS Simulator' \
  build
```

```bash
xcodebuild \
  -project Landmarks.xcodeproj \
  -target MacLandmarks \
  -sdk macosx \
  -destination 'platform=macOS' \
  build
```

Xcode 自动创建 scheme 之后，可以在模拟器里启动 iOS App（把 `iPhone 16` 换成 `xcrun simctl list devices available` 里实际存在的名称）：

```bash
xcodebuild \
  -project Landmarks.xcodeproj \
  -scheme Landmarks \
  -destination 'platform=iOS Simulator,name=iPhone 16' \
  build
```

模板测试同样在 scheme 可用后执行：

```bash
xcodebuild \
  -project Landmarks.xcodeproj \
  -scheme Landmarks \
  -destination 'platform=iOS Simulator,name=iPhone 16' \
  test
```

### 已核对与未验证

- 已核对：`landmarkData.json` 12 条、其中精选 3 条；`hikeData.json` 10 条。分类计数与上面的表格一致。
- 未验证：当前环境是 Linux，没有 `xcodebuild` 和 Swift 工具链，上面的构建、运行和测试命令没有实际执行。

## 参考

- [Apple SwiftUI Tutorials](https://developer.apple.com/tutorials/swiftui)（本仓库的 Landmarks 教程来源：列表、详情、绘制、动画、组合视图，以及与 UIKit 的衔接）
- 提交记录里，macOS target 与 UIKit 翻页是在教程内容之上另加的（`feat: 兼容macos`、`feat: interfacing with uikit`）
