//
//  WSNetWorkManager.h
//  AutoUploadTools
//
//  Created by shun on 2018/6/12.
//  Copyright © 2018年 shun. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 蒲公英上传后返回的内容
 */
@interface WSNetPgyerModel : NSObject
@property (nonatomic, copy) NSString *buildKey; //buildKey    String    Build Key是唯一标识应用的索引ID
@property (nonatomic, copy) NSString *buildType; //buildType    Integer    应用类型（1:iOS; 2:Android）
@property (nonatomic, copy) NSString *buildIsFirst; //buildIsFirst    Integer    是否是第一个App（1:是; 2:否）
@property (nonatomic, copy) NSString *buildIsLastest; //buildIsLastest    Integer    是否是最新版（1:是; 2:否）
@property (nonatomic, copy) NSString *buildFileSize; //buildFileSize    Integer    App 文件大小
@property (nonatomic, copy) NSString *buildName; //buildName    String    应用名称
@property (nonatomic, copy) NSString *buildVersion; //buildVersion    String    版本号, 默认为1.0 (是应用向用户宣传时候用到的标识，例如：1.1、8.2.1等。)
@property (nonatomic, copy) NSString *buildVersionNo; //buildVersionNo    String    上传包的版本编号，默认为1 (即编译的版本号，一般来说，编译一次会变动一次这个版本号, 在 Android 上叫 Version Code。对于 iOS 来说，是字符串类型；对于 Android 来说是一个整数。例如：1001，28等。)
@property (nonatomic, copy) NSString *buildBuildVersion; //buildBuildVersion    Integer    蒲公英生成的用于区分历史版本的build号
@property (nonatomic, copy) NSString *buildIdentifier; //buildIdentifier    String    应用程序包名，iOS为BundleId，Android为包名
@property (nonatomic, copy) NSString *buildIcon; //buildIcon    String    应用的Icon图标key，访问地址为 https://www.pgyer.com/image/view/app_icons/[应用的Icon图标key]
@property (nonatomic, copy) NSString *buildDescription; //buildDescription    String    应用介绍
@property (nonatomic, copy) NSString *buildUpdateDescription; //buildUpdateDescription    String    应用更新说明
@property (nonatomic, copy) NSString *buildScreenShots; //buildScreenShots    String    应用截图的key，获取地址为 https://www.pgyer.com/image/view/app_screenshots/[应用截图的key]
@property (nonatomic, copy) NSString *buildShortcutUrl; //buildShortcutUrl    String    应用短链接
@property (nonatomic, copy) NSString *buildQRCodeURL; //buildQRCodeURL    String    应用二维码地址
@property (nonatomic, copy) NSString *buildCreated; //buildCreated    String    应用上传时间
@property (nonatomic, copy) NSString *buildUpdated; //buildUpdated    String    应用更新时间
@end
@interface WSNetWorkManager : NSObject
+ (void)uploadToPgyerWithFilePath:(NSString *)filePath
                             uKey:(NSString *)uKey
                          api_key:(NSString *)api_key
                         progress:(void (^)(NSProgress * progress))cuploadProgress
                          success:(void (^)(NSDictionary *result))success
                          failure:(void (^)(NSError *error))failure;
/// 给钉钉发消息
+ (void)sendMessageToDingDingWithParams:(id)params
                                 finish:(void(^)(id Data,NSError *error))finishBlock;
@end
