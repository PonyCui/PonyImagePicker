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
        _maximumBoundsOfImages = 640;
        _dataManager = [[PIPImagePickerDataManager alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
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

- (void)onCommit {
    [self.dataManager fetchSelectedAssetsAsImages:^(NSArray<UIImage *> *images) {
        [self dismissViewControllerAnimated:YES completion:^{
            [self.imagePickerDelegate imagePicker:self didFinishPickedImages:images];
        }];
    } rejector:^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                                 message:@"获取图片数据失败，请重试。"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
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

- (void)setMaximumBoundsOfImages:(NSInteger)maximumBoundsOfImages {
    _maximumBoundsOfImages = maximumBoundsOfImages;
    self.dataManager.maximumBoundsOfImages = maximumBoundsOfImages;
}

- (void)setEditor:(PIPImagePickerEditor)editor {
    _editor = editor;
    self.dataManager.editor = editor;
}

@end
