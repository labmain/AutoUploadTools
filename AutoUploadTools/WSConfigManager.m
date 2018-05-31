//
//  WSConfigManager.m
//  AutoUploadTools
//
//  Created by shun on 2018/5/31.
//  Copyright © 2018年 shun. All rights reserved.
//

#import "WSConfigManager.h"
#import "WSAppConfigModel.h"
#import "MJExtension.h"

static NSString *WSPgyerUKey = @"WSPgyerUKey";
static NSString *WSPgyerapi_key = @"WSPgyerapi_key";
static NSString *WSUserDataKey = @"WSUserDataKey";

static WSConfigManager *staticConfigManager;

@implementation WSConfigManager
+ (instancetype)sharedConfigManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        staticConfigManager = [[WSConfigManager alloc] init];
        [staticConfigManager readConfigData];
    });
    return staticConfigManager;
}

- (void)readConfigData {
    self.api_k = [[NSUserDefaults standardUserDefaults] objectForKey:WSPgyerapi_key];
    self.uKey = [[NSUserDefaults standardUserDefaults] objectForKey:WSPgyerUKey];
    NSDictionary *dict =  [[NSUserDefaults standardUserDefaults] objectForKey:WSUserDataKey];
    self.appConfig = [WSAppConfigModel mj_objectWithKeyValues:dict];
    
}

- (void)saveUserData {
    NSDictionary *dict = [[self.appConfig mj_keyValues] copy];
    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:WSUserDataKey];
}

- (void)setUKey:(NSString *)uKey {
    _uKey = [uKey copy];
    [[NSUserDefaults standardUserDefaults] setObject:_uKey forKey:WSPgyerUKey];
}

- (void)setApi_k:(NSString *)api_k {
    _api_k = [api_k copy];
    [[NSUserDefaults standardUserDefaults] setObject:_api_k forKey:WSPgyerapi_key];
}

@end
