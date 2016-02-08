//
//  EventViewController.h
//  Rodeo_free
//
//  Created by arvind on 4/20/15.
//  Copyright (c) 2015 arvind. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "RodeoListVO.h"
#import <sqlite3.h>
#import "EventVO.h"
@interface EventViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,retain) AppDelegate *appDelegate;
@property(nonatomic,retain) IBOutlet UITableView *tableViewMain;
@property(nonatomic,retain) NSMutableArray *eventlistDetailsArray;
@property(nonatomic,retain) RodeoListVO *selectRodeo;
@property (nonatomic) sqlite3 *RodeoDB;
@property(nonatomic,retain) IBOutlet UIActivityIndicatorView *activityIndicator;
@property(nonatomic,retain) NSMutableArray *eventDetailsArray;
@property(nonatomic,retain) EventVO *selectEvent;
@property(nonatomic,readwrite) int currentround,currentevent;
@property(nonatomic,retain) EventVO *currentEventVO;
@property(nonatomic,retain)  NSNumber *menuID,*oldcontestantid;
@property(nonatomic,retain) NSMutableArray *rodeolistDetailsArray;


@end
