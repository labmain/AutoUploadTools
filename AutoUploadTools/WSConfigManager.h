//
//  WSConfigManager.h
//  AutoUploadTools
//
//  Created by shun on 2018/5/31.
//  Copyright © 2018年 shun. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WSAppConfigModel;
@interface WSConfigManager : NSObject

@property (nonatomic, strong) WSAppConfigModel *appConfig;
@property (nonatomic, copy) NSString *api_k;
@property (nonatomic, copy) NSString *uKey;

+ (instancetype)sharedConfigManager;
- (void)saveUserData;
@end
