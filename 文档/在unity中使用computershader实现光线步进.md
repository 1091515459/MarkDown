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


##  ##
