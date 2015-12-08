//
//  PMFilePreviewViewController.m
//  PMFMDB
//
//  Created by wsy on 15/12/8.
//  Copyright © 2015年 WSY. All rights reserved.
//

#import "PMFilePreviewViewController.h"

@interface PMFilePreviewViewController ()<QLPreviewControllerDataSource,QLPreviewControllerDelegate>


@end

@implementation PMFilePreviewViewController

- (instancetype)initWithFilePath:(NSString *)filePath
{
    self = [super init];
    if (self) {
        self.filePath = filePath;
        [self _createPreviewViewController];
    }
    return self;
}

- (void)_createPreviewViewController
{
    if (!_qlPreviewViewController) {
        _qlPreviewViewController = [[QLPreviewController alloc] init];
        _qlPreviewViewController.dataSource = self;
        _qlPreviewViewController.delegate = self;
        _qlPreviewViewController.hidesBottomBarWhenPushed = YES;
    }
}

- (void)reloadData
{
    [_qlPreviewViewController reloadData];
}

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller
{
    return 1;
}

- (id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index
{
    NSURL *fileUrl;
    if (_filePath) {
        fileUrl = [NSURL fileURLWithPath:_filePath];
    }
    return fileUrl;
}

@end
