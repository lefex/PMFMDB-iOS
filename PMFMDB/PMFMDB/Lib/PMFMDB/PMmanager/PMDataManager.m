//
//  PMDataManager.m
//  PMFMDB
//
//  Created by wsy on 15/12/1.
//  Copyright © 2015年 WSY. All rights reserved.
//

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

        }
    }
    return self;
}

- (NSArray *)getAllTables
{
    __block NSMutableArray *results = [NSMutableArray array];
    [_dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *set = [db executeQuery: get_all_table_sql];
        while ([set next]) {
            NSDictionary *tableDict = [set resultDictionary];
            if (tableDict) {
                [results addObject:tableDict];
            }
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
        results = [set columnNameToIndexMap];
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




- (BOOL)createMessageDB
{
    FMDatabase *messageDB = [[FMDatabase alloc] initWithPath:_dbpath];
    if (![messageDB open]) {
        NSLog(@"messageDB 数据库打开失败");
        return NO;
    }
    
    // 创建信息详情表
    NSString *createStr = @"create table if not exists messageTable(mesMainKeyId integer primary key autoincrement,mesChatId varchar(30), mesChatTo varchar(1000), mesChatTime varchar(30), mesChatKey varchar(1000), mesFrom varchar(50), mesTo varchar(50), mesType char(20),mesBody varchar(2000), mesIsSend char(4), mesChatSubject varchar(50), mesBadge char(3),mesMessageId char(1),mesIsSuccessSend char(2));";
    
    NSString *createIndex = @"create index messageIndex on messageTable(mesMainKeyId)";
    
    BOOL result = [messageDB executeUpdate:createStr];
    [messageDB executeUpdate:createIndex];
    
    [messageDB close];
    if (!result) {
        NSLog(@"创建数据库失败");
    }
    return result;
    
}


@end
