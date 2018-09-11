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

@interface PIPAlbumDetailViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionViewFlowLayout *collectionFlowLayout;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray<PHAsset *> *collectionAssets;

@end

@implementation PIPAlbumDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupNavigationItems];
    [self setupCollectionView];
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
    [self.collectionView registerClass:[PIPAssetCollectionViewCell class]
            forCellWithReuseIdentifier:@"AssetCell"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
}

- (void)onCancel {
    [self dismissViewControllerAnimated:YES completion:^{ }];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.collectionView.frame = self.view.bounds;
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
        [cell setData:self.collectionAssets[indexPath.row]];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.collectionAssets.count) {
        PIPAlbumDetailPageViewController *pageViewController = [[PIPAlbumDetailPageViewController alloc] init];
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
