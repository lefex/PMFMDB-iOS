//
//  PMTableDetailViewController.m
//  PMFMDB
//
//  Created by wsy on 15/12/2.
//  Copyright © 2015年 WSY. All rights reserved.
//

#import "PMTableDetailViewController.h"
#import "PMListView.h"
#import "PMDataManager.h"

@interface PMTableDetailViewController ()
{
    PMListView *_columnNameView;
    PMDataManager *_dataManager;
}

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

static NSString *kTableDetailCellIdentifier = @"tableDetailCellIdentifier";

@implementation PMTableDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = _tableName;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchAllData)];
    _dataManager = [PMDataManager dataBaseWithDbpath:[[NSUserDefaults standardUserDefaults] objectForKey:@"dbpath"]];
    [self createHeaderView];
}

#pragma mark - action
- (void)searchAllData
{
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableDetailCellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kTableDetailCellIdentifier];
    }
    
    return cell;
}

- (void)createHeaderView
{
    CGFloat height = 44;
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), height)];
    bgView.image = [UIImage imageNamed:@"rect"];
    bgView.userInteractionEnabled = YES;
    
    CGFloat width = CGRectGetWidth(self.view.frame)/4.0;
    _columnNameView = [[PMListView alloc] initWithFrame:CGRectMake(0, 0, width+40, height)];
    NSDictionary *columnDict = [_dataManager getTableColumnNamesWithTableName:_tableName];
    _columnNameView.topTitle = @"列名";
    [_columnNameView.dataArray addObjectsFromArray:[columnDict allKeys]];
    [bgView addSubview:_columnNameView];
    
    PMListView *conditionListView = [[PMListView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_columnNameView.frame), 0, width-20 , height)];
    conditionListView.topTitle = @"条件";
    [conditionListView.dataArray addObjectsFromArray:@[@">", @"<", @"=", @">=", @"<=", @"!=", @"like"]];
    [bgView addSubview:conditionListView];
    
    
    UITextField *valueTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(conditionListView.frame), 0, width, height)];
    valueTextField.placeholder = @"值";
    valueTextField.font = [UIFont systemFontOfSize:14];
    [bgView addSubview:valueTextField];
    
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchButton.frame = CGRectMake(CGRectGetMaxX(valueTextField.frame)+2, 0, width-22, height);
    [searchButton setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    searchButton.titleLabel.font = [UIFont systemFontOfSize:14];
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


@end
