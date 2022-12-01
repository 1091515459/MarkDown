## 创建自定义模块
这篇文章是用 4.27 版本的引擎编写的。根据您阅读本文的时间，这些信息可能已经过时。

为了创建一个模块，我们必须做以下事情：

修改项目的 .uproject 文件以包含新模块
创建一个包含其他依赖项并包含私有和公共包含路径的模块构建文件
在我们的模块中创建至少一个类

在进一步移动之前，请确保关闭您当前正在编辑的项目。那么，让我们开始吧！

## 修改 .uproject 文件
要修改 .uproject 文件，请右键单击它并使用您选择的文本编辑器将其打开。

默认情况下，您的文件将包含至少一个与 UE4 项目同名的模块。在模块的结束括号后添加一个逗号，然后添加您的模块。在我的例子中，我添加了一个名为 OrfeasModule 的运行时模块。这是完整的 .uproject 文件：

```cpp
{
	"FileVersion": 3,
	"EngineAssociation": "4.27",
	"Category": "",
	"Description": "",
	"Modules": [
		{
			"Name": "GDBlogPost",
			"Type": "Runtime",
			"LoadingPhase": "Default"
		},
		{
			"Name": "OrfeasModule",
			"Type": "Runtime",
			"LoadingPhase": "Default"
		}
	]
}
```

保存您的文件，让我们创建模块构建文件。

## 创建模块构建文件
在项目的 Source 文件夹中导航并创建一个与插件同名的新文件夹（在我的例子中，这将是 OrfeasModule）。然后，在该文件夹中添加：

一个名为 Public 的文件夹（这将包含您要添加的类的头文件）
一个名为 Private 的文件夹（这将包含您要添加的类的源文件）
具有以下名称的新 .cs 文件 [YourModuleName].Build.cs（在我的情况下，这将是 OrfeasModule.Build.cs）
这是到目前为止我的文件夹结构的屏幕截图：

![在这里插入图片描述](https://img-blog.csdnimg.cn/34c164d254b446d48ebd57df18ff0d39.png)


打开 .cs 文件并添加以下代码：


```cpp
//------------------ 4.27 VERSION
using UnrealBuildTool;
 
public class OrfeasModule : ModuleRules
{
	public OrfeasModule(ReadOnlyTargetRules Target) : base(Target)
	{
        PCHUsage = PCHUsageMode.UseExplicitOrSharedPCHs;
 
		//Public module names that this module uses.
		//In case you would like to add various classes that you're going to use in your game
		//you should add the core,coreuobject and engine dependencies.
		PublicDependencyModuleNames.AddRange(new string[] { "Core", "CoreUObject", "Engine","GDBlogPost"});
 
		//The path for the header files
		PublicIncludePaths.AddRange(new string[] {"OrfeasModule/Public"});
 
		//The path for the source files
		PrivateIncludePaths.AddRange(new string[] {"OrfeasModule/Private"});
	}
}
```

根据您的需要，您可能需要稍后向您的模块添加更多依赖项。此外，在 4.27 版本中，您可能需要删除 Binaries 和 Intermediate 文件夹，删除VS文件（.sln）并从 .uproject 文件重新生成 VS 文件。

创建模块类
我们需要做的最后一件事是添加一个新类来处理我们模块的启动和关闭。（再次）打开您选择的文本编辑器并添加以下代码：


```cpp
#pragma once

#include "ModuleManager.h"

DECLARE_LOG_CATEGORY_EXTERN(OrfeasModule, All, All);

class FOrfeasModule : public IModuleInterface
{
	public:

	/* This will get called when the editor loads the module */
	virtual void StartupModule() override;

	/* This will get called when the editor unloads the module */
	virtual void ShutdownModule() override;
};
```

这是我们类的头文件。将它保存在我们之前添加的与您的模块同名的公共文件夹中（在我的例子中，这是 OrfeasModule.h）。

然后，使用您的文本编辑器创建以下文件并将其保存在我们之前添加的 Private 文件夹中：


```cpp
#include "OrfeasModule.h"
 
DEFINE_LOG_CATEGORY(OrfeasModule);
 
#define LOCTEXT_NAMESPACE "FOrfeasModule"
 
void FOrfeasModule::StartupModule()
{
	UE_LOG(OrfeasModule, Warning, TEXT("Orfeas module has started!"));
}
 
void FOrfeasModule::ShutdownModule()
{
	UE_LOG(OrfeasModule, Warning, TEXT("Orfeas module has shut down"));
}
 
#undef LOCTEXT_NAMESPACE
 
IMPLEMENT_MODULE(FOrfeasModule,OrfeasModule)
```
最后在两个.Target.cs文件中添加模块名
![在这里插入图片描述](https://img-blog.csdnimg.cn/45ed3fbd8d8b480eb89d8a077aef0042.png)

然后，再次转到您的 .uproject 文件并选择生成项目文件。打开编辑器后，您的模块将被加载。如果您尝试使用类向导添加新的 c++ 类，您可以选择将您的类存储在新创建的模块中：
![在这里插入图片描述](https://img-blog.csdnimg.cn/5584c2cdcce2423aad19bacd43afb329.png)



 
