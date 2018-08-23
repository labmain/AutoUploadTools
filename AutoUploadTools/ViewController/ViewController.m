//
//  ViewController.m
//  AutoUploadTools
//
//  Created by shun on 2018/5/31.
//  Copyright © 2018年 shun. All rights reserved.
//

#import "ViewController.h"
#import "WSAppConfigModel.h"
#import "WSConfigManager.h"
#import "WSBuildShellFileManager.h"
#import "WSNetWorkManager.h"
#import "WSFileManager.h"
#import "MJExtension.h"
#import "WSAppConfigVC.h"

@interface ViewController ()
@property (unsafe_unretained) IBOutlet NSTextView *logTextView;
@property(nonatomic,strong)NSDateFormatter* dateFormatter;
@property (weak) IBOutlet NSProgressIndicator *uploadProgress;
@property (weak) IBOutlet NSTextField *teamTextField;
@property (weak) IBOutlet NSButton *dingCheckBtn;
@property (weak) IBOutlet NSTextField *appName;
@property (unsafe_unretained) IBOutlet NSTextView *textView;

@property (nonatomic, assign) BOOL isCompiling;
@property (nonatomic, assign) BOOL isUploading;
@end
@implementation ViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewWillAppear
{
    [super viewWillAppear];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appConfigNotification) name:@"AppConfigNotification" object:nil];
    [self setAppInfo];
}
- (IBAction)appConfigBtnDidClick:(NSButton *)sender {
//       EHPracticeWordDetailVC *VC = [[UIStoryboard storyboardWithName:@"Practice" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"EHPracticeWordDetailVC"];
    WSAppConfigVC *vc = [[NSStoryboard storyboardWithName:@"Main" bundle:nil] instantiateControllerWithIdentifier:@"WSAppConfigVC"];
    [self presentViewControllerAsSheet:vc];
    
}
    
- (void)setAppInfo
{
    if ([WSConfigManager sharedConfigManager].appConfig.appName.length > 0) {
        self.appName.stringValue = [NSString stringWithFormat:@"项目：%@",[WSConfigManager sharedConfigManager].appConfig.appName];
    } else {
        self.appName.stringValue = @"项目：未配置";
    }
    self.teamTextField.stringValue = [WSConfigManager sharedConfigManager].appConfig.teamID;
}
- (void)appConfigNotification
{
    [self setAppInfo];
}
- (IBAction)openLastBuildDidClick:(id)sender {
    WSAppConfigModel *model = [WSConfigManager sharedConfigManager].appConfig;
    NSString *lastAppPath = [[WSFileManager sharedFileManager] getLatestIPAFinderPathFromWithConfigurationModel:model];
    if (lastAppPath.length > 0) {
        NSURL *fileURL = [NSURL fileURLWithPath:lastAppPath];
        [[NSWorkspace sharedWorkspace] openURL:fileURL];
    }
    
}
    // 打包
- (IBAction)didClickArchiveButton:(id)sender {
    [self createIPAFileComplete:nil];
}

// 上传
- (IBAction)didClickUploadButton:(id)sender {
     [self uploadToPgyer];
}
// 打包并且上传
- (IBAction)didClickArchiveAndUpload:(id)sender {
    __weak typeof(self)weakSelf = self;
    [self createIPAFileComplete:^{
        [weakSelf uploadToPgyer];
    }];
}
- (IBAction)teamIDDidChange:(NSTextField *)sender {
    if (sender.stringValue.length > 0) {
        [WSConfigManager sharedConfigManager].appConfig.teamID = sender.stringValue;
        [[WSConfigManager sharedConfigManager] saveUserData];
    }
}
#pragma mark - 打包
- (void)createIPAFileComplete:(void(^)(void))complete {
    if (self.isCompiling == YES) {
        NSString *str = @"正在打包";
        [self addLog:str];
        return;
    }
    self.isCompiling = YES;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        WSAppConfigModel *model = [WSConfigManager sharedConfigManager].appConfig;
        NSString *logStr = [NSString stringWithFormat:@"正在编译%@项目",model.appName];
        [self addLog:logStr];
        NSString *filePath = [WSBuildShellFileManager writeShellFileWithConfigurationModel:model];
        system(filePath.UTF8String);
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *finishStr = @"";
            if ([[NSFileManager defaultManager] fileExistsAtPath:model.lastIpaPath]) {
                finishStr = [NSString stringWithFormat:@"完成%@项目编译生成ipa包",model.appName];
            } else {
                finishStr = @"打包失败！";
            }
            NSAlert *alert = [[NSAlert alloc] init];
            [alert addButtonWithTitle:@"确认"];
            alert.messageText = @"警告";
            alert.informativeText = [NSString stringWithFormat:@"%@项目，打包失败！",model.appName];
            alert.alertStyle = NSAlertStyleWarning;
            [alert runModal];
            [self addLog:finishStr];
            self.isCompiling = NO;
        });
        if (complete) {
            complete();
        }
    });
    
}

#pragma mark - 上传
- (void)uploadToPgyer {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.isUploading) {
            NSString *str = @"正在上传";
            [self addLog:str];
            return;
        }
        
        self.isUploading = YES;
        NSString *ukey = [WSConfigManager sharedConfigManager].pgyerConfig.uKey;
        NSString *api_k = [WSConfigManager sharedConfigManager].pgyerConfig.api_k;
        __weak typeof(self)weakSelf = self;
        WSAppConfigModel *model = [WSConfigManager sharedConfigManager].appConfig;
        NSString *logStr = [NSString stringWithFormat:@"开始上传%@项目ipa包",model.appName];
        [self addLog:logStr];
        [WSNetWorkManager uploadToPgyerWithFilePath:[[WSFileManager sharedFileManager] getLatestIPAFilePathFromWithConfigurationModel:model]
                                               uKey:ukey
                                            api_key:api_k
                                           progress:^(NSProgress *progress) {
                                               double currentProgress = progress.fractionCompleted * 100.0;
                                               model.uploadProgress = currentProgress;
                                               weakSelf.uploadProgress.doubleValue = currentProgress;
                                               NSLog(@"上传进度%lf",currentProgress);
                                           } success:^(WSNetPgyerModel *pgyerModel){
                                               model.uploadState = @"上传成功";
                                               NSString *logStr = [NSString stringWithFormat:@"%@项目ipa包上传完成",model.appName];
                                               [weakSelf addLog:logStr];
                                               NSString *resultString = [pgyerModel mj_JSONString];
                                               [weakSelf writeLog:resultString withPath:model.historyLogPath];
                                               if (weakSelf.dingCheckBtn.state == NSControlStateValueOn) {
                                                   [weakSelf sendToDingDingWithPgyerModel:pgyerModel];
                                               }
                                           } failure:^(NSError *error) {
                                               model.uploadState = @"上传失败";
                                               NSString *logStr = [NSString stringWithFormat:@"上传%@项目ipa包失败",model.appName];
                                               [weakSelf addLog:logStr];
                                               [weakSelf writeLog:error.localizedDescription withPath:model.historyLogPath];
                                           }];
        
    });
}

#pragma mark -
- (void)sendToDingDingWithPgyerModel:(WSNetPgyerModel *)pgyerModel
{
    WSDingModel *dingModel = [WSConfigManager sharedConfigManager].dingConfig;
    NSString *downUrl = [pgyerModel getDownUrl];
    NSString *sizeStr = [NSByteCountFormatter stringFromByteCount:pgyerModel.buildFileSize.longLongValue countStyle:NSByteCountFormatterCountStyleFile];
    dingModel.message = [NSString stringWithFormat:@"打包完成！\n下载地址：%@\n项目：%@\n版本：%@\nBulid：%@\n大小：%@\n上传时间：%@",downUrl,pgyerModel.buildName,pgyerModel.buildVersion,pgyerModel.buildVersionNo,sizeStr,pgyerModel.buildCreated];
    if (dingModel.dingUrl.length > 0) {
        if (dingModel.message.length == 0) {
            dingModel.message = @"打包完成！";
        }
        [WSNetWorkManager sendMessageToDingDingWithMassage:dingModel.message at:dingModel.phoneArray dingUrl:dingModel.dingUrl finish:nil];
    }
}
#pragma mark - Log
- (void)addSystemLog:(NSString *)message
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSAttributedString *attr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n",message]];
        [[self.textView textStorage] appendAttributedString:attr];
    });
}
- (void)writeLog:(NSString *)string withPath:(NSString *)path{
    NSString *logString = [[self.dateFormatter stringFromDate:[NSDate date]] stringByAppendingString:[NSString stringWithFormat:@":\n%@",string]];
    [[WSFileManager sharedFileManager] wirteLogToFileWith:logString withName:[self.dateFormatter stringFromDate:[NSDate date]] withPath:path];
}
- (void)addLog:(NSString *)string {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *temStrin = self.logTextView.string;
        NSString *dateString = [self.dateFormatter stringFromDate:[NSDate date]];
        NSString *logString = [NSString stringWithFormat:@"%@:%@",dateString,string];
        temStrin = [temStrin stringByAppendingFormat:@"%@\n",logString];
        self.logTextView.string = temStrin;
    });
}
#pragma mark - lazy
- (NSDateFormatter *)dateFormatter {
    if (_dateFormatter == nil) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"yyyy年MM月dd日 HH:mm:ss";
    }
    return _dateFormatter;
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
    
    // Update the view, if already loaded.
}
@end
