//
//  PMListViewCell.m
//  PMFMDB
//
//  Created by wsy on 15/12/5.
//  Copyright © 2015年 WSY. All rights reserved.
//

#import "PMListViewCell.h"

@interface PMListViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation PMListViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
        _titleLabel.backgroundColor = [UIColor greenColor];
    }
    return self;
}

- (void)createUI
{
    _titleLabel = [[UILabel alloc] initWithFrame:self.contentView.frame];
    NSLog(@"contentView = %@", NSStringFromCGRect(self.contentView.frame));
     NSLog(@"self = %@", NSStringFromCGRect(self.frame));
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_titleLabel];
}

- (void)setTitleText:(NSString *)titleText
{
    _titleText = titleText;
    _titleLabel.text = titleText;
}

@end
