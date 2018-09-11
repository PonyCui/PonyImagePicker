//
//  PIPAlbumDetailPageViewController.h
//  PonyImagePicker
//
//  Created by 崔 明辉 on 2018/9/11.
//  Copyright © 2018年 Pony Cui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PIPImagePickerDataManager.h"

@interface PIPAlbumDetailPageViewController : UIViewController

@property (nonatomic, strong) PIPImagePickerDataManager *dataManager;
@property (nonatomic, strong) PHAsset *currentAsset;
@property (nonatomic, strong) NSArray<PHAsset *> *collectionAssets;

@end
