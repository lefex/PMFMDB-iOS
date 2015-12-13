//
//  PMMainViewController.m
//  PMFMDB
//
//  Created by wsy on 15/12/1.
//  Copyright © 2015年 WSY. All rights reserved.
//

#import "PMMainViewController.h"
#import "PMTablesViewController.h"
#import "PMCSVFileViewController.h"
#import "PMSQLViewController.h"
#import "PMConfigure.h"

@interface PMMainViewController ()

@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, strong) NSMutableArray *classNames;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSArray *dataDescriptions;

@end

@implementation PMMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"PMFMDB";
    self.titles = @[].mutableCopy;
    self.classNames = @[].mutableCopy;

    self.tableView.tableFooterView = [[UIView alloc] init];
    [self _configureMainVCData];
}

- (void)_addTitle:(NSString *)title className:(NSString *)name
{
    [self.titles addObject:title];
    [self.classNames addObject:name];
}

- (void)_configureMainVCData
{
    [self _addTitle:@"PMTables" className:@"PMTablesViewController"];
    [self _addTitle:@"PMSQL" className:@"PMSQLViewController"];
    [self _addTitle:@"PMCSV" className:@"PMCSVFileViewController"];
    
    _dataArray = @[@"All tables",
                   @"Execute SQL",
                   @"The records that you searched"
                   ];
    _dataDescriptions = @[@"All the tables that in you database", @"You can execute SQL in your database what you like", @"The recodes that you have searched."];
    
}

- (void)setDataPath:(NSString *)dataPath
{
    _dataPath = dataPath;
    [[NSUserDefaults standardUserDefaults] setObject:dataPath forKey:kPMDbpathKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *kCellIdentifier = @"mainCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCellIdentifier];
    }
    cell.textLabel.text = _dataArray[indexPath.row];
    cell.detailTextLabel.text = _dataDescriptions[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *className = self.classNames[indexPath.row];
    if (className) {
        Class class = NSClassFromString(className);
        UIViewController *vc = class.new;
        vc.title = _titles[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end