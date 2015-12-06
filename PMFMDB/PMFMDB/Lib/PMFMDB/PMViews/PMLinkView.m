//
//  PMLinkView.m
//  PMFMDB
//
//  Created by wsy on 15/12/6.
//  Copyright © 2015年 WSY. All rights reserved.
//

#import "PMLinkView.h"
#import "PMTextView.h"

@interface PMLinkView ()<UITextViewDelegate, NSLayoutManagerDelegate>

@property (nonatomic, strong) PMTextView *containTextView;

@end

@implementation PMLinkView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:CGSizeZero];
    textContainer.lineBreakMode = NSLineBreakByWordWrapping;
    textContainer.lineFragmentPadding = 10;
    textContainer.maximumNumberOfLines = 5;
    textContainer.heightTracksTextView = YES;
    textContainer.widthTracksTextView = YES;
    
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
    layoutManager.delegate = self;
    [layoutManager addTextContainer:textContainer];
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:@""];
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString: attStr];

    NSArray *links = [[self linkText] componentsSeparatedByString:@","];
    for (int i = 0; i < links.count; i++) {
        NSString *linkStr = links[i];
        linkStr = [linkStr uppercaseString];
        NSMutableAttributedString *linkAtt = [[NSMutableAttributedString alloc] initWithString:linkStr];
        NSRange textRange = NSMakeRange(0, linkStr.length);
        [linkAtt addAttribute:NSLinkAttributeName value:linkStr range:textRange];
        [linkAtt addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:textRange];
        [linkAtt addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:textRange];
        [linkAtt addAttribute:NSStrokeColorAttributeName value:[UIColor blackColor] range:textRange];
        [linkAtt addAttribute:NSStrokeWidthAttributeName value:@(1) range:textRange];
        NSShadow *shadow = [[NSShadow alloc] init];
        shadow.shadowBlurRadius = 3;
        shadow.shadowColor = [UIColor blackColor];
        shadow.shadowOffset = CGSizeMake(0, 0);
        [linkAtt  addAttribute:NSShadowAttributeName value:shadow range:textRange];
        [textStorage appendAttributedString: linkAtt];
        [textStorage appendAttributedString:[[NSAttributedString alloc] initWithString:@"  "]];

    }
    
    [textStorage addLayoutManager:layoutManager];
    
    _containTextView = [[PMTextView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) textContainer:textContainer];
    _containTextView.editable = NO;
    _containTextView.delegate = self;
    [self addSubview:_containTextView];
}

- (NSString *)linkText
{
    return @"select,update,from,delete,insert into,alter,where,order by,group by,count(*),distinct,inner join,left join,like,desc,asc,having,set,and,or";
}

#pragma mark - NSLayoutManagerDelegate
- (CGFloat)layoutManager:(NSLayoutManager *)layoutManager lineSpacingAfterGlyphAtIndex:(NSUInteger)glyphIndex withProposedLineFragmentRect:(CGRect)rect
{
    return 5.0;
}


#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange
{
    return NO;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(linkViewDidClickText:linkView:)]) {
        [self.delegate linkViewDidClickText:[textView.text substringWithRange:characterRange] linkView:self];
    }
    return NO;
}
@end
