//
//  PMListView.m
//  PMFMDB
//
//  Created by wsy on 15/12/2.
//  Copyright © 2015年 WSY. All rights reserved.
//

#import "PMListView.h"

@interface PMListView ()<UITableViewDataSource, UITableViewDelegate>
{
    CGFloat topViewHeigth;
    CGFloat listWidth;
    UIView *_showView;
    BOOL isShow;
    CGRect oldFrame;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *topButton;

@end

@implementation PMListView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        oldFrame = frame;
        topViewHeigth = CGRectGetHeight(frame);
        listWidth =  CGRectGetWidth(frame);
        _dataArray = [NSMutableArray array];
        _rowHeight = 30;
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    [self createTopButton];
    [self createTableView];
}

- (void)createTopButton
{
    _topButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _topButton.frame = CGRectMake(0, 0, listWidth, topViewHeigth);
    [_topButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_topButton addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    _topButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:_topButton];
}

- (void)setTopTitle:(NSString *)topTitle
{
    _topTitle = topTitle;
    [_topButton setTitle:topTitle forState:UIControlStateNormal];

}

- (void)buttonClick
{
    if (isShow) {
        [self hidenListView];
    }else{
        [self showListView];
    }
    [_tableView reloadData];
}

- (void)showInView:(UIView *)showView
{
    _showView = showView;
}

- (void)hidenListView
{
    isShow = NO;
    [UIView animateWithDuration:0.3 animations:^{
       _tableView.frame = CGRectMake(0, topViewHeigth, listWidth, 0);
    } completion:^(BOOL finished) {
        self.frame = CGRectMake(oldFrame.origin.x, oldFrame.origin.y, listWidth, topViewHeigth);
        NSLog(@"hiden %@", NSStringFromCGRect(self.frame));
    }];
}

- (void)showListView
{
    isShow = YES;
    self.frame = CGRectMake(oldFrame.origin.x, oldFrame.origin.y, listWidth,  [self getListViewHeight] + topViewHeigth);
    NSLog(@"show %@", NSStringFromCGRect(self.frame));
    
    [UIView animateWithDuration:0.2 animations:^{
        _tableView.frame = CGRectMake(0, topViewHeigth, listWidth, [self getListViewHeight]);
    } completion:^(BOOL finished) {
        
    }];

}

- (CGFloat)getListViewHeight
{
    CGFloat scrHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat maxHeight = scrHeight - 200;
    CGFloat totoalHeight = _dataArray.count * _rowHeight;
    return MIN(maxHeight, totoalHeight);
}

- (void)createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, topViewHeigth, listWidth, 0) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.sectionFooterHeight = 0;
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.rowHeight = self.rowHeight;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"listCell"];
    [self addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"listCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = _dataArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
