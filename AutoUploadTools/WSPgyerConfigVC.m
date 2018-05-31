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
    
    if ([WSConfigManager sharedConfigManager].uKey) {
        self.uKeyTextField.stringValue = [WSConfigManager sharedConfigManager].uKey;
    }

    if ([WSConfigManager sharedConfigManager].api_k) {
        self._api_kTextField.stringValue = [WSConfigManager sharedConfigManager].api_k;
    }
    
}

- (IBAction)didClickMakeConfigButton:(id)sender {
    
    [WSConfigManager sharedConfigManager].uKey = self.uKeyTextField.stringValue;
    [WSConfigManager sharedConfigManager].api_k = self._api_kTextField.stringValue;
    
    [self dismissController:nil];
}


@end
