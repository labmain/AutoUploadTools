//
//  WSDingDingConfigVC.m
//  AutoUploadTools
//
//  Created by shun on 2018/8/20.
//  Copyright © 2018年 shun. All rights reserved.
//

#import "WSDingDingConfigVC.h"
#import "WSConfigManager.h"

@interface WSDingDingConfigVC ()
@property (weak) IBOutlet NSTextField *DingDingUrlTextField;
@property (weak) IBOutlet NSTextField *phoneTextField;
@property (weak) IBOutlet NSTextField *messageTextField;
@end

@implementation WSDingDingConfigVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    if ([WSConfigManager sharedConfigManager].dingConfig.phoneArray.count > 0) {
        NSString *string = [[WSConfigManager sharedConfigManager].dingConfig.phoneArray componentsJoinedByString:@""];
        self.phoneTextField.stringValue = string;
    }
    if ([WSConfigManager sharedConfigManager].dingConfig.message) {
        self.messageTextField.stringValue = [WSConfigManager sharedConfigManager].dingConfig.message;
    }
    if ([WSConfigManager sharedConfigManager].dingConfig.dingUrl) {
        self.DingDingUrlTextField.stringValue = [WSConfigManager sharedConfigManager].dingConfig.dingUrl;
    }
}
- (IBAction)didClickMakeConfigButton:(id)sender {
    [WSConfigManager sharedConfigManager].dingConfig.phoneArray = @[self.phoneTextField.stringValue];
    [WSConfigManager sharedConfigManager].dingConfig.message = self.messageTextField.stringValue;
       [WSConfigManager sharedConfigManager].dingConfig.dingUrl = self.DingDingUrlTextField.stringValue;
    [[WSConfigManager sharedConfigManager] saveUserData];
    [self dismissController:nil];
}

@end
