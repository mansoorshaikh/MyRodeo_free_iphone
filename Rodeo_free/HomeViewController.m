//
//  HomeViewController.m
//  Rodeo_free
//
//  Created by arvind on 4/19/15.
//  Copyright (c) 2015 arvind. All rights reserved.
//

#import "HomeViewController.h"
#import "RodeoListViewController.h"
#import "LookupRodeoListViewController.h"
#import "GettingStartedViewController.h"
#import "AbutMyRodeoViewController.h"
#import "HelpViewController.h"
#import "AboutViewController.h"
@interface HomeViewController ()

@end

@implementation HomeViewController
@synthesize createRodeobtn,lookupRodeobtn,gettingstartedbtn,aboutbtn,helpbtn,appDelegate,scrollview,bgimage;
@synthesize logoimage;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=YES;

    appDelegate=[[UIApplication sharedApplication] delegate];
    
    /*if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        createRodeobtn.titleLabel.font = [UIFont fontWithName:@"Segoe Print" size:24];
        lookupRodeobtn.titleLabel.font = [UIFont fontWithName:@"Segoe Print" size:24];
        gettingstartedbtn.titleLabel.font = [UIFont fontWithName:@"Segoe Print" size:24];
        aboutbtn.titleLabel.font = [UIFont fontWithName:@"Segoe Print" size:24];
        helpbtn.titleLabel.font = [UIFont fontWithName:@"Segoe Print" size:24];
        
        self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIFont fontWithName:@"Brush Script Std" size:24] forKey:NSFontAttributeName];
    }else{
        createRodeobtn.titleLabel.font = [UIFont fontWithName:@"Segoe Print" size:45];
        lookupRodeobtn.titleLabel.font = [UIFont fontWithName:@"Segoe Print" size:45];
        gettingstartedbtn.titleLabel.font = [UIFont fontWithName:@"Segoe Print" size:45];
        aboutbtn.titleLabel.font = [UIFont fontWithName:@"Segoe Print" size:45];
        helpbtn.titleLabel.font = [UIFont fontWithName:@"Segoe Print" size:45];
        
        self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIFont fontWithName:@"Brush Script Std" size:40] forKey:NSFontAttributeName];
    }*/

    
    CGFloat yheight = [UIScreen mainScreen].bounds.size.height;
    if(yheight>=480 && yheight<568){
        bgimage.image=[UIImage imageNamed:@"bg.png"];

    logoimage.frame=CGRectMake(73, 131, 173, 41);
    createRodeobtn.frame=CGRectMake(36, 182, 247, 45);
    lookupRodeobtn.frame=CGRectMake(36, 227, 247, 45);
    gettingstartedbtn.frame=CGRectMake(36, 272, 247, 45);
    aboutbtn.frame=CGRectMake(36, 317, 247, 40);
    helpbtn.frame=CGRectMake(36, 357, 247, 40);
    //font
    createRodeobtn.titleLabel.font = [UIFont fontWithName:@"Segoe Print" size:18];
    lookupRodeobtn.titleLabel.font = [UIFont fontWithName:@"Segoe Print" size:18];
    gettingstartedbtn.titleLabel.font = [UIFont fontWithName:@"Segoe Print" size:18];
    aboutbtn.titleLabel.font = [UIFont fontWithName:@"Segoe Print" size:18];
    helpbtn.titleLabel.font = [UIFont fontWithName:@"Segoe Print" size:18];

    }else if(yheight>=568 && yheight<600){
        //iphone 5
        bgimage.image=[UIImage imageNamed:@"bg.png"];
        logoimage.frame=CGRectMake(73, 160, 173, 41);
        createRodeobtn.frame=CGRectMake(36, 215, 247, 45);
        lookupRodeobtn.frame=CGRectMake(36, 262, 247, 45);
        gettingstartedbtn.frame=CGRectMake(36, 307, 247, 45);
        aboutbtn.frame=CGRectMake(36,352, 247, 40);
        helpbtn.frame=CGRectMake(36, 392, 247, 40);
        //font
        createRodeobtn.titleLabel.font = [UIFont fontWithName:@"Segoe Print" size:18];
        lookupRodeobtn.titleLabel.font = [UIFont fontWithName:@"Segoe Print" size:18];
        gettingstartedbtn.titleLabel.font = [UIFont fontWithName:@"Segoe Print" size:18];
        aboutbtn.titleLabel.font = [UIFont fontWithName:@"Segoe Print" size:18];
        helpbtn.titleLabel.font = [UIFont fontWithName:@"Segoe Print" size:18];
    }
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    [self copyDatabaseIfNeeded];
    self.navigationController.navigationBar.hidden = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)rodeoListAction{
    RodeoListViewController *rodeoList;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        rodeoList=[[RodeoListViewController alloc] initWithNibName:@"RodeoListViewController" bundle:nil];
    else
        rodeoList=[[RodeoListViewController alloc] initWithNibName:@"RodeoListViewController_ipad" bundle:nil];
    [self.navigationController pushViewController:rodeoList animated:YES];
}

-(IBAction)lookupRodeoAction{
    LookupRodeoListViewController *lurvc;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        lurvc=[[LookupRodeoListViewController alloc] initWithNibName:@"LookupRodeoListViewController" bundle:nil];
    else
        lurvc=[[LookupRodeoListViewController alloc] initWithNibName:@"LookupRodeoListViewController_ipad" bundle:nil];
    [self.navigationController pushViewController:lurvc animated:YES];
}
-(IBAction)gettingStartedAction{
    GettingStartedViewController *gsvc;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        gsvc=[[GettingStartedViewController alloc] initWithNibName:@"GettingStartedViewController" bundle:nil];
    else
        gsvc=[[GettingStartedViewController alloc] initWithNibName:@"GettingStartedViewController_ipad" bundle:nil];
    [self.navigationController pushViewController:gsvc animated:YES];
}

-(IBAction)aboutRodeoAction{
    AbutMyRodeoViewController *amrvc;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        amrvc=[[AbutMyRodeoViewController alloc] initWithNibName:@"AbutMyRodeoViewController" bundle:nil];
    else
        amrvc=[[AbutMyRodeoViewController alloc] initWithNibName:@"AbutMyRodeoViewController_ipad" bundle:nil];
    [self.navigationController pushViewController:amrvc animated:YES];
}

-(IBAction)helpAction{
    HelpViewController *hvc;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        hvc=[[HelpViewController alloc] initWithNibName:@"HelpViewController" bundle:nil];
    else
        hvc=[[HelpViewController alloc] initWithNibName:@"HelpViewController_ipad" bundle:nil];
    [self.navigationController pushViewController:hvc animated:YES];
}

- (void) copyDatabaseIfNeeded
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSString *dbPath = [appDelegate getDestPath];
    NSLog(@"dbPath  = %@", dbPath);
    BOOL success = [fileManager fileExistsAtPath:dbPath];
    
    if(!success) {
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Rodeo.sqlite"];
        
        NSLog(@"DefaultDBPath.....>>%@",defaultDBPath);
        success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
        
        if (!success)
            NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
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
