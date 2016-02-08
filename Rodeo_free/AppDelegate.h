//
//  AppDelegate.h
//  Rodeo_free
//
//  Created by arvind on 4/19/15.
//  Copyright (c) 2015 arvind. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@class HomeViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (nonatomic) sqlite3 *RodeoDB;

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,retain) NSMutableArray *eventsList;
@property(nonatomic,retain) HomeViewController *hvc;
@property(nonatomic,readwrite) BOOL isfromLookup;
@property(nonatomic,retain) NSString *currentlocation;
@property(nonatomic,readwrite) BOOL isLandscapeOK;
@property(nonatomic,retain) NSString *isSaved;
-(NSString*)getDestPath;


@end

