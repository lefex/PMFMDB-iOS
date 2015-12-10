//
//  PMConfigure.h
//  PMFMDB
//
//  Created by wsy on 15/12/8.
//  Copyright © 2015年 WSY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PMConfigure : NSObject

/**
 *  The data base path that store in NSUserDefaults. If you have the same key in you project
 *   as the NSUserDefaults key , you must replace it.
 */
extern NSString *const kPMDbpathKey;

/**
 *  The root path that store the search reslut
 *  The path as /Application/2252DA41-08D0-4D1F-8FC5-87C565559F7A/Documents/pmcsv/2015-12-9 21:24.30.csv
 */
extern NSString *const kPMCSVFileRootPathName;

@end
