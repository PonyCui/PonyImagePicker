//
//  PIPAlbumDetailPageViewController.m
//  PonyImagePicker
//
//  Created by 崔 明辉 on 2018/9/11.
//  Copyright © 2018年 Pony Cui. All rights reserved.
//

#import "PIPAlbumDetailPageViewController.h"
#import <Photos/Photos.h>

@interface PIPAlbumDetailPageItemViewController: UIViewController

@property (nonatomic, strong) PHAsset *asset;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation PIPAlbumDetailPageItemViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.imageView];
}

- (void)setAsset:(PHAsset *)asset {
    _asset = asset;
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.networkAccessAllowed = YES;
    option.synchronous = NO;
    [[PHCachingImageManager defaultManager]
     requestImageForAsset:asset
     targetSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)
     contentMode:PHImageContentModeAspectFit
     options:option
     resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
         dispatch_async(dispatch_get_main_queue(), ^{
             self.imageView.image = result;
         });
     }];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.imageView.frame = self.view.bounds;
}

@end

@interface PIPAlbumDetailPageViewController ()<UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@property (nonatomic, strong) UIPageViewController *pageViewController;

@end

@implementation PIPAlbumDetailPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupPageViewController];
}

- (void)setupPageViewController {
    self.pageViewController = [[UIPageViewController alloc]
                               initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                               navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                               options:nil];
    PIPAlbumDetailPageItemViewController *currentViewController = [[PIPAlbumDetailPageItemViewController alloc] init];
    currentViewController.asset = self.currentAsset;
    [self.pageViewController setViewControllers:@[currentViewController]
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:NO
                                     completion:nil];
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.pageViewController.view.frame = self.view.bounds;
}

#pragma mark - UIPageViewControllerDelegate, UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(PIPAlbumDetailPageItemViewController *)viewController {
    NSUInteger atIndex = [self.collectionAssets indexOfObject:viewController.asset];
    if (atIndex != NSNotFound) {
        if (atIndex == 0) {
            return nil;
        }
        PIPAlbumDetailPageItemViewController *currentViewController = [[PIPAlbumDetailPageItemViewController alloc] init];
        currentViewController.asset = self.collectionAssets[atIndex - 1];
        return currentViewController;
    }
    return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(PIPAlbumDetailPageItemViewController *)viewController {
    NSUInteger atIndex = [self.collectionAssets indexOfObject:viewController.asset];
    if (atIndex != NSNotFound) {
        if (atIndex + 1 >= self.collectionAssets.count) {
            return nil;
        }
        PIPAlbumDetailPageItemViewController *currentViewController = [[PIPAlbumDetailPageItemViewController alloc] init];
        currentViewController.asset = self.collectionAssets[atIndex + 1];
        return currentViewController;
    }
    return nil;
}

@end
