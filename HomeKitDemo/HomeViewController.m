//
//  HomeViewController.m
//  HomeKitDemo
//
//  Created by XuChengcheng on 2017/2/7.
//  Copyright © 2017年 xcc. All rights reserved.
//

#import "HomeViewController.h"
#import "UIView+ATAdditions.h"
#import <HomeKit/HomeKit.h>
#import "AddNewAccessoryViewController.h"
#import "AccessoryDetailViewController.h"

@interface HomeViewController () <HMHomeManagerDelegate, HMHomeDelegate, HMAccessoryDelegate>

@property (nonatomic, strong) UILabel *currentHomeLabel;
@property (nonatomic, strong) HMHomeManager *homeManager;
@property (nonatomic, strong) HMHome *currentHome;
@property (nonatomic, strong) NSMutableArray *accessories;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavigationItem];
    [self addTableHeaderView];
    [self initHomeManager];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.accessories = [NSMutableArray array];
    
    if (self.homeManager && self.homeManager.primaryHome) {
        for (HMAccessory *accessory in self.homeManager.primaryHome.accessories) {
            [self.accessories insertObject:accessory atIndex:0];
            accessory.delegate = self;
            [self.tableView reloadData];
        }
    }
}

- (void)initNavigationItem {
    UIBarButtonItem *allHomesItem = [[UIBarButtonItem alloc] initWithTitle:@"All Homes" style:UIBarButtonItemStylePlain target:self action:@selector(allHomesBtnClicked:)];
    self.navigationItem.leftBarButtonItem = allHomesItem;
    
    UIBarButtonItem *addAccessoriesItem = [[UIBarButtonItem alloc] initWithTitle:@"Add Accessories" style:UIBarButtonItemStylePlain target:self action:@selector(addAccessoriesBtnClicked:)];
    self.navigationItem.rightBarButtonItem = addAccessoriesItem;
}

- (void)addTableHeaderView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];
    headerView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.1];
    
    UIButton *removeHomeBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 120, 44)];
    [removeHomeBtn setTitle:@"delete home" forState:UIControlStateNormal];
    [removeHomeBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [removeHomeBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [removeHomeBtn addTarget:self action:@selector(removeHomeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:removeHomeBtn];
    
    UIButton *addHomeBtn = [[UIButton alloc] initWithFrame:CGRectMake(removeHomeBtn.right + 20, 10, 120, 44)];
    [addHomeBtn setTitle:@"add home" forState:UIControlStateNormal];
    [addHomeBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [addHomeBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [addHomeBtn addTarget:self action:@selector(addHomeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:addHomeBtn];
    
    _currentHomeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 55, self.view.width - 10, 20)];
    _currentHomeLabel.textColor = [UIColor blackColor];
    _currentHomeLabel.font = [UIFont systemFontOfSize:14];
    _currentHomeLabel.text = @"current home：";
    [headerView addSubview:_currentHomeLabel];
    
    self.tableView.tableHeaderView = headerView;
}

- (void)initHomeManager {
    self.homeManager = [[HMHomeManager alloc] init];
    self.homeManager.delegate = self;
}

- (IBAction)addAccessoriesBtnClicked:(id)sender {
    AddNewAccessoryViewController *vc = [[AddNewAccessoryViewController alloc] init];
    vc.homeManager = self.homeManager;
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:vc] animated:YES completion:^{
        
    }];
}

- (IBAction)allHomesBtnClicked:(id)sender {
    
    if (self.homeManager.homes.count > 0) {
        UIAlertController *homeListAC = [UIAlertController alertControllerWithTitle:@"" message:@"all homes" preferredStyle:UIAlertControllerStyleActionSheet];
        for (HMHome *home in self.homeManager.homes) {
            NSString *homeName = home.name;
            if ([home isPrimary]) {
                homeName = [NSString stringWithFormat:@"%@ is primary", home.name];
            }
            
            __weak typeof(self) weakSelf = self;
            UIAlertAction *action = [UIAlertAction actionWithTitle:homeName style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [weakSelf.homeManager updatePrimaryHome:home completionHandler:^(NSError * _Nullable error) {
                    if (error) {
                        NSLog(@"Error updating primary home: %@", error);
                    } else {
                        NSLog(@"Primary home updated.");
                        weakSelf.currentHome = weakSelf.homeManager.primaryHome;
                        [weakSelf updateCurrentHomeInfo];
                    }
                }];
            }];
            [homeListAC addAction:action];
        }
        
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
        [homeListAC addAction:actionCancel];
        [self presentViewController:homeListAC animated:YES completion:^{
        }];
    }
}

- (IBAction)removeHomeBtnClicked:(id)sender {
    if (_currentHome) {
        [self.homeManager removeHome:_currentHome completionHandler:^(NSError * _Nullable error) {
            if (!error) {
                NSLog(@"删除home成功！");
            }
        }];
    }
}

- (IBAction)addHomeBtnClicked:(id)sender {
    UIAlertController *inputNameAlter = [UIAlertController alertControllerWithTitle:@"请输入新home的名字" message:@"请确保这个名字的唯一性" preferredStyle:UIAlertControllerStyleAlert];
    [inputNameAlter addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = @"请输入新家的名字";
    }];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    __weak HomeViewController *weakSelf = self;
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *newName = inputNameAlter.textFields.firstObject.text;
        [weakSelf.homeManager addHomeWithName:newName completionHandler:^(HMHome * _Nullable home, NSError * _Nullable error) {
            
        }];
    }];
    [inputNameAlter addAction:action1];
    [inputNameAlter addAction:action2];
    [self presentViewController:inputNameAlter animated:YES completion:^{}];
}

- (NSMutableArray *)accessories {
    if (_accessories == nil) {
        _accessories = [NSMutableArray array];
    }
    
    return _accessories;
}

- (void)updateCurrentHomeInfo {
    _currentHomeLabel.text = [NSString stringWithFormat:@"current home：%@", _currentHome.name];
    
    _currentHome.delegate = self;
    
    self.accessories = nil;
    for (HMAccessory *accessory in _currentHome.accessories) {
        [self.accessories addObject:accessory];
        accessory.delegate = self;
    }
    
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.accessories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    HMAccessory *accessory = self.accessories[indexPath.row];
    cell.textLabel.text = accessory.name;
    if (accessory.reachable) {
        cell.detailTextLabel.text = @"Available";
        cell.detailTextLabel.textColor = [UIColor colorWithRed:46.0/255.0 green:108.0/255.0 blue:73.0/255.0 alpha:1.0];
    } else {
        cell.detailTextLabel.text = @"Not Available";
        cell.detailTextLabel.textColor = [UIColor redColor];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AccessoryDetailViewController *vc = [[AccessoryDetailViewController alloc] init];
    vc.accessory = self.accessories[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - HMHomeManagerDelegate

// 你的应用程序要重新加载所有的数据
- (void)homeManagerDidUpdateHomes:(HMHomeManager *)manager {
    
    if (manager.primaryHome) {
        _currentHome = self.homeManager.primaryHome;
        [self updateCurrentHomeInfo];
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"no home" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)homeManager:(HMHomeManager *)manager didAddHome:(HMHome *)home {
    
}


- (void)homeManager:(HMHomeManager *)manager didRemoveHome:(HMHome *)home {
    
}

- (void)homeManagerDidUpdatePrimaryHome:(HMHomeManager *)manager {
    _currentHome = self.homeManager.primaryHome;
    [self updateCurrentHomeInfo];
}

#pragma mark - HMHomeDelegate

- (void)home:(HMHome *)home didAddAccessory:(HMAccessory *)accessory {
    
    for (HMAccessory *accessory in _currentHome.accessories) {
        [self.accessories addObject:accessory];
        accessory.delegate = self;
        [self.tableView reloadData];
    }
}

- (void)home:(HMHome *)home didRemoveAccessory:(HMAccessory *)accessory {
    
    if ([self.accessories containsObject:accessory]) {
        NSUInteger index = [self.accessories indexOfObject:accessory];
        [self.accessories removeObjectAtIndex:index];
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)home:(HMHome *)home didUpdateRoom:(HMRoom *)room forAccessory:(HMAccessory *)accessory {
    
}

#pragma mark - HMAccessoryDelegate

- (void)accessoryDidUpdateReachability:(HMAccessory *)accessory {
    if ([self.accessories containsObject:accessory]) {
        NSUInteger index = [self.accessories indexOfObject:accessory];
        
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        
        if (accessory.reachable) {
            cell.detailTextLabel.text = @"Available";
            cell.detailTextLabel.textColor = [UIColor colorWithRed:46.0/255.0 green:108.0/255.0 blue:73.0/255.0 alpha:1.0];
        } else {
            cell.detailTextLabel.text = @"Not Available";
            cell.detailTextLabel.textColor = [UIColor redColor];
        }
    }
}

- (void)accessory:(HMAccessory *)accessory service:(HMService *)service didUpdateValueForCharacteristic:(HMCharacteristic *)characteristic
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"characteristicValueChanged" object:nil userInfo:@{@"accessory": accessory,
                                                                                                                   @"service": service,
                                                                                                                   @"characteristic": characteristic}];
}

- (void)accessoryDidUpdateServices:(HMAccessory *)accessory {
    
}

@end
