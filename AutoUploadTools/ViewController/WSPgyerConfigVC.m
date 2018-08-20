//
//  WSPgyerConfigVC.m
//  AutoUploadTools
//
//  Created by shun on 2018/5/31.
//  Copyright © 2018年 shun. All rights reserved.
//

#import "WSPgyerConfigVC.h"
#import "WSConfigManager.h"

@interface WSPgyerConfigVC ()
@property (weak) IBOutlet NSTextField *uKeyTextField;
@property (weak) IBOutlet NSTextField *_api_kTextField;
@property (weak) IBOutlet NSTextField *phoneTextField;
@property (weak) IBOutlet NSTextField *messageTextField;

@end
@implementation WSPgyerConfigVC
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([WSConfigManager sharedConfigManager].pgyerConfig.uKey) {
        self.uKeyTextField.stringValue = [WSConfigManager sharedConfigManager].pgyerConfig.uKey;
    }

    if ([WSConfigManager sharedConfigManager].pgyerConfig.api_k) {
        self._api_kTextField.stringValue = [WSConfigManager sharedConfigManager].pgyerConfig.api_k;
    }
    
    if ([WSConfigManager sharedConfigManager].pgyerConfig.phoneArray.count > 0) {
        NSString *string = [[WSConfigManager sharedConfigManager].pgyerConfig.phoneArray componentsJoinedByString:@""];
        self.phoneTextField.stringValue = string;
    }
    if ([WSConfigManager sharedConfigManager].pgyerConfig.message) {
        self.messageTextField.stringValue = [WSConfigManager sharedConfigManager].pgyerConfig.message;
    }
    
}

- (IBAction)didClickMakeConfigButton:(id)sender {
    
    [WSConfigManager sharedConfigManager].pgyerConfig.uKey = self.uKeyTextField.stringValue;
    [WSConfigManager sharedConfigManager].pgyerConfig.api_k = self._api_kTextField.stringValue;
    [WSConfigManager sharedConfigManager].pgyerConfig.phoneArray = @[self.phoneTextField.stringValue];
    [WSConfigManager sharedConfigManager].pgyerConfig.message = self.messageTextField.stringValue;
    [[WSConfigManager sharedConfigManager] saveUserData];
    [self dismissController:nil];
}


@end
