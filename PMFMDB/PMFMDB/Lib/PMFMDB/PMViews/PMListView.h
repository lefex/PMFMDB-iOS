//
//  PMListView.h
//  PMFMDB
//
//  Created by wsy on 15/12/2.
//  Copyright © 2015年 WSY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PMListView;

@protocol PMListViewDelegate <NSObject>

- (void)listViewDidSelectIndexTitle:(NSString *)text;
- (void)listViewWillClickTopView:(PMListView *)listView;

@end

@interface PMListView : UIView

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) CGFloat rowHeight;
@property (nonatomic, assign) id<PMListViewDelegate> delegate;
@property (nonatomic, copy) NSString *topTitle;

- (void)showInView:(UIView *)showView;

@end
