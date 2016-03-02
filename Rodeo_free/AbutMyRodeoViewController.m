//
//  AbutMyRodeoViewController.m
//  Rodeo_free
//
//  Created by arvind on 4/22/15.
//  Copyright (c) 2015 arvind. All rights reserved.
//

#import "AbutMyRodeoViewController.h"

@interface AbutMyRodeoViewController ()

@end

@implementation AbutMyRodeoViewController
@synthesize appDelegate,aboutTextView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSUInteger)supportedInterfaceOrientations
{
    appDelegate.isLandscapeOK=NO;
    return UIInterfaceOrientationMaskPortrait;
}

-(void)viewWillAppear:(BOOL)animated{
    appDelegate.isLandscapeOK=NO;
    self.navigationController.navigationBar.hidden = NO;

}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden=NO;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        [backButton setFrame:CGRectMake(0,0,50,30)];
    else
        [backButton setFrame:CGRectMake(0,0,80,48)];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    backButton.userInteractionEnabled = YES;
    [backButton addTarget:self
                   action:@selector(popviewController)
         forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"backbtn.png"] forState:UIControlStateNormal];
    
    // ASSIGNING THE BUTTON WITH IMAGE TO BACK BAR BUTTON
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    backBarButton.title=@"Back";
    
    self.navigationItem.leftBarButtonItem = backBarButton;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"navigationbar.png"]];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIFont fontWithName:@"Segoe Print" size:25] forKey:NSFontAttributeName];

           self.navigationItem.title=@"About My Rodeo";    // Do any additional setup after loading the view from its nib.
    CGFloat height = [UIScreen mainScreen].bounds.size.height;

    if(height>=480 && height<568){
        
        aboutTextView.layer.frame=CGRectMake(0,0,self.view.bounds.size.width,400);
        aboutTextView.delegate = self;
        aboutTextView.font=[UIFont fontWithName:@"Segoe Print" size:20];
        [self.view addSubview:aboutTextView];
    }else if(height>=568 && height<600){
        
        aboutTextView.layer.frame=CGRectMake(0,0,self.view.bounds.size.width-100,500);
        aboutTextView.delegate = self;
        aboutTextView.font=[UIFont fontWithName:@"Segoe Print" size:20];
        
        [self.view addSubview:aboutTextView];
        
    }else{
        aboutTextView.font=[UIFont fontWithName:@"Segoe Print" size:20];
        [self.view addSubview:aboutTextView];
        
    }

    // Do any additional setup after loading the view from its nib.
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)popviewController{
    [self.navigationController popViewControllerAnimated:YES];
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
