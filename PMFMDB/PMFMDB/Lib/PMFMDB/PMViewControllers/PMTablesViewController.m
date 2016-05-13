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

@interface PMTablesViewController ()<UIAlertViewDelegate>
{
    PMDataManager *_dataManager;
    NSMutableArray *_dataArray;
    
    BOOL _isReducedMode; // Reduced mode
    NSIndexPath *_delIndexPath;
}

@property (nonatomic, strong) NSMutableDictionary *heigthCache;

@end


@implementation PMTablesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.sectionHeaderHeight = 30;
    self.heigthCache = [NSMutableDictionary dictionary];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(rightItemClick)];
    _isReducedMode = YES;
    [self _loadData];
}

- (void)_loadData
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        _dataManager = [PMDataManager dataBaseWithDbpath:[[NSUserDefaults standardUserDefaults] objectForKey:kPMDbpathKey]];
        _dataArray = [[_dataManager getAllTables] mutableCopy];
        
        [_dataManager getDBSize];
       dispatch_async(dispatch_get_main_queue(), ^{
           [self.tableView reloadData];
       });
    });

}

#pragma mark - Action
- (void)rightItemClick
{
    _isReducedMode = !_isReducedMode;
    [self.tableView reloadData];
}

#pragma mark - Delegate
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
    cell.textLabel.text = dict[@"name"];
    if (_isReducedMode) {
        cell.detailTextLabel.text = @"";
        cell.detailTextLabel.numberOfLines = 1;
    }else{
        cell.detailTextLabel.text = dict[@"sql"];
        cell.detailTextLabel.numberOfLines = 0;
    }
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    label.textColor = [UIColor redColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor lightGrayColor];
    label.text = [NSString stringWithFormat:@"size:%@ tables:%@", [_dataManager getDBSize], @(_dataArray.count)];
    return label;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete table data
        _delIndexPath = indexPath;
        NSDictionary *dict = _dataArray[indexPath.row];

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"Are sure dellete table [%@] cache data?", dict[@"name"]] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        [alert show];
    }
#pragma clang diagnostic pop

}

#pragma makr - UIAlertViewDelegate
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        // OK
        if (_delIndexPath) {
            NSDictionary *dict = _dataArray[_delIndexPath.row];
            [_dataManager deleteTableCacheWihtName:dict[@"name"]];
        }
    }
}
#pragma clang diagnostic pop

- (CGFloat)getHeightWithIndexPath:(NSIndexPath *)indexPath
{
    if (_isReducedMode) {
        return 44;
    }
    
    CGFloat rowHeight = 0;
    NSDictionary *dict = _dataArray[indexPath.row];
    NSString *tableName = dict[@"name"];
    NSString *sql = dict[@"sql"];

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
