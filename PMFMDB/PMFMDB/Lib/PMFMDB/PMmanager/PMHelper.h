//
//  PMHelper.h
//  PMFMDB
//
//  Created by wsy on 15/12/8.
//  Copyright © 2015年 WSY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PMHelper : NSObject

+ (float)pmGetTextHeightWithText:(NSString *)text width:(float)width;

/**
 *  CSV files root path, if you want to change it, you can change it with
 *  a new file path.
 *
 *  @return the CSV file root path
 */
+ (NSString *)csvRootPath;

@end
