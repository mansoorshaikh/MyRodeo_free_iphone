//
//  GettingStartedViewController.h
//  Rodeo_free
//
//  Created by arvind on 4/22/15.
//  Copyright (c) 2015 arvind. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@interface GettingStartedViewController : UIViewController<UITextViewDelegate>
@property(nonatomic,retain) AppDelegate *appDelegate;
@property(nonatomic,retain) IBOutlet UIImageView *imgview;
@property(nonatomic,retain) IBOutlet UITextView *gettingstartedTextView;
@end
