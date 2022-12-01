## 获取项目中所有level中的所有符合条件的material

```csharp
	TArray<FString> maps;
	TArray<UWorld*> worlds;
	TArray<UMaterialInterface*> materials;
	IFileManager::Get().FindFilesRecursive(maps, *FPaths::ProjectContentDir(), TEXT("*.umap"), true, false, false);
	for (int32 i = 0; i < maps.Num(); ++i)
	{
		int32 lastSlashIndex = -1;
		if (maps[i].FindLastChar('/', lastSlashIndex))
		{
			FString pureMapName;
			for (int32 j = lastSlashIndex + 1; j < maps[i].Len() - 5; ++j)
				pureMapName.AppendChar(maps[i][j]);
			maps[i] = pureMapName;
		}
	}
	for (auto map : maps)
	{
		UWorld* NewWorld = UEditorLoadingAndSavingUtils::LoadMap(map);
		worlds.Add(NewWorld);
	}
	for (auto world : worlds)
	{
		for (auto tag : tags)
		{
			TArray<AActor*> actors;
			UGameplayStatics::GetAllActorsOfClassWithTag(world,AStaticMeshActor::StaticClass(), FName(*tag), actors);
			for (auto actor: actors)
			{
				TArray<UMaterialInterface*> itemMaterials= Cast<AStaticMeshActor>(actor)->GetStaticMeshComponent()->GetMaterials();
				for (auto m : itemMaterials)
				{
					if (!materials.Contains(m))
					{
						materials.Add(m);
					}
				}
			}
		}
	}
```
也可以将material换成任何其他的元素
