### 插件创建部分我就不说了直接上图
![在这里插入图片描述](https://img-blog.csdnimg.cn/fd3971e7cd5f428d83f0a787cfb98c38.png)
### 接下来是代码部分
#### Tool.app部分

```cpp
#include "EditorAssetLibrary.h"
#include "Blutility/Classes/EditorUtilityWidget.h"
#include "UMGEditor/Public/WidgetBlueprint.h"
#include "EditorUtilityWidgetBlueprint.h"
#include "EditorUtilitySubsystem.h"
void FToolModule::StartupModule()
{
	// This code will execute after your module is loaded into memory; the exact timing is specified in the .uplugin file per-module

	FToolStyle::Initialize();
	FToolStyle::ReloadTextures();

	FToolCommands::Register();

	PluginCommands = MakeShareable(new FUICommandList);

	PluginCommands->MapAction(
		FToolCommands::Get().OpenPluginWindow,
		FExecuteAction::CreateRaw(this, &FToolModule::StartToolWidget),
		FCanExecuteAction());

	UToolMenus::RegisterStartupCallback(
		FSimpleMulticastDelegate::FDelegate::CreateRaw(this, &FToolModule::RegisterMenus));

	FGlobalTabmanager::Get()->RegisterNomadTabSpawner(ToolTabName,
	                                                  FOnSpawnTab::CreateRaw(this, &FToolModule::OnSpawnPluginTab))
	                        .SetDisplayName(LOCTEXT("FToolTabTitle", "Tool"))
	                        .SetMenuType(ETabSpawnerMenuType::Hidden);
}
//注释掉不用的方法
// void FToolModule::PluginButtonClicked()
// {
// 	FGlobalTabmanager::Get()->TryInvokeTab(ToolTabName);
// }

```

```cpp
void FToolModule::RegisterMenus()
{
	// Owner will be used for cleanup in call to UToolMenus::UnregisterOwner
	FToolMenuOwnerScoped OwnerScoped(this);
	FLevelEditorModule& LevelEditorModule = FModuleManager::LoadModuleChecked<FLevelEditorModule>("LevelEditor");
	TSharedPtr<FExtender> ToolbarExtender = MakeShareable(new FExtender);
	ToolbarExtender->AddToolBarExtension("Settings", EExtensionHook::After, PluginCommands, FToolBarExtensionDelegate::CreateRaw(this, &FToolModule::AddToolbarExtension));
	LevelEditorModule.GetToolBarExtensibilityManager()->AddExtender(ToolbarExtender);
}
```

```cpp
void FToolModule::AddToolbarExtension(FToolBarBuilder& Builder)
{
	Builder.AddComboButton(
		FUIAction(),
		FOnGetContent::CreateRaw(this, &FToolModule::GetComboConent),
		FText::FromString("Tool"),
		FText::FromString("Context"),
		FSlateIcon(FToolStyle::GetStyleSetName(), "Tool")
	);
}

TSharedRef<SWidget> FToolModule::GetComboConent()
{
	FMenuBuilder MenuBuilder(true, PluginCommands);
	MenuBuilder.AddMenuEntry(FToolCommands::Get().OpenPluginWindow);
	return MenuBuilder.MakeWidget();
}

void FToolModule::StartToolWidget()
{
	// load blueprint ..
	FString widgetUrl = FString::Printf(TEXT("/Tool/ToolWidget"));
	FString fileName = "ToolWidget";
	UClass* uclass = UEditorAssetLibrary::LoadBlueprintClass(widgetUrl);
	UObject* uobj = UEditorAssetLibrary::LoadAsset(*widgetUrl);
	UWidgetBlueprint* Blueprint = Cast<UWidgetBlueprint>(uobj);
	if (Blueprint->GeneratedClass->IsChildOf(UEditorUtilityWidget::StaticClass()))
	{
		UEditorUtilityWidgetBlueprint* EditorWidget = Cast<UEditorUtilityWidgetBlueprint>(Blueprint);
		if (EditorWidget)
		{
			UEditorUtilitySubsystem* EditorUtilitySubsystem = GEditor->GetEditorSubsystem<UEditorUtilitySubsystem>();
			EditorUtilitySubsystem->SpawnAndRegisterTab(EditorWidget);
		}
	}
}
```
#### ToolStyle.cpp部分

```cpp
const FVector2D Icon80x40(80.0f, 40.0f);
TSharedRef< FSlateStyleSet > FToolStyle::Create()
{
	TSharedRef< FSlateStyleSet > Style = MakeShareable(new FSlateStyleSet("ToolStyle"));
	Style->SetContentRoot(IPluginManager::Get().FindPlugin("Tool")->GetBaseDir() / TEXT("Resources"));

	Style->Set("Tool", new IMAGE_BRUSH(TEXT("logo"), Icon80x40));//这里的logo是自己制作的图标
	return Style;
}
```
#### Tool.Build.cs部分

```cpp
		PrivateDependencyModuleNames.AddRange(
			new string[]
			{
				...
				"EditorScriptingUtilities", 
				"Blutility",
				"UMGEditor"
				// ... add private dependencies that you statically link with here ...	
			}
			);
```
#### 创建EditorUtilityWidget并且设置样式
![在这里插入图片描述](https://img-blog.csdnimg.cn/afb82c3a31b449eb9983baf82c4b0b85.png)

#### 最终效果
![在这里插入图片描述](https://img-blog.csdnimg.cn/e81d8b2557df46d1bc52a07be10c6567.png)


