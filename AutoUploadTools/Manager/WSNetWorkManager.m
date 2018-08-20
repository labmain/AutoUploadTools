//
//  WSNetWorkManager.m
//  AutoUploadTools
//
//  Created by shun on 2018/6/12.
//  Copyright © 2018年 shun. All rights reserved.
//

#import "WSNetWorkManager.h"
#import "AFHTTPSessionManager.h"
#import "MJExtension.h"

NSString *WSPgyerUploadIPAURLPath = @"https://www.pgyer.com/apiv2/app/upload";

@implementation WSNetPgyerModel
- (NSString *)getDownUrl
{
    return [NSString stringWithFormat:@"https://www.pgyer.com/%@",self.buildShortcutUrl];
}
@end

@interface WSNetWorkManager ()

@property(nonatomic,strong)AFHTTPSessionManager* httpSessionManager;

@end

static WSNetWorkManager *staticNetWorkManager;

@implementation WSNetWorkManager

+ (instancetype)sharedNetWorkManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        staticNetWorkManager = [[WSNetWorkManager alloc] init];
    });
    return staticNetWorkManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.httpSessionManager = [[AFHTTPSessionManager alloc] init];
        self.httpSessionManager.requestSerializer = [[AFHTTPRequestSerializer alloc] init];
        [self.httpSessionManager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"enctype"];
    }
    return self;
}

+ (void)uploadToPgyerWithFilePath:(NSString *)filePath
                             uKey:(NSString *)uKey
                          api_key:(NSString *)api_key
                         progress:(void (^)(NSProgress * progress))cuploadProgress
                          success:(void (^)(WSNetPgyerModel *pgyerModel))success
                          failure:(void (^)(NSError *error))failure{
    NSDictionary *pare = @{@"uKey":uKey,
                           @"_api_key":api_key,
                           @"installType":@"1", // (选填)应用安装方式，值为(1,2,3)。1：公开，2：密码安装，3：邀请安装。默认为1公开
                           @"password":@"", // 设置app 安装密码，不设置为空，或者不传
                           @"updateDWSription":@"" // 版本更新描述，请传空字符串，或不传。
                           };
    [[WSNetWorkManager sharedNetWorkManager].httpSessionManager POST:WSPgyerUploadIPAURLPath parameters:pare constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSURL *url=[NSURL fileURLWithPath:filePath];
        NSError *error;
        BOOL result = [formData appendPartWithFileURL:url name:@"file" fileName:[filePath lastPathComponent] mimeType:@"ipa" error:&error];
        if (result) {
            NSLog(@"success");
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(error);
            });
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            cuploadProgress(uploadProgress);
        });
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
            if (code == 0) {
                WSNetPgyerModel *model = [WSNetPgyerModel mj_objectWithKeyValues:[responseObject objectForKey:@"data"]];
                success(model);
            }else {
                NSString *errorString = [responseObject mj_JSONString];
                if (errorString == nil) {
                    errorString = @"上传失败";
                }
                NSError *error = [NSError errorWithDomain:@"error" code:-1 userInfo:@{NSLocalizedDescriptionKey:errorString}];
                failure(error);
            }
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            failure(error);
        });
    }];
}
+ (void)sendMessageToDingDingWithMassage:(NSString *)message
                                      at:(NSArray<NSString *> *)atArray
                                 dingUrl:(NSString *)dingUrl
                                  finish:(void(^)(id Data,NSError *error))finishBlock
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", nil];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    manager.requestSerializer =  [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                   @"text",@"msgtype",
                                   @{@"content":message},@"text"
                                   ,nil];
    if (atArray.count > 0) {
        NSDictionary *atMobiles = @{@"atMobiles":atArray,@"isAtAll":@(false)};
        [params setObject:atMobiles forKey:@"at"];
    }
    [manager POST:dingUrl
       parameters:params
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              NSNumber *errcode = [responseObject objectForKey:@"errcode"];
              if (errcode.integerValue == 0) {
                  if (finishBlock) {
                      finishBlock(responseObject,nil);
                  }
              } else {
                  if (finishBlock) {
                      NSInteger codee = errcode.integerValue;
                      
                      NSString *domain = [responseObject objectForKey:@"errmsg"];
                      
                      finishBlock(nil,[NSError errorWithDomain:domain code:codee userInfo:nil]);
                  }
              }
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              if (finishBlock) {
                  finishBlock(nil,error);
              }
          }];
    
}
@end
