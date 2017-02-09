//
//  ServiceDetailViewController.h
//  HomeKitDemo
//
//  Created by XuChengcheng on 2017/2/9.
//  Copyright © 2017年 xcc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HomeKit/HomeKit.h>

@interface ServiceDetailViewController : UITableViewController

@property (nonatomic, strong) HMService *service;

@end
