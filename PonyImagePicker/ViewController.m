//
//  ViewController.m
//  PonyImagePicker
//
//  Created by 崔 明辉 on 2018/9/11.
//  Copyright © 2018年 Pony Cui. All rights reserved.
//

#import "ViewController.h"
#import "PIPImagePickerController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)doPickImages:(id)sender {
    PIPImagePickerController *imagePickerController = [[PIPImagePickerController alloc] init];
    imagePickerController.allowMultipeSelection = NO;
    imagePickerController.editor = PIPImagePickerEditorCircle;
    [self presentViewController:imagePickerController animated:YES completion:^{
        
    }];
}

@end
