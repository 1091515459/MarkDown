```cpp
let cmd = UE4.World.GetFirstPlayerController();//UnrealCLR::Engine::World->GetFirstPlayerController();
cmd.ConsoleCommand('DisableAllScreenMessages');//DisableAllScreenMessages/EnableAllScreenMessages 关闭/打开屏幕打印信息息

cmd.ConsoleCommand('r.ScreenPercentage 50');//0-200 这个代码是缩小渲染分辨率的。可以提升帧率。
cmd.ConsoleCommand('r.DistanceFieldAO 1');//距离场 0 关 1 开
cmd.ConsoleCommand('r.TonemapperFilm');//开关后处理效果

cmd.ConsoleCommand("stat fps");//开启fps显示
cmd.ConsoleCommand("stat unit");//显示包括Draw Call ，游戏逻辑等各种项的消耗
cmd.ConsoleCommand("stat UnitGraph");//显示各个参数的实时曲线图
cmd.ConsoleCommand("stat rhi");//显示各种GPU上的消耗细则
cmd.ConsoleCommand("stat game");//显示当前帧的时间信息
cmd.ConsoleCommand("stat Engine");//显示帧数时间，三角面数等
cmd.ConsoleCommand("stat scenerendering");//显示Drawcall
cmd.ConsoleCommand("ShowFlag.Bounds 0");//显示包围盒 0 关 1 开
cmd.ConsoleCommand("ShowFlag.Collision 0");//显示碰撞盒 0 关 1 开
cmd.ConsoleCommand("r.visualizeOccludedPrimitives 0");//查看遮挡剔除 0 关 1 开
cmd.ConsoleCommand("HighResShot 3840x2160");//指定分辨率截图（分辨率）[图片存储位置：\Saved\Screenshots\]
cmd.ConsoleCommand("stat startfile");//stat startfile / stat stopfile 开始/结束统计性能分析  ，用于记录某段时间内的性能分析数据。[此时会在路径 Saved/Profiling/UnrealStats 下生成数据文件]

cmd.ConsoleCommand("slomo");//游戏运行速度（运行速度）
```


