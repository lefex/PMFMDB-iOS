//
//  PMCSVManager.m
//  PMFMDB
//
//  Created by wsy on 15/12/5.
//  Copyright © 2015年 WSY. All rights reserved.
//

#import "PMCSVManager.h"
#import "CHCSVParser.h"

@interface PMCSVManager ()
{
    CHCSVWriter *_csvWrite;
    NSArray *_dataArray;
}
@end

@implementation PMCSVManager

- (instancetype)initData:(NSArray *)data
{
    self = [super init];
    if (self) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSString *dateStr = [formatter stringFromDate:[NSDate date]];
        _dataArray = [data copy];
        NSString *rootPath = [self csvRootPath];
        NSError *error;
        [[NSFileManager defaultManager] createDirectoryAtPath:rootPath withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            NSLog(@"create csv file error %@", error.localizedDescription);
        }
        _filePath = [[[self csvRootPath] stringByAppendingPathComponent:dateStr] stringByAppendingPathExtension:@"csv"];
        _csvWrite = [[CHCSVWriter alloc] initForWritingToCSVFile: _filePath];
        [self writeToFile];
    }
    return self;
}

- (void)writeToFile
{
    if (!_dataArray.count) {
        return;
    }
    
    // 写列名
    for (NSString *columnName in [[_dataArray firstObject] allKeys]) {
        [_csvWrite writeField:columnName];
    }
    [_csvWrite finishLine];
    
    // 写数据
    for (NSDictionary *dataDict in _dataArray) {
        for (NSString *columnValue in [dataDict allValues]) {
            [_csvWrite writeField:columnValue];
        }
        [_csvWrite finishLine];
    }
    
}

- (NSString *)csvRootPath
{
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
            stringByAppendingPathComponent:@"pmcsv"];
}




@end
