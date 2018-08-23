//
//  WSFileManager.m
//  AutoUploadTools
//
//  Created by shun on 2018/6/12.
//  Copyright © 2018年 shun. All rights reserved.
//

#import "WSFileManager.h"
#import "WSAppConfigModel.h"
#import "NSDate+DateString.h"
#import "MJExtension.h"

@interface WSFileManager ()

@property(nonatomic,strong)NSDateFormatter* dateFormatter;

@end

static WSFileManager *staticWSFileManager;
@implementation WSFileManager

+ (instancetype)sharedFileManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        staticWSFileManager = [[WSFileManager alloc] init];
    });
    return staticWSFileManager;
}


#pragma mark - public
- (NSString *)getLatestIPAFilePathFromWithConfigurationModel:(WSAppConfigModel *)model {
    NSString *path = model.ipaPath;
    NSArray *ipaArray = [self getAllIPAinDirectoryPath:path];
    NSString *filePath = [self getLatestIPAFilePath:ipaArray];
    return filePath;
}
- (NSString *)getLatestIPAFinderPathFromWithConfigurationModel:(WSAppConfigModel *)model {
    NSArray *ipaArray =  [[NSFileManager defaultManager] contentsOfDirectoryAtPath:model.ipaPath error:nil];
    NSString *filePath = [self getLatestIPAFilePath:ipaArray];
    filePath = [model.ipaPath stringByAppendingString:[NSString stringWithFormat:@"/%@",filePath]];
    return filePath;
}

- (void)getLatestIPAFileInfoWithConfigurationModel:(WSAppConfigModel *)model {
    model.ipaName = [[NSFileManager defaultManager] displayNameAtPath:[self getLatestIPAFilePathFromWithConfigurationModel:model]];
    NSDictionary *infoDicture = [[WSFileManager sharedFileManager] getLatestIPAFileInfoFromDirectoryWithConfigurationModel:model];
    NSDate *date = [infoDicture objectForKey:NSFileCreationDate];
    model.createDateString = [self.dateFormatter stringFromDate:date];
    model.offTime = [date getOffTime];
    float firstSize = [[infoDicture objectForKey:NSFileSize] floatValue] / 1024 / 1024;
    model.sizeString = [NSString stringWithFormat:@"%.2lfM",firstSize];
}

- (NSDictionary *)getLatestIPAFileInfoFromDirectoryWithConfigurationModel:(WSAppConfigModel *)model {
    NSString *filePath = [self getLatestIPAFilePathFromWithConfigurationModel:model];
    NSError *error;
    NSDictionary *attributesDict = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:&error];
    if (error) {
        NSLog(@"get ipa attributes error === %@ ===\n==%@",error,filePath);
        return nil;
    }else {
        return attributesDict;
    }
}

- (void)wirteLogToFileWith:(NSString *)logString withName:(NSString *)name withPath:(NSString *)path{
    NSError *error;
    NSString *filePath = [NSString stringWithFormat:@"%@/%@.txt",path,name];
    [logString writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
}

#pragma mark - private
- (NSString *)getLatestIPAFilePath:(NSArray <NSString *>*)ipaPathArray {
    NSString *temFilePath = ipaPathArray.firstObject;
    for (NSString *filePath in ipaPathArray) {
        NSError *error;
        NSDictionary *attributesDict = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:&error];
        if (error) {
            NSLog(@"get attributes error %@",error);
        }else {
            NSDictionary *temAttributesDict = [[NSFileManager defaultManager] attributesOfItemAtPath:temFilePath error:&error];
            if (error) {
                NSLog(@"get attributes error %@",error);
            }else {
                NSDate *fileDate = [attributesDict objectForKey:NSFileCreationDate];
                NSDate *temFileDate = [temAttributesDict objectForKey:NSFileCreationDate];
                NSComparisonResult result = [fileDate compare:temFileDate];
                if (result == NSOrderedDescending) {
                    temFilePath = filePath;
                }else {
                    
                }
            }
        }
        
    }
    return temFilePath;
}

- (NSArray <NSString *>*)getAllIPAinDirectoryPath:(NSString *)directoryPath {
    NSMutableArray *ipaArray = [NSMutableArray array];
    [self scanAllIPAFilePathWithDirectory:directoryPath resultArray:ipaArray];
    return ipaArray;
}

- (void)scanAllIPAFilePathWithDirectory:(NSString *)directoryPath resultArray:(NSMutableArray *)resultArray{
    NSError *error;
    NSArray *temArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directoryPath error:&error];
    if (error) {
        NSLog(@"%@",error);
        return;
    }
    if (temArray.count == 0) {
        return;
    }
    for (NSString *fileString in temArray) {
        BOOL isDirectory = NO;
        NSString *temfile = [NSString stringWithFormat:@"%@/%@",directoryPath,fileString];
        if ([[NSFileManager defaultManager] fileExistsAtPath:temfile isDirectory:&isDirectory]) {
            if (isDirectory == YES) {
                [self scanAllIPAFilePathWithDirectory:temfile resultArray:resultArray];
            }else {
                if ([fileString containsString:@".ipa"]) {
                    [resultArray addObject:temfile];
                }
            }
        }
    }
    
    
}

- (NSDateFormatter *)dateFormatter {
    if (_dateFormatter == nil) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"yyyy年MM月dd日 HH:mm:ss";
    }
    return _dateFormatter;
}
@end
