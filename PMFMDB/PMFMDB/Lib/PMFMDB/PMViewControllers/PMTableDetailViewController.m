//
//  PMTableDetailViewController.m
//  PMFMDB
//
//  Created by wsy on 15/12/2.
//  Copyright © 2015年 WSY. All rights reserved.
//

#import <QuickLook/QuickLook.h>
#import "PMTableDetailViewController.h"
#import "PMListView.h"
#import "PMDataManager.h"
#import "PMCSVManager.h"

@interface PMTableDetailViewController ()<QLPreviewControllerDataSource,QLPreviewControllerDelegate>
{
    PMListView *_columnNameView;
    PMListView *_conditionListView;
    UITextField *_valueTextField;
    
    PMCSVManager *allCSVManager;
    PMCSVManager *partCSVManager;
    
    PMDataManager *_dataManager;
}

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) QLPreviewController *qlPreviewViewController;

@end

static NSString *kTableDetailCellIdentifier = @"tableDetailCellIdentifier";

@implementation PMTableDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = _tableName;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchAllData)];
    _dataManager = [PMDataManager dataBaseWithDbpath:[[NSUserDefaults standardUserDefaults] objectForKey:@"dbpath"]];
    [self createHeaderView];
}

#pragma mark - action
- (void)searchAllData
{
    NSArray *datas = [_dataManager getTableAllValueWithTableName:_tableName];
    NSLog(@"datas = %@", datas);
    allCSVManager = [[PMCSVManager alloc] initData:datas];
}

- (void)searchPartDataAction
{
    if (_columnNameView.topTitle.length == 0  || [_columnNameView.topTitle isEqualToString:@"列名"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please select column name!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        return;
    }
    
    if (_conditionListView.topTitle.length == 0  || [_conditionListView.topTitle isEqualToString:@"条件"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please select condition name!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        return;
    }
    
    if (_valueTextField.text.length == 0 || !_valueTextField.text) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please input value!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        [_valueTextField becomeFirstResponder];
        return;
    }
    
    NSString *sql = [NSString stringWithFormat:@"SELECT *FROM %@ WHERE %@ %@ %@", _tableName, _columnNameView.topTitle, _conditionListView.topTitle, _valueTextField.text];
    NSArray *datas = [_dataManager getTableValueWithSql:sql];
    NSLog(@"datas = %@", datas);

    partCSVManager = [[PMCSVManager alloc] initData:datas];
}

#pragma mark - delegate


// 控制文件预览时显示视图控制器的个数
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller
{
    return 1;
}

- (id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index
{
    NSURL *fileUrl = nil;
    return fileUrl;
}

#pragma mark - createView
- (void)createHeaderView
{
    CGFloat height = 44;
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), height)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.image = [UIImage imageNamed:@"rect"];
    bgView.userInteractionEnabled = YES;
    
    CGFloat width = CGRectGetWidth(self.view.frame)/4.0;
    _columnNameView = [[PMListView alloc] initWithFrame:CGRectMake(0, 0, width+40, height)];
    NSDictionary *columnDict = [_dataManager getTableColumnNamesWithTableName:_tableName];
    _columnNameView.topTitle = @"列名";
    [_columnNameView showInView:self.view];
    [_columnNameView.dataArray addObjectsFromArray:[columnDict allKeys]];
    [bgView addSubview:_columnNameView];
    
    _conditionListView = [[PMListView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_columnNameView.frame), 0, width-20 , height)];
    _conditionListView.topTitle = @"条件";
    [_conditionListView.dataArray addObjectsFromArray:@[@">", @"<", @"=", @">=", @"<=", @"!=", @"like"]];
    [_conditionListView showInView:self.view];
    [bgView addSubview:_conditionListView];
    
    
    _valueTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_conditionListView.frame), 0, width, height)];
    _valueTextField.placeholder = @"值";
    _valueTextField.textAlignment = NSTextAlignmentCenter;
    _valueTextField.font = [UIFont systemFontOfSize:14];
    [bgView addSubview:_valueTextField];
    
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchButton.frame = CGRectMake(CGRectGetMaxX(_valueTextField.frame)+2, 0, width-22, height);
    [searchButton setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    searchButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [searchButton addTarget:self action:@selector(searchPartDataAction) forControlEvents:UIControlEventTouchUpInside];
    [searchButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [bgView addSubview:searchButton];
    
    for (int i = 1; i < 4; i++) {
        CGFloat x = 0;
        if (i == 1) {
            x = width+40;
        }else{
            x = i * width + 20;
        }
        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(x, 5, 1, height-2*5)];
        line.image = [UIImage imageNamed:@"line"];
        [bgView addSubview:line];
    }
    
    [self.view addSubview:bgView];
}

- (void)createPreview
{
    _qlPreviewViewController = [[QLPreviewController alloc] init];
    _qlPreviewViewController.dataSource = self;
    _qlPreviewViewController.delegate = self;
    _qlPreviewViewController.hidesBottomBarWhenPushed = YES;
    _qlPreviewViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-44);
    [self.view addSubview:_qlPreviewViewController.view];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)dealloc
{
    NSLog(@"%@", NSStringFromClass([self class]));
}

@end
