//
//  LookupEventsViewController.h
//  Rodeo_free
//
//  Created by arvind on 4/20/15.
//  Copyright (c) 2015 arvind. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "RodeoListVO.h"
#import <sqlite3.h>

@interface LookupEventsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,retain) AppDelegate *appDelegate;
@property (nonatomic) sqlite3 *database;

@property(nonatomic,retain) IBOutlet UITableView *tblview;
@property(nonatomic,retain) IBOutlet UIActivityIndicatorView *activityIndicator;
@property(nonatomic,retain) RodeoListVO *selectRodeo;
@property(nonatomic,retain) NSMutableArray *eventsArray;
@end
