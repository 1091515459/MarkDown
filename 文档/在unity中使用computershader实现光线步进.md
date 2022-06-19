Use Computershader to implement RayMarching in Unity
====

## ComputeBuffer ##
GPU数据缓冲区，主要用于计算着色器。

## #pragma kernel  ##
#pragma kernel后面跟的是入口函数名  
numthreads(u,v,w)表示一个线程组内对应的线程总数为 u * v * w 个，同样方便三维索引，比如之后纹理采样 [SampleLevel](https://docs.microsoft.com/en-us/windows/win32/direct3dhlsl/dx-graphics-hlsl-to-samplelevel) 就能很方便地去索引。

```C#
#pragma kernel ZXMain

[numthreads(8,8,1)]
void ZXMain (uint3 id : SV_DispatchThreadID){
    //DO something
}
```
扩展一下C++中创建出一组三维线程组，并且声明一个线程组对应的线程数
```C++
cmdList->Dispatch(x, y, z);

[numthreads(8,8,1)]
void ***(int3 groupThreadID : SV_GroupThreadID, // 组内线程ID，这里的范围是(0,0,0)~(N-1,0,0)
                int3 dispatchThreadID : SV_DispatchThreadID) // 全局的调度线程ID，对于一个线程组内所有线程，该ID的y坐标应该一致

```
<img src= "https://user-images.githubusercontent.com/33256117/174475524-b7c42be7-cd12-4806-b005-51e1a58e55c2.png" width="50%" alt="来自龙书">

## Dispatch 执行计算着色器。 ##
```C#
/// <param name="kernelIndex">执行哪个内核。单个计算着色器资产可以有多个内核入口点。</param>
/// <param name="threadGroupsX">X维度中的工作组数量。</param>
/// <param name="threadGroupsY">Y维度中的工作组数量。</param>
/// <param name="threadGroupsZ">Z维度中的工作组数量。</param>
[NativeName("DispatchComputeShader")]
[MethodImpl(MethodImplOptions.InternalCall)]
public extern void Dispatch(
  int kernelIndex,
  int threadGroupsX,
  int threadGroupsY,
  int threadGroupsZ);
```

```C#
ComputeShader raymarching;
int threadGroupsX = Mathf.CeilToInt (cam.pixelWidth / 8.0f);//cam.pixelWidth 相机的像素宽度(不考虑动态分辨率缩放)(只读)。
int threadGroupsY = Mathf.CeilToInt (cam.pixelHeight / 8.0f);//Mathf.CeilToInt(f) 返回大于或等于f的最小整数。
raymarching.Dispatch (0, threadGroupsX, threadGroupsY, 1);
```
