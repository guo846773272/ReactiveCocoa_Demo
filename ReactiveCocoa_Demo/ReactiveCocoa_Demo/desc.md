1:RACSignal
RACSignal只会向订阅者发送三种事件 : next, error 和 completed.
RACSignal的一系列功能是通过类簇来实现的. 如 :

RACEmptySignal ：空信号，用来实现 RACSignal 的 +empty 方法；
RACReturnSignal ：一元信号，用来实现 RACSignal 的 +return: 方法；
RACDynamicSignal ：动态信号，使用一个 block 来实现订阅行为，我们在使用 RACSignal 的 +createSignal: 方法时创建的就是该类的实例；
RACErrorSignal ：错误信号，用来实现 RACSignal 的 +error: 方法；
RACChannelTerminal ：通道终端，代表 RACChannel 的一个终端，用来实现双向绑定。

2:RACSubject
继承自RACSignal, 是可以手动控制的信号, 相当于RACSignal的可变版本.
能作为信号源被订阅者订阅, 又能作为订阅者订阅其他信号源(实现了RACSubscriber协议).
RACSubject有三个用来实现不同功能的子类 :

RACGroupedSignal ：分组信号，用来实现 RACSignal 的分组功能；
RACBehaviorSubject ：重演最后值的信号，当被订阅时，会向订阅者发送它最后接收到的值；
RACReplaySubject ：重演信号，保存发送过的值，当被订阅时，会向订阅者重新发送这些值。

3:RACSequence
代表的是一个不可变的值的序列. 不能被订阅者订阅, 但是能与RACSignal之间非常方便地进行转换.
RACSequence由两部分组成 : head 和 tail, head是序列中的第一个对象, tail则是其余的全部对象.
RACSequence存在的最大意义就是简化OC中的集合操作. 并且RACSequence所包含的值默认是懒计算的, 所以不知不觉中提高了我们应用的性能.

4:push-driven与pull-driven
RACSignal : push-driven, 生产一个吃一个, 类似于工厂的主动生产模式, 生产出产品就push给供销商.
RACSequence : pull-driven, 吃一个生产一个, 类似于工厂的被动生产模式, 供销商过来pull的时候才现做产品.
对于RACSignal的push-driven模式来说, 没有供销商(subscriber)签合同要产品, 当然就不生产了. 只有一个以上准备收货的供销商时, 工厂才开始生产. 这就是RACSignal的休眠(cold)和激活(hot)状态, 也就是冷信号和热信号. 一般情况下RACSignal创建以后都处于cold状态, 当有人去subscribe才变成hot状态.

5:冷信号与热信号
热信号 : 主动, 即使你没有订阅事件, 仍然会时刻推送. 热信号可以有多个订阅者, 是一对多的关系, 信号可以与订阅者共享信息.
冷信号 : 被动, 只有当你订阅的时候, 它才会发布消息. 冷信号只能一对一, 当有不同的订阅者, 消息是重新完整发送的.
ps : 任何的信号转换即是对原有信号进行订阅从而产生新的信号. (例如 : Map, FlattenMap等等)

6:如何区分热信号和冷信号
Subject类似于直播, 错过了就不再处理, 而Signal类似于点播, 每次订阅都从头开始重新发送.
我们能得出 :
1. RACSubject及其子类是热信号
2. RACSignal排除RACSubject类以外的都是冷信号

7:将冷信号转化成热信号
RAC帮我们封装了一套可以轻松将冷信号转换成热信号的API :
- (RACMulticastConnection *)publish;
- (RACMulticastConnection *)multicast:(RACSubject *)subject;
- (RACSignal *)replay;
- (RACSignal *)replayLast;
- (RACSignal *)replayLazily; // 跟replay的区别是replayLazily会在第一次订阅的时候才订阅sourceSignal
其中最重要的就是- (RACMulticastConnection *)multicast:(RACSubject *)subject;, 其他几个方法都是间接调用它的.
本质 : 使用一个Subject来订阅原始信号, 并让其他订阅者订阅这个Subject, 由于RACSubject本身为热信号, 所以源信号此时就像由冷信号变成了热信号.

8:调度器
RACScheduler
RAC中对GCD的简单封装. 子类如下 :
RACImmediateScheduler ：立即执行调度的任务，这是唯一一个支持同步执行的调度器；
RACQueueScheduler ：一个抽象的队列调度器，在一个 GCD 串行列队中异步调度所有任务；
RACTargetQueueScheduler ：继承自 RACQueueScheduler ，在一个以一个任意的 GCD 队列为 target 的串行队列中异步调度所有任务；
RACSubscriptionScheduler ：一个只用来调度订阅的调度器。

9:清洁工
RACDisposable
在订阅者订阅信号源的过程中, 可能会产生副作用或者消耗一定的资源, 所以在取消订阅或完成订阅的时候我们就需要做一些资源回收和辣鸡清理的工作. 核心方法为-dispose
RACSerialDisposable ：作为 disposable 的容器使用，可以包含一个 disposable 对象，并且允许将这个 disposable 对象通过原子操作交换出来；
RACKVOTrampoline ：代表一次 KVO 观察，并且可以用来停止观察；
RACCompoundDisposable ：跟 RACSerialDisposable 一样，RACCompoundDisposable 也是作为 disposable 的容器使用。不同的是，它可以包含多个 disposable 对象，并且支持手动添加和移除 disposable 对象，有点类似于可变数组 NSMutableArray 。而当一个 RACCompoundDisposable 对象被 disposed 时，它会调用其所包含的所有 disposable 对象的 -dispose 方法，有点类似于 autoreleasepool 的作用;
RACScopedDisposable ：当它被 dealloc 的时候调用本身的 -dispose 方法。
*总的来说就是在适当的时机调用disposable对象的-dispose方法而已.

10:RAC常见宏
用法在demo中
1. RAC(TARGET, [KEYPATH, [NIL_VALUE]])  -> 总是出现在等号左边, 等号右边是一个RACSignal
2. RACObserve(TARGET, KEYPATH)  -> 产生一个RACSignal
3. @weakify(self) 和 @strongify(self)
4. RACTuplePack 和 RACTupleUnpack  -> 压包与解包
5. @keypath(self.property)  -> 产生一个字符串@"property"

