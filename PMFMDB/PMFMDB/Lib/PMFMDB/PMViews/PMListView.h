//
//  PMListView.h
//  PMFMDB
//
//  Created by wsy on 15/12/2.
//  Copyright © 2015年 WSY. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PMListViewDelegate <NSObject>

- (void)listViewDidSelectIndexTitle:(NSString *)text;

@end

@interface PMListView : UIView

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) CGFloat rowHeight;
@property (nonatomic, assign) id<PMListViewDelegate> delegate;
@property (nonatomic, copy) NSString *topTitle;


@end
