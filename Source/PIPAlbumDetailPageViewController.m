//
//  PIPAlbumDetailPageViewController.m
//  PonyImagePicker
//
//  Created by 崔 明辉 on 2018/9/11.
//  Copyright © 2018年 Pony Cui. All rights reserved.
//

#import "PIPAlbumDetailPageViewController.h"
#import <Photos/Photos.h>
#import "PIPImagePickerController.h"

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
@property (nonatomic, strong) UIToolbar *toolBar;
@property (nonatomic, strong) UIBarButtonItem *finishedItem;
@property (nonatomic, strong) UIButton *selectButton;
@property (nonatomic, strong) UIButton *selectedButton;
@property (nonatomic, strong) UILabel *selectedButtonLabel;

@end

@implementation PIPAlbumDetailPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupPageViewController];
    [self setupToolBar];
    [self setupSelectionViews];
    [self resetSelectionState];
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

- (void)setupToolBar {
    self.toolBar = [[UIToolbar alloc] init];
    self.toolBar.translucent = YES;
    self.finishedItem = [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                                         style:UIBarButtonItemStyleDone
                                                        target:self
                                                        action:@selector(onCommit)];
    [self.toolBar setItems:@[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                           target:nil
                                                                           action:nil],
                             self.finishedItem]];
    [self.view addSubview:self.toolBar];
}

- (void)setupSelectionViews {
    self.selectButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.selectButton setImage:[UIImage imageWithData:[[NSData alloc] initWithBase64EncodedString:@"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" options:kNilOptions] scale:3.0]
                   forState:UIControlStateNormal];
    [self.selectButton addTarget:self action:@selector(handleSelected) forControlEvents:UIControlEventTouchUpInside];
    self.selectButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.selectButton.tintColor = [UIColor grayColor];
    self.selectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.selectedButtonLabel = [[UILabel alloc] init];
    self.selectedButtonLabel.backgroundColor = self.selectedButton.tintColor;
    self.selectedButtonLabel.textColor = [UIColor whiteColor];
    self.selectedButtonLabel.textAlignment = NSTextAlignmentCenter;
    self.selectedButtonLabel.font = [UIFont boldSystemFontOfSize:14];
    self.selectedButtonLabel.layer.cornerRadius = 12;
    self.selectedButtonLabel.layer.masksToBounds = YES;
    [self.selectedButton addSubview:self.selectedButtonLabel];
    [self.selectedButton addTarget:self action:@selector(handleSelected) forControlEvents:UIControlEventTouchUpInside];
}

- (void)handleSelected {
    PIPAlbumDetailPageItemViewController *viewController = self.pageViewController.viewControllers.firstObject;
    if (viewController != nil) {
        if ([self.dataManager.selectedAssets containsObject:viewController.asset]) {
            [self.dataManager.selectedAssets removeObject:viewController.asset];
        }
        else {
            [self.dataManager.selectedAssets addObject:viewController.asset];
            self.selectedButtonLabel.transform = CGAffineTransformMake(0.6, 0.0, 0.0, 0.6, 0.0, 0.0);
            self.selectedButtonLabel.alpha = 0.0;
            [UIView animateWithDuration:0.50 delay:0.10 usingSpringWithDamping:0.6 initialSpringVelocity:16.0 options:kNilOptions animations:^{
                self.selectedButtonLabel.transform = CGAffineTransformMake(1.0, 0.0, 0.0, 1.0, 0.0, 0.0);
                self.selectedButtonLabel.alpha = 1.0;
            } completion:nil];
        }
        [self.dataManager notifySelectedAssetsChanged];
        [self resetSelectionState];
    }
}

- (void)resetSelectionState {
    PIPAlbumDetailPageItemViewController *viewController = self.pageViewController.viewControllers.firstObject;
    if (viewController != nil) {
        NSUInteger selectionIndex = [self.dataManager.selectedAssets indexOfObject:viewController.asset];
        if (selectionIndex != NSNotFound) {
            self.selectedButton.frame = CGRectMake(0, 0, 44, 44);
            self.selectedButtonLabel.frame = CGRectMake(44 - 24, (44 - 24) / 2, 24, 24);
            self.selectedButtonLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)(selectionIndex + 1)];
            UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:self.selectedButton];
            self.navigationItem.rightBarButtonItem = item;
        }
        else {
            self.selectButton.frame = CGRectMake(0, 0, 44, 44);
            self.selectButton.enabled = !(self.dataManager.selectedAssets.count >= self.dataManager.maximumMultipeSelection ||
            (!self.dataManager.allowMultipeSelection && self.dataManager.selectedAssets.count > 0));
            self.selectButton.userInteractionEnabled = self.selectButton.enabled;
            self.selectButton.alpha = self.selectButton.enabled ? 1.0 : 0.35;
            UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:self.selectButton];
            self.navigationItem.rightBarButtonItem = item;
        }
    }
    self.finishedItem.enabled = self.dataManager.selectedAssets.count > 0;
}

- (void)onCommit {
    if ([self.navigationController isKindOfClass:[PIPImagePickerController class]]) {
        [(PIPImagePickerController *)self.navigationController onCommit];
    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.pageViewController.view.frame = CGRectMake(0.0, self.topLayoutGuide.length, self.view.bounds.size.width, self.view.bounds.size.height - 44 - self.topLayoutGuide.length);
    self.toolBar.frame = CGRectMake(0.0, self.view.bounds.size.height - 44, self.view.bounds.size.width, 44);
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

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    [self resetSelectionState];
}

@end
