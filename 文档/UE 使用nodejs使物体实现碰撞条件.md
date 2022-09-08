(以下代码可理解为使用思路或者伪代码，其中调用的UE4函数或者类皆实在)
## 设置碰撞器
#### Boxcollision/Spherecollision

```javascript
let actor = new UE4.Actor();
let box = actor.AddComponent(UE4.BoxComponent);//添加BoxCollision或者SphereCollision
//let extent = actor.getAABB();
//box.SetBoxExtent(extent.halfSize);
box.SetBoxExtent(new UE4.location(1,1,1))//给碰撞盒设置大小
box.SetGenerateOverlapEvents(true);//设置为可触发碰撞事件（重要）
```

#### 复杂碰撞

```javascript
let com = actor.GetComponent(UE4.staticMeshComponent);//获取静态网格体组件
com.SetCollisionEnabled(UE4.CollisionMode.QueryAndPhysics);//设置碰撞器触发类型（重要）
com.SetGenerateOverlapEvents(true);//设置为可触发碰撞事件（重要）
```

## 设置回调
#### 监听world中的重叠事件

```javascript
UE4.World.SetOnActorBeginOverlapCallback(onActorBeginOverlap);
const onActorEndOverlap(overlapActor, otherActor) {
    //触发碰撞之后实际要执行的代码
}
```

#### actor注册回调事件
```javascript
const ActorEventType = {
	/// <summary>
	/// Called when actors start overlapping
	/// </summary>
	OnActorBeginOverlap: 0,
	/// <summary>
	/// Called when actors stop overlapping
	/// </summary>
	OnActorEndOverlap: 1,
	/// <summary>
	/// Called when actors hit collisions
	/// </summary>
	OnActorHit: 2
}
module.exports.ActorEventType = ActorEventType;
UE4.Actor.registerEvent(actor , ActorEventType.OnActorBeginOverlap);
```

