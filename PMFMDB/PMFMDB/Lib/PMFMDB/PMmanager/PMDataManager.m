//
//  PMDataManager.m
//  PMFMDB
//
//  Created by wsy on 15/12/1.
//  Copyright © 2015年 WSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PMDataManager.h"
#import "FMDB.h"
#import "PMDataSql.h"

@interface PMDataManager ()
{
    FMDatabaseQueue *_dbQueue;
    FMDatabase *_db;
}
@end

@implementation PMDataManager

+ (instancetype)dataBaseWithDbpath:(NSString *)dbpath
{
    static dispatch_once_t pred = 0;
    __strong static id defaultDataBaseManager = nil;
    dispatch_once( &pred, ^{
        defaultDataBaseManager = [[self alloc] initWithDataBasePath:dbpath];
        
    });
    return defaultDataBaseManager;
}

- (instancetype)initWithDataBasePath:(NSString *)dbpath
{
    self = [super init];
    if (self) {
        if (!dbpath || dbpath.length == 0) {
            NSLog(@"Db path is can not nill");
            
        }else{
            _dbpath = dbpath;
            _db = [FMDatabase databaseWithPath:dbpath];
            _dbQueue = [FMDatabaseQueue databaseQueueWithPath: dbpath];
            
            /**
             *  This is not user, if you want to test PMFMDB, you can create 
             *  tables and test it
             */
            [self createTbale];
        }
    }
    return self;
}

- (NSString *)getDBSize
{
    NSDictionary *att = [[NSFileManager defaultManager] attributesOfItemAtPath:_dbpath error:nil];
    NSUInteger totalSize = [[att objectForKey:NSFileSize] longLongValue];
    NSUInteger tempSize = totalSize/1024;
    if (tempSize >= 1024) {
        CGFloat temMB = tempSize/1024.0;
        if (temMB >= 1024.0) {
            CGFloat temGB = temMB/1024.0;
            return [NSString stringWithFormat:@"%.2f GB",temGB];
        }else{
            return [NSString stringWithFormat:@"%.2f MB",temMB];
        }
    }
    CGFloat KBSize = totalSize/1024.0;
    return [NSString stringWithFormat:@"%.2f KB",KBSize];;
}

- (NSArray *)getAllTables
{
    __block NSMutableArray *results = [NSMutableArray array];
    [_dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *set = [db executeQuery: get_all_table_sql];
        while ([set next]) {
            NSString *name = [set stringForColumn:@"name"];
            NSString *sql = [set stringForColumn:@"sql"];
            if ([name isKindOfClass:[NSNull class]]) {
                name = @"";
            }
            if ([sql isKindOfClass:[NSNull class]]) {
                sql = @"";
            }
            NSDictionary *tableDict = @{@"name":name?:@"", @"sql":sql?:@""};
            [results addObject:tableDict];
        }
    }];
    return results;
}

- (NSArray *)getAllIndexs
{
    __block NSMutableArray *results = [NSMutableArray array];
    [_dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *set = [db executeQuery: get_all_table_sql];
        while ([set next]) {
            NSString *name = [set stringForColumn:@"name"];
            NSString *sql = [set stringForColumn:@"sql"];
            if ([name isKindOfClass:[NSNull class]]) {
                name = @"";
            }
            if ([sql isKindOfClass:[NSNull class]]) {
                sql = @"";
            }
            NSDictionary *tableDict = @{@"name":name?:@"", @"sql":sql?:@""};
            [results addObject:tableDict];
        }
    }];
    return results;
}

- (NSDictionary *)getTableColumnNamesWithTableName:(NSString *)tableName
{
    __block NSDictionary *results = [NSDictionary dictionary];
    [_dbQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ LIMIT 1", tableName];
        FMResultSet *set = [db executeQuery: sql];
        while ([set next]) {
            results = [set columnNameToIndexMap];
        }
    }];
    return results;
}

- (NSArray *)getTableValueWithSql:(NSString *)sql
{
    __block NSMutableArray *results = [NSMutableArray array];
    [_dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *set = [db executeQuery: sql];
        while ([set next]) {
            NSDictionary *tableDict = [set resultDictionary];
            if (tableDict) {
                [results addObject:tableDict];
            }
        }
    }];
    return results;
}

- (NSMutableArray *)getWithSql:(NSString *)sql
{
    __block NSMutableArray *results = [NSMutableArray array];

    [_dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *set = [db executeQuery: sql];
        while ([set next]) {
            NSDictionary *tableDict = [set resultDictionary];
            if (tableDict) {
                [results addObject:tableDict];
            }
        }
    }];
    
    return results;
}

- (NSError *)executeWithSql:(NSString *)sql
{
    __block NSError *error;
    __block BOOL isSuccess;
    [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
      isSuccess = [db executeUpdate:sql withErrorAndBindings:&error];
    }];
    if (isSuccess) {
        return nil;
    }
    return error;

}

- (NSArray *)getTableAllValueWithTableName:(NSString *)tableName
{
    __block NSMutableArray *results = [NSMutableArray array];
    [_dbQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@", tableName];
        FMResultSet *set = [db executeQuery: sql];
        while ([set next]) {
            NSDictionary *tableDict = [set resultDictionary];
            if (tableDict) {
                [results addObject:tableDict];
            }
        }
    }];
    return results;
}

- (NSString *)sqlIsValid:(NSString *)sql
{
    __block NSError *error;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        [db validateSQL:sql error:&error];
    }];
    if (error) {
        return error.localizedDescription;
    }else{
        return nil;
    }
}

- (void)deleteTableCacheWihtName:(NSString *)name
{
    [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM %@", name]];
    }];
}

- (void)deleteAllTables
{
    NSArray *tableNames = [self getAllTables];
    for (NSDictionary *dict in tableNames) {
        NSString *tableName = dict[@"name"];
        [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            [db executeUpdate:[NSString stringWithFormat:@"DROP TABLE %@", tableName]];
        }];
    }
}

/**
 *  create table if you want to test FMFMDB
 */
- (void)createTbale
{
    [_dbQueue inDatabase:^(FMDatabase *db) {
        // 创建数据表
        NSString * myDBcreate_NameList_table_Sql = @"create table if not exists PMNameList (NLname varchar(100) primary key, NLaddTime varchar(100), NLmoreMessage varchar(200))";
        
        NSString * myDBcreate_NameListDetail_table_sql = @"create table if not exists PMDetail (NLDnameNumber integer primary key autoincrement, NLDname varchar(20) not null, NLDsex char(2), NLDtelphone char(11), NLDmoreMessage varchar(200), NLDnameListName varchar(100), NLP_flag char(5))";
        
        NSString * myDBcreate_NameListHistory_table_sql = @"create table if not exists PMHistory(NLHnameNumber integer primary key autoincrement, NLHname varchar(100), NLHtime varchar(50))";
        
        NSString * myDBcreate_NameListStatistic_table_sql = @"create table if not exists PMStatistic(NLSname varchar(100), NLSpersonNumber interger, NLSflag char(5),NLS_time char(20))";
        
        [db executeUpdate:myDBcreate_NameList_table_Sql];
        [db executeUpdate:myDBcreate_NameListDetail_table_sql];
        [db executeUpdate:myDBcreate_NameListHistory_table_sql];
        [db executeUpdate:myDBcreate_NameListStatistic_table_sql];
        
        [db executeUpdate:@"insert into PMNameList (NLname, NLaddTime, NLmoreMessage) values ('精简点名', '2015-12-12', 'This is first name list')"];
        [db executeUpdate:@"insert into PMNameList (NLname, NLaddTime, NLmoreMessage) values ('精简点名APP', '2015-12-12', 'This is second t name list')"];
        [db executeUpdate:@"insert into PMNameList (NLname, NLaddTime, NLmoreMessage) values ('wsyxyxs@126.com', '2015-12-12', 'A app')"];
        
         [db executeUpdate:@"insert into PMDetail (NLDname, NLDsex, NLDtelphone, NLDmoreMessage, NLDnameListName) values ('wsyxyxs@126.com', '男', '15601147566', 'BeiJin', '精简点名')"];
        [db executeUpdate:@"insert into PMDetail (NLDname, NLDsex, NLDtelphone, NLDmoreMessage, NLDnameListName) values ('wsyxyxs@126.com', '男', '15601147566', 'BeiJin', '精简点名')"];
        [db executeUpdate:@"insert into PMDetail (NLDname, NLDsex, NLDtelphone, NLDmoreMessage, NLDnameListName) values ('wsyxyxs@126.com', '男', '15601147566', 'BeiJin', '精简点名APP')"];
        
        
    }];
}
     
@end
