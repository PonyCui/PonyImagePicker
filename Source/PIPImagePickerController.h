//
//  PIPImagePickerController.h
//  PonyImagePicker
//
//  Created by 崔 明辉 on 2018/9/11.
//  Copyright © 2018年 Pony Cui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@class PIPImagePickerController;

@protocol PIPImagePickerControllerDelegate

@required
- (void)imagePicker:(PIPImagePickerController *)imagePickerController
        didFinishPickedImages:(NSArray<UIImage *> *)images;

@end

typedef enum : NSUInteger {
    PIPImagePickerEditorNone = 0,
    PIPImagePickerEditorSquare,
    PIPImagePickerEditorCircle,
} PIPImagePickerEditor;

@interface PIPImagePickerController : UINavigationController

@property (nonatomic, weak) id<PIPImagePickerControllerDelegate> imagePickerDelegate;
@property (nonatomic, assign) BOOL allowMultipeSelection;
@property (nonatomic, assign) NSInteger maximumMultipeSelection;
@property (nonatomic, assign) PHAssetMediaType allowMediaTypes;
@property (nonatomic, assign) BOOL allowMutlipeMediaTypes;
@property (nonatomic, assign) NSInteger maximumBoundsOfImages;
@property (nonatomic, assign) PIPImagePickerEditor editor;

- (void)onCommit;

@end
