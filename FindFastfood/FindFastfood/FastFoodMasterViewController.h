//
//  FastFoodMasterViewController.h
//  FindFastfood
//
//  Created by Gypin on 12/8/25.
//  Copyright (c) 2012年 Gypin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FastFoodDetailViewController;

@interface FastFoodMasterViewController : UITableViewController

@property (strong, nonatomic) FastFoodDetailViewController *detailViewController;

@end
