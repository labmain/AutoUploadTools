//
//  WSConfigManager.h
//  AutoUploadTools
//
//  Created by shun on 2018/5/31.
//  Copyright © 2018年 shun. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 蒲公英配置
 */
@interface WSPgyerModel : NSObject
@property (nonatomic, copy) NSString *api_k;
@property (nonatomic, copy) NSString *uKey;
@end

/**
 钉钉配置
 */
@interface WSDingModel : NSObject
@property (nonatomic, copy) NSString *dingUrl; // 钉钉地址
@property (nonatomic, strong) NSArray<NSString *> *phoneArray; /**< 上传之后@的手机号 */
@property (nonatomic, copy) NSString *message; // 消息
@end

@class WSAppConfigModel;
@interface WSConfigManager : NSObject

@property (nonatomic, strong) WSAppConfigModel *appConfig;
@property (nonatomic, strong) WSPgyerModel *pgyerConfig;
@property (nonatomic, strong) WSDingModel *dingConfig;

+ (instancetype)sharedConfigManager;
- (void)saveUserData;
@end
