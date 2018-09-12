//
//  PIPAlbumDetailViewController.m
//  PonyImagePicker
//
//  Created by 崔 明辉 on 2018/9/11.
//  Copyright © 2018年 Pony Cui. All rights reserved.
//

#import "PIPAlbumDetailViewController.h"
#import "PIPAssetCollectionViewCell.h"
#import "PIPAlbumDetailPageViewController.h"
#import "PIPImagePickerController.h"

@interface PIPAlbumDetailViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionViewFlowLayout *collectionFlowLayout;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray<PHAsset *> *collectionAssets;
@property (nonatomic, strong) UIToolbar *toolBar;
@property (nonatomic, strong) UIBarButtonItem *previewItem;
@property (nonatomic, strong) UIBarButtonItem *finishedItem;
@property (nonatomic, strong) id selectionChangedObserver;

@end

@implementation PIPAlbumDetailViewController

- (void)dealloc
{
    if (self.selectionChangedObserver != nil) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.selectionChangedObserver];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupNavigationItems];
    [self setupCollectionView];
    [self setupToolBar];
    [self setupObserver];
    [self fetchAssets];
}

- (void)setupNavigationItems {
    if (self.assetColleciton == nil) {
        self.title = @"所有照片";
    }
    else {
        self.title = self.assetColleciton.localizedTitle;
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(onCancel)];
}

- (void)setupCollectionView {
    self.collectionFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionFlowLayout.sectionInset = UIEdgeInsetsMake(4, 4, 4, 4);
    self.collectionFlowLayout.minimumLineSpacing = 0;
    self.collectionFlowLayout.minimumInteritemSpacing = 4;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                             collectionViewLayout:self.collectionFlowLayout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.showsVerticalScrollIndicator = NO;
    if (!self.dataManager.allowMultipeSelection) {
        self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    else {
        self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0);
    }
    [self.collectionView registerClass:[PIPAssetCollectionViewCell class]
            forCellWithReuseIdentifier:@"AssetCell"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
}

- (void)setupToolBar {
    self.toolBar = [[UIToolbar alloc] init];
    if (!self.dataManager.allowMultipeSelection) {
        self.toolBar.hidden = YES;
    }
    self.toolBar.translucent = YES;
    self.previewItem = [[UIBarButtonItem alloc] initWithTitle:@"预览"
                                                        style:UIBarButtonItemStyleDone
                                                       target:self
                                                       action:@selector(onPreview)];
    self.finishedItem = [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                                         style:UIBarButtonItemStyleDone
                                                        target:self
                                                        action:@selector(onCommit)];
    [self.toolBar setItems:@[self.previewItem,
                             [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                           target:nil
                                                                           action:nil],
                             self.finishedItem]];
    [self.view addSubview:self.toolBar];
}

- (void)setupObserver {
    __weak PIPAlbumDetailViewController *welf = self;
    self.selectionChangedObserver = [[NSNotificationCenter defaultCenter] addObserverForName:@"PIPImagePickerDataManagerSelectedAssetsChanged" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        PIPAlbumDetailViewController *strongSelf = welf;
        if (strongSelf != nil) {
            for (PIPAssetCollectionViewCell *cell in [strongSelf.collectionView visibleCells]) {
                [cell resetSelectionState];
            }
            strongSelf.previewItem.enabled = self.dataManager.selectedAssets.count > 0;
            strongSelf.finishedItem.enabled = self.dataManager.selectedAssets.count > 0;
        }
    }];
}

- (void)onCancel {
    [self dismissViewControllerAnimated:YES completion:^{ }];
}

- (void)onPreview {
    PIPAlbumDetailPageViewController *pageViewController = [[PIPAlbumDetailPageViewController alloc] init];
    pageViewController.dataManager = self.dataManager;
    pageViewController.currentAsset = self.dataManager.selectedAssets.firstObject;
    pageViewController.collectionAssets = self.dataManager.selectedAssets.copy;
    [self.navigationController pushViewController:pageViewController animated:YES];
}

- (void)onCommit {
    if ([self.navigationController isKindOfClass:[PIPImagePickerController class]]) {
        [(PIPImagePickerController *)self.navigationController onCommit];
    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.collectionView.frame = self.view.bounds;
    self.toolBar.frame = CGRectMake(0, self.view.bounds.size.height - 44, self.view.bounds.size.width, 44);
    [self.collectionFlowLayout invalidateLayout];
}

#pragma mark - Data

- (void)fetchAssets {
    self.collectionAssets = [self.dataManager fetchAssetsItems:self.assetColleciton];
    [self.collectionView reloadData];
    if (self.collectionAssets.count > 0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.collectionAssets.count - 1 inSection:0]
                                        atScrollPosition:UICollectionViewScrollPositionBottom
                                                animated:NO];
        });
    }
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.collectionAssets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PIPAssetCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AssetCell"
                                                                                 forIndexPath:indexPath];
    if (indexPath.row < self.collectionAssets.count) {
        [cell setData:self.collectionAssets[indexPath.row] viewController:self];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.collectionAssets.count) {
        PIPAlbumDetailPageViewController *pageViewController = [[PIPAlbumDetailPageViewController alloc] init];
        pageViewController.dataManager = self.dataManager;
        pageViewController.currentAsset = self.collectionAssets[indexPath.row];
        pageViewController.collectionAssets = self.collectionAssets;
        [self.navigationController pushViewController:pageViewController animated:YES];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((collectionView.bounds.size.width - 4 * 5) / 4,
                      (collectionView.bounds.size.width - 4 * 5) / 4 + 4);
}

@end
