//
//  PMCSVManager.m
//  PMFMDB
//
//  Created by wsy on 15/12/5.
//  Copyright © 2015年 WSY. All rights reserved.
//

#import "PMCSVManager.h"
#import "PMHelper.h"

@interface PMCSVManager ()
{
    PMCSVWriter *_csvWrite;
    NSArray *_dataArray;
}
@end

@implementation PMCSVManager

- (instancetype)initData:(NSArray *)data
{
    self = [super init];
    if (self) {
        self.contentMaxLength = 50;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSString *dateStr = [formatter stringFromDate:[NSDate date]];
        _dataArray = [data copy];
        NSString *rootPath = [PMHelper csvRootPath];
        
        NSError *error;
        [[NSFileManager defaultManager] createDirectoryAtPath:rootPath withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            NSLog(@"create csv file error %@", error.localizedDescription);
        }
        _filePath = [[[PMHelper csvRootPath] stringByAppendingPathComponent:dateStr] stringByAppendingPathExtension:@"csv"];
        _csvWrite = [[PMCSVWriter alloc] initForWritingToCSVFile: _filePath];
        [self writeToFile];
    }
    return self;
}

- (void)writeToFile
{
    if (!_dataArray.count) {
        return;
    }
    
    
    // write cloumn name
    for (NSString *columnName in [[_dataArray firstObject] allKeys]) {
        [_csvWrite writeField:columnName];
    }
    [_csvWrite finishLine];
    
    // write data
    for (NSDictionary *dataDict in _dataArray) {
        for (NSString *columnValue in [dataDict allValues]) {
            if ([columnValue isKindOfClass:[NSString class]]) {
                if (columnValue.length <= self.contentMaxLength) {
                    [_csvWrite writeField:columnValue];
                }else{
                    [_csvWrite writeField:[columnValue substringToIndex:self.contentMaxLength]];
                }
            }else{
                 [_csvWrite writeField:columnValue];
            }
        }
        [_csvWrite finishLine];
    }
    
}

@end


@interface PMCSVWriter ()
{
    NSOutputStream *_stream;
    NSStringEncoding _streamEncoding;
    
    NSData *_delimiter;
    NSData *_bom;
    NSCharacterSet *_illegalCharacters;
    
    NSUInteger _currentField;
}
@end

@implementation PMCSVWriter
- (instancetype)initForWritingToCSVFile:(NSString *)path
{
    NSOutputStream *stream = [NSOutputStream outputStreamToFileAtPath:path append:NO];
    return [self initWithOutputStream:stream encoding:NSUTF8StringEncoding delimiter:','];
}

- (instancetype)initWithOutputStream:(NSOutputStream *)stream encoding:(NSStringEncoding)encoding delimiter:(unichar)delimiter {
    self = [super init];
    if (self) {
        _stream = stream;
        _streamEncoding = encoding;
        
        if ([_stream streamStatus] == NSStreamStatusNotOpen) {
            [_stream open];
        }
        
        NSData *a = [@"a" dataUsingEncoding:_streamEncoding];
        NSData *aa = [@"aa" dataUsingEncoding:_streamEncoding];
        if ([a length] * 2 != [aa length]) {
            NSUInteger characterLength = [aa length] - [a length];
            _bom = [a subdataWithRange:NSMakeRange(0, [a length] - characterLength)];
            [self _writeData:_bom];
        }
        
        NSString *delimiterString = [NSString stringWithFormat:@"%C", delimiter];
        NSData *delimiterData = [delimiterString dataUsingEncoding:_streamEncoding];
        if ([_bom length] > 0) {
            _delimiter = [delimiterData subdataWithRange:NSMakeRange([_bom length], [delimiterData length] - [_bom length])];
        } else {
            _delimiter = delimiterData;
        }
        
        NSMutableCharacterSet *illegalCharacters = [[NSCharacterSet newlineCharacterSet] mutableCopy];
        [illegalCharacters addCharactersInString:delimiterString];
        [illegalCharacters addCharactersInString:@"\""];
        _illegalCharacters = [illegalCharacters copy];
    }
    return self;
}

- (void)dealloc {
    [self closeStream];
}

- (void)_writeData:(NSData *)data {
    if ([data length] > 0) {
        const void *bytes = [data bytes];
        [_stream write:bytes maxLength:[data length]];
    }
}

- (void)_writeString:(NSString *)string {
    NSData *stringData = [string dataUsingEncoding:_streamEncoding];
    if ([_bom length] > 0) {
        stringData = [stringData subdataWithRange:NSMakeRange([_bom length], [stringData length] - [_bom length])];
    }
    [self _writeData:stringData];
}

- (void)_writeDelimiter {
    [self _writeData:_delimiter];
}

- (void)writeField:(id)field {
    if (_currentField > 0) {
        [self _writeDelimiter];
    }
    NSString *string = field ? [field description] : @"";
    if ([string rangeOfCharacterFromSet:_illegalCharacters].location != NSNotFound) {
        // replace double quotes with double double quotes
        string = [string stringByReplacingOccurrencesOfString:@"\"" withString:@"\"\""];
        // surround in double quotes
        string = [NSString stringWithFormat:@"\"%@\"", string];
    }
    [self _writeString:string];
    _currentField++;
}

- (void)finishLine {
    [self _writeString:@"\n"];
    _currentField = 0;
}

- (void)_finishLineIfNecessary {
    if (_currentField != 0) {
        [self finishLine];
    }
}

- (void)writeLineOfFields:(id<NSFastEnumeration>)fields {
    [self _finishLineIfNecessary];
    
    for (id field in fields) {
        [self writeField:field];
    }
    [self finishLine];
}

- (void)writeComment:(NSString *)comment
{
    [self _finishLineIfNecessary];
    
    NSArray *lines = [comment componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    for (NSString *line in lines) {
        NSString *commented = [NSString stringWithFormat:@"#%@\n", line];
        [self _writeString:commented];
    }
}

- (void)closeStream
{
    [_stream close];
    _stream = nil;
}

@end








