//
//  PMCSVFileViewController.m
//  PMFMDB
//
//  Created by wsy on 15/12/5.
//  Copyright © 2015年 WSY. All rights reserved.
//

#import "PMCSVFileViewController.h"
#import "PMFilePreviewViewController.h"
#import "PMHelper.h"

@interface PMCSVFileViewController ()
{
    NSMutableArray *_dataArray;
}
@end

static NSString *kTableCellIdentifier = @"csvCellIdentifier";

@implementation PMCSVFileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteAllData)];
    [self loadData];
}

- (void)deleteAllData
{
    NSError *error;
    [[NSFileManager defaultManager] removeItemAtPath:[PMHelper csvRootPath] error:&error];
    if (error) {
        NSLog(@"Delete CSV file error :%@", error.localizedDescription);
    }else{
        [self loadData];
    }
}

- (void)loadData
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        _dataArray = [[[NSFileManager defaultManager] contentsOfDirectoryAtPath:[PMHelper csvRootPath] error:nil] mutableCopy];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kTableCellIdentifier];
    }
    cell.textLabel.text = _dataArray[indexPath.row] ?: @"";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *filePath = [[PMHelper csvRootPath] stringByAppendingPathComponent:_dataArray[indexPath.row] ?: @""];
    PMFilePreviewViewController *previewVC = [[PMFilePreviewViewController alloc] initWithFilePath:filePath];
    [self.navigationController pushViewController:previewVC animated:YES];
}

- (UITableViewCellEditingStyle )tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSError *error;
        BOOL isRemove = [[NSFileManager defaultManager] removeItemAtPath:[[PMHelper csvRootPath] stringByAppendingPathComponent:_dataArray[indexPath.row] ?: @""] error:&error];
        if (isRemove) {
            [_dataArray removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }else{
            NSLog(@"Delete CSV file error :%@", error.localizedDescription);
        }
    }
}


@end
