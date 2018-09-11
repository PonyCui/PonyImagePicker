//
//  PIPImagePickerDataManager.h
//  PonyImagePicker
//
//  Created by 崔 明辉 on 2018/9/11.
//  Copyright © 2018年 Pony Cui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface PIPImagePickerDataManager : NSObject

@property (nonatomic, assign) BOOL allowMultipeSelection;
@property (nonatomic, assign) PHAssetMediaType allowMediaTypes;
@property (nonatomic, assign) BOOL allowMutlipeMediaTypes;

- (void)grantPermission:(nonnull void (^)(void))resolver
               rejecter:(nonnull void (^)(void))rejecter;

- (nonnull NSArray<PHAssetCollection *> *)fetchAssetCollectionsItems;

- (nonnull NSArray<PHAsset *> *)fetchAssetsItems:(nullable PHCollection *)inCollection;

@end
