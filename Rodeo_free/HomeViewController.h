//
//  HomeViewController.h
//  Rodeo_free
//
//  Created by arvind on 4/19/15.
//  Copyright (c) 2015 arvind. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface HomeViewController : UIViewController<UINavigationControllerDelegate>
{
    UIDeviceOrientation orientation;
}

@property(nonatomic,retain) IBOutlet UIButton *createRodeobtn,*lookupRodeobtn,*gettingstartedbtn,*aboutbtn,*helpbtn;
@property(nonatomic,retain) IBOutlet UIScrollView *scrollview;
@property(nonatomic,retain) IBOutlet UIImageView *bgimage;
@property(nonatomic,retain) AppDelegate *appDelegate;
@property(nonatomic,retain) IBOutlet UIImageView *logoimage;

@end
