//
//  PMMainViewController.h
//  PMFMDB
//
//  Created by wsy on 15/12/1.
//  Copyright © 2015年 WSY. All rights reserved.
//

// The main view controllelr
/**
 *  If you want you PMFMDB in you project, you should do as below:
 *
 *  PMMainViewController *mainViewController = [[PMMainViewController alloc] init];
 *  mainViewController.dataPath = [self messageDBPath];
 *  UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:mainViewController];
 * [self presentViewController:nav animated:YES completion:nil];
 *
 *  If you want to execute SQL in you DB, you can select a templete SQL or
 *  input you SQL in plist file PMExecuteSql.plist
 */

#import <UIKit/UIKit.h>

@interface PMMainViewController : UITableViewController

/**
 *  The DB path of you project, you must set the valid DB path, not nil
 */
@property (nonatomic, copy) NSString *dataPath;

@end
