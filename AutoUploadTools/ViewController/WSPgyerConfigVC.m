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
    
}

- (IBAction)didClickMakeConfigButton:(id)sender {
    
    [WSConfigManager sharedConfigManager].pgyerConfig.uKey = self.uKeyTextField.stringValue;
    [WSConfigManager sharedConfigManager].pgyerConfig.api_k = self._api_kTextField.stringValue;
    [[WSConfigManager sharedConfigManager] saveUserData];
    [self dismissController:nil];
}


@end
