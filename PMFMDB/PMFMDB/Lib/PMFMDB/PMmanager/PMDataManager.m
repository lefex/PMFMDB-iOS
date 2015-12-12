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

@end
