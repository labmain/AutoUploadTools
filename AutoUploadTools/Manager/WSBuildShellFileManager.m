//
//  WSBuildShellFileManager.m
//  AutoUploadTools
//
//  Created by shun on 2018/6/12.
//  Copyright © 2018年 shun. All rights reserved.
//

#import "WSBuildShellFileManager.h"
#import "WSAppConfigModel.h"

@implementation WSBuildShellFileManager

+ (NSString *)writeShellFileWithConfigurationModel:(WSAppConfigModel *)configurationModel {
    return [self writeProjectShellFileWithConfigurationModel:configurationModel];
}

+ (NSString *)writeProjectShellFileWithConfigurationModel:(WSAppConfigModel *)configurationModel {
    
    NSString *projectPath = configurationModel.projectPath;
    
    NSString *ipaPath = configurationModel.ipaPath;
    
    NSString *projectTypeString;
    if (configurationModel.projectType == WSXCodeProjectTypeProj) {
        projectTypeString = @"project";
    }else {
        projectTypeString = @"workspace";
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd-HH-mm-ss";
    NSDate *date = [NSDate date];
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    NSString *projectName = [configurationModel projectName];
    
    NSString *archiveFilePath = [NSString stringWithFormat:@"%@/%@/%@.xcarchive",ipaPath,dateString,projectName];
    
    NSString *ipaFilePath = [NSString stringWithFormat:@"%@/%@",ipaPath,dateString];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:ipaFilePath]) { // 打包路径
        [[NSFileManager defaultManager] createDirectoryAtPath:ipaFilePath withIntermediateDirectories:NO attributes:nil error:nil];
    }
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"buildinfo.plist" ofType:nil]; // exportOptionsPlist文件所在目录，可判断development, ad-hoc等（method 包含四种： app-store, ad-hoc, enterprise, development）
    if (configurationModel.teamID.length > 0) { // 写入 teamID
        NSMutableDictionary *plistData = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
        [plistData setObject:configurationModel.teamID forKey:@"teamID"];
        [plistData writeToFile:plistPath atomically:YES];
    }
    
    NSString *archiveShellString = [NSString stringWithFormat:@"\"$(xcodebuild archive -%@ %@ -scheme %@ -archivePath %@)\"",projectTypeString,projectPath,configurationModel.schemes,archiveFilePath]; // 打包脚本，archive导出.xcarchive文件

    NSString *exportArchiveShellString = [NSString stringWithFormat:@"\"$(xcodebuild -exportArchive -archivePath %@ -exportPath %@ -exportOptionsPlist %@)\"",archiveFilePath,ipaFilePath,plistPath]; // 打包之后，导出ipa包

    NSString *shellString = [NSString stringWithFormat:@"#!/bin/sh\n\n%@\n\n%@\n",archiveShellString,exportArchiveShellString];
    
    NSString *temShellPath = [NSString stringWithFormat:@"%@/tem.sh",ipaPath];

    if (![[NSFileManager defaultManager] fileExistsAtPath:temShellPath]) {
        [[NSFileManager defaultManager] createFileAtPath:temShellPath contents:nil attributes:nil];
    }
    NSString *getauto = [NSString stringWithFormat:@"chmod a+x %@",temShellPath];
    system(getauto.UTF8String);
    NSError *error;
    [shellString writeToFile:temShellPath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    
    if (error) {
        return nil;
    }else {
        return temShellPath;
    }
}
@end
