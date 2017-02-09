//
//  AddAccessoryViewController.m
//  HomeKitDemo
//
//  Created by XuChengcheng on 2017/2/9.
//  Copyright © 2017年 xcc. All rights reserved.
//

#import "AddNewAccessoryViewController.h"

@interface AddNewAccessoryViewController () <HMAccessoryBrowserDelegate>

@property (nonatomic, strong) HMAccessoryBrowser *accessoryBrowser;
@property (nonatomic, strong) NSMutableArray *accessoryArray;

@end

@implementation AddNewAccessoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Add New Accessory";
    
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(doneItemClicked:)];
    self.navigationItem.rightBarButtonItem = doneItem;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.accessoryBrowser = [[HMAccessoryBrowser alloc] init];
    self.accessoryBrowser.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.accessoryBrowser startSearchingForNewAccessories];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.accessoryBrowser stopSearchingForNewAccessories];
}

- (IBAction)doneItemClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSMutableArray *)accessoryArray {
    if (_accessoryArray == nil) {
        _accessoryArray = [NSMutableArray array];
    }
    
    return _accessoryArray;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.accessoryArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    HMAccessory *accessory = self.accessoryArray[indexPath.row];
    cell.textLabel.text = accessory.name;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.homeManager.primaryHome addAccessory:[self.accessoryArray objectAtIndex:indexPath.row] completionHandler:^(NSError *error){
        
        if (error) {
            NSLog(@"error in adding accessory: %@", error);
        } else {
            NSLog(@"add accessory success");
        }
    }];
}

#pragma mark - HMAccessoryBrowserDelegate

- (void)accessoryBrowser:(HMAccessoryBrowser *)browser didFindNewAccessory:(HMAccessory *)accessory {
    [self.accessoryArray addObject:accessory];
    [self.tableView reloadData];
}

- (void)accessoryBrowser:(HMAccessoryBrowser *)browser didRemoveNewAccessory:(HMAccessory *)accessory {
    [self.accessoryArray removeObject:accessory];
    [self.tableView reloadData];
}




@end
