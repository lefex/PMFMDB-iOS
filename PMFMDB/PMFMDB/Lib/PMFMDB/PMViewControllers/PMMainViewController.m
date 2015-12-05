//
//  PMMainViewController.m
//  PMFMDB
//
//  Created by wsy on 15/12/1.
//  Copyright © 2015年 WSY. All rights reserved.
//

#import "PMMainViewController.h"
#import "PMTablesViewController.h"

static NSString *kCellIdentifier = @"mainCellIdentifier";

@interface PMMainViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSArray *_dataArray;
}

@end

@implementation PMMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"PMFMDB";
    _tableView.tableFooterView = [[UIView alloc] init];
    [self createUI];
    [self configureMainVCData];
}

- (void)configureMainVCData
{
    _dataArray = @[@"所有的表",
                   @"执行SQL语句",
                   @"查询记录"
                   ];
    
}

- (void)createUI
{
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.sectionFooterHeight = 0;
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
}

- (void)setDataPath:(NSString *)dataPath
{
    _dataPath = dataPath;
    [[NSUserDefaults standardUserDefaults] setObject:dataPath forKey:@"dbpath"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
    }
    cell.textLabel.text = _dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        PMTablesViewController *tablesVC = [[PMTablesViewController alloc] init];
        [self.navigationController pushViewController:tablesVC animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end