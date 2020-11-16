活体检测 iOS SDK 接入指南
===
### 1 SDK集成
Demo与Framework下载地址：https://github.com/yidun/alive-detected-iOS-demo
### 1.1 Cocoapods 集成
执行pod repo update更新。

Podfile 里面添加以下代码：

```ruby
 source 'https://github.com/CocoaPods/Specs.git' // 指定下载源
 
# 以下两种版本选择方式示例

# 集成最新版SDK:
pod 'NTESLiveDetect'

# 集成指定SDK，具体版本号可先执行 pod search NTESLiveDetect，根据返回的版本信息自行决定:
pod 'NTESLiveDetect', '~> 2.2.0'
```

* 保存并执行pod install即可，若未执行pod repo update，请执行pod install --repo-update

* 将引入SDK头文件的.m文件重命名为.mm文件 或者 在Xcode中找到TARGETS-->Build Setting-->Apple Clang - Language-->Compile Source As在这个选项中选择 Objective-C++

### 1.2手动集成
* 1、导入 `NTESLiveDetect.framework` 到XCode工程，直接拖拽`NTESLiveDetect.framework`文件到Xcode工程内(请勾选Copy items if needed选项)
* 2、导入 `NTESLiveDetectBundle.bundle`到XCode工程，进入Build phase，在copy bundle resources选项中添加`NTESLiveDetectBundle.bundle`文件（请勾选copy items if needed选项）
* 3、添加依赖库，在项目设置target -> 选项卡General ->Linked Frameworks and Libraries添加如下依赖库： 
	* `opencv2.framework`
	* `MNN.framework`
	* `AVFoundation.framework`
	* `CoreMedia.framework`
	* `AssetsLibrary.framework`
	* `CoreData.framework`
* 4、在Xcode中找到`TARGETS-->Build Setting-->Linking-->Other Linker Flags`在这个选项中需要添加 `-ObjC`
* 5、将引入SDK头文件的.m文件重命名为.mm文件 或者 在Xcode中找到`TARGETS-->Build Setting-->Apple Clang - Language-->Compile Source As`在这个选项中选择 `Objective-C++`
* 6、活体检测SDK需要配置相机权限，请在plist文件中添加相应权限`Privacy - Camera Usage Description`
* 7、工程项目需关闭bitcode，设置`ENABLE_BITCODE = NO`。
    
   __备注:__  
   
   (1)如果已存在上述的系统framework，则忽略
   
   (2)SDK 最低兼容系统版本 iOS 9.0
  
## 2 SDK 使用

### 2.1 Object-C 工程

* 1、在项目需要使用SDK的文件中引入LiveDetect SDK头文件，如下：

		#import <NTESLiveDetect/NTESLiveDetectManager.h>
		
* 2、在页面初始化的地方初始化 SDK，如下：

		@property (nonatomic, strong) NTESLiveDetectManager *detector;

		- (void)viewDidLoad {
    		[super viewDidLoad];
            // withDetectSensit：活体检灵敏度类型
    		self.detector = [[NTESLiveDetectManager alloc] initWithImageView:self.imageView withDetectSensit:NTESSensitNormal];
		}
		
* 3、开始进行活体检测时，调用如下方法:

		
		[self.detector startLiveDetectWithBusinessID:@"your_business_id"
									actionsHandler:^(NSDictionary * _Nonnull params) {
									// 获取动作序列
										}
                               completionHandler:^(NTESLDStatus status, NSDictionary * _Nullable params) {
           // 获取活体检测结果                  
    	}];
    	
* 4、当需要中止活体检测 或者 收到活体检测结果的回调时，请在主线程中调用：

		[self.detector stopLiveDetect];
    	
* 5、需要在页面进行动作提示时，需监听动作状态，在viewDidLoad中监听通知:   
		
		- (void)viewDidLoad {
			[super viewDidLoad];
  			[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(liveDetectStatusChange:) name:@"NTESLDNotificationStatusChange" object:nil];
  		}
    	
    	// 在相应的监听方法中进行动作提示：
    	- (void)liveDetectStatusChange:(NSNotification *)infoNotification {
	    	NSDictionary *dic = infoNotification.userInfo;
	    	NSDictionary *action = [dic objectForKey:@"action"];
            NSNumber *key = [[action allKeys] firstObject];
	    	switch ([key intValue]) {
	    		case 0:
	    			// 正面提示
	    			break;
	    		case 1:
	    			// 右转头提示
	    			break;
	    		case 2:
	    			// 左转头提示
	    			break;
	    		case 3:
	    			// 张嘴提示
	    			break;
	    		case 4:
	    			// 眨眼提示
	    			break;
	    		default:
		    		break;
	    	}
    
### 2.2 Swift 工程

* 1、在项目需要使用SDK的文件中引入LiveDetect SDK头文件，如下：

        import NTESLiveDetect

* 2、在页面初始化的地方初始化 SDK，如下：

        var detector: NTESLiveDetectManager? = nil

        override func viewDidLoad() {
            super.viewDidLoad()

            detector = NTESLiveDetectManager(imageView:faceImageView)
        }
        
* 3、开始进行活体检测时，调用如下方法:

        detector?.startLiveDetect(withBusinessID: "your_business_id", actionsHandler: { params in
            // 获取动作序列
        }, completionHandler: { (status, params) in
            // 获取活体检测结果
        })
        
* 4、当需要中止活体检测 或者 收到活体检测结果的回调时，请在主线程中调用：

        detector?.stopLiveDetect()
        
* 5、需要在页面进行动作提示时，需监听动作状态，在viewDidLoad中监听通知:   
        
        override func viewDidLoad() {
            super.viewDidLoad()
             
            NotificationCenter.default.addObserver(self, selector: #selector(liveDetectStatusChange(notification:)), name: NSNotification.Name(rawValue: "NTESLDNotificationStatusChange"), object: nil)
        }

        @objc
        func liveDetectStatusChange(notification: Notification) {
            let userInfo = notification.userInfo?["action"]
            guard let info = userInfo as? NSDictionary else {
                return
            }

            guard let status = info.allKeys.first as? String else {
                return
            }
           
            var msg = ""
            switch Int(status) {
            case 0:
                // 正面提示
                msg = "正面提示"
            break
            case 1:
                // 右转头提示
                msg = "右转头提示"
            break
            case 2:
                // 左转头提示
                msg = "左转头提示"
            break
            case 3:
                // 张嘴提示
                msg = "张嘴提示"
            break
            case 4:
                // 眨眼提示
                msg = "眨眼提示"
            break
            default:
            break
            }
        }

__备注:__  
1. 在获取活体检测结果成功的回调里做下一步reCheck接口的验证，否则，做客户端的下一步处理;
2. 出于业务安全策略，在app切到后台时，建议停止活体检测，并在重新进入前台时，重新开始活体检测，可参考demo。

## 3 SDK接口

* 1、枚举
		
		/**
		 *  @abstract    枚举
		 *
		 *  @说明         NTESLDCompletionHandler    对象的参数，用于表示获取token的状态
		 *
		 *               NTESLDCheckPass            活体检测通过
		 *               NTESLDCheckNotPass         活体检测不通过
		 *               NTESLDOperationTimeout     操作超时，用户未在规定时间内完成动作
		 *               NTESLDGetConfTimeout       活体检测获取配置信息超时
		 *               NTESLDOnlineCheckTimeout   云端检测结果请求超时
		 *               NTESLDOnlineUploadFailure  云端检测上传图片失败
		 *               NTESLDNonGateway           网络未连接
		 *               NTESLDSDKError             SDK内部发生错误
		 *               NTESLDCameraNotAvailable   App未获取相机权限
		 *
		 */
		typedef NS_ENUM(NSUInteger, NTESLDStatus) {
		    NTESLDCheckPass = 1,
		    NTESLDCheckNotPass,
		    NTESLDOperationTimeout,
		    NTESLDGetConfTimeout,
		    NTESLDOnlineCheckTimeout,
		    NTESLDOnlineUploadFailure,
		    NTESLDNonGateway,
		    NTESLDSDKError,
		    NTESLDCameraNotAvailable,
		};

* 2、回调block
	
		/**
		 @说明        获取活体检测结果的回调
		 */
		typedef void(^NTESLDCompletionHandler)(NTESLDStatus status, NSDictionary * _Nullable params);
- 		
		/**
		 @说明        返回所有动作的序列码
		             动作状态表示：0——正面，1——右转，2——左转，3——张嘴，4——眨眼
		 */
		typedef void(^NTESLDAcitionsHandler)(NSDictionary *params);

* 3、通知		

		/**
 		 @说明  动作检测监听，可在App内做相应提示
          动作检测的数据结构：@{@"action" : @{1 : YES}}  或者 @{@"exception" : 				 @"1"}  二者只可能出现其中之一。
          使用[notification.userInfo objectForKey:@"action"]获取当前动作状态，NSDictionary类型
          key:当前执行的动作状态 0——正面，1——右转，2——左转，3——张嘴，4——眨眼, -1——未检			测到完整人脸
          value:对应动作的完成状态 NO——未完成 YES——已完成
          使用NSString *exception =  [notification.userInfo objectForKey:@"exception"]获取异常，NSString类型
          exception:当前的异常状态 1——保持面部在框内，2——环境光线过暗，3——环境光线过亮，4——请勿抖动手机。
 */
		extern NSString * _Nonnull const NTESLDNotificationStatusChange;
		
* 4、初始化检测对象

		/**
		 初始化检测对象
		 
		 @param imageView               传入放置检测活体的imageView对象
         @param sensit                  请传入活体检灵敏度类型。
		 */
		- (instancetype)initWithImageView:(UIImageView *)imageView withDetectSensit:(NTESSensit)sensit;

* 5、设置活体检测的超时时间

		/**
		 设置活体检测的超时时间
		 
		 @param timeout                 请传入10-30范围内的时间值，默认15，单位s
		 */
		- (void)setTimeoutInterval:(NSTimeInterval)timeout;

* 6、开始活体检测

		/**
		 开始活体检测
		 
		 @param businessID              产品编号
		 @param actionsHandler          活体检测动作序列号的回调
		 @param completionHandler       活体检测结果的回调，结果状态见NTESLDStatus枚举类型
		 */
		- (void)startLiveDetectWithBusinessID:(NSString *)businessID actionsHandler:(NTESLDAcitionsHandler)actionsHandler completionHandler:(NTESLDCompletionHandler)completionHandler;

* 7、停止活体检测

		/**
		 停止活体检测
		 ⚠️ 请在主线程中调用
		 @abstract                      调用时机：
		                                1、在活体检测结果的回调里（NTESLDCompletionHandler）调用
		                                2、未完成活体检测，需要中止时调用
		 */
		- (void)stopLiveDetect;
		
* 8、SDK版本号获取

		/**
		 SDK版本号获取
		 */
		- (NSString *)getSDKVersion;
        
        

	
