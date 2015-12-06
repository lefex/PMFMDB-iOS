//
//  PMCSVFileViewController.m
//  PMFMDB
//
//  Created by wsy on 15/12/5.
//  Copyright © 2015年 WSY. All rights reserved.
//

#import "PMCSVFileViewController.h"
#import <QuickLook/QuickLook.h>


@interface PMCSVFileViewController ()<QLPreviewControllerDataSource,QLPreviewControllerDelegate>
{
    NSMutableArray *_dataArray;
    NSIndexPath *_indexPath;
}
@property (nonatomic, strong) QLPreviewController *qlPreviewViewController;
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
    [[NSFileManager defaultManager] removeItemAtPath:[self csvRootPath] error:&error];
    if (error) {
        NSLog(@"Delete CSV file error :%@", error.localizedDescription);
    }else{
        [self loadData];
    }
}

- (void)loadData
{
    _dataArray = [[[NSFileManager defaultManager] contentsOfDirectoryAtPath:[self csvRootPath] error:nil] mutableCopy];
    [self.tableView reloadData];
}

- (NSString *)csvRootPath
{
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
            stringByAppendingPathComponent:@"pmcsv"];
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
    _indexPath = indexPath;
    [self createPreview];
}

- (UITableViewCellEditingStyle )tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSError *error;
        BOOL isRemove = [[NSFileManager defaultManager] removeItemAtPath:[[self csvRootPath] stringByAppendingPathComponent:_dataArray[indexPath.row] ?: @""] error:&error];
        if (isRemove) {
            [_dataArray removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }else{
            NSLog(@"Delete CSV file error :%@", error.localizedDescription);
        }
    }
}

- (void)createPreview
{
    _qlPreviewViewController = [[QLPreviewController alloc] init];
    _qlPreviewViewController.dataSource = self;
    _qlPreviewViewController.delegate = self;
    _qlPreviewViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:_qlPreviewViewController animated:YES];
}

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller
{
    return 1;
}

- (id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index
{
    NSURL *fileUrl;
    if (_indexPath.row < [_dataArray count]) {
        fileUrl = [NSURL fileURLWithPath:[[self csvRootPath] stringByAppendingPathComponent:_dataArray[_indexPath.row] ?: @""]];
    }
    return fileUrl;

}



@end
