//
//  PMTablesViewController.m
//  PMFMDB
//
//  Created by wsy on 15/12/2.
//  Copyright © 2015年 WSY. All rights reserved.
//

#import "PMTablesViewController.h"
#import "PMDataManager.h"

@interface PMTablesViewController ()
{
    PMDataManager *_dataManager;
    NSMutableArray *_dataArray;
}
@end

static NSString *kTableCellIdentifier = @"tableCellIdentifier";

@implementation PMTablesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"PMTables";
    [self loadData];
}

- (void)loadData
{
    _dataManager = [PMDataManager dataBaseWithDbpath:[self messageDBPath]];
    _dataArray = [[_dataManager getAllTables] mutableCopy];
    [_dataManager getTableSchema];
}

- (NSString *)messageDBPath
{
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
            stringByAppendingPathComponent:@"message.db"];
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
    return 200;
}

@end
