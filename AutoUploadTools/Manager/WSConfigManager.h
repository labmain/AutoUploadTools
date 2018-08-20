//
//  WSConfigManager.h
//  AutoUploadTools
//
//  Created by shun on 2018/5/31.
//  Copyright © 2018年 shun. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WSPgyerModel : NSObject
@property (nonatomic, copy) NSString *api_k;
@property (nonatomic, copy) NSString *uKey;
@property (nonatomic, strong) NSArray<NSString *> *phoneArray; /**< 上传之后@的手机号 */
@property (nonatomic, copy) NSString *message;
@end

@class WSAppConfigModel;
@interface WSConfigManager : NSObject

@property (nonatomic, strong) WSAppConfigModel *appConfig;
@property (nonatomic, strong) WSPgyerModel *pgyerConfig;
+ (instancetype)sharedConfigManager;
- (void)saveUserData;
@end
