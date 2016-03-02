//
//  LookupRodeoListViewController.m
//  Rodeo_free
//
//  Created by arvind on 4/20/15.
//  Copyright (c) 2015 arvind. All rights reserved.
//

#import "LookupRodeoListViewController.h"
#import "LookupEventsViewController.h"
#import "RodeoListVO.h"
@interface LookupRodeoListViewController ()

@end

@implementation LookupRodeoListViewController
@synthesize tblview,activityIndicator,rodeosArray,database,rodeolist,selectedRodeo;
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
    
    self.navigationItem.title=@"Rodeos";
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIFont fontWithName:@"Segoe Print" size:25] forKey:NSFontAttributeName];

    tblview.frame=CGRectMake(0,0,self.view.bounds.size.width,self.view.bounds.size.height);
    tblview.backgroundColor=[UIColor clearColor];
    [tblview removeFromSuperview];
    [self.view addSubview:tblview];

    // Do any additional setup after loading the view from its nib.
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


- (void) threadStartAnimating:(id)data {
    [activityIndicator startAnimating];
    activityIndicator.center = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0);
    [self.view addSubview: activityIndicator];
}

-(void)readRodeoList{
    char *dbChars ;
    rodeosArray =[[NSMutableArray alloc] init];
    NSString* destPath = [self getDestPath];
    NSString *sqlStatement = [NSString stringWithFormat:@"select * from rodeodetails"];
    
    sqlite3_stmt *compiledStatement;
    if(sqlite3_prepare_v2(database, [sqlStatement UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK) {
        while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
            RodeoListVO *rodeo=[[RodeoListVO alloc] init];
            dbChars = (char *)sqlite3_column_text(compiledStatement, 0);
            if(dbChars!=nil)
                rodeo.rodeoid=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
            
            dbChars = (char *)sqlite3_column_text(compiledStatement, 1);
            if(dbChars!=nil)
                rodeo.rodeoname=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
            
            dbChars = (char *)sqlite3_column_text(compiledStatement, 4);
            if(dbChars!=nil)
                rodeo.noofrounds=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)];
            
            dbChars = (char *)sqlite3_column_text(compiledStatement, 2);
            if(dbChars!=nil)
                rodeo.location=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
            
            dbChars = (char *)sqlite3_column_text(compiledStatement, 3);
            if(dbChars!=nil)
                rodeo.rodeodate=[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
            
            [rodeosArray addObject:rodeo];
        }
    }
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
    NSString *documentsDirectory = [paths objectAtIndex:0]; //2
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"rodeolist.plist"]; //3
    rodeolist = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
    NSMutableArray *allKeys=(NSMutableArray*)[rodeolist allKeys];
    NSMutableArray *allValues=(NSMutableArray*)[rodeolist allValues];
    for (int i=0; i<[rodeolist count]; i++) {
        RodeoListVO *tempRodeo=[[RodeoListVO alloc] init];
        tempRodeo.rodeoid=[allValues objectAtIndex:i];
        tempRodeo.rodeoname=[allKeys objectAtIndex:i];
        
        [rodeosArray addObject:tempRodeo];
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
      [self readRodeoList];
    self.navigationController.navigationBar.hidden = NO;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [rodeosArray count];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    return 40;
else
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    
    RodeoListVO *tempRodeo=[rodeosArray objectAtIndex:indexPath.row];
    UILabel *rodeonameLabel;
        cell.backgroundColor=[UIColor clearColor];
        rodeonameLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 5,self.view.bounds.size.width, 20)];
        rodeonameLabel.tag=1;
        rodeonameLabel.textAlignment = NSTextAlignmentCenter;
        rodeonameLabel.text=tempRodeo.rodeoname;
        [cell.contentView addSubview:rodeonameLabel];

        return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LookupEventsViewController *lookupEvent;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        lookupEvent=[[LookupEventsViewController alloc] initWithNibName:@"LookupEventsViewController" bundle:nil];
    else
        lookupEvent=[[LookupEventsViewController alloc] initWithNibName:@"LookupEventsViewController_ipad" bundle:nil];
    lookupEvent.selectRodeo=[[RodeoListVO alloc]init];
    lookupEvent.selectRodeo=[rodeosArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:lookupEvent animated:YES];
    
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
