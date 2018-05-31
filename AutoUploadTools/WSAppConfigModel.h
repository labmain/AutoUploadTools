//
//  WSAppConfigModel.h
//  AutoUploadTools
//
//  Created by shun on 2018/5/31.
//  Copyright © 2018年 shun. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger, WSXCodeProjectType) {
    WSXCodeProjectTypeProj,
    WSXCodeProjectTypeWorkspace,
};

typedef NS_ENUM(NSUInteger, WSXcodeBuildConfiguration) {
    WSXcodeBuildConfigurationDebug,
    WSXcodeBuildConfigurationRelease,
};
@interface WSAppConfigModel : NSObject
@property(nonatomic,copy)NSString* projectPath;

@property(nonatomic,copy)NSString* temPath;

@property(nonatomic,copy)NSString* ipaPath;

@property (nonatomic, readonly,copy) NSString *historyLogPath;

@property(nonatomic,copy)NSString* schemes;

@property(nonatomic,assign)WSXCodeProjectType projectType;

@property(nonatomic,assign)WSXcodeBuildConfiguration configuration;

@property(nonatomic,copy)NSString* appName;

@property (nonatomic, copy) NSString *projectName;

@property(nonatomic,assign)BOOL isCreateIPA;

@property(nonatomic,assign)BOOL isUploadIPA;

@property(nonatomic,copy)NSString* WSprojectName;

@property(nonatomic,copy)NSString* ipaName;

@property(nonatomic,copy)NSString* createDateString;

@property(nonatomic,copy)NSString* offTime;

@property(nonatomic,copy)NSString* sizeString;

@property(nonatomic,assign)CGFloat uploadProgress;

@property(nonatomic,copy)NSString* uploadState;
@end
