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
        formatter.dateStyle = NSDateFormatterLongStyle;
        NSString *dateStr = [formatter stringFromDate:[NSDate date]];
        _dataArray = [data copy];
        _filePath = [[self csvRootPath] stringByAppendingPathComponent:dateStr];
        _csvWrite = [[CHCSVWriter alloc] initForWritingToCSVFile: _filePath];
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
