//
//  RodeoListViewController.m
//  Rodeo_free
//
//  Created by arvind on 4/19/15.
//  Copyright (c) 2015 arvind. All rights reserved.
//

#import "RodeoListViewController.h"
#import "EventViewController.h"
#import "RodeoListVO.h"
@interface RodeoListViewController ()

@end

@implementation RodeoListViewController
@synthesize tableViewMain,rodeolistDetailsArray,appDelegate,activityIndicator;
- (void)viewDidLoad {
    [super viewDidLoad];
    [activityIndicator stopAnimating];

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
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIFont fontWithName:@"Segoe Print" size:30] forKey:NSFontAttributeName];

    self.navigationItem.title=@"Rodeo List";
    
   

    
    tableViewMain.frame=CGRectMake(0,0,self.view.bounds.size.width,self.view.bounds.size.height);
    [tableViewMain removeFromSuperview];
    [self.view addSubview:tableViewMain];
    // Do any additional setup after loading the view from its nib.
    [self getRodeoList];
}

- (void) threadStartAnimating:(id)data {
    [activityIndicator startAnimating];
    activityIndicator.center = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0);
    [self.view addSubview: activityIndicator];
}

-(void)popviewController{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)getRodeoList{
    rodeolistDetailsArray=[[NSMutableArray alloc]init];
    [NSThread detachNewThreadSelector:@selector(threadStartAnimating:) toTarget:self withObject:nil];

        NSString *urlString = [[NSString alloc]initWithFormat:@"http://mobiwebcode.com/rodeo/getrodeolist.php"];
    NSData *mydata = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    NSString *content = [[NSString alloc]  initWithBytes:[mydata bytes]
                                                  length:[mydata length] encoding: NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:mydata options:0 error:&error];
            NSArray *activityArray=[[json objectForKey:@"rodeodetails"] objectForKey:@"rodeo"];
        for (int count=0; count<[activityArray count]; count++) {
            NSDictionary *activityData=[activityArray objectAtIndex:count];
            RodeoListVO *rlvo=[[RodeoListVO alloc] init];
            rlvo.rodeoid=[[NSString alloc] init];
            rlvo.rodeoname=[[NSString alloc] init];
            rlvo.noofrounds=[[NSString alloc] init];
            rlvo.location=[[NSString alloc] init];
            rlvo.rodeodate=[[NSString alloc] init];
            
            if ([activityData objectForKey:@"rodeoid"] != [NSNull null])
                rlvo.rodeoid=[activityData objectForKey:@"rodeoid"];
            rlvo.rodeoname=[activityData objectForKey:@"rodeoname"];
            rlvo.noofrounds=[activityData objectForKey:@"noofrounds"];
            rlvo.location=[activityData objectForKey:@"location"];
            rlvo.rodeodate=[activityData objectForKey:@"rodeodate"];

            [rodeolistDetailsArray addObject:rlvo];
        }
    
    [tableViewMain reloadData];
    [activityIndicator stopAnimating];

    }

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [rodeolistDetailsArray count];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    RodeoListVO *rlvo=[rodeolistDetailsArray objectAtIndex:indexPath.row];

    UILabel *rodeonameLabel;
    if (nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.backgroundColor=[UIColor clearColor];        
        rodeonameLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 5,self.view.bounds.size.width, 20)];
        rodeonameLabel.tag=1;
        rodeonameLabel.textAlignment = NSTextAlignmentCenter;

        [cell.contentView addSubview:rodeonameLabel];
    }
    tableView.backgroundColor=[UIColor clearColor];
    dispatch_async(dispatch_get_main_queue(), ^{
        //Your main thread code goes in here
        NSLog(@"Im on the main thread");
        
        
        UILabel *rodeonameLabel = (id)[cell.contentView viewWithTag:1];
        
        
        rodeonameLabel.text=rlvo.rodeoname;
        
        
    });

    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    EventViewController *event;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        event=[[EventViewController alloc] initWithNibName:@"EventViewController" bundle:nil];
    else
        event=[[EventViewController alloc] initWithNibName:@"EventViewController_ipad" bundle:nil];
    event.selectRodeo=[[RodeoListVO alloc]init];
    event.selectRodeo=[rodeolistDetailsArray objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:event animated:YES];

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
