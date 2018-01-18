ReactiveCocoa5.0以后将 RAC 拆分为四个库：ReactiveCocoa、ReactiveSwift、ReactiveObjC、ReactiveObjCBridge。其中的ReactiveCocoa和ReactiveObjC，一个适用于您的纯Swift项目,另一个适用于纯OC项目。

纯Swift项目Cocoapods导入
platform :ios,’8.0’
target “这里写你的工程名” do
//这里默认会导入最新的ReactiveCocoa版本
pod 'ReactiveCocoa'
use_frameworks!
end

纯OC项目Cocoapods导入
platform :ios,’8.0’
target “这里写你的工程名” do
//这里默认会导入最新的ReactiveCocoa版本
pod 'ReactiveObjC'
use_frameworks!
end

导入注意事项,若你的项目为Swift和OC混编，那么需要将ReactiveObjC和ReactiveCocoa都导入，同时需要手动导入ReactiveObjCBridge(桥接文件)，桥接文件的设置:https://www.jianshu.com/p/267d1a4077de
platform :ios,’8.0’
target “这里写你的工程名” do
//这里默认会导入最新的ReactiveCocoa版本
pod 'ReactiveCocoa'
pod 'ReactiveObjC'
use_frameworks!
end

参考：
https://www.jianshu.com/p/68ae979ba814?utm_campaign=maleskine&utm_content=note&utm_medium=seo_notes&utm_source=recommendation
