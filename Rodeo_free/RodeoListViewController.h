//
//  RodeoListViewController.h
//  Rodeo_free
//
//  Created by arvind on 4/19/15.
//  Copyright (c) 2015 arvind. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "RodeoListVO.h"

@interface RodeoListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,retain) AppDelegate *appDelegate;
@property(nonatomic,retain) IBOutlet UITableView *tableViewMain;
@property(nonatomic,retain) RodeoListVO *selectedRodeo;
@property(nonatomic,retain) NSMutableArray *rodeolistDetailsArray;
@property(nonatomic,retain) IBOutlet UIActivityIndicatorView *activityIndicator;
@end
