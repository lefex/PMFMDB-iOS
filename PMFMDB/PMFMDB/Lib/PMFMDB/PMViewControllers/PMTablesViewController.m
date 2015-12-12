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
#import "PMHelper.h"
#import "PMConfigure.h"

@interface PMTablesViewController ()
{
    PMDataManager *_dataManager;
    NSMutableArray *_dataArray;
}

@property (nonatomic, strong) NSMutableDictionary *heigthCache;

@end


@implementation PMTablesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.heigthCache = [NSMutableDictionary dictionary];
    [self _loadData];
}

- (void)_loadData
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        _dataManager = [PMDataManager dataBaseWithDbpath:[[NSUserDefaults standardUserDefaults] objectForKey:kPMDbpathKey]];
        _dataArray = [[_dataManager getAllTables] mutableCopy];
       dispatch_async(dispatch_get_main_queue(), ^{
           [self.tableView reloadData];
       });
    });

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *kTableCellIdentifier = @"tableCellIdentifier";
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
    if (tableName.length == 0 || sql.length == 0) return 44;
    
    if (self.heigthCache[tableName]) {
        rowHeight = [self.heigthCache[tableName] floatValue];
    }else{
        rowHeight = [PMHelper pmGetTextHeightWithText:sql width:CGRectGetWidth(self.view.frame) - 20];
        [self.heigthCache setObject:@(rowHeight) forKey:tableName];
    }
    return (rowHeight < 44 ? 44 : rowHeight);
}

@end
