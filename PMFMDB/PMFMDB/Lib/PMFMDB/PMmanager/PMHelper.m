//
//  PMHelper.m
//  PMFMDB
//
//  Created by wsy on 15/12/8.
//  Copyright © 2015年 WSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PMHelper.h"
#import "PMConfigure.h"

@implementation PMHelper

+ (float)pmGetTextHeightWithText:(NSString *)text width:(float)width
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
    CGSize rowSize =  [text sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(width - 20, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    return  rowSize.height + 20;
#pragma clang diagnostic pop
}

+ (NSString *)csvRootPath
{
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
            stringByAppendingPathComponent:kPMCSVFileRootPathName];
}

@end
