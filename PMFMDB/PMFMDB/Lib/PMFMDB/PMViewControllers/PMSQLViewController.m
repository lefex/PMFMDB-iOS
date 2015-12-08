//
//  PMSQLViewController.m
//  PMFMDB
//
//  Created by wsy on 15/12/5.
//  Copyright © 2015年 WSY. All rights reserved.
//

#import "PMSQLViewController.h"
#import "PMLinkView.h"
#import "PMLocalSqlViewController.h"
#import "PMTablesViewController.h"
#import "PMDataManager.h"

@interface PMSQLViewController ()<PMLinkViewDelegate>

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) PMLinkView *linkView;

@end

@implementation PMSQLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(cleanTextViewText)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTextColor) name:UITextViewTextDidBeginEditingNotification object: nil];
    [self createTextView];

}

- (void)changeTextColor
{
    [_textView setTextColor:[UIColor blackColor]];
}

- (void)cleanTextViewText
{
    _textView.text = @"";
}

- (void)searchClickAction:(UIButton *)button
{
    NSUInteger index = button.tag - 44444;
    __weak typeof(self) _self = self;
    if (index == 1 || index == 2) {
        PMLocalSqlViewController *localSql = [[PMLocalSqlViewController alloc] init];
        localSql.jumpType = index == 1 ? PMLocalSqlJumpTypeFromLocalSql : PMLocalSqlJumpTypeFromCommonSql;
        localSql.title = index == 1 ? @"PMLocal SQL" : @"PMCommon SQL";
        localSql.completeCB = ^(NSString *selectSql){
            _self.textView.text = selectSql;
        };
        [self.navigationController pushViewController:localSql animated:YES];

    }else if (index == 0){
        PMTablesViewController *tablesVC = [[PMTablesViewController alloc] init];
        tablesVC.title = @"PMTables";
        tablesVC.isSelectedTable = YES;
        tablesVC.completeCB = ^(NSString *tableName){
            [_self setTextViewText:tableName];
        };
        [self.navigationController pushViewController:tablesVC animated:YES];
         
    }else{
        [self runSqlAction];
    }
}

- (void)runSqlAction
{
    if (_textView.text.length == 0) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please input your sql!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
#pragma clang diagnostic pop
        return;
    }
    PMDataManager *dataManager = [PMDataManager dataBaseWithDbpath:[[NSUserDefaults standardUserDefaults] objectForKey:@"dbpath"]];
    
    NSArray *datas;
    _textView.textColor = [UIColor redColor];
    if ([[_textView.text lowercaseString] rangeOfString:@"select"].location == NSNotFound) {
        NSError *error = [dataManager executeWithSql:_textView.text];
        if (error) {
            _textView.text = error.localizedDescription;
        }else{
            _textView.text = @"Execute success";
        }
    }else{
        NSDictionary *dataDict = [dataManager getWithSql:_textView.text];
        datas = dataDict[@"data"];
        NSString *errorMessage = dataDict[@"isSuccess"];
        if (datas.count) {
            _textView.text = datas.debugDescription;
        }else{
            _textView.text = errorMessage;
        }

    }
}

- (void)setTextViewText:(NSString *)linkText
{
    if (_textView.text && _textView.text.length > 0) {
        _textView.text = [NSString stringWithFormat:@"%@ %@", _textView.text, linkText];
    }else{
        _textView.text = linkText;
    }
}

#pragma mark - PMLinkViewDelegate
- (void)linkViewDidClickText:(NSString *)linkText linkView:(PMLinkView *)linkView
{
    _textView.textColor = [UIColor blackColor];
    [self setTextViewText:linkText];
}

- (void)createTextView
{
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    _textView.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:18];
    _textView.textColor = [UIColor blackColor];
    _textView.layer.borderColor = [UIColor blackColor].CGColor;
    _textView.layer.borderWidth = 0.5;
    _textView.keyboardType = UIKeyboardTypeWebSearch;
    [self.view addSubview:_textView];
    
    UIButton *button;
    CGFloat kEdge = 10;
    NSArray *titles = @[@"Tables", @"Local SQL", @"Common SQL", @"Run SQL"];
    CGFloat width = (self.view.frame.size.width - (titles.count+1) * kEdge) / titles.count;
    for (int i = 0; i < titles.count; i++) {
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(kEdge*(i+1) + width*i, CGRectGetMaxY(_textView.frame) + 20, width, 40);
        [button setBackgroundImage:[UIImage imageNamed:@"bgview"] forState:UIControlStateNormal];
        [button setTitle:titles[i] forState:UIControlStateNormal];
        button.tag = 44444+i;
        button.layer.cornerRadius = 5;
        button.layer.masksToBounds = YES;
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        [button addTarget:self action:@selector(searchClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }

    _linkView = [[PMLinkView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(button.frame) + 20, self.view.frame.size.width, 200)];
    _linkView.delegate = self;
    [self.view addSubview:_linkView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
