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
#import "PMDataManager.h"

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
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(didClickCancelItem)];
}

- (void)didClickCancelItem
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
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
                   @"The records that you searched",
                   @"Delete tables"
                   ];
    _dataDescriptions = @[@"All the tables that in you database", @"You can execute SQL in your database what you like", @"The recodes that you have searched.", @"Clear all tables"];
    
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.row < self.classNames.count) {
        NSString *className = self.classNames[indexPath.row];
        if (className) {
            Class class = NSClassFromString(className);
            UIViewController *vc = class.new;
            vc.title = _titles[indexPath.row];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else{
        // Delete all tables
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Are you sure you want to delete all tables?" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            PMDataManager *dataManager = [PMDataManager dataBaseWithDbpath:[[NSUserDefaults standardUserDefaults] objectForKey:kPMDbpathKey]];
            [dataManager deleteAllTables];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }

}

@end
