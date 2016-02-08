//
//  AppDelegate.m
//  Rodeo_free
//
//  Created by arvind on 4/19/15.
//  Copyright (c) 2015 arvind. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "MainNavigatinViewController.h"
#import <UIKit/UIKit.h>
@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize hvc,isfromLookup,currentlocation,isLandscapeOK,eventsList,isSaved,RodeoDB;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    isLandscapeOK=NO;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        hvc = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
    else
        hvc = [[HomeViewController alloc] initWithNibName:@"HomeViewController_iPad" bundle:nil];
    
    MainNavigatinViewController *navController = [[MainNavigatinViewController alloc] initWithRootViewController:hvc];
    navController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    self.window.rootViewController=navController;
    [self.window makeKeyAndVisible];
    

           // Override point for customization after application launch.]
    return YES;
} 
-(NSString*)getDestPath
{
    NSString* srcPath = [[NSBundle mainBundle]pathForResource:@"Rodeo" ofType:@"sqlite"];
    NSArray* arrayPathComp = [NSArray arrayWithObjects:NSHomeDirectory(),@"Documents",@"Rodeo.sqlite", nil];
    
    NSString* destPath = [NSString pathWithComponents:arrayPathComp];
    NSLog(@"src path:%@",srcPath);
    NSLog(@"dest path:%@",destPath);
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath:destPath]!=YES) {
        NSError *error;
        
        if ([manager copyItemAtPath:srcPath toPath:destPath error:&error]!=YES) {
            NSLog(@"Failed");
            
            NSLog(@"Reason = %@",[error localizedDescription]);
        }
    }
    return  destPath;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
