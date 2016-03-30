//
//  ViewController.m
//  TestApp
//
//  Created by Yurii on 3/29/16.
//  Copyright © 2016 Nostris. All rights reserved.
//

#import "ListViewController.h"
#import "DataModel.h"
#import "Item.h"
#import "ItemTableViewCell.h"
#import "NetworkModel.h"
#import "DetailViewController.h"

@interface ListViewController ()
//@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *data;
@property (nonatomic) BOOL isLoading;
@property (nonnull, strong) DataModel *dataModel;
@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak ListViewController *weakSelf = self;
    self.dataModel = [DataModel new];
    [self.dataModel getCashedDataWithCallback:^(BOOL status, id result) {
        if (status) {
            [weakSelf reloadData:result];
        }
        
    }];
//    UIRefreshControl *refreshControl = [UIRefreshControl new];
//    [refreshControl addTarget:self action:@selector(update:) forControlEvents:UIControlEventValueChanged];
//    [self.tableView addSubview:refreshControl];

    [self update:nil];
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    Item *item = self.data[indexPath.row];
    ((DetailViewController *)segue.destinationViewController).item = item;
}
-(IBAction)update:(UIRefreshControl *)refreshControl {
    if (self.isLoading)
        return;
    self.isLoading = YES;
    
    __weak ListViewController *weakSelf = self;
    
    [self.dataModel loadDataFromNetwork:^(BOOL status, id result) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [refreshControl endRefreshing];
            weakSelf.isLoading = NO;
        });
        if (status) {
            [weakSelf reloadData:result];
        } else {
            [weakSelf showError:result];
        }
    }];
}
- (void)showError:(NSError *)error {
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)reloadData:(NSArray *)result {
    self.data = result;
    __weak ListViewController *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.tableView reloadData];
    });
}
#pragma UITableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ItemTableViewCell *cell = (ItemTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"ItemCell" forIndexPath:indexPath];
    Item *item = self.data[indexPath.row];
    cell.titleLabel.text = item.title;
    __weak ListViewController* weakSelf = self;
    [[NetworkModel shareIntance] downloadImage:[NSURL URLWithString:item.media] callback:^(BOOL status, id result) {
        if (!status) {
            return ;
        }
        if (indexPath.row == [weakSelf.tableView indexPathForCell:cell].row) {
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.thumbView.image = [UIImage imageWithContentsOfFile:result];
            });
            
        }
    }];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
@end
