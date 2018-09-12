//
//  PIPAssetCollectionViewCell.m
//  PonyImagePicker
//
//  Created by 崔 明辉 on 2018/9/11.
//  Copyright © 2018年 Pony Cui. All rights reserved.
//

#import "PIPAssetCollectionViewCell.h"
#import "PIPAlbumDetailViewController.h"

@interface PIPAssetCollectionViewCell()

@property (nonatomic, weak) PIPAlbumDetailViewController *viewController;
@property (nonatomic, strong) PHAsset *data;
@property (nonatomic, assign) PHImageRequestID requestID;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *selectButton;
@property (nonatomic, strong) UIButton *selectedButton;
@property (nonatomic, strong) UILabel *selectedButtonLabel;

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
        _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectButton setImage:[UIImage imageWithData:[[NSData alloc] initWithBase64EncodedString:@"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" options:kNilOptions] scale:3.0]
                           forState:UIControlStateNormal];
        [_selectButton addTarget:self action:@selector(handleSelected) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_selectButton];
        _selectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectedButtonLabel = [[UILabel alloc] init];
        _selectedButtonLabel.textColor = [UIColor whiteColor];
        _selectedButtonLabel.textAlignment = NSTextAlignmentCenter;
        _selectedButtonLabel.backgroundColor = self.tintColor;
        _selectedButtonLabel.font = [UIFont boldSystemFontOfSize:14];
        _selectedButtonLabel.layer.cornerRadius = 12;
        _selectedButtonLabel.layer.masksToBounds = YES;
        [_selectedButton addSubview:_selectedButtonLabel];
        [_selectedButton addTarget:self action:@selector(handleSelected) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_selectedButton];
    }
    return self;
}

- (void)setData:(PHAsset *)data viewController:(PIPAlbumDetailViewController *)viewController {
    self.viewController = viewController;
    _data = data;
    [[PHCachingImageManager defaultManager] cancelImageRequest:self.requestID];
    self.imageView.image = nil;
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
    [self resetSelectionState];
}

- (void)handleSelected {
    if (self.viewController != nil && self.data != nil) {
        if ([self.viewController.dataManager.selectedAssets containsObject:self.data]) {
            [self.viewController.dataManager.selectedAssets removeObject:self.data];
        }
        else {
            [self.viewController.dataManager.selectedAssets addObject:self.data];
            self.selectedButtonLabel.transform = CGAffineTransformMake(0.6, 0.0, 0.0, 0.6, 0.0, 0.0);
            self.selectedButtonLabel.alpha = 0.0;
            [UIView animateWithDuration:0.50 delay:0.10 usingSpringWithDamping:0.6 initialSpringVelocity:16.0 options:kNilOptions animations:^{
                self.selectedButtonLabel.transform = CGAffineTransformMake(1.0, 0.0, 0.0, 1.0, 0.0, 0.0);
                self.selectedButtonLabel.alpha = 1.0;
            } completion:nil];
        }
        [self.viewController.dataManager notifySelectedAssetsChanged];
    }
}

- (void)resetSelectionState {
    if (self.viewController != nil && self.data != nil) {
        NSUInteger atIndex = [self.viewController.dataManager.selectedAssets indexOfObject:self.data];
        if (!self.viewController.dataManager.allowMultipeSelection) {
            self.selectButton.hidden = YES;
            self.selectedButton.hidden = YES;
        }
        else if (atIndex != NSNotFound) {
            [self.selectedButtonLabel setText:[NSString stringWithFormat:@"%lu", (unsigned long)(atIndex + 1)]];
            self.selectedButton.hidden = NO;
            self.selectButton.hidden = YES;
            self.selectButton.enabled = YES;
            self.imageView.alpha = 1.0;
        }
        else {
            self.selectedButton.hidden = YES;
            self.selectButton.hidden = NO;
            if (self.viewController.dataManager.selectedAssets.count >= self.viewController.dataManager.maximumMultipeSelection) {
                self.selectButton.enabled = NO;
                self.imageView.alpha = 0.35;
            }
            else {
                self.selectButton.enabled = YES;
                self.imageView.alpha = 1.0;
            }
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(0.0, 0.0, self.bounds.size.width, self.bounds.size.height - 4);
    self.selectButton.frame = CGRectMake(self.bounds.size.width - 36, -8, 44, 44);
    self.selectedButton.frame = CGRectMake(self.bounds.size.width - 36, -8, 44, 44);
    self.selectedButtonLabel.frame = CGRectMake((self.selectedButton.bounds.size.width - 24) / 2.0, (self.selectedButton.bounds.size.width - 24) / 2.0, 24, 24);
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if (!self.selectButton.enabled) {
        return NO;
    }
    return point.x > 0.0 && point.x < self.bounds.size.width + 12 && point.y > -12.0 && point.y < self.bounds.size.height - 4;
}

@end
