//
//  WSFileManager.h
//  AutoUploadTools
//
//  Created by shun on 2018/6/12.
//  Copyright © 2018年 shun. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WSAppConfigModel;
@interface WSFileManager : NSObject

+ (instancetype)sharedFileManager;

/**
 获取文件夹里最新api路径
 */
- (NSString *)getLatestIPAFilePathFromWithConfigurationModel:(WSAppConfigModel *)model;
/**
 获取最后一个Build的文件夹
 */
- (NSString *)getLatestIPAFinderPathFromWithConfigurationModel:(WSAppConfigModel *)model;
/**
 获取第一个文件夹里最新ipa文件属性
 */
- (void)getLatestIPAFileInfoWithConfigurationModel:(WSAppConfigModel *)model;
/**
 写入日志
 */
- (void)wirteLogToFileWith:(NSString *)logString withName:(NSString *)name withPath:(NSString *)path;
@end
