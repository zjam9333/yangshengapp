//
//  ProductListViewController.m
//  yangsheng
//
//  Created by Macx on 17/7/9.
//  Copyright © 2017年 jam. All rights reserved.
//

#import "ProductListViewController.h"
#import "HomeHttpTool.h"
#import "ProductCell.h"

@interface ProductListViewController ()
{
    NSArray* data;
}
@end

@implementation ProductListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadMore];
    // Do any additional setup after loading the view.
}

-(void)refresh
{
    [HomeHttpTool getProductListType:[self.idd integerValue] page:1 success:^(NSArray *datasource) {
        data=datasource;
        [self.tableView reloadData];
        [self stopRefreshAfterSeconds];
        if (data.count>0) {
            self.currentPage=1;
        }
    } isCache:NO];
}

-(void)loadMore
{
    
    [HomeHttpTool getProductListType:[self.idd integerValue] page:1+self.currentPage success:^(NSArray *datasource) {
        NSMutableArray* arr=[NSMutableArray array];
        [arr addObjectsFromArray:data?:[NSArray array]];
        [arr addObjectsFromArray:datasource];
        data=arr;
        [self.tableView reloadData];
        if (datasource.count>0) {
            self.currentPage++;
        }
        self.shouldLoadMore=datasource.count>=20;
        
    } isCache:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return data.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0001;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductCell* ce=[tableView dequeueReusableCellWithIdentifier:@"ProductCell" forIndexPath:indexPath];
    BaseModel* m=[data objectAtIndex:indexPath.row];
    [ce.proImageView sd_setImageWithURL:[m.thumb urlWithMainUrl]];
    [ce.proTitle setText:m.post_title];
    [ce.proContent setText:m.post_subtitle];
    return ce;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BaseModel* m=[data objectAtIndex:indexPath.row];
    BaseWebViewController* we=[[BaseWebViewController alloc]initWithUrl:[html_product_detail urlWithMainUrl]];
    we.idd=m.idd.integerValue;
    we.title=@"产品详情";
    [self.navigationController pushViewController:we animated:YES];
    
}

@end