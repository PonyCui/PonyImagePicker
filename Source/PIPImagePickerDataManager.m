//
//  PIPImagePickerDataManager.m
//  PonyImagePicker
//
//  Created by 崔 明辉 on 2018/9/11.
//  Copyright © 2018年 Pony Cui. All rights reserved.
//

#import "PIPImagePickerDataManager.h"
#import <Photos/Photos.h>

@implementation PIPImagePickerDataManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        _allowMultipeSelection = YES;
        _maximumMultipeSelection = 9;
        _allowMediaTypes = PHAssetMediaTypeImage;
        _allowMutlipeMediaTypes = NO;
        _selectedAssets = [NSMutableArray array];
    }
    return self;
}

- (void)grantPermission:(void (^)(void))resolver rejecter:(void (^)(void))rejecter {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted ||
        status == PHAuthorizationStatusDenied) {
        rejecter();
    }
    else if (status == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (status == PHAuthorizationStatusRestricted ||
                    status == PHAuthorizationStatusDenied) {
                    rejecter();
                }
                else if (status == PHAuthorizationStatusAuthorized) {
                    resolver();
                }
            });
        }];
    }
    else if (status == PHAuthorizationStatusAuthorized) {
        resolver();
    }
}

- (NSArray<PHAssetCollection *> *)fetchAssetCollectionsItems {
    NSMutableArray *albums = [NSMutableArray array];
    PHFetchResult *smartAlbums = [PHAssetCollection
                                  fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
                                  subtype:PHAssetCollectionSubtypeAlbumRegular
                                  options:nil];
    if (smartAlbums.count > 0) {
        [smartAlbums enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [albums addObject:obj];
        }];
    }
    PHFetchResult *userAlbums = [PHAssetCollection
                                 fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum
                                 subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary
                                 options:nil];
    if (userAlbums.count > 0) {
        [userAlbums enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [albums addObject:obj];
        }];
    }
    return [albums copy];
}

- (NSArray<PHAsset *> *)fetchAssetsItems:(PHCollection *)inCollection {
    if (inCollection != nil) {
        NSMutableArray<PHAsset *> *assets = [NSMutableArray array];
        PHFetchOptions *option = [[PHFetchOptions alloc] init];
        option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate"
                                                                 ascending:YES]];
        PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:(id)inCollection
                                                              options:option];
        if (result.count > 0) {
            [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [assets addObject:obj];
            }];
        }
        return [assets copy];
    }
    else {
        NSMutableArray<PHAsset *> *assets = [NSMutableArray array];
        PHFetchOptions *option = [[PHFetchOptions alloc] init];
        option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate"
                                                                 ascending:YES]];
        PHFetchResult *result = [PHAsset fetchAssetsWithMediaType:self.allowMediaTypes
                                                          options:option];
        if (result.count > 0) {
            [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [assets addObject:obj];
            }];
        }
        return [assets copy];
    }
}

- (void)notifySelectedAssetsChanged {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PIPImagePickerDataManagerSelectedAssetsChanged" object:nil];
}

@end
