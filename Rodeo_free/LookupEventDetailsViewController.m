//
//  LookupEventDetailsViewController.m
//  Rodeo_free
//
//  Created by arvind on 4/21/15.
//  Copyright (c) 2015 arvind. All rights reserved.
//

#import "LookupEventDetailsViewController.h"
#import "EventDetailsVO.h"
#import "EventVO.h"
@interface LookupEventDetailsViewController ()

@end

@implementation LookupEventDetailsViewController
@synthesize mainPortraitView,imgview,eventidSelected,activityIndicator,activityIndicator_landscape,oldContestantName;
@synthesize mainLandscapeView,tblview,appDelegate;
@synthesize sharebtn,editbtn,sortbtn,addcontestantbtn;
@synthesize roundNumberLabel,roundNumberLabel_landscape;
@synthesize scoreLabel,timeLabel,totalTimeLabel,for1stinRoundLabel,forLastInRoundLabel,forfirstInAvgLabel,forLastInAvgLabel,isLandscape,contestantSaved;
@synthesize scoreLabel_portrait,timeLabel_portrait,roundLabel,roundLabel_Landscape,sorttype,sortbtn_landscape,tblview_landscape,selectRodeo,selectEvent,database,contestantsArray,currentRound,currentround;

- (void)viewDidLoad {
    [super viewDidLoad];
    [activityIndicator stopAnimating];
    [activityIndicator_landscape stopAnimating];
    database=[self getNewDb];
    currentround=1;
    roundNumberLabel.text=[NSString stringWithFormat:@"Round %d",currentround];
    roundNumberLabel_landscape.text=[NSString stringWithFormat:@"Round %d",currentround];
    appDelegate=[[UIApplication sharedApplication] delegate];
    timeLabel.hidden=YES;
    scoreLabel.hidden=YES;
    timeLabel_portrait.hidden=YES;
    scoreLabel_portrait.hidden=YES;
    if([selectEvent.eventtype isEqualToString:@"Timed Event"])
    {
        timeLabel.hidden=NO;
        timeLabel_portrait.hidden=NO;
        scoreLabel_portrait.hidden=YES;
        scoreLabel.hidden=YES;
        
    }else{
        timeLabel.hidden=YES;
        timeLabel_portrait.hidden=YES;
        scoreLabel_portrait.hidden=NO;
        scoreLabel.hidden=NO;
    }

    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    if(height>=568){
        imgview.image=[UIImage imageNamed:@"innerbg.png"];
    }else{
        imgview.image=[UIImage imageNamed:@"innerbg_.png"];
    }
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        sharebtn.font = [UIFont fontWithName:@"Segoe Print" size:14];
        editbtn.font = [UIFont fontWithName:@"Segoe Print" size:14];
        sortbtn.font = [UIFont fontWithName:@"Segoe Print" size:14];
        addcontestantbtn.font = [UIFont fontWithName:@"Segoe Print" size:14];
    }else{
        sharebtn.font = [UIFont fontWithName:@"Segoe Print" size:30];
        editbtn.font = [UIFont fontWithName:@"Segoe Print" size:30];
        sortbtn.font = [UIFont fontWithName:@"Segoe Print" size:30];
        addcontestantbtn.font = [UIFont fontWithName:@"Segoe Print" size:30];
    }
    
    [self.view addSubview:mainPortraitView];

    self.navigationController.navigationBar.hidden=NO;
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
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIFont fontWithName:@"Segoe Print" size:15] forKey:NSFontAttributeName];

    self.navigationItem.title=selectEvent.eventname;
    
    
    UIBarButtonItem *prevButton = [[UIBarButtonItem alloc] initWithTitle:@"Prev" style:UIBarButtonItemStyleBordered target:self action:@selector(prevClicked)];
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleBordered target:self action:@selector(nextClicked)];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        [nextButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:18], UITextAttributeFont,nil] forState:UIControlStateNormal];
        [prevButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:18], UITextAttributeFont,nil] forState:UIControlStateNormal];
    }
    else{
        [nextButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:30], UITextAttributeFont,nil] forState:UIControlStateNormal];
        [prevButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:30], UITextAttributeFont,nil] forState:UIControlStateNormal];
    }
    nextButton.tintColor=[UIColor whiteColor];
    prevButton.tintColor=[UIColor whiteColor];
    self.navigationItem.rightBarButtonItems = @[nextButton,prevButton];

    // Do any additional setup after loading the view from its nib.
}

- (void) threadStartAnimating:(id)data {
    [activityIndicator startAnimating];
    activityIndicator.center = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0);
    [self.view addSubview: activityIndicator];
}
-(void)viewDidAppear:(BOOL)animated{
    [self getContestantsList];
}
-(NSString*)getDestPath
{
    NSString* srcPath = [[NSBundle mainBundle]pathForResource:@"Rodeo" ofType:@"sqlite"];
    NSArray* arrayPathComp = [NSArray arrayWithObjects:NSHomeDirectory(),@"Documents",@"Rodeo.sqlite", nil];
    
    NSString* destPath = [NSString pathWithComponents:arrayPathComp];
    //    NSLog(@"src path:%@",srcPath);
    //  NSLog(@"dest path:%@",destPath);
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

- (sqlite3 *)getNewDb {
    sqlite3 *newDb = nil;
    if (sqlite3_open([[self getDestPath] UTF8String], &newDb) == SQLITE_OK) {
        sqlite3_busy_timeout(newDb, 1000);
    } else {
        sqlite3_close(newDb);
    }
    return newDb;
}


-(void)getContestantsList{
    char *dbChars ;
    EventDetailsVO *contestant;
    NSString *sqlStatement = [NSString stringWithFormat:@"select * from contestants where eventid=%@",selectEvent.eventid];
    NSLog(@"sqlStatement contestants : %@",sqlStatement);
    sqlite3_stmt *compiledStatement;
    int contestantcount=0;
    if(sqlite3_prepare_v2(database, [sqlStatement UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK) {
        contestantsArray=[[NSMutableArray alloc] init];
        while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
            contestantcount++;
           contestant=[[EventDetailsVO alloc] init];
           
            dbChars = (char *)sqlite3_column_text(compiledStatement, 0);
            if(dbChars!=nil)
                contestant.contestantid=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
            
            dbChars = (char *)sqlite3_column_text(compiledStatement, 2);
            if(dbChars!=nil)
                contestant.contestantname=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
            [contestantsArray addObject:contestant];
            
        }
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    sqlite3_stmt *compiledStatement_;
    NSString *format_avg=@"%";
    for (int count=0; count<[contestantsArray count]; count++) {
        contestant=[contestantsArray objectAtIndex:count];
        sqlStatement = [NSString stringWithFormat:@"select * from rounddetails where contestantid=%@ and round=%d",contestant.contestantid,currentround];
        NSLog(@"sqlStatement contestants : %@",sqlStatement);
        if(sqlite3_prepare_v2(database, [sqlStatement UTF8String], -1, &compiledStatement_, NULL) == SQLITE_OK) {
            while(sqlite3_step(compiledStatement_) == SQLITE_ROW) {
                dbChars = (char *)sqlite3_column_text(compiledStatement_, 1);
                if(dbChars!=nil)
                    contestant.score=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement_, 1)];
                
                dbChars = (char *)sqlite3_column_text(compiledStatement_, 2);
                if(dbChars!=nil)
                    contestant.time=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement_, 2)];
                                     
            dbChars = (char *)sqlite3_column_text(compiledStatement_, 8);
                        if(dbChars!=nil)
        contestant.average=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement_, 8)];
               
                                      dbChars = (char *)sqlite3_column_text(compiledStatement_, 4);
                                      if(dbChars!=nil)
                                      contestant.forfirstinround=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement_, 4)];
                                      
                                      dbChars = (char *)sqlite3_column_text(compiledStatement_, 5);
                                      if(dbChars!=nil)
                                      contestant.forlastinround=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement_, 5)];
                                      
                                      dbChars = (char *)sqlite3_column_text(compiledStatement_, 6);
                                      if(dbChars!=nil)
                                      contestant.forfirstinaverage=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement_, 6)];
                                      
                                      dbChars = (char *)sqlite3_column_text(compiledStatement_, 7);
                                      if(dbChars!=nil)
                                      contestant.forlastinaverage=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement_, 7)];
            }
        }
    }
    
    
        if([sorttype isEqualToString:@"Contestant Name"]){
            [self sortByContestantName];
        }else if([sorttype isEqualToString:@"Time"]){
            contestantsArray=[[NSMutableArray alloc] initWithArray:[self sortTimeArrayList:contestantsArray]];
        }
        else if([sorttype isEqualToString:@"Score"]){
            contestantsArray=[[NSMutableArray alloc] initWithArray:[self sortScoredEvent:contestantsArray]];
        }else if([sorttype isEqualToString:@"Average"]){
            if([selectEvent.eventtype isEqualToString:@"timed"])
                contestantsArray = [[NSMutableArray alloc] initWithArray:[self sortTimeArrayList_Avg:contestantsArray]];
            else
                contestantsArray = [[NSMutableArray alloc] initWithArray:[self sortScoredAvgFunction:contestantsArray]];
        }
        [tblview reloadData];
    
    [activityIndicator stopAnimating];
    [activityIndicator_landscape stopAnimating];

    
}


-(IBAction)sortFunction{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"My Rodeo" message:@"Please choose the sort parameter" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Place in round",@"Place in average",@"Contestant name",nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    sorttype=[[NSString alloc] init];
    if([title isEqualToString:@"Place in round"]){
        if([selectEvent.eventtype isEqualToString:@"Scored Event"]){
            roundLabel.text=@"Place\nRound";
            roundLabel_Landscape.text=@"Place\nRound";
            sorttype=@"Score";
            contestantsArray=[[NSMutableArray alloc] initWithArray:[self sortScoredEvent:contestantsArray]];
        }
        if([selectEvent.eventtype isEqualToString:@"Timed Event"]){
            roundLabel.text=@"Place\nRound";
            roundLabel_Landscape.text=@"Place\nRound";
            sorttype=@"Time";
            contestantsArray=[[NSMutableArray alloc] initWithArray:[self sortTimeArrayList:contestantsArray]];
        }
    }else if([title isEqualToString:@"Contestant name"]){
        roundLabel.text=@"Sort\nName";
        roundLabel_Landscape.text=@"Sort\nName";
        sorttype=@"Contestant Name";
        [self sortByContestantName];
    }else if([title isEqualToString:@"Place in average"]){
        sorttype=@"Average";
        roundLabel.text=@"Place\nAverage";
        roundLabel_Landscape.text=@"Place\nAverage";
        if([selectEvent.eventtype isEqualToString:@"Scored Event"]){
            contestantsArray = [[NSMutableArray alloc] initWithArray:[self sortScoredAvgFunction:contestantsArray]];
        }
        if([selectEvent.eventtype isEqualToString:@"Timed Event"]){
            contestantsArray = [[NSMutableArray alloc] initWithArray:[self sortTimeArrayList_Avg:contestantsArray]];
        }
    }
    [tblview reloadData];
    [activityIndicator stopAnimating];
    
}

-(void)prevClicked{
    if(currentround==1){
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"My Rodeo"
                                                          message:@"No Previous Round Available."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        
        [message show];
    }else{
        currentround=currentround-1;
        roundNumberLabel.text=[NSString stringWithFormat:@"Round %d",currentround];
        roundNumberLabel_landscape.text=[NSString stringWithFormat:@"Round %d",currentround];
        [self getContestantsList];
    }
}

-(void)nextClicked{
    if(currentround==[selectRodeo.noofrounds intValue]){
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"My Rodeo"
                                                          message:@"No Next Round Available."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
    }else{
        currentround=currentround+1;
        roundNumberLabel.text=[NSString stringWithFormat:@"Round %d",currentround];
        roundNumberLabel_landscape.text=[NSString stringWithFormat:@"Round %d",currentround];
        [self getContestantsList];
        
    }
}

-(double)getAvg:(EventDetailsVO*)cvo{
    char *dbChars ;
    NSString *format_avg=@"%";
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    double avg=0.00;
    for (int i=[selectEvent.currentround intValue]; i>=1; i--) {
        NSString *sqlStatement = [NSString stringWithFormat:@"select * from rounddetails where contestantid=%@ and round=%d",cvo.contestantid,i];
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database, [sqlStatement UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK) {
            while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                if([selectEvent.eventtype isEqualToString:@"timed"]){
                    dbChars = (char *)sqlite3_column_text(compiledStatement, 2);
                    if(dbChars!=nil)
                        avg += [[NSString stringWithFormat:[NSString stringWithFormat:@"%@.%@f",format_avg,[defaults objectForKey:@"timeformat"]],[[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)] doubleValue]] doubleValue];
                }else{
                    dbChars = (char *)sqlite3_column_text(compiledStatement, 1);
                    if(dbChars!=nil)
                        avg += [[NSString stringWithFormat:[NSString stringWithFormat:@"%@.%@f",format_avg,[defaults objectForKey:@"scoreformat"]],[[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)] doubleValue]] doubleValue];
                }
            }
        }
    }
    return avg;
}


-(NSMutableArray*)sortScoredEvent:(NSMutableArray*)scoredArray{
    [scoredArray sortUsingComparator:
     ^NSComparisonResult(EventDetailsVO *obj1, EventDetailsVO *obj2){
         if(([obj2.score floatValue]-[obj1.score floatValue])>0)
             return 1;
         else if(([obj2.score floatValue]-[obj1.score floatValue])<0)
             return -1;
         else
             return 0;
     }];
    return scoredArray;
}

-(void)sortTimeEvent:(NSMutableArray*)array{
    [array sortUsingComparator:
     ^NSComparisonResult(EventDetailsVO *obj1, EventDetailsVO *obj2){
         if(([obj1.time floatValue]-[obj2.time floatValue])>0)
             return 1;
         else if(([obj1.time floatValue]-[obj2.time floatValue]<0))
             return -1;
         else
             return 0;
     }];
}

-(NSMutableArray*)sortTimeArrayList:(NSMutableArray*)contArray{
    NSMutableArray *sortnotZeroList=[[NSMutableArray alloc] init];
    NSMutableArray *sortZeroList=[[NSMutableArray alloc] init];
    
    for (int count=0; count<[contArray count]; count++) {
        EventDetailsVO *edvo=[contArray objectAtIndex:count];
        if([edvo.time floatValue]>0.00){
            [sortnotZeroList addObject:edvo];
        }else if([edvo.time floatValue]==0.00){
            [sortZeroList addObject:edvo];
        }
    }
    
    [self sortTimeEvent:sortnotZeroList];
    
    contArray=[[NSMutableArray alloc] init];
    for (int count=0; count<[sortnotZeroList count]; count++) {
        [contArray addObject:[sortnotZeroList objectAtIndex:count]];
    }
    
    for (int count=0; count<[sortZeroList count]; count++) {
        [contArray addObject:[sortZeroList objectAtIndex:count]];
    }
    
    return contArray;
}

-(NSMutableArray*)sortTimeArrayList_Avg:(NSMutableArray*)contArray{
    NSMutableArray *sortnotZeroList=[[NSMutableArray alloc] init];
    NSMutableArray *sortZeroList=[[NSMutableArray alloc] init];
    
    for (int count=0; count<[contArray count]; count++) {
        EventDetailsVO *edvo=[contArray objectAtIndex:count];
        if([edvo.average floatValue]>0.00){
            [sortnotZeroList addObject:edvo];
        }else if([edvo.average floatValue]==0.00){
            [sortZeroList addObject:edvo];
        }
    }
    
    [self sortTimeEvent_Avg:sortnotZeroList];
    
    contArray=[[NSMutableArray alloc] init];
    for (int count=0; count<[sortnotZeroList count]; count++) {
        [contArray addObject:[sortnotZeroList objectAtIndex:count]];
    }
    
    for (int count=0; count<[sortZeroList count]; count++) {
        [contArray addObject:[sortZeroList objectAtIndex:count]];
    }
    return contArray;
}

-(void)sortTimeEvent_Avg:(NSMutableArray*)array{
    [array sortUsingComparator:
     ^NSComparisonResult(EventDetailsVO *obj1, EventDetailsVO *obj2){
         if(([obj1.average floatValue]-[obj2.average floatValue])>0)
             return 1;
         else if(([obj1.average floatValue]-[obj2.average floatValue]<0))
             return -1;
         else
             return 0;
     }];
}

-(void)sortByContestantName{
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"contestantname"
                                                 ascending:YES selector:@selector(caseInsensitiveCompare:)];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *sortedArray;
    sortedArray = [contestantsArray sortedArrayUsingDescriptors:sortDescriptors];
    contestantsArray=[[NSMutableArray alloc] initWithArray:sortedArray];
    [tblview reloadData];
}

-(NSMutableArray*)sortScoredAvgFunction:(NSMutableArray*)contArray{
    [contArray sortUsingComparator:
     ^NSComparisonResult(EventDetailsVO *obj1, EventDetailsVO *obj2){
         if(([obj2.average floatValue]-[obj1.average floatValue])>0)
             return 1;
         else if(([obj2.average floatValue]-[obj1.average floatValue])<0)
             return -1;
         else
             return 0;
     }];
    return contArray;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [contestantsArray count];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    UILabel *contestantnameLabel,*placeRoundLabel,*avgLbl,*scoretimeLabel,*fistroundLbl,*thirdsroundLbl,*firstavgLbl,*thirdsavgLabel;
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    EventDetailsVO *contestant=[contestantsArray objectAtIndex:indexPath.row];

    cell.backgroundColor=[UIColor clearColor];
    contestantnameLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 5,160, 20)];
    contestantnameLabel.tag=1;
    contestantnameLabel.text=contestant.contestantname;
    [cell.contentView addSubview:contestantnameLabel];
    
    placeRoundLabel=[[UILabel alloc] initWithFrame:CGRectMake(150, 5,30, 20)];
    placeRoundLabel.tag=2;
    placeRoundLabel.text=[NSString stringWithFormat:@"%d",indexPath.row+1];
    placeRoundLabel.text=[NSString stringWithFormat:@"%d",[self getPosition:contestant :contestant.contestantname]];
    [cell.contentView addSubview:placeRoundLabel];
    
    avgLbl=[[UILabel alloc] initWithFrame:CGRectMake(190, 5,60, 20)];
    avgLbl.tag=3;
    avgLbl.text=contestant.average;
    [cell.contentView addSubview:avgLbl];
    
    if([selectEvent.eventtype isEqual:@"Timed Event"])
    {
        scoretimeLabel=[[UILabel alloc] initWithFrame:CGRectMake(260, 5,60, 20)];
        scoretimeLabel.tag=3;
        scoretimeLabel.text=contestant.time;
        [cell.contentView addSubview:scoretimeLabel];
    }else{
        scoretimeLabel=[[UILabel alloc] initWithFrame:CGRectMake(260, 5,60, 20)];
        scoretimeLabel.tag=3;
        scoretimeLabel.text=contestant.score;
        [cell.contentView addSubview:scoretimeLabel];
    }
    
    fistroundLbl=[[UILabel alloc] initWithFrame:CGRectMake(340, 5, 30, 20)];
    fistroundLbl.tag=3;
    fistroundLbl.text=contestant.forfirstinround;
    [cell.contentView addSubview:fistroundLbl];
    
    thirdsroundLbl=[[UILabel alloc] initWithFrame:CGRectMake(400, 5, 30, 20)];
    thirdsroundLbl.tag=3;
    thirdsroundLbl.text=contestant.forlastinround;
    [cell.contentView addSubview:thirdsroundLbl];
    
    firstavgLbl=[[UILabel alloc] initWithFrame:CGRectMake(470, 5, 30, 20)];
    firstavgLbl.tag=3;
    firstavgLbl.text=contestant.forfirstinaverage;
    [cell.contentView addSubview:firstavgLbl];
    
    thirdsavgLabel=[[UILabel alloc] initWithFrame:CGRectMake(530, 5, 30, 20)];
    thirdsavgLabel.tag=3;
    thirdsavgLabel.text=contestant.forlastinaverage;
    [cell.contentView addSubview:thirdsavgLabel];
    
    
    return cell;
}

-(int)getPosition:(EventDetailsVO*)cvo:(NSString*)contName{
    NSMutableArray *tempArray=[[NSMutableArray alloc] initWithArray:contestantsArray];
    if([selectEvent.eventtype isEqualToString:@"timed"]){
        if([sorttype isEqualToString:@"Average"])
            tempArray=[self sortTimeArrayList_Avg:tempArray];
        else
            tempArray=[self sortTimeArrayList:tempArray];
    }else{
        if([sorttype isEqualToString:@"Average"])
            tempArray=[self sortScoredAvgFunction:tempArray];
        else
            tempArray=[self sortScoredEvent:tempArray];
    }
    
    for (int count=0; count<[tempArray count]; count++) {
        EventDetailsVO *cvo=[tempArray objectAtIndex:count];
        if([cvo.contestantname isEqualToString:contName]){
            return count+1;
        }
    }
    
    return 0;
}

- (void) clearCurrentView
{
    if (mainLandscapeView.superview)
    {
        [mainLandscapeView removeFromSuperview];
    }
    else if (mainPortraitView.superview)
    {
        [mainPortraitView removeFromSuperview];
    }
}

- (void)orientationChanged:(NSNotification *)notification{
    [self adjustViewsForOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
}

- (void) adjustViewsForOrientation:(UIInterfaceOrientation) orientation {
    [self clearCurrentView];
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        isLandscape=NO;
        [self.view addSubview:mainPortraitView];
    }
    else if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight)
    {
        isLandscape=YES;
        [self.view addSubview:mainLandscapeView];
    }
    
}

-(void)viewWillAppear:(BOOL)animated
{
    isLandscape=NO;
    appDelegate.isLandscapeOK=YES;
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(orientationChanged:)  name:UIDeviceOrientationDidChangeNotification  object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}

-(void)popviewController{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)viewDidLayoutSubviews{
    if(self.view.frame.size.width == ([[UIScreen mainScreen] bounds].size.width*([[UIScreen mainScreen] bounds].size.width<[[UIScreen mainScreen] bounds].size.height))+([[UIScreen mainScreen] bounds].size.height*([[UIScreen mainScreen] bounds].size.width>[[UIScreen mainScreen] bounds].size.height))){
        [self clearCurrentView];
        isLandscape=NO;
        [self.view addSubview:mainPortraitView];
        [self getContestantsList];
    }
    else{
        [self clearCurrentView];
        isLandscape=YES;
        [self.view addSubview:mainLandscapeView];
        [self getContestantsList];
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
