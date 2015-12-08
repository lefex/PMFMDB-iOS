//
//  PMLocalSqlViewController.m
//  PMFMDB
//
//  Created by wsy on 15/12/6.
//  Copyright © 2015年 WSY. All rights reserved.
//

#import "PMLocalSqlViewController.h"
#import "PMDataManager.h"

@interface PMLocalSqlViewController ()
{
    NSDictionary *_dataDict;
}
@property (nonatomic, strong) NSMutableDictionary *heigthCache;

@end

static NSString *kTableCellIdentifier = @"localSqlCellIdentifier";

@implementation PMLocalSqlViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteAllData)];
    self.navigationItem.rightBarButtonItem.enabled = _jumpType == PMLocalSqlJumpTypeFromLocalSql;
    self.heigthCache = [NSMutableDictionary dictionary];

    [self loadData];
}

- (void)deleteAllData
{
    _dataDict = [NSDictionary dictionary];
    [_dataDict writeToFile:[self localSqlPath] atomically:YES];
     [self loadData];
}

- (void)loadData
{
     _dataDict = [NSDictionary dictionaryWithContentsOfFile:[self localSqlPath]];
    [self.tableView reloadData];
}

- (NSString *)localSqlPath
{
    NSString *fileName = @"";
    if (_jumpType == PMLocalSqlJumpTypeFromLocalSql) {
        fileName = @"PMExecuteSql";
    }else if (_jumpType == PMLocalSqlJumpTypeFromCommonSql){
        fileName = @"PMCommonSql";
    }
    return [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataDict.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kTableCellIdentifier];
    }
    cell.textLabel.text = [_dataDict allValues][indexPath.row] ?: @"";
    cell.textLabel.numberOfLines = 0;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self getHeightWithIndexPath:indexPath];;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.completeCB ? self.completeCB([_dataDict allValues][indexPath.row] ?: @"") : nil;
    [self.navigationController popViewControllerAnimated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)getHeightWithIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowHeight = 0;
    NSString *sql = [_dataDict allValues][indexPath.row] ?: @"";
    NSString *sqlKey = [_dataDict allKeys][indexPath.row];

    if (self.heigthCache[sqlKey]) {
        rowHeight = [self.heigthCache[sqlKey] floatValue];
    }else{
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
        CGSize rowSize =  [sql sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(CGRectGetWidth(self.view.frame) - 20, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
        rowHeight = rowSize.height + 20;
#pragma clang diagnostic pop
        [self.heigthCache setObject:@(rowHeight) forKey:sqlKey];
    }
    return (rowHeight < 40 ? 44 : rowHeight);
}

@end
