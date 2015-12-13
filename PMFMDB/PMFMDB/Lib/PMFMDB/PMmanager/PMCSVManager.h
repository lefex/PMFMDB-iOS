//
//  PMCSVManager.h
//  PMFMDB
//
//  Created by wsy on 15/12/5.
//  Copyright © 2015年 WSY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PMCSVManager : NSObject

- (instancetype)initData:(NSArray *)data;

@property (nonatomic, readonly) NSString *filePath;

@end

/**
 This class is intend to write data in CSV file
 
 - returns: 
 */
@interface PMCSVWriter : NSObject

- (instancetype)initForWritingToCSVFile:(NSString *)path;

- (void)writeField:(id)field;

- (void)finishLine;

@end
