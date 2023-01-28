RenderTarget2D转Texture2D（TextureFormRenderTarget2D）
=============
```C++
UTexture2D* UWebBrowserComponent::TextureFormRenderTarget2D(UTextureRenderTarget2D* RenderTexture)
{
	// Creates Texture2D to store TextureRenderTarget content
	if(RenderTexture)
	{
		UTexture2D *Texture = UTexture2D::CreateTransient(RenderTexture->SizeX, RenderTexture->SizeY, PF_B8G8R8A8);
#if WITH_EDITORONLY_DATA
		Texture->MipGenSettings = TMGS_NoMipmaps;
#endif
		Texture->SRGB = RenderTexture->SRGB;

		// Read the pixels from the RenderTarget and store them in a FColor array
		TArray<FColor> SurfData;
		FRenderTarget *RenderTarget = RenderTexture->GameThread_GetRenderTargetResource();
		RenderTarget->ReadPixels(SurfData);

		// Lock and copies the data between the textures
		void* TextureData = Texture->PlatformData->Mips[0].BulkData.Lock(LOCK_READ_WRITE);
		const int32 TextureDataSize = SurfData.Num() * 4;
		FMemory::Memcpy(TextureData, SurfData.GetData(), TextureDataSize);
		Texture->PlatformData->Mips[0].BulkData.Unlock();
		// Apply Texture changes to GPU memory
		Texture->UpdateResource();
		FMemory::Free( SurfData.GetData() );
		return Texture;
	}
	return NULL;
}
```
![Snipaste_2022-06-15_14-42-52](https://user-images.githubusercontent.com/33256117/173773565-8d20a7bb-d020-41d0-9a5b-7584ed96d54f.png)
