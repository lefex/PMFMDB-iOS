//
//  PMLinkView.h
//  PMFMDB
//
//  Created by wsy on 15/12/6.
//  Copyright © 2015年 WSY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PMLinkView;

@protocol PMLinkViewDelegate <NSObject>

- (void)linkViewDidClickText:(NSString *)linkText linkView:(PMLinkView *)linkView;

@end

@interface PMLinkView : UIView

@property (nonatomic, assign) id<PMLinkViewDelegate> delegate;

@end
