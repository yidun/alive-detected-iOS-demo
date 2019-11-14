活体检测 iOS SDK 接入指南
===
### 一、SDK集成
Demo与Framework下载地址：https://github.com/yidun/alive-detected-iOS-demo
####1.搭建开发环境
* 1、导入 `NTESLiveDetect.framework` 到XCode工程，直接拖拽`NTESLiveDetect.framework`文件到Xcode工程内(请勾选Copy items if needed选项)
* 2、导入 `NTESLiveDetectBundle.bundle`到XCode工程，进入Build phase，在copy bundle resources选项中添加`NTESLiveDetectBundle.bundle`文件（请勾选copy items if needed选项）
* 3、添加依赖库，在项目设置target -> 选项卡General ->Linked Frameworks and Libraries添加如下依赖库： 
	* `opencv2.framework`
	* `AVFoundation.framework`
	* `CoreMedia.framework`
	* `AssetsLibrary.framework`
	* `CoreData.framework`
* 4、在Xcode中找到`TARGETS-->Build Setting-->Linking-->Other Linker Flags`在这个选项中需要添加 `-ObjC`
* 5、在Xcode中找到`TARGETS-->Build Setting-->Apple Clang - Language-->Compile Source As`在这个选项中选择 `Objective-C++`
* 6、活体检测SDK需要配置相机权限，请在plist文件中添加相应权限。
    
   __备注:__  
   
   (1)如果已存在上述的系统framework，则忽略
   
   (2)SDK 最低兼容系统版本 iOS 9.0
  
### 二、SDK 使用

#### 2.1 Object-C 工程

* 1、在项目需要使用SDK的文件中引入LiveDetect SDK头文件，如下：

		#import <NTESLiveDetect/NTESLiveDetectManager.h>
		
* 2、在页面初始化的地方初始化 SDK，如下：

		@property (nonatomic, strong) NTESLiveDetectManager *detector;

		- (void)viewDidLoad {
    		[super viewDidLoad];
    		self.detector = [[NTESLiveDetectManager alloc] initWithImageView:self.imageView];
		}
		
* 3、开始进行活体检测时，调用如下方法:

		
		[self.detector startLiveDetectWithBusinessID:@"your_business_id"
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
	    	NSNumber *status = [dic objectForKey:@"info"];
	    	switch ([status intValue]) {
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
		
 __备注:__  
 1. 在获取活体检测结果成功的回调里做下一步reCheck接口的验证，否则，做客户端的下一步处理;
 2. 出于业务安全策略，在app切到后台时，建议停止活体检测，并在重新进入前台时，重新开始活体检测，可参考demo。


### 三、SDK 接口

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

* 3、通知		

		/**
		 @说明        动作检测监听，可在App内做相应提示
		             使用[notification.userInfo objectForKey:@"info"]获取当前动作状态，NSDictionary类型
		             key:当前执行的动作状态 0——正面，1——右转，2——左转，3——张嘴，4——眨眼, -1——未检测到完整人脸
		             value:对应动作的完成状态 NO——未完成 YES——已完成
		 
		 */
		extern NSString * _Nonnull const NTESLDNotificationStatusChange;
		
* 4、初始化检测对象

		/**
		 初始化检测对象
		 
		 @param imageView               传入放置检测活体的imageView对象
		 */
		- (instancetype)initWithImageView:(UIImageView *)imageView;

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
		 @param completionHandler       活体检测结果的回调，结果状态见NTESLDStatus枚举类型
		 */
		- (void)startLiveDetectWithBusinessID:(NSString *)businessID completionHandler:(NTESLDCompletionHandler)completionHandler;

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
        
        

	
