//
//  PIPAlbumDetailViewController.h
//  PonyImagePicker
//
//  Created by 崔 明辉 on 2018/9/11.
//  Copyright © 2018年 Pony Cui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PIPImagePickerDataManager.h"

@interface PIPAlbumDetailViewController : UIViewController

@property (nonatomic, strong) PHAssetCollection *assetColleciton;
@property (nonatomic, strong) PIPImagePickerDataManager *dataManager;

@end
