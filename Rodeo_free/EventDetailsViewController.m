//
//  EventDetailsViewController.m
//  Rodeo_free
//
//  Created by arvind on 4/20/15.
//  Copyright (c) 2015 arvind. All rights reserved.
//

#import "EventDetailsViewController.h"
#import "AppDelegate.h"
#import "EventDetailsVO.h"

@interface EventDetailsViewController ()

@end

@implementation EventDetailsViewController
@synthesize mainPortraitView,imgview,eventidSelected,activityIndicator,activityIndicator_landscape,oldContestantName;
@synthesize mainLandscapeView,tblview,appDelegate;
@synthesize sharebtn,editbtn,sortbtn,addcontestantbtn;
@synthesize roundNumberLabel,roundNumberLabel_landscape;
@synthesize scoreLabel,timeLabel,totalTimeLabel,for1stinRoundLabel,forLastInRoundLabel,forfirstInAvgLabel,forLastInAvgLabel,isLandscape,contestantSaved;
@synthesize scoreLabel_portrait,timeLabel_portrait,selectRodeo,selectEvent,eventDetailsArray,roundLabel,roundLabel_Landscape,sorttype,currentround,sortbtn_landscape,tblview_landscape;
- (void)viewDidLoad {
    [super viewDidLoad];
    [activityIndicator stopAnimating];

    currentround=1;
    roundNumberLabel.text=[NSString stringWithFormat:@"Round %d",currentround];
    roundNumberLabel_landscape.text=[NSString stringWithFormat:@"Round %d",currentround];
    //sortbtn.hidden=YES;
    //tblview.hidden=YES;
    //tblview_landscape.hidden=YES;
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
    
    [activityIndicator stopAnimating];
    [activityIndicator_landscape stopAnimating];
    
    
    
    appDelegate=[[UIApplication sharedApplication] delegate];
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
    
    /*CGFloat yheight = [UIScreen mainScreen].bounds.size.height;
    if(yheight>=480 && yheight<568){
    
    tblview.frame=CGRectMake(0,50,self.view.bounds.size.width,self.view.bounds.size.height);
    tblview.backgroundColor=[UIColor clearColor];
    [tblview removeFromSuperview];
    [self.view addSubview:tblview];
        
        sortbtn.frame=CGRectMake(150,0,60,20);
        [self.view addSubview:sortbtn];
        
    }else if(yheight>=568 && yheight<600){
        tblview.frame=CGRectMake(0,100,self.view.bounds.size.width,600);
        tblview.backgroundColor=[UIColor clearColor];
        [self.view addSubview:tblview];
        
        sortbtn_landscape.frame=CGRectMake(150,460,60,20);
        [self.view addSubview:sortbtn];
        
        tblview_landscape.frame=CGRectMake(0,50,self.view.bounds.size.width,400);
        tblview_landscape.backgroundColor=[UIColor clearColor];
        [tblview_landscape removeFromSuperview];
        [self.view addSubview:tblview_landscape];
        
        sortbtn.frame=CGRectMake(150,410,60,20);
        [self.view addSubview:sortbtn];

        

    }else
    {
        tblview.frame=CGRectMake(0,50,self.view.bounds.size.width,670);
        tblview.backgroundColor=[UIColor clearColor];
        [tblview removeFromSuperview];
        [self.view addSubview:tblview];
        
        sortbtn.frame=CGRectMake(150,460,60,20);
        [self.view addSubview:sortbtn];

    }*/
    // Do any additional setup after loading the view from its nib.
    [self getEventDetailsList];
}

-(void)popviewController{
    [self.navigationController popViewControllerAnimated:YES];
   }
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getEventDetailsList{
    eventDetailsArray=[[NSMutableArray alloc]init];
    NSString *urlString = [[NSString alloc]initWithFormat:@"http://mobiwebcode.com/rodeo/eventdetails.php?eventid=%@&round=%d",selectEvent.eventid,currentround];
    NSData *mydata = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    NSString *content = [[NSString alloc]  initWithBytes:[mydata bytes]
                                                  length:[mydata length] encoding: NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:mydata options:0 error:&error];
    NSArray *activityArray=[[json objectForKey:@"eventdetails"] objectForKey:@"event"];
    @try{
        for (int count=0; count<[activityArray count]; count++) {
        NSDictionary *activityData=[activityArray objectAtIndex:count];
        EventDetailsVO *edvo=[[EventDetailsVO alloc] init];
       
        edvo.contestantname=[[NSString alloc] init];
        edvo.score=[[NSString alloc] init];
        edvo.time=[[NSString alloc] init];
        edvo.average=[[NSString alloc] init];
        edvo.forfirstinround=[[NSString alloc] init];
        edvo.forlastinround=[[NSString alloc] init];
        edvo.forfirstinaverage=[[NSString alloc] init];
        edvo.forlastinaverage=[[NSString alloc] init];
        
        if ([activityData objectForKey:@"contestantname"] != [NSNull null])
            edvo.contestantname=[activityData objectForKey:@"contestantname"];
        edvo.score=[activityData objectForKey:@"score"];
        edvo.time=[activityData objectForKey:@"time"];
        edvo.average=[activityData objectForKey:@"average"];
        edvo.forfirstinround=[activityData objectForKey:@"forfirstinround"];
        edvo.forlastinround=[activityData objectForKey:@"forlastinround"];
        edvo.forfirstinaverage=[activityData objectForKey:@"forfirstinaverage"];
        edvo.forlastinaverage=[activityData objectForKey:@"forlastinaverage"];
        
        [eventDetailsArray addObject:edvo];
        }
    }@catch (NSException * e) {
            NSLog(@"Exception: %@", e);
            NSDictionary *activityData=[[json objectForKey:@"eventdetails"] objectForKey:@"event"];
            EventDetailsVO *edvo=[[EventDetailsVO alloc] init];
            
            edvo.contestantname=[[NSString alloc] init];
            edvo.score=[[NSString alloc] init];
            edvo.time=[[NSString alloc] init];
            edvo.average=[[NSString alloc] init];
            edvo.forfirstinround=[[NSString alloc] init];
            edvo.forlastinround=[[NSString alloc] init];
            edvo.forfirstinaverage=[[NSString alloc] init];
            edvo.forlastinaverage=[[NSString alloc] init];
            
            if ([activityData objectForKey:@"contestantname"] != [NSNull null])
                edvo.contestantname=[activityData objectForKey:@"contestantname"];
            edvo.score=[activityData objectForKey:@"score"];
            edvo.time=[activityData objectForKey:@"time"];
            edvo.average=[activityData objectForKey:@"average"];
            edvo.forfirstinround=[activityData objectForKey:@"forfirstinround"];
            edvo.forlastinround=[activityData objectForKey:@"forlastinround"];
            edvo.forfirstinaverage=[activityData objectForKey:@"forfirstinaverage"];
            edvo.forlastinaverage=[activityData objectForKey:@"forlastinaverage"];
            
            [eventDetailsArray addObject:edvo];
        }
    
    
    [tblview reloadData];
}

- (NSUInteger)supportedInterfaceOrientations
{
    appDelegate.isLandscapeOK=YES;
    return UIInterfaceOrientationMaskAll;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [eventDetailsArray count];

    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    EventDetailsVO *edvo=[eventDetailsArray objectAtIndex:indexPath.row];

    UILabel *contestantnameLabel,*placeRoundLabel,*avgLbl,*scoretimeLabel,*fistroundLbl,*thirdsroundLbl,*firstavgLbl,*thirdsavgLabel;
    
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        
        cell.backgroundColor=[UIColor clearColor];
        contestantnameLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 5,160, 20)];
        contestantnameLabel.tag=1;
        contestantnameLabel.text=edvo.contestantname;
        [cell.contentView addSubview:contestantnameLabel];
        
        placeRoundLabel=[[UILabel alloc] initWithFrame:CGRectMake(150, 5,30, 20)];
        placeRoundLabel.tag=2;
        placeRoundLabel.text=[NSString stringWithFormat:@"%d",indexPath.row+1];
    placeRoundLabel.text=[NSString stringWithFormat:@"%d",[self getPosition:edvo :edvo.contestantname]];
        [cell.contentView addSubview:placeRoundLabel];
        
        avgLbl=[[UILabel alloc] initWithFrame:CGRectMake(190, 5,60, 20)];
        avgLbl.tag=3;
        avgLbl.text=edvo.average;
        [cell.contentView addSubview:avgLbl];
        
        if([selectEvent.eventtype isEqual:@"Timed Event"])
        {
        scoretimeLabel=[[UILabel alloc] initWithFrame:CGRectMake(260, 5,60, 20)];
        scoretimeLabel.tag=3;
        scoretimeLabel.text=edvo.time;
        [cell.contentView addSubview:scoretimeLabel];
        }else{
            scoretimeLabel=[[UILabel alloc] initWithFrame:CGRectMake(260, 5,60, 20)];
            scoretimeLabel.tag=3;
            scoretimeLabel.text=edvo.score;
            [cell.contentView addSubview:scoretimeLabel];
        }
        
        fistroundLbl=[[UILabel alloc] initWithFrame:CGRectMake(340, 5, 30, 20)];
        fistroundLbl.tag=3;
        fistroundLbl.text=edvo.forfirstinround;
        [cell.contentView addSubview:fistroundLbl];
        
        thirdsroundLbl=[[UILabel alloc] initWithFrame:CGRectMake(400, 5, 30, 20)];
        thirdsroundLbl.tag=3;
        thirdsroundLbl.text=edvo.forlastinround;
        [cell.contentView addSubview:thirdsroundLbl];
        
        firstavgLbl=[[UILabel alloc] initWithFrame:CGRectMake(470, 5, 30, 20)];
        firstavgLbl.tag=3;
        firstavgLbl.text=edvo.forfirstinaverage;
        [cell.contentView addSubview:firstavgLbl];
        
        thirdsavgLabel=[[UILabel alloc] initWithFrame:CGRectMake(530, 5, 30, 20)];
        thirdsavgLabel.tag=3;
        thirdsavgLabel.text=edvo.forlastinaverage;
        [cell.contentView addSubview:thirdsavgLabel];
    
    
    return cell;
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
        [self getEventDetailsList];
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
        [self getEventDetailsList];

        }
}

-(int)getPosition:(EventDetailsVO*)edvo:(NSString*)contName{
    NSMutableArray *tempArray=[[NSMutableArray alloc] initWithArray:eventDetailsArray];
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

-(IBAction)sortFunction{

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"My Rodeo" message:@"Please choose the sort parameter" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Place in round",@"Place in average",@"Contestant name",nil];
    [alert show];
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
- (void) threadStartAnimating:(id)data {
    [activityIndicator startAnimating];
    activityIndicator.center = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0);
    [self.view addSubview: activityIndicator];
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
    sortedArray = [eventDetailsArray sortedArrayUsingDescriptors:sortDescriptors];
    eventDetailsArray=[[NSMutableArray alloc] initWithArray:sortedArray];
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

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [NSThread detachNewThreadSelector:@selector(threadStartAnimating:) toTarget:self withObject:nil];

    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    sorttype=[[NSString alloc] init];
    if([title isEqualToString:@"Place in round"]){
        if([selectEvent.eventtype isEqualToString:@"Scored Event"]){
            roundLabel.text=@"Place\nRound";
            roundLabel_Landscape.text=@"Place\nRound";
            sorttype=@"Score";
            eventDetailsArray=[[NSMutableArray alloc] initWithArray:[self sortScoredEvent:eventDetailsArray]];
        }
        if([selectEvent.eventtype isEqualToString:@"Timed Event"]){
            roundLabel.text=@"Place\nRound";
            roundLabel_Landscape.text=@"Place\nRound";
            sorttype=@"Time";
            eventDetailsArray=[[NSMutableArray alloc] initWithArray:[self sortTimeArrayList:eventDetailsArray]];
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
            eventDetailsArray = [[NSMutableArray alloc] initWithArray:[self sortScoredAvgFunction:eventDetailsArray]];
        }
        if([selectEvent.eventtype isEqualToString:@"Timed Event"]){
            eventDetailsArray = [[NSMutableArray alloc] initWithArray:[self sortTimeArrayList_Avg:eventDetailsArray]];
        }
    }
    [tblview reloadData];
    [activityIndicator stopAnimating];

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

-(void)viewDidLayoutSubviews{
    if(self.view.frame.size.width == ([[UIScreen mainScreen] bounds].size.width*([[UIScreen mainScreen] bounds].size.width<[[UIScreen mainScreen] bounds].size.height))+([[UIScreen mainScreen] bounds].size.height*([[UIScreen mainScreen] bounds].size.width>[[UIScreen mainScreen] bounds].size.height))){
        [self clearCurrentView];
        isLandscape=NO;
        [self.view addSubview:mainPortraitView];
        [self getEventDetailsList];
    }
    else{
        [self clearCurrentView];
        isLandscape=YES;
        [self.view addSubview:mainLandscapeView];
        [self getEventDetailsList];
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
