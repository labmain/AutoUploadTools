//
//  WSAppConfigVC.m
//  AutoUploadTools
//
//  Created by shun on 2018/5/31.
//  Copyright © 2018年 shun. All rights reserved.
//

#import "WSAppConfigVC.h"
#import "WSAppConfigModel.h"
#import "WSConfigManager.h"

@interface WSAppConfigVC ()
@property (weak) IBOutlet NSButton *xcodeprojButton;
@property (weak) IBOutlet NSButton *xcworkspaceButton;
@property (weak) IBOutlet NSTextField *schemesTextField;
@property (weak) IBOutlet NSTextField *appNameTextField;
@property (weak) IBOutlet NSTextField *projectPathTextField;
@property (weak) IBOutlet NSTextField *ipaPathTextField;
@end

@implementation WSAppConfigVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.appConfig = [WSConfigManager sharedConfigManager].appConfig;
    if (self.appConfig == nil) {
        self.appConfig = [[WSAppConfigModel alloc] init];
    }
    
    [self setupUI];
}
- (void)setupUI {
    WSAppConfigModel *config = self.appConfig;
    
    if (config.projectPath) {
        self.projectPathTextField.stringValue = config.projectPath;
    }
    
    if (config.ipaPath) {
        self.ipaPathTextField.stringValue = config.ipaPath;
    }
    
    self.xcodeprojButton.state = !config.projectType;
    self.xcworkspaceButton.state = config.projectType;
    if (config.schemes) {
        self.schemesTextField.stringValue = config.schemes;
    }
    if (config.appName) {
        self.appNameTextField.stringValue = config.appName;
    }
    
}
- (IBAction)didClickCancelButton:(id)sender {
    [self dismissController:nil];
}

- (IBAction)didClickCheckProject:(id)sender {
    WSAppConfigModel *configurationModel = self.appConfig;
    
    NSString *projectPath = self.projectPathTextField.stringValue;
    configurationModel.projectPath = projectPath;
    
    NSString *ipaPath = self.ipaPathTextField.stringValue;
    configurationModel.ipaPath = ipaPath;
    
    if (self.xcodeprojButton.state) {
        configurationModel.projectType = WSXCodeProjectTypeProj;
    }else {
        configurationModel.projectType = WSXCodeProjectTypeWorkspace;
    }
    
    NSString *schemes = self.schemesTextField.stringValue;
    configurationModel.schemes = schemes;
    configurationModel.appName = self.appNameTextField.stringValue;
    
    [WSConfigManager sharedConfigManager].appConfig = configurationModel;
    [[WSConfigManager sharedConfigManager] saveUserData];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AppConfigNotification" object:nil];
    [self dismissController:nil];
}
- (IBAction)didClickxcodeprojButton:(id)sender {
    self.xcworkspaceButton.state = !self.xcodeprojButton.state;
}
- (IBAction)didClickxcworkspaceButton:(id)sender {
    self.xcodeprojButton.state = !self.xcworkspaceButton.state;
}
@end
