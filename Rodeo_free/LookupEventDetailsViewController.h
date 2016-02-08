//
//  LookupEventDetailsViewController.h
//  Rodeo_free
//
//  Created by arvind on 4/21/15.
//  Copyright (c) 2015 arvind. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "RodeoListVO.h"
#import "EventVO.h"
#import <sqlite3.h>

@interface LookupEventDetailsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
@property(nonatomic) sqlite3 *database;

@property(nonatomic,retain) IBOutlet UILabel *roundNumberLabel,*roundNumberLabel_landscape,*roundLabel,*roundLabel_Landscape;
@property(nonatomic,retain) IBOutlet UIActivityIndicatorView *activityIndicator,*activityIndicator_landscape;
@property(nonatomic,retain) IBOutlet UILabel *scoreLabel,*timeLabel,*totalTimeLabel,*for1stinRoundLabel,*forLastInRoundLabel,*forfirstInAvgLabel,*forLastInAvgLabel,*scoreLabel_portrait,*timeLabel_portrait;
@property(nonatomic,retain) NSString *eventidSelected,*oldContestantName,*eventtype,*sorttype;
@property(nonatomic,retain) AppDelegate *appDelegate;
@property(nonatomic,retain) IBOutlet UITableView *tblview,*tblview_landscape;
@property(nonatomic,retain) IBOutlet UIView *mainPortraitView;
@property(nonatomic,retain) IBOutlet UIView *mainLandscapeView;
@property(nonatomic,retain) IBOutlet UIButton *sharebtn,*editbtn,*sortbtn,*addcontestantbtn,*sortbtn_landscape;
@property(nonatomic,retain) IBOutlet UIImageView *imgview;
@property(nonatomic,readwrite) bool isLandscape,contestantSaved;
@property(nonatomic,retain) RodeoListVO *selectRodeo;
@property(nonatomic,retain) EventVO *selectEvent;
@property(nonatomic,retain) NSMutableArray *contestantsArray;
@property(nonatomic,readwrite) int currentRound;
@property(nonatomic,readwrite) int currentround;


@end
