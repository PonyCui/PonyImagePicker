//
//  PIPAssetCollectionViewCell.h
//  PonyImagePicker
//
//  Created by 崔 明辉 on 2018/9/11.
//  Copyright © 2018年 Pony Cui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface PIPAssetCollectionViewCell : UICollectionViewCell

- (void)setData:(PHAsset *)data;

@end
