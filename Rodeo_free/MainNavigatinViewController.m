//
//  MainNavigatinViewController.m
//  Rodeo_free
//
//  Created by arvind on 4/19/15.
//  Copyright (c) 2015 arvind. All rights reserved.
//

#import "MainNavigatinViewController.h"

@interface MainNavigatinViewController ()

@end

@implementation MainNavigatinViewController
@synthesize appDelegate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    appDelegate=[[UIApplication sharedApplication] delegate];

    // Do any additional setup after loading the view from its nib.
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if (appDelegate.isLandscapeOK) {
        // for iPhone, you could also return UIInterfaceOrientationMaskAllButUpsideDown
        return UIInterfaceOrientationMaskAll;
    }
    return UIInterfaceOrientationMaskPortrait;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
