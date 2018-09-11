//
//  PIPAssetCollectionViewCell.m
//  PonyImagePicker
//
//  Created by 崔 明辉 on 2018/9/11.
//  Copyright © 2018年 Pony Cui. All rights reserved.
//

#import "PIPAssetCollectionViewCell.h"

@interface PIPAssetCollectionViewCell()

@property (nonatomic, strong) PHAsset *data;
@property (nonatomic, assign) PHImageRequestID requestID;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation PIPAssetCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        [self.contentView addSubview:_imageView];
    }
    return self;
}

- (void)setData:(PHAsset *)data {
    _data = data;
    [[PHCachingImageManager defaultManager] cancelImageRequest:self.requestID];
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.networkAccessAllowed = YES;
    option.synchronous = NO;
    self.requestID = [[PHCachingImageManager defaultManager]
                      requestImageForAsset:data
                                targetSize:CGSizeMake(200, 200)
                                contentMode:PHImageContentModeAspectFill
                                    options:option
                              resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      self.imageView.image = result;
                                  });
                              }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(0.0, 0.0, self.bounds.size.width, self.bounds.size.height - 4);
}

@end
