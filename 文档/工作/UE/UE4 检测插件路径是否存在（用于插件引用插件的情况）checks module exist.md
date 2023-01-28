
### 获得引用的插件的目录
.Build.cs中获取路径，判断是否存在，添加宏命令
```cpp
string SVG = PluginDirectory.Substring(0, PluginDirectory.LastIndexOf("\\")) +
             "\\HelloWorld\\Source\\HelloWorld";
bool bSVG = Directory.Exists(SVG);
PublicDefinitions.Add("HELLO_WORLD=" + (bSVG ? '1' : '0'));
```

### 添加依赖
.Build.cs中
```cpp
List<string> modules = new List<string>();
modules.Add("Projects");
modules.Add("InputCore");
modules.Add("UnrealEd");
if (bSVG)
{
	modules.Add("HelloWorld");
}
string[] s = modules.ToArray();
PrivateDependencyModuleNames.AddRange(
	s
);
```

### CPP中的调用
调用HelloWorld插件的插件的cpp
```cpp
#if HELLO_WORLD
#include "HelloWorld.h"
#endif

void FToolModule::HelloWorld()
{
	// load blueprint ..
#if HELLO_WORLD
	THING::HelloWorld ::DoSomeTHing();
#else
	GEngine->AddOnScreenDebugMessage(-1, 5.f, FColor::Green, "Not Found HelloWorld Plugin");
#endif
}
```

