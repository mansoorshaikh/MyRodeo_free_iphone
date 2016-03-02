//
//  LookupEventsViewController.m
//  Rodeo_free
//
//  Created by arvind on 4/20/15.
//  Copyright (c) 2015 arvind. All rights reserved.
//

#import "LookupEventsViewController.h"
#import "LookupEventDetailsViewController.h"
#import "EventVO.h"
@interface LookupEventsViewController ()

@end

@implementation LookupEventsViewController
@synthesize tblview,activityIndicator,selectRodeo,eventsArray,database;

- (void)viewDidLoad {
    [super viewDidLoad];
    [activityIndicator stopAnimating];
    database=[self getNewDb];

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
    
    self.navigationItem.title=@"Events";
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIFont fontWithName:@"Segoe Print" size:25] forKey:NSFontAttributeName];

    tblview.frame=CGRectMake(0,50,self.view.bounds.size.width,self.view.bounds.size.height);
    tblview.backgroundColor=[UIColor clearColor];
    [tblview removeFromSuperview];
    [self.view addSubview:tblview];

    // Do any additional setup after loading the view from its nib.
}

- (void) threadStartAnimating:(id)data {
    [activityIndicator startAnimating];
    activityIndicator.center = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0);
    [self.view addSubview: activityIndicator];
}

- (sqlite3 *)getNewDb {
    sqlite3 *newDb = nil;
    if (sqlite3_open([[self getDestPath] UTF8String], &newDb) == SQLITE_OK) {
        sqlite3_busy_timeout(newDb, 1000);
    } else {
        sqlite3_close(newDb);
    }
    return newDb;
}

-(void)readEventsList{
    char *dbChars ;
    eventsArray =[[NSMutableArray alloc] init];
    NSString *sqlStatement = [NSString stringWithFormat:@"select * from events where rodeoid=%@",selectRodeo.rodeoid];
    
    sqlite3_stmt *compiledStatement;
    if(sqlite3_prepare_v2(database, [sqlStatement UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK) {
        while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
            EventVO *event=[[EventVO alloc] init];
            dbChars = (char *)sqlite3_column_text(compiledStatement, 0);
            if(dbChars!=nil)
                event.eventid=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
            
            dbChars = (char *)sqlite3_column_text(compiledStatement, 2);
            if(dbChars!=nil)
                event.eventname=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
            
            dbChars = (char *)sqlite3_column_text(compiledStatement, 3);
            if(dbChars!=nil)
                event.contestants=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
            
            dbChars = (char *)sqlite3_column_text(compiledStatement, 4);
            if(dbChars!=nil)
                event.places=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)];
            
            dbChars = (char *)sqlite3_column_text(compiledStatement, 6);
            if(dbChars!=nil)
                event.eventtype=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 6)];
            
            [eventsArray addObject:event];
        }
    }
    [tblview reloadData];
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


-(void)popviewController{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [self readEventsList];
    self.navigationController.navigationBar.hidden = NO;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [eventsArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    EventVO *event=[eventsArray objectAtIndex:indexPath.row];
    UILabel *nameLabel,*contestantsLabel,*placeLabel;
    if (nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.backgroundColor=[UIColor clearColor];
        nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 5,160, 20)];
        nameLabel.tag=1;
        nameLabel.text=event.eventname;
        [cell.contentView addSubview:nameLabel];
        
        contestantsLabel=[[UILabel alloc] initWithFrame:CGRectMake(185, 5,40, 20)];
        contestantsLabel.tag=2;
        contestantsLabel.text=event.contestants;
        [cell.contentView addSubview:contestantsLabel];
        
        placeLabel=[[UILabel alloc] initWithFrame:CGRectMake(275, 5, 40, 20)];
        placeLabel.tag=3;
        placeLabel.text=event.places;
        [cell.contentView addSubview:placeLabel];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LookupEventDetailsViewController *lookeventdetails;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        lookeventdetails=[[LookupEventDetailsViewController alloc] initWithNibName:@"LookupEventDetailsViewController" bundle:nil];
    else
        lookeventdetails=[[LookupEventDetailsViewController alloc] initWithNibName:@"LookupEventDetailsViewController_ipad" bundle:nil];
    lookeventdetails.selectRodeo=[[RodeoListVO alloc]init];
    lookeventdetails.selectRodeo=selectRodeo;
    lookeventdetails.selectEvent=[[EventVO alloc]init];
    lookeventdetails.selectEvent=[eventsArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:lookeventdetails animated:YES];
    
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
