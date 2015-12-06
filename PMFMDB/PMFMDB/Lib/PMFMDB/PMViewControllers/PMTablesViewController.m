//
//  PMTablesViewController.m
//  PMFMDB
//
//  Created by wsy on 15/12/2.
//  Copyright © 2015年 WSY. All rights reserved.
//

#import "PMTablesViewController.h"
#import "PMTableDetailViewController.h"
#import "PMDataManager.h"

@interface PMTablesViewController ()
{
    PMDataManager *_dataManager;
    NSMutableArray *_dataArray;
}

@property (nonatomic, strong) NSMutableDictionary *heigthCache;

@end

static NSString *kTableCellIdentifier = @"tableCellIdentifier";

@implementation PMTablesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.heigthCache = [NSMutableDictionary dictionary];
    [self loadData];
}

- (void)loadData
{
    _dataManager = [PMDataManager dataBaseWithDbpath:[[NSUserDefaults standardUserDefaults] objectForKey:@"dbpath"]];
    _dataArray = [[_dataManager getAllTables] mutableCopy];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kTableCellIdentifier];
    }
    NSDictionary *dict = _dataArray[indexPath.row];
    cell.textLabel.text = dict[@"name"] ?: @"";
    cell.detailTextLabel.text = dict[@"sql"] ?: @"";
    cell.detailTextLabel.numberOfLines = 0;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self getHeightWithIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isSelectedTable) {
        self.completeCB ? self.completeCB(_dataArray[indexPath.row][@"name"]) : nil;
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        PMTableDetailViewController *tableDetailVC = [[PMTableDetailViewController alloc] init];
        tableDetailVC.tableName = _dataArray[indexPath.row][@"name"];
        [self.navigationController pushViewController:tableDetailVC animated:YES];
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)getHeightWithIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowHeight = 0;
    NSDictionary *dict = _dataArray[indexPath.row];
    NSString *tableName = dict[@"name"] ?: @"";
    NSString *sql = dict[@"sql"] ?: @"";
    if (self.heigthCache[tableName]) {
        rowHeight = [self.heigthCache[tableName] floatValue];
    }else{
        CGSize rowSize =  [sql sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(CGRectGetWidth(self.view.frame) - 20, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
        rowHeight = rowSize.height + 20;
        [self.heigthCache setObject:@(rowHeight) forKey:tableName];
    }
    return (rowHeight < 40 ? 44 : rowHeight);
}

@end
