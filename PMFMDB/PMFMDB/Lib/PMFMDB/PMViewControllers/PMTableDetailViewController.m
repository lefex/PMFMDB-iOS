//
//  PMTableDetailViewController.m
//  PMFMDB
//
//  Created by wsy on 15/12/2.
//  Copyright © 2015年 WSY. All rights reserved.
//

#import "PMTableDetailViewController.h"
#import "PMFilePreviewViewController.h"
#import "PMListView.h"
#import "PMDataManager.h"
#import "PMCSVManager.h"
#import "PMConfigure.h"

@interface PMTableDetailViewController ()<PMListViewDelegate>
{
    PMListView *_columnNameView;
    PMListView *_conditionListView;
    UITextField *_valueTextField;
    
    PMCSVManager *allCSVManager;
    PMCSVManager *partCSVManager;
    
    NSString *_filePath;
    
    PMDataManager *_dataManager;
}

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) PMFilePreviewViewController *filePreviewController;

@end


@implementation PMTableDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = _tableName;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(_searchAllData)];
    _dataManager = [PMDataManager dataBaseWithDbpath:[[NSUserDefaults standardUserDefaults] objectForKey:kPMDbpathKey]];
    [self createHeaderView];
}

#pragma mark - action
- (void)_searchAllData
{
    if ([_valueTextField isFirstResponder]) {
        [_valueTextField resignFirstResponder];
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray *datas = [_dataManager getTableAllValueWithTableName:_tableName];
        if (datas.count) {
            allCSVManager = [[PMCSVManager alloc] initData:datas];
            _filePath = allCSVManager.filePath;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (datas.count) {
                [self createPreview];
            }else{
                [self alertNoData];
            }

        });
    });
}

- (void)alertNoData
{    
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"There is No data" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
#pragma clang diagnostic pop

}

- (void)_searchPartDataAction
{
    if ([_valueTextField isFirstResponder]) {
        [_valueTextField resignFirstResponder];
    }
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
    if (_columnNameView.topTitle.length == 0  || [_columnNameView.topTitle isEqualToString:@"Cloumn"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please select column name!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        return;
    }
    
    if (_conditionListView.topTitle.length == 0  || [_conditionListView.topTitle isEqualToString:@"Condition"]) {
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
#pragma clang diagnostic pop
    
    NSString *sql = [NSString stringWithFormat:@"SELECT *FROM %@ WHERE %@ %@ %@", _tableName, _columnNameView.topTitle, _conditionListView.topTitle, _valueTextField.text];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray *datas = [_dataManager getTableValueWithSql:sql];
        if (datas.count > 0) {
            partCSVManager = [[PMCSVManager alloc] initData:datas];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!datas.count) {
                [self alertNoData];
            }else{
                _filePath = partCSVManager.filePath;
                [self createPreview];
            }
        });
    });
    
}

#pragma mark - PMListViewDelegate
- (void)listViewWillClickTopView:(PMListView *)listView
{
    if ([_valueTextField isFirstResponder]) {
        [_valueTextField resignFirstResponder];
    }
    [_filePreviewController.qlPreviewViewController.view removeFromSuperview];
    _filePreviewController = nil;
}

#pragma mark - createView
- (void)createHeaderView
{
    CGFloat height = 44;
    CGFloat topY = 0;
    if (CGRectGetMinY(self.view.frame) == 20) {
        topY = 44;
    }else if (CGRectGetMinY(self.view.frame) == 64){
        topY = 0;
    }else if (CGRectGetMinY(self.view.frame) == 0){
        topY = 64;
    }
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, topY, CGRectGetWidth(self.view.frame), height)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.image = [UIImage imageNamed:@"rect"];
    bgView.userInteractionEnabled = YES;
    
    CGFloat width = CGRectGetWidth(self.view.frame)/4.0;
    _columnNameView = [[PMListView alloc] initWithFrame:CGRectMake(0, 0, width+40, height)];
    _columnNameView.topTitle = @"Cloumn";
    _columnNameView.delegate = self;
    [_columnNameView showInView:self.view];
    [bgView addSubview:_columnNameView];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSDictionary *columnDict = [_dataManager getTableColumnNamesWithTableName:_tableName];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_columnNameView.dataArray addObjectsFromArray:[columnDict allKeys]];
        });

    });
    
    _conditionListView = [[PMListView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_columnNameView.frame), 0, width-20, height)];
    _conditionListView.topTitle = @"Condition";
    _conditionListView.delegate = self;
    [_conditionListView showInView:self.view];
    [bgView addSubview:_conditionListView];
    [_conditionListView.dataArray addObjectsFromArray:@[@"",@"",@">", @"<", @"=", @">=", @"<=", @"!=", @"like"]];
    
    
    _valueTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_conditionListView.frame), 0, width, height)];
    _valueTextField.placeholder = @"Value";
    _valueTextField.textAlignment = NSTextAlignmentCenter;
    _valueTextField.font = [UIFont systemFontOfSize:14];
    [bgView addSubview:_valueTextField];
    
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchButton.frame = CGRectMake(CGRectGetMaxX(_valueTextField.frame)+2, 0, width-22, height);
    [searchButton setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    searchButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [searchButton addTarget:self action:@selector(_searchPartDataAction) forControlEvents:UIControlEventTouchUpInside];
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
    if (!_filePreviewController) {
        _filePreviewController = [[PMFilePreviewViewController alloc] initWithFilePath:_filePath];
        _filePreviewController.qlPreviewViewController.view.frame = CGRectMake(0, 64+44, self.view.frame.size.width, self.view.frame.size.height-44-64);
        [self.view addSubview:_filePreviewController.qlPreviewViewController.view];
    }
    _filePreviewController.filePath = _filePath;
    [_filePreviewController reloadData];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
