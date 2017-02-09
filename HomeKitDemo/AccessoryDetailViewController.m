//
//  AccessoryDetailViewController.m
//  HomeKitDemo
//
//  Created by XuChengcheng on 2017/2/9.
//  Copyright © 2017年 xcc. All rights reserved.
//

#import "AccessoryDetailViewController.h"
#import "ServiceDetailViewController.h"

@interface AccessoryDetailViewController ()

@end

@implementation AccessoryDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.accessory.name;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.accessory.services.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    HMService *service = self.accessory.services[indexPath.row];
    cell.textLabel.text = service.name;
    cell.detailTextLabel.text = service.localizedDescription;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ServiceDetailViewController *vc = [[ServiceDetailViewController alloc] init];
    vc.service = self.accessory.services[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}





@end
