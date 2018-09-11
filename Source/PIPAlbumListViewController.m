//
//  PIPAlbumListViewController.m
//  PonyImagePicker
//
//  Created by 崔 明辉 on 2018/9/11.
//  Copyright © 2018年 Pony Cui. All rights reserved.
//

#import "PIPAlbumListViewController.h"
#import "PIPAlbumDetailViewController.h"

@interface PIPAlbumListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<PHAssetCollection *> *assetCollections;

@end

@implementation PIPAlbumListViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"照片";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                                  initWithTitle:@"取消"
                                                  style:UIBarButtonItemStylePlain
                                                  target:self action:@selector(onCancel)];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupTableView];
    [self fetchData];
    [self.tableView reloadData];
}

- (void)setupTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (void)onCancel {
    [self dismissViewControllerAnimated:YES completion:^{ }];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

#pragma mark - Datas

- (void)fetchData {
    self.assetCollections = [self.dataManager fetchAssetCollectionsItems];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return self.assetCollections.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 66.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:reuseIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.section == 0) {
        cell.textLabel.text = @"全部照片";
    }
    else if (indexPath.section == 1) {
        if (indexPath.row < self.assetCollections.count) {
            PHAssetCollection *assetCollection = self.assetCollections[indexPath.row];
            cell.textLabel.text = assetCollection.localizedTitle;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.dataManager.selectedAssets removeAllObjects];
    if (indexPath.section == 0) {
        PIPAlbumDetailViewController *detailViewController = [[PIPAlbumDetailViewController alloc] init];
        detailViewController.dataManager = self.dataManager;
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
    else if (indexPath.section == 1) {
        if (indexPath.row < self.assetCollections.count) {
            PIPAlbumDetailViewController *detailViewController = [[PIPAlbumDetailViewController alloc] init];
            detailViewController.assetColleciton = self.assetCollections[indexPath.row];
            detailViewController.dataManager = self.dataManager;
            [self.navigationController pushViewController:detailViewController animated:YES];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
