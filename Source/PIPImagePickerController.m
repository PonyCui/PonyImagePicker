//
//  PIPImagePickerController.m
//  PonyImagePicker
//
//  Created by 崔 明辉 on 2018/9/11.
//  Copyright © 2018年 Pony Cui. All rights reserved.
//

#import "PIPImagePickerController.h"
#import "PIPImagePickerDataManager.h"
#import "PIPAlbumListViewController.h"
#import "PIPAlbumDetailViewController.h"

@interface PIPImagePickerController ()

@property (nonatomic) PIPImagePickerDataManager *dataManager;

@end

@implementation PIPImagePickerController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _allowMultipeSelection = YES;
        _maximumMultipeSelection = 9;
        _allowMediaTypes = PHAssetMediaTypeImage;
        _allowMutlipeMediaTypes = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataManager = [[PIPImagePickerDataManager alloc] init];
    [self.dataManager grantPermission:^{
        PIPAlbumListViewController *albumListViewController = [[PIPAlbumListViewController alloc] init];
        albumListViewController.dataManager = self.dataManager;
        PIPAlbumDetailViewController *albumDetailViewController = [[PIPAlbumDetailViewController alloc] init];
        albumDetailViewController.dataManager = self.dataManager;
        [self setViewControllers:@[
                                   albumListViewController,
                                   albumDetailViewController,
                                   ]];
    } rejecter:^{
        
    }];
}

- (void)setAllowMultipeSelection:(BOOL)allowMultipeSelection {
    _allowMultipeSelection = allowMultipeSelection;
    self.dataManager.allowMultipeSelection = allowMultipeSelection;
}

- (void)setMaximumMultipeSelection:(NSInteger)maximumMultipeSelection {
    _maximumMultipeSelection = maximumMultipeSelection;
    self.dataManager.maximumMultipeSelection = maximumMultipeSelection;
}

- (void)setAllowMediaTypes:(PHAssetMediaType)allowMediaTypes {
    _allowMediaTypes = allowMediaTypes;
    self.dataManager.allowMediaTypes = allowMediaTypes;
}

- (void)setAllowMutlipeMediaTypes:(BOOL)allowMutlipeMediaTypes {
    _allowMutlipeMediaTypes = allowMutlipeMediaTypes;
    self.dataManager.allowMutlipeMediaTypes = allowMutlipeMediaTypes;
}

@end
