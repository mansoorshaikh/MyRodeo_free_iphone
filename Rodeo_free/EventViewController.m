//
//  EventViewController.m
//  Rodeo_free
//
//  Created by arvind on 4/20/15.
//  Copyright (c) 2015 arvind. All rights reserved.
//

#import "EventViewController.h"
#import "EventDetailsViewController.h"
#import "EventVO.h"
#import "RodeoListVO.h"
#import "EventDetailsVO.h"
@interface EventViewController ()

@end

@implementation EventViewController
@synthesize tableViewMain,eventlistDetailsArray,selectRodeo,appDelegate,RodeoDB,activityIndicator,eventDetailsArray,selectEvent,currentround,rodeolistDetailsArray,currentEventVO,currentevent,menuID,oldcontestantid;

- (void)viewDidLoad {
    [super viewDidLoad];
    [activityIndicator stopAnimating];

    self.navigationController.navigationBarHidden=NO;
    appDelegate=[[UIApplication sharedApplication] delegate];
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

    self.navigationItem.title=@"Event";
    
    
    UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleBordered target:self action:@selector(InsertRecords)];
    

    [saveBtn setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:18], UITextAttributeFont,nil] forState:UIControlStateNormal];
    [saveBtn setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:18], UITextAttributeFont,nil] forState:UIControlStateNormal];
    
    saveBtn.tintColor=[UIColor whiteColor];
    self.navigationItem.rightBarButtonItems = @[saveBtn];
    

    
    tableViewMain.frame=CGRectMake(0,0,self.view.bounds.size.width,self.view.bounds.size.height);
    [tableViewMain removeFromSuperview];
    [self.view addSubview:tableViewMain];

    [self getEventList];
    // Do any additional setup after loading the view from its nib.
}

- (void) threadStartAnimating:(id)data {
    [activityIndicator startAnimating];
    activityIndicator.center = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0);
    [self.view addSubview: activityIndicator];
}


-(void)InsertRecords{
    [NSThread detachNewThreadSelector:@selector(threadStartAnimating:) toTarget:self withObject:nil];

    sqlite3_stmt *statement;
    NSNumber *menuID;
    NSLog(@"[self getDestPath] = %@",[appDelegate getDestPath]);
    
    if (sqlite3_open([[appDelegate getDestPath] UTF8String], &RodeoDB) == SQLITE_OK)
    {
        NSString *insertSQL;
        insertSQL = [NSString stringWithFormat:
                     @"insert into rodeodetails (rodeoname,location,rodeostartdate,numberofrounds) VALUES (\"%@\",\"%@\",\"%@\",\"%@\")",selectRodeo.rodeoname,selectRodeo.location,selectRodeo.rodeodate,selectRodeo.noofrounds];
        
        NSLog(@"insertSQL = %@",insertSQL);
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(RodeoDB, insert_stmt,
                           -1, &statement, NULL);
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"record inserted");
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            menuID = [NSDecimalNumber numberWithLongLong:sqlite3_last_insert_rowid(RodeoDB)];
            selectRodeo.rodeoid=[NSString stringWithFormat:@"%@",menuID];
            int myInt = [prefs integerForKey:@"rodeocount"];
            myInt=myInt+1;
            [prefs setInteger:myInt forKey:@"rodeocount"];
        }else{
            NSLog(@"record insertion failed");
            NSLog(@"Error %s while preparing statement", sqlite3_errmsg(RodeoDB));
        }
        sqlite3_finalize(statement);
        sqlite3_close(RodeoDB);
           }
    NSNumber *lastId = 0;
    for (int i=0; i<[eventlistDetailsArray count]; i++) {
        EventVO *eventvo=[eventlistDetailsArray objectAtIndex:i];
        sqlite3_stmt *statement;
        NSLog(@"[self getDestPath] = %@",[appDelegate getDestPath]);
        
        if (sqlite3_open([[appDelegate getDestPath] UTF8String], &RodeoDB) == SQLITE_OK)
        {
            NSString *insertSQL;
            insertSQL = [NSString stringWithFormat:
                         @"insert into events (rodeoid,eventname,contestants,places,eventType) VALUES (%@,\"%@\",\"%@\",\"%@\",\"%@\")",menuID,eventvo.eventname,eventvo.contestants,eventvo.places,eventvo.eventtype];
            
            NSLog(@"insertSQL = %@",insertSQL);
            const char *insert_stmt = [insertSQL UTF8String];
            sqlite3_prepare_v2(RodeoDB, insert_stmt,
                               -1, &statement, NULL);
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"record inserted");
                lastId = [NSDecimalNumber numberWithLongLong:sqlite3_last_insert_rowid(RodeoDB)];
                eventvo.eventid=[NSString stringWithFormat:@"%@",lastId];
            }else{
                NSLog(@"record insertion failed");
                NSLog(@"Error %s while preparing statement", sqlite3_errmsg(RodeoDB));
            }
            sqlite3_finalize(statement);
            sqlite3_close(RodeoDB);
        }
    }
    
    currentevent=0;
    oldcontestantid=[NSDecimalNumber numberWithLongLong:1];
    currentround=1;
    currentEventVO=[[EventVO alloc] init];
    currentEventVO=[eventlistDetailsArray objectAtIndex:currentevent];
    [self saveEventDetailsToDB];
}


-(void)saveEventDetailsToDB{
    NSString *urlString = [[NSString alloc]initWithFormat:@"http://mobiwebcode.com/rodeo/eventdetails.php?eventid=%@&round=%d",currentEventVO.eventid,currentround];
    NSData *mydata = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    NSString *content = [[NSString alloc]  initWithBytes:[mydata bytes]
                                                  length:[mydata length] encoding: NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:mydata options:0 error:&error];
    NSArray *activityArray=[[json objectForKey:@"eventdetails"] objectForKey:@"event"];
        for (int count=0; count<[activityArray count]; count++) {
            NSDictionary *activityData=[activityArray objectAtIndex:count];
            sqlite3_stmt *statement;
           
            
            if (sqlite3_open([[appDelegate getDestPath] UTF8String], &RodeoDB) == SQLITE_OK)
            {
                
                    NSString *insertSQL;
                const char *insert_stmt;
                if(currentround==1){
                    insertSQL = [NSString stringWithFormat:
                                 @"insert into contestants (contestantname,eventid) VALUES (\"%@\",\"%@\")",[activityData objectForKey:@"contestantname"],currentEventVO.eventid];
                    
                    NSLog(@"insertSQL = %@",insertSQL);
                    insert_stmt = [insertSQL UTF8String];
                    sqlite3_prepare_v2(RodeoDB, insert_stmt,
                                       -1, &statement, NULL);
                    
                    
                    if (sqlite3_step(statement) == SQLITE_DONE)
                    {
                        NSLog(@"record inserted");
                        menuID = [NSDecimalNumber numberWithLongLong:sqlite3_last_insert_rowid(RodeoDB)];
                        oldcontestantid=menuID;
                    }
                }else{
                    if(oldcontestantid==menuID)
                    {
                        menuID=[NSDecimalNumber numberWithLongLong:([menuID intValue]-[currentEventVO.contestants intValue])];
                    }
                    menuID=[NSDecimalNumber numberWithLongLong:([menuID intValue]+1)];
                }
                
                
                insertSQL = [NSString stringWithFormat:
                             @"insert into rounddetails (contestantid,time,score,first_in_round,last_in_round,first_in_avg,last_in_avg,average,round) VALUES (%@,\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",menuID,[activityData objectForKey:@"time"],[activityData objectForKey:@"score"],[activityData objectForKey:@"forfirstinround"],[activityData objectForKey:@"forlastinround"],[activityData objectForKey:@"forfirstinaverage"],[activityData objectForKey:@"forlastinaverage"],[activityData objectForKey:@"average"],[NSString stringWithFormat:@"%d",currentround]];
                
                NSLog(@"insertSQL = %@",insertSQL);
                insert_stmt = [insertSQL UTF8String];
                sqlite3_prepare_v2(RodeoDB, insert_stmt,
                                   -1, &statement, NULL);
                
                if (sqlite3_step(statement) == SQLITE_DONE)
                {
                    NSLog(@"record inserted");
                }
            }
            sqlite3_close(RodeoDB);
        }
    
    if(currentevent<[eventlistDetailsArray count]-1){
        if(currentround==[selectRodeo.noofrounds intValue]){
            currentround=1;
            currentevent=currentevent+1;
            currentEventVO=[eventlistDetailsArray objectAtIndex:currentevent];
        }else{
            currentround=currentround+1;
        }
        [self saveEventDetailsToDB];
    }else if(currentround!=[selectRodeo.noofrounds intValue]){
        currentround=currentround+1;
        [self saveEventDetailsToDB];
    }else{
        [activityIndicator stopAnimating];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"My Rodeo"
                                                        message:@"Rodeo saved successfully."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
    
}

-(void)getEventList{
    [NSThread detachNewThreadSelector:@selector(threadStartAnimating:) toTarget:self withObject:nil];

    eventlistDetailsArray=[[NSMutableArray alloc]init];
    NSString *urlString = [[NSString alloc]initWithFormat:@"http://mobiwebcode.com/rodeo/geteventslist.php?rodeoid=%@",selectRodeo.rodeoid];
    NSData *mydata = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    NSString *content = [[NSString alloc]  initWithBytes:[mydata bytes]
                                                  length:[mydata length] encoding: NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:mydata options:0 error:&error];
    NSArray *activityArray=[[json objectForKey:@"eventdetails"] objectForKey:@"event"];
    for (int count=0; count<[activityArray count]; count++) {
        NSDictionary *activityData=[activityArray objectAtIndex:count];
        EventVO *evo=[[EventVO alloc] init];
        evo.eventid=[[NSString alloc] init];
        evo.eventname=[[NSString alloc] init];
        evo.contestants=[[NSString alloc] init];
        evo.places=[[NSString alloc] init];
        evo.eventtype=[[NSString alloc] init];
        
        if ([activityData objectForKey:@"eventid"] != [NSNull null])
                   evo.eventid=[activityData objectForKey:@"eventid"];
        evo.eventname=[activityData objectForKey:@"eventname"];
        evo.contestants=[activityData objectForKey:@"contestants"];
        evo.places=[activityData objectForKey:@"places"];
        evo.eventtype=[activityData objectForKey:@"eventtype"];

        [eventlistDetailsArray addObject:evo];
    }
    
    [tableViewMain reloadData];
    [activityIndicator stopAnimating];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [eventlistDetailsArray count];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    EventVO *evo=[eventlistDetailsArray objectAtIndex:indexPath.row];
    UILabel *nameLabel,*contestantsLabel,*placeLabel;
    if (nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.backgroundColor=[UIColor clearColor];
        
        nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 5,160, 20)];
        nameLabel.tag=1;
        nameLabel.text=evo.eventname;
        [cell.contentView addSubview:nameLabel];
        
        contestantsLabel=[[UILabel alloc] initWithFrame:CGRectMake(185, 5,40, 20)];
        contestantsLabel.tag=2;
        contestantsLabel.text=evo.contestants;
        [cell.contentView addSubview:contestantsLabel];
        
        placeLabel=[[UILabel alloc] initWithFrame:CGRectMake(275, 5, 40, 20)];
        placeLabel.tag=3;
        placeLabel.text=evo.places;
        [cell.contentView addSubview:placeLabel];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
        EventDetailsViewController *eventdetails;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            eventdetails=[[EventDetailsViewController alloc] initWithNibName:@"EventDetailsViewController" bundle:nil];
        else
            eventdetails=[[EventDetailsViewController alloc] initWithNibName:@"EventDetailsViewController_ipad" bundle:nil];
    eventdetails.selectRodeo=[[RodeoListVO alloc]init];
    eventdetails.selectRodeo=selectRodeo;
    eventdetails.selectEvent=[[EventVO alloc]init];
    eventdetails.selectEvent=[eventlistDetailsArray objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:eventdetails animated:YES];
    
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
