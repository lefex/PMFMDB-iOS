//
//  PMLocalSqlViewController.h
//  PMFMDB
//
//  Created by wsy on 15/12/6.
//  Copyright © 2015年 WSY. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, PMLocalSqlJumpType) {
    PMLocalSqlJumpTypeFromLocalSql,
    PMLocalSqlJumpTypeFromCommonSql,
    PMLocalSqlJumpTypeFromTables
};

@interface PMLocalSqlViewController : UITableViewController

@property (nonatomic, assign) PMLocalSqlJumpType jumpType;

@property (nonatomic, copy) void(^completeCB)(NSString *selectSql);

@end
