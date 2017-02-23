## 简介

> IOS10中已经自带了homekit程序。现在由于支持该框架的硬件设备有限，所以homekit应用还是比较少的。
- HomeKit库是用来沟通和控制家庭自动化配件的，这些家庭自动化配件都支持苹果的HomeKit Accessory Protocol。
- HomeKit应用程序可让用户发现兼容配件并配置它们。用户可以创建一些action来控制智能配件（例如恒温或者光线强弱），对其进行分组，并且可以通过Siri触发。
- HomeKit 对象被存储在用户iOS设备的数据库中，并且通过iCloud还可以同步到其他iOS设备。
- HomeKit支持远程访问智能配件，并支持多个用户设备和多个用户。HomeKit 还对用户的安全和隐私做了处理。

## 启用HomeKit
HomeKit应用服务只提供给通过App Store发布的app应用程序。在你的Xcode工程中， HomeKit应用程序需要额外的配置，你的app必须有开发证书和代码签名才能使用HomeKit。

- 在Xcode中，选择View > Navigators > Show Project Navigator。
- 从Project/Targets弹出菜单中target（或者从Project/Targets的侧边栏）
- 点击Capabilities查看你可以添加的应用服务列表。
- 滑到HomeKit 所在的行并打开关。

## 模拟器
你将可以使用[*HomeKit Accessory Simulator*](https://developer.apple.com/library/ios/documentation/NetworkingInternet/Conceptual/HomeKitDeveloperGuide/EnablingHomeKit/EnablingHomeKit.html#//apple_ref/doc/uid/TP40015050-CH2-SW3)测试你的HomeKit应用程序

## HMhome
 - HomeKit 允许用户创建一个或者多个Home布局。每个Home（HMHome）代表一个有网络设备的住所。
 - 用户拥有Home的数据并可通过自己的任何一台iOS设备进行访问。用户也可以和客户共享一个Home，但是客户的权限会有更多限制。
 - 被指定为primary home的home默认是Siri指令的对象，并且不能指定home。
 - 我们可以通过创建一个HMHomeManager对象去管理home。使用这个HMHomeManager对象的访问home、room、配件、服务以及其他HomeKit对象

## HMroom

- 每个Home一般有多个room，并且每个room一般会有多个智能配件。在home中，每个房间是独立的room，并具有一个有意义的名字，这个名字是唯一的。
- （home的名字也是唯一的）例如“卧室”或者“厨房”，这些名字可以在Siri 命令中使用

## HMAccessory
- 一个accessory代表一个家庭中的自动化设备，例如一个智能插座，一个智能灯具等

## HMService && HMCharacteristic
- 服务(HMService)代表了一个配件(accessory)的某个功能和一些具有可读写的特性(HMCharacteristic)。
- 一个配件可以拥有多项服务,一个服务也可以有很多特性。
- 比如一个车库开门器可能拥有一个照明和开关的服务。照明服务可能拥有打开/关闭和调节亮度的特性。
- 用户不能制造智能家电配件和它们的服务-配件制造商会制造配件和它们的服务-但是用户可以改变服务的特性。
## 场景自动化

- 需要Apple TV 或者家中的一台iPad开控制
![Paste_Image.png](http://upload-images.jianshu.io/upload_images/2516123-e7152bd4c7c281d5.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/400)

## Demo

- 下面是的Demo，调试的时候打开模拟器HomeKit Accessory Simulator，需要在一个局域网下，打开蓝牙，先添加Home，然后添加设备。
- 设备的特性就支持了我自己模拟器添加的，所以如果想做别的控制，可以自己去添加适当的特征。
- 添加room和修改Home，room名字的功能没有做，可以用苹果的HomeKit APP "家庭"去修改
- 有问题可以给我留言
- 下面是效果图


![Paste_Image.png](http://upload-images.jianshu.io/upload_images/2516123-12b8c08988f451f4.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/400)


![Paste_Image.png](http://upload-images.jianshu.io/upload_images/2516123-4372be5542dc41db.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/400)

![Paste_Image.png](http://upload-images.jianshu.io/upload_images/2516123-d349d4965a940138.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/400)


![Paste_Image.png](http://upload-images.jianshu.io/upload_images/2516123-871198c79d1539a3.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/400)


![模拟器.png](http://upload-images.jianshu.io/upload_images/2516123-514a044d90ac9629.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

- [*代码连接：https://github.com/xuchengcheng/HomeKitDemo*](https://github.com/xuchengcheng/HomeKitDemo)
