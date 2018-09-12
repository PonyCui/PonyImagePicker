//
//  PIPImageEditorViewController.m
//  PonyImagePicker
//
//  Created by 崔 明辉 on 2018/9/12.
//  Copyright © 2018年 Pony Cui. All rights reserved.
//

#import "PIPImageEditorViewController.h"
#import "PIPImagePickerController.h"
#import <Photos/Photos.h>

@interface PIPImageEditorViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIView *cropRectView;
@property (nonatomic, strong) CAShapeLayer *cropRectBackgroundLayer;
@property (nonatomic, strong) CAShapeLayer *cropRectBorderLayer;

@end

@implementation PIPImageEditorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationItems];
    [self setupContents];
    [self setupCropRectBounds];
}

- (void)setupNavigationItems {
    self.title = @"编辑图片";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                                                              style:UIBarButtonItemStyleDone
                                                                             target:self
                                                                             action:@selector(onCommit)];
}

- (void)setupContents {
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.minimumZoomScale = 1.0;
    self.scrollView.maximumZoomScale = 1.0;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.delegate = self;
    self.imageView = [[UIImageView alloc] init];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.networkAccessAllowed = YES;
    option.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    option.resizeMode = PHImageRequestOptionsResizeModeExact;
    option.synchronous = NO;
    [[PHCachingImageManager defaultManager] requestImageDataForAsset:self.dataManager.selectedAssets.firstObject options:option resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        UIImage *image = [UIImage imageWithData:imageData];
        self.imageView.image = image;
        [self viewWillLayoutSubviews];
    }];
    [self.scrollView addSubview:self.imageView];
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.scrollView];
}

- (void)setupCropRectBounds {
    self.cropRectBackgroundLayer = [[CAShapeLayer alloc] init];
    self.cropRectBackgroundLayer.fillColor = [UIColor colorWithWhite:0.0 alpha:0.75].CGColor;
    self.cropRectBorderLayer = [[CAShapeLayer alloc] init];
    self.cropRectBorderLayer.fillColor = [UIColor clearColor].CGColor;
    self.cropRectBorderLayer.lineWidth = 1;
    self.cropRectBorderLayer.strokeColor = [UIColor whiteColor].CGColor;
    self.cropRectView = [[UIView alloc] init];
    self.cropRectView.userInteractionEnabled = NO;
    [self.view addSubview:self.cropRectView];
    [self.cropRectView.layer addSublayer:self.cropRectBackgroundLayer];
    [self.cropRectView.layer addSublayer:self.cropRectBorderLayer];
}

- (void)onCommit {
    CGPoint xyPoint = self.scrollView.contentOffset;
    xyPoint = CGPointMake(xyPoint.x / self.imageView.frame.size.width,
                          xyPoint.y / self.imageView.frame.size.height);
    PIPImagePickerEditor editor = self.dataManager.editor;
    self.dataManager.editorBlock = ^UIImage *(UIImage *originalImage) {
        if (editor == PIPImagePickerEditorSquare) {
            CGFloat length = MIN(originalImage.size.width * originalImage.scale,
                                 originalImage.size.height * originalImage.scale);
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(length, length), NO, 1.0);
            [originalImage drawAtPoint:
             CGPointMake(-xyPoint.x * (originalImage.size.width * originalImage.scale),
                         -xyPoint.y * (originalImage.size.height * originalImage.scale))];
            UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            return newImage;
        }
        else if (editor == PIPImagePickerEditorCircle) {
            CGFloat length = MIN(originalImage.size.width * originalImage.scale,
                                 originalImage.size.height * originalImage.scale);
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(length, length), NO, 1.0);
            [originalImage drawAtPoint:
             CGPointMake(-xyPoint.x * (originalImage.size.width * originalImage.scale),
                         -xyPoint.y * (originalImage.size.height * originalImage.scale))];
            UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(length, length), NO, 1.0);
            CGRect rect = CGRectMake(0.0, 0.0, length, length);
            UIBezierPath *bezierPath = [UIBezierPath bezierPathWithOvalInRect:rect];
            [bezierPath addClip];
            [bezierPath fill];
            [newImage drawInRect:rect];
            UIImage *newImage2 = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            return newImage2;
        }
        return originalImage;
    };
    if ([self.navigationController isKindOfClass:[PIPImagePickerController class]]) {
        [(PIPImagePickerController *)self.navigationController onCommit];
    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.scrollView.frame = CGRectMake(0.0, self.topLayoutGuide.length, self.view.bounds.size.width, self.view.bounds.size.height - 44 - self.topLayoutGuide.length);
    if (self.imageView.image != nil) {
        if (self.imageView.image.size.width / self.imageView.image.size.height > 1.0) {
            CGFloat imageViewWidth = self.imageView.image.size.width / self.imageView.image.size.height * self.view.bounds.size.width;
            self.imageView.frame = CGRectMake(0.0,
                                              (self.scrollView.bounds.size.height - self.view.bounds.size.width) / 2.0,
                                              imageViewWidth,
                                              self.view.bounds.size.width);
            self.scrollView.contentSize = CGSizeMake(imageViewWidth, self.view.bounds.size.width);
            self.scrollView.contentOffset = CGPointMake((imageViewWidth - self.view.bounds.size.width) / 2.0, 0.0);
        }
        else {
            CGFloat imageViewHeight = self.view.bounds.size.width / (self.imageView.image.size.width / self.imageView.image.size.height);
            self.imageView.frame = CGRectMake(0.0,
                                              (self.scrollView.bounds.size.height - imageViewHeight) / 2.0 + (imageViewHeight - self.scrollView.bounds.size.width) / 2.0,
                                              self.view.bounds.size.width,
                                              imageViewHeight);
            self.scrollView.contentSize = CGSizeMake(0.0, self.scrollView.bounds.size.height + (imageViewHeight - self.scrollView.bounds.size.width));
            self.scrollView.contentOffset = CGPointMake(0.0, (imageViewHeight - self.scrollView.bounds.size.width) / 2.0);
        }
    }
    else {
        self.imageView.frame = CGRectMake(0.0, (self.scrollView.bounds.size.height - self.view.bounds.size.width) / 2.0, self.view.bounds.size.width, self.view.bounds.size.width);
    }
    self.cropRectView.frame = self.scrollView.frame;
    if (self.dataManager.editor == PIPImagePickerEditorSquare) {
        {
            UIBezierPath *bezierPath = [UIBezierPath bezierPath];
            [bezierPath moveToPoint:CGPointMake(0.0, 0.0)];
            [bezierPath addLineToPoint:CGPointMake(self.scrollView.bounds.size.width, 0.0)];
            [bezierPath addLineToPoint:CGPointMake(self.scrollView.bounds.size.width, (self.scrollView.bounds.size.height - self.scrollView.bounds.size.width) / 2.0)];
            [bezierPath addLineToPoint:CGPointMake(0.0, (self.scrollView.bounds.size.height - self.scrollView.bounds.size.width) / 2.0)];
            [bezierPath addLineToPoint:CGPointMake(0.0, 0.0)];
            [bezierPath moveToPoint:CGPointMake(0.0, (self.scrollView.bounds.size.height - self.scrollView.bounds.size.width) / 2.0 + self.scrollView.bounds.size.width)];
            [bezierPath addLineToPoint:CGPointMake(self.scrollView.bounds.size.width, (self.scrollView.bounds.size.height - self.scrollView.bounds.size.width) / 2.0 + self.scrollView.bounds.size.width)];
            [bezierPath addLineToPoint:CGPointMake(self.scrollView.bounds.size.width, self.scrollView.bounds.size.height)];
            [bezierPath addLineToPoint:CGPointMake(0.0, self.scrollView.bounds.size.height)];
            [bezierPath addLineToPoint:CGPointMake(0.0, (self.scrollView.bounds.size.height - self.scrollView.bounds.size.width) / 2.0 +
                                                   self.scrollView.bounds.size.width)];
            
            self.cropRectBackgroundLayer.path = [bezierPath CGPath];
        }
        {
            UIBezierPath *bezierPath = [UIBezierPath bezierPath];
            [bezierPath moveToPoint:CGPointMake(0.0, (self.scrollView.bounds.size.height - self.scrollView.bounds.size.width) / 2.0)];
            [bezierPath addLineToPoint:CGPointMake(self.scrollView.bounds.size.width, (self.scrollView.bounds.size.height - self.scrollView.bounds.size.width) / 2.0)];
            [bezierPath addLineToPoint:CGPointMake(self.scrollView.bounds.size.width, (self.scrollView.bounds.size.height - self.scrollView.bounds.size.width) / 2.0 + self.scrollView.bounds.size.width)];
            [bezierPath addLineToPoint:CGPointMake(0.0, (self.scrollView.bounds.size.height - self.scrollView.bounds.size.width) / 2.0 + self.scrollView.bounds.size.width)];
            [bezierPath closePath];
            self.cropRectBorderLayer.path = [bezierPath CGPath];
        }
    }
    else if (self.dataManager.editor == PIPImagePickerEditorCircle) {
        {
            UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRect:CGRectMake(0.0, -44.0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height + 44)];
            [bezierPath appendPath:[[UIBezierPath
                                     bezierPathWithOvalInRect:CGRectMake(0.0, (self.scrollView.bounds.size.height - self.scrollView.bounds.size.width) / 2.0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.width)] bezierPathByReversingPath]];
            self.cropRectBackgroundLayer.path = [bezierPath CGPath];
        }
        {
            UIBezierPath *bezierPath = [UIBezierPath
                                        bezierPathWithOvalInRect:CGRectMake(0.0, (self.scrollView.bounds.size.height - self.scrollView.bounds.size.width) / 2.0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.width)];
            self.cropRectBorderLayer.path = [bezierPath CGPath];
        }
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

@end
