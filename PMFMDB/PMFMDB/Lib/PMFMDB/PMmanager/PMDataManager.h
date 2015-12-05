//
//  PMDataManager.h
//  PMFMDB
//
//  Created by wsy on 15/12/1.
//  Copyright © 2015年 WSY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PMDataManager : NSObject

+ (instancetype)dataBaseWithDbpath:(NSString *)dbpath;

@property (nonatomic, copy, readonly) NSString *dbpath;

- (NSArray *)getAllTables;

- (NSDictionary *)getTableColumnNamesWithTableName:(NSString *)tableName;

- (NSArray *)getTableAllValueWithTableName:(NSString *)tableName;

- (NSArray *)getTableValueWithSql:(NSString *)sql;

@end
