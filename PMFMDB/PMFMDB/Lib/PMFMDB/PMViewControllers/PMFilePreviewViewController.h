//
//  PMFilePreviewViewController.h
//  PMFMDB
//
//  Created by wsy on 15/12/8.
//  Copyright © 2015年 WSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuickLook/QuickLook.h>

@interface PMFilePreviewViewController : UIViewController

@property (nonatomic, copy) NSString *filePath;

@property (nonatomic, strong) QLPreviewController *qlPreviewViewController;

- (instancetype)initWithFilePath:(NSString *)filePath;

- (void)reloadData;

@end
