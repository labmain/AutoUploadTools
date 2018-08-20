//
//  WSBuildShellFileManager.h
//  AutoUploadTools
//
//  Created by shun on 2018/6/12.
//  Copyright © 2018年 shun. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WSAppConfigModel;
@interface WSBuildShellFileManager : NSObject
+ (NSString *)writeShellFileWithConfigurationModel:(WSAppConfigModel *)configurationModel;
@end
